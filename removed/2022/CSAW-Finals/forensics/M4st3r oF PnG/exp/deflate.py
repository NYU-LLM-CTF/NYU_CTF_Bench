#
# Simple DEFLATE decompressor
# Copyright (c) Project Nayuki
#
# https://www.nayuki.io/page/simple-deflate-decompressor
# https://github.com/nayuki/Simple-DEFLATE-decompressor
#

import io
from typing import BinaryIO, Dict, List, Optional, Sequence, Tuple


class BitInputStream:
    """A stream of bits that can be read. Because they come from an underlying byte stream, the
    total number of bits is always a multiple of 8. Bits are packed in little endian within a byte.
    For example, the byte 0x87 reads as the sequence of bits [1,1,1,0,0,0,0,1]."""

    # The underlying byte stream to read from.
    _input: BinaryIO

    # Either in the range [0x00, 0xFF] if bits are available, or -1 if end of stream is reached.
    _current_byte: int

    # Number of remaining bits in the current byte, always between 0 and 7 (inclusive).
    _num_bits_remaining: int

    def __init__(self, inp: BinaryIO):
        """Constructs a bit input stream based on the given byte input stream."""
        self._input = inp
        self._current_byte = 0
        self._num_bits_remaining = 0

    def get_bit_position(self) -> int:
        """Returns the current bit position, which ascends from 0 to 7 as bits are read."""
        assert 0 <= self._num_bits_remaining <= 7
        return -self._num_bits_remaining % 8

    def read_bit_maybe(self) -> int:
        """Reads a bit from this stream. Returns 0 or 1 if a bit is available, or -1 if
        the end of stream is reached. The end of stream always occurs on a byte boundary."""
        if self._current_byte == -1:
            return -1
        if self._num_bits_remaining == 0:
            b: bytes = self._input.read(1)
            if len(b) == 0:
                self._current_byte = -1
                return -1
            self._current_byte = b[0]
            self._num_bits_remaining = 8
        assert self._num_bits_remaining > 0
        self._num_bits_remaining -= 1
        return (self._current_byte >> (7 - self._num_bits_remaining)) & 1

    def read_uint(self, numbits: int) -> int:
        """Reads the given number of bits from this stream, packing them in little endian as an unsigned integer."""
        if numbits < 0:
            raise ValueError()
        result: int = 0
        for i in range(numbits):
            bit: int = self.read_bit_maybe()
            if bit == -1:
                raise EOFError()
            result |= bit << i
        return result

    def close(self) -> None:
        """Closes this stream and the underlying input stream."""
        self._input.close()
        self._current_byte = -1
        self._num_bits_remaining = 0


class ByteHistory:
    """Stores a finite recent history of a byte stream. Useful as an implicit
    dictionary for Lempel-Ziv schemes. Mutable and not thread-safe."""

    # Circular buffer of byte data.
    _data: List[int]

    # Index of next byte to write to, always in the range [0, len(data)).
    _index: int

    def __init__(self, size: int):
        """Creates a byte history of the given size, initialized to zeros."""
        if size < 1:
            raise ValueError("Size must be positive")
        self._data = [0] * size
        self._index = 0

    def append(self, b: int) -> None:
        """Appends the specified byte to this history.
        This overwrites the byte value at 'size' positions ago."""
        assert 0 <= self._index < len(self._data)
        self._data[self._index] = b
        self._index = (self._index + 1) % len(self._data)

    def copy(self, dist: int, count: int, out: BinaryIO) -> None:
        """Copies 'count' bytes starting at 'dist' bytes ago to the
        given output stream and also back into this buffer itself.
        Note that if the count exceeds the distance, then some of the output
        data will be a copy of data that was copied earlier in the process."""
        if count < 0 or not (1 <= dist <= len(self._data)):
            raise ValueError()

        readindex: int = (self._index - dist) % len(self._data)
        for _ in range(count):
            b: int = self._data[readindex]
            readindex = (readindex + 1) % len(self._data)
            out.write(bytes((b,)))
            self.append(b)


