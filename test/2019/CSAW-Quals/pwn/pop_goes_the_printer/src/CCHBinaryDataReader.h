//
//  BinaryDataReader.h
//  BinaryData
//
//  Copyright (C) 2014 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** Options for changing the behavior of this class. */
typedef NS_OPTIONS(NSUInteger, CCHBinaryDataReaderOptions) {
    CCHBinaryDataReaderBigEndian = (1UL << 0)    /// Endianess of multi-byte values (default: little endian)
};

/**
 Reads data from binary input.
 */
@interface CCHBinaryDataReader : NSObject {
    NSMutableData *_data;
    const uint8_t *_currentPosition;
    BOOL _bigEndian;
}

/** Binary data used for reading. */
@property (nonatomic, readonly) NSMutableData *_data;
/** Current reading position. */
@property (nonatomic, readonly) const uint8_t *_currentPosition;
/** Endianess of multi-byte values. */
@property (nonatomic, readonly) BOOL _bigEndian;

/**
 Initializes this class with data to read and options.
 @param data data to read
 @param options changes behavior of this class
 */
- (instancetype)initWithData:(NSMutableData *)data options:(CCHBinaryDataReaderOptions)options NS_DESIGNATED_INITIALIZER;

/**
 Resets the reading position to the begin of the data.
 */
- (void)reset;

/**
 Sets the current reading position.
 @param numberOfBytes number of bytes relative to the begin of the data
 */
- (void)setNumberOfBytesRead:(NSUInteger)numberOfBytes;

/**
 Advances the current reading position by the given number of bytes.
 @param numberOfBytes number of bytes relative to the current reading position
 */
- (void)skipNumberOfBytes:(NSUInteger)numberOfBytes;

/**
 Checks if the given number of bytes can be read.
 @param numberOfBytes number of bytes to read
 @return YES if the given number of bytes can be read
 */
- (BOOL)canReadNumberOfBytes:(NSUInteger)numberOfBytes;

/** Reads data and advances the current position by one byte. */
- (char)readChar;
/** Reads unsigned data and advances the current position by one byte. */
- (unsigned char)readUnsignedChar;

/** Reads data and advances the current position by two bytes. */
- (short)readShort;
/** Reads unsigned data and advances the current position by two bytes. */
- (unsigned short)readUnsignedShort;

/** Reads data and advances the current position by four bytes. */
- (int)readInt;
/** Reads unsigned data and advances the current position by four bytes. */
- (unsigned int)readUnsignedInt;

/** Reads data and advances the current position by eight bytes. */
- (long long)readLongLong;
/** Reads unsigned data and advances the current position by eight bytes. */
- (unsigned long long)readUnsignedLongLong;

/**
 Reads a string with the given encoding until the value '\0' is encountered.
 @param encoding string encoding
 @return string
 */
- (NSString *)readNullTerminatedStringWithEncoding:(NSStringEncoding)encoding;

/**
 Reads a string with the given byte-length and encoding.
 @param numberOfBytes number of bytes (not characters)
 @param encoding string encoding
 @return string
 */
- (NSString *)readStringWithNumberOfBytes:(NSUInteger)numberOfBytes encoding:(NSStringEncoding)encoding;

- (NSMutableData *)readDataWithNumberOfBytes:(NSUInteger)numberOfBytes;

@end

NS_ASSUME_NONNULL_END
