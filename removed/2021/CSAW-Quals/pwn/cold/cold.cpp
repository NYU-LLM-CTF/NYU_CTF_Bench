#include <stdio.h>
#include <string>
#include <unistd.h>

struct Bitstream {
  std::string_view backing_store;
  size_t bit_offset;

  uint8_t get_bit(ssize_t offset) {
    auto byte_offset = offset / 8;
    unsigned bit_index = offset & 7;
    auto value = (backing_store[byte_offset] >> bit_index) & 1;
    return value;
  }
  uint8_t get_bit() { return get_bit(bit_offset++); }
  template <typename T> T get_bits(size_t n) {
    T result = 0;
    for (size_t i = 0; i < n; i++) {
      result = (result << 1) | get_bit(bit_offset + i);
    }
    bit_offset += n;
    return result;
  }
  void set_bit(size_t offset, uint8_t value) {
    auto byte_offset = offset / 8;
    unsigned bit_index = offset % 8;
    if (value) {
      (char &)backing_store[byte_offset] |= 1 << bit_index;
    } else {
      (char &)backing_store[byte_offset] &= ~(1 << bit_index);
    }
  }
  void append_bit(uint8_t value) {
    set_bit(bit_offset, value);
    bit_offset++;
  }
  template <typename T> void append_bits(size_t n, T value) {
    for (size_t i = 0; i < n; i++) {
      append_bit((value >> i) & 1);
    }
  }
};

enum class Opcode {
  Done = 0,
  EmitBit = 1,
  EmitByte = 2,
  CopyRecentBits = 3,
  Seek = 4,
};

void decompress(Bitstream &input, Bitstream &output) {
  while (true) {
    auto opcode = Opcode(input.get_bits<uint8_t>(3));
    switch (opcode) {
    case Opcode::Done: {
      return;
    }
    case Opcode::EmitBit: {
      output.append_bit(input.get_bit());
      break;
    }
    case Opcode::EmitByte: {
      output.append_bits(8, input.get_bits<uint8_t>(8));
      break;
    }
    case Opcode::CopyRecentBits: {
      auto offset = input.get_bits<size_t>(10);
      auto length = input.get_bits<size_t>(10);
      for (size_t i = 0; i < length; i++) {
        output.append_bit(output.get_bit(output.bit_offset - offset));
      }
      break;
    }
    case Opcode::Seek: {
      auto nbits = input.get_bits<int16_t>(16);
      output.bit_offset += nbits;
      break;
    }
    default:
      printf("Invalid opcode: %#x\n", opcode);
      abort();
    }

    if (output.bit_offset >= output.backing_store.size() * 8 ||
        input.bit_offset >= input.backing_store.size() * 8) {
      puts("Went out of bounds");
      abort();
    }
  }
}

int main() {
  setvbuf(stdout, NULL, _IONBF, 0);
  // force a specific layout -- we want output to be immediately before
  // bs_output
  struct {
    char buffer[1024];
    std::string input;
    Bitstream bs_input;
    std::string output;
    Bitstream bs_output;
  } locals;

  printf("Ready for compressed buffer:\n");
  fflush(stdout);
  ssize_t size = read(0, locals.buffer, sizeof(locals.buffer));
  if (size < 0) {
    puts("Read failure");
    abort();
  }
  locals.input = std::string(locals.buffer, size);
  locals.bs_input = {locals.input, 0};

  auto output_size = locals.bs_input.get_bits<size_t>(20);
  locals.output = std::string(output_size, '\0');
  locals.bs_output = {locals.output, 0};

  printf("Decompressing %zu bytes of data\n", output_size);
  decompress(locals.bs_input, locals.bs_output);
  printf("Output: %s\n", locals.output.c_str());
}