class CanonicalCode:
    """A canonical Huffman code, where the code values for each symbol is derived
    from a given sequence of code lengths. This data structure is immutable.
    This could be transformed into an explicit Huffman code tree.

    Example:
      Code lengths (canonical code):
        Symbol A: 1
        Symbol B: 0 (no code)
        Symbol C: 3
        Symbol D: 2
        Symbol E: 3

      Generated Huffman codes:
        Symbol A: 0
        Symbol B: (Absent)
        Symbol C: 110
        Symbol D: 10
        Symbol E: 111

      Huffman code tree:
          .
         / \
        A   .
           / \
          D   .
             / \
            C   E"""

    # This dictionary maps Huffman codes to symbol values.
    # Each key is the Huffman code padded with a 1 bit at the
    # beginning to disambiguate codes of different lengths
    # (e.g. otherwise we can't distinguish 0b01 from 0b0001).
    # For the example of codelengths=[1,0,3,2,3], we would have:
    #     0b1_0 -> 0
    #    0b1_10 -> 3
    #   0b1_110 -> 2
    #   0b1_111 -> 4
    _code_bits_to_symbol: Dict[int, int]

    def __init__(self, codelengths: Sequence[int]):
        """Creates a canonical Huffman code from the given list of symbol code lengths.
        Each code length must be non-negative. Code length 0 means no code for the symbol.
        The collection of code lengths must represent a proper full Huffman code tree.
        Examples of code lengths that result in correct full Huffman code trees:
        - [1, 1] (result: A=0, B=1)
        - [2, 2, 1, 0, 0, 0] (result: A=10, B=11, C=0)
        - [3, 3, 3, 3, 3, 3, 3, 3] (result: A=000, B=001, C=010, ..., H=111)
        Examples of code lengths that result in under-full Huffman code trees:
        - [0, 2, 0] (result: B=00, unused=01, unused=1)
        - [0, 1, 0, 2] (result: B=0, D=10, unused=11)
        Examples of code lengths that result in over-full Huffman code trees:
        - [1, 1, 1] (result: A=0, B=1, C=overflow)
        - [1, 1, 2, 2, 3, 3, 3, 3] (result: A=0, B=1, C=overflow, ...)"""

        # Check argument values
        if any(x < 0 for x in codelengths):
            raise ValueError("Negative code length")

        self._code_bits_to_symbol = {}

        # Allocate code values to symbols. Symbols are processed in the order
        # of shortest code length first, breaking ties by lowest symbol value.
        nextcode: int = 0
        for codelength in range(1, max(codelengths) + 1):
            nextcode <<= 1
            startbit: int = 1 << codelength
            for (symbol, cl) in enumerate(codelengths):
                if cl != codelength:
                    continue
                if nextcode >= startbit:
                    raise ValueError("This canonical code produces an over-full Huffman code tree")
                self._code_bits_to_symbol[startbit | nextcode] = symbol
                nextcode += 1
        if nextcode != 1 << max(codelengths):
            raise ValueError("This canonical code produces an under-full Huffman code tree")

    def decode_next_symbol(self, inp: BitInputStream) -> int:
        """Decodes the next symbol from the given bit input stream based on this
        canonical code. The returned symbol value is in the range [0, len(codelengths))."""
        codebits: int = 1  # The start bit
        while True:
            # Accumulate one bit at a time on the right side until a match is found
            # in the code_bits_to_symbol dictionary. Because the Huffman code tree is
            # full, this loop must terminate after at most max(codelengths) iterations.
            codebits = codebits << 1 | inp.read_uint(1)
            result: int = self._code_bits_to_symbol.get(codebits, -1)
            if result != -1:
                return result

    def __str__(self) -> str:
        """Returns a string representation of this canonical code,
        useful for debugging only, and the format is subject to change."""
        return "\n".join(
            "Code {}: Symbol {}".format(bin(codebits)[3:], symbol)
            for (codebits, symbol) in sorted(self._code_bits_to_symbol.items())) + "\n"


class Decompressor:
    # -- Public functions --

    """Decompresses raw DEFLATE data (without zlib or gzip container) into bytes."""

    @staticmethod
    def decompress_to_bytes(bitin: BitInputStream) -> bytes:
        """Reads from the given input stream, decompress the data, and returns a new byte list."""
        out = io.BytesIO()
        Decompressor.decompress_to_stream(bitin, out)
        return out.getvalue()

    @staticmethod
    def decompress_to_stream(bitin: BitInputStream, out: BinaryIO) -> None:
        """Reads from the given input stream, decompress the data, and writes to the given output stream."""
        Decompressor(bitin, out)

    # -- Private implementation --

    _input: BitInputStream
    _output: BinaryIO
    _dictionary: ByteHistory

    def __init__(self, bitin: BitInputStream, out: BinaryIO):
        # Initialize fields
        self._input = bitin
        self._output = out
        self._dictionary = ByteHistory(32 * 1024)
        self.typeli = []

        # Process the stream of blocks
        while True:
            # Read the block header
            isfinal: bool = bitin.read_uint(1) != 0  # bfinal
            type: int = self._input.read_uint(2)  # btype

            # Decompress rest of block based on the type
            if type == 0:
                self._decompress_uncompressed_block()
                self.typeli.append(0)
            elif type == 1:
                self._decompress_huffman_block(Decompressor._FIXED_LITERAL_LENGTH_CODE,
                                               Decompressor._FIXED_DISTANCE_CODE)
                self.typeli.append(1)
            elif type == 2:
                litlencode, distcode = self._decode_huffman_codes()
                self._decompress_huffman_block(litlencode, distcode)
                self.typeli.append(2)
            elif type == 3:
                raise ValueError("Reserved block type")
            else:
                assert False, "Impossible value"
            if isfinal:
                break

    # -- The constant code trees for static Huffman codes (btype = 1) --

    _FIXED_LITERAL_LENGTH_CODE = CanonicalCode([8] * 144 + [9] * 112 + [7] * 24 + [8] * 8)

    _FIXED_DISTANCE_CODE = CanonicalCode([5] * 32)

    # -- Method for reading and decoding dynamic Huffman codes (btype = 2) --

    # Reads from the bit input stream, decodes the Huffman code
    # specifications into code trees, and returns the trees.
    def _decode_huffman_codes(self) -> Tuple[CanonicalCode, Optional[CanonicalCode]]:
        numlitlencodes: int = self._input.read_uint(5) + 257  # hlit + 257
        numdistcodes: int = self._input.read_uint(5) + 1  # hdist + 1

        numcodelencodes: int = self._input.read_uint(4) + 4  # hclen + 4
        codelencodelen: List[int] = [0] * 19  # This list is filled in a strange order
        codelencodelen[16] = self._input.read_uint(3)
        codelencodelen[17] = self._input.read_uint(3)
        codelencodelen[18] = self._input.read_uint(3)
        codelencodelen[0] = self._input.read_uint(3)
        for i in range(numcodelencodes - 4):
            j = (8 + i // 2) if (i % 2 == 0) else (7 - i // 2)
            codelencodelen[j] = self._input.read_uint(3)

        # Create the code length code
        codelencode = CanonicalCode(codelencodelen)

        # Read the main code lengths and handle runs
        codelens: List[int] = []
        while len(codelens) < numlitlencodes + numdistcodes:
            sym: int = codelencode.decode_next_symbol(self._input)
            if 0 <= sym <= 15:
                codelens.append(sym)
            elif sym == 16:
                if len(codelens) == 0:
                    raise ValueError("No code length value to copy")
                runlen: int = self._input.read_uint(2) + 3
                codelens.extend(codelens[-1:] * runlen)
            elif sym == 17:
                runlen = self._input.read_uint(3) + 3
                codelens.extend([0] * runlen)
            elif sym == 18:
                runlen = self._input.read_uint(7) + 11
                codelens.extend([0] * runlen)
            else:
                assert False, "Symbol out of range"
        if len(codelens) > numlitlencodes + numdistcodes:
            raise ValueError("Run exceeds number of codes")

        # Create literal-length code tree
        litlencode = CanonicalCode(codelens[: numlitlencodes])

        # Create distance code tree with some extra processing
        distcodelen: List[int] = codelens[numlitlencodes:]
        if len(distcodelen) == 1 and distcodelen[0] == 0:
            distcode: Optional[CanonicalCode] = None  # Empty distance code; the block shall be all literal symbols
        else:
            # Get statistics for upcoming logic
            onecount: int = sum(1 for x in distcodelen if x == 1)
            otherpositivecount: int = sum(1 for x in distcodelen if x > 1)

            # Handle the case where only one distance code is defined
            if onecount == 1 and otherpositivecount == 0:
                # Add a dummy invalid code to make the Huffman tree complete
                distcodelen.extend([0] * (32 - len(distcodelen)))
                distcodelen[31] = 1
            distcode = CanonicalCode(distcodelen)

        return (litlencode, distcode)

    # -- Block decompression methods --

    # Handles and copies an uncompressed block from the bit input stream.
    def _decompress_uncompressed_block(self) -> None:
        # Discard bits to align to byte boundary
        while self._input.get_bit_position() != 0:
            self._input.read_uint(1)

        # Read length
        len: int = self._input.read_uint(16)
        nlen: int = self._input.read_uint(16)
        if len ^ 0xFFFF != nlen:
            raise ValueError("Invalid length in uncompressed block")

        # Copy bytes
        for _ in range(len):
            b: int = self._input.read_uint(8)  # Byte is aligned
            if b == -1:
                raise EOFError()
            self._output.write(bytes((b,)))
            self._dictionary.append(b)

    # Decompresses a Huffman-coded block from the bit input stream based on the given Huffman codes.
    def _decompress_huffman_block(self, litlencode: CanonicalCode, distcode: Optional[CanonicalCode]) -> None:
        # litlencode cannot be None, but distcode is allowed to be None
        while True:
            sym: int = litlencode.decode_next_symbol(self._input)
            if sym == 256:  # End of block
                break

            if sym < 256:  # Literal byte
                self._output.write(bytes((sym,)))
                self._dictionary.append(sym)
            else:  # Length and distance for copying
                run: int = self._decode_run_length(sym)
                assert 3 <= run <= 258, "Invalid run length"
                if distcode is None:
                    raise ValueError("Length symbol encountered with empty distance code")
                distsym: int = distcode.decode_next_symbol(self._input)
                dist: int = self._decode_distance(distsym)
                assert 1 <= dist <= 32768, "Invalid distance"
                self._dictionary.copy(dist, run, self._output)

    # -- Symbol decoding methods --

    # Returns the run length based on the given symbol and possibly reading more bits.
    def _decode_run_length(self, sym: int) -> int:
        # Symbols outside the range cannot occur in the bit stream;
        # they would indicate that the decompressor is buggy
        assert 257 <= sym <= 287, f"Invalid run length symbol: {sym}"

        if sym <= 264:
            return sym - 254
        elif sym <= 284:
            numextrabits: int = (sym - 261) // 4
            return (((sym - 265) % 4 + 4) << numextrabits) + 3 + self._input.read_uint(numextrabits)
        elif sym == 285:
            return 258
        else:  # sym is 286 or 287
            raise ValueError(f"Reserved length symbol: {sym}")

    # Returns the distance based on the given symbol and possibly reading more bits.
    def _decode_distance(self, sym: int) -> int:
        # Symbols outside the range cannot occur in the bit stream;
        # they would indicate that the decompressor is buggy
        assert 0 <= sym <= 31, f"Invalid distance symbol: {sym}"

        if sym <= 3:
            return sym + 1
        elif sym <= 29:
            numextrabits: int = sym // 2 - 1
            return ((sym % 2 + 2) << numextrabits) + 1 + self._input.read_uint(numextrabits)
        else:  # sym is 30 or 31
            raise ValueError(f"Reserved distance symbol: {sym}")


