//
//  BinaryDataReader.m
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

#import "CCHBinaryDataReader.h"

@implementation CCHBinaryDataReader

@synthesize _data;
@synthesize _currentPosition;
@synthesize _bigEndian;

#define OSSwapConstInt16(x) \
    ((uint16_t)((((uint16_t)(x) & 0xff00) >> 8) | \
                (((uint16_t)(x) & 0x00ff) << 8)))

#define OSSwapConstInt32(x) \
    ((uint32_t)((((uint32_t)(x) & 0xff000000) >> 24) | \
                (((uint32_t)(x) & 0x00ff0000) >>  8) | \
                (((uint32_t)(x) & 0x0000ff00) <<  8) | \
                (((uint32_t)(x) & 0x000000ff) << 24)))

#define OSSwapConstInt64(x) \
    ((uint64_t)((((uint64_t)(x) & 0xff00000000000000ULL) >> 56) | \
                (((uint64_t)(x) & 0x00ff000000000000ULL) >> 40) | \
                (((uint64_t)(x) & 0x0000ff0000000000ULL) >> 24) | \
                (((uint64_t)(x) & 0x000000ff00000000ULL) >>  8) | \
                (((uint64_t)(x) & 0x00000000ff000000ULL) <<  8) | \
                (((uint64_t)(x) & 0x0000000000ff0000ULL) << 24) | \
                (((uint64_t)(x) & 0x000000000000ff00ULL) << 40) | \
                (((uint64_t)(x) & 0x00000000000000ffULL) << 56)))

- (instancetype)init
{
    abort();
}

- (instancetype)initWithData:(NSMutableData *)data options:(CCHBinaryDataReaderOptions)options
{
    self = [super init];
    if (self) {
        _data = data;
        _currentPosition = (const uint8_t *)data.bytes;
        _bigEndian = (options & CCHBinaryDataReaderBigEndian) != 0;
    }

    return self;
}

- (void)reset
{
    _currentPosition = (const uint8_t *)_data.bytes;
}

- (void)setNumberOfBytesRead:(NSUInteger)numberOfBytes
{
    NSAssert(numberOfBytes <= _data.length, @"Passed end of data");

    _currentPosition = (const uint8_t *)_data.bytes + numberOfBytes;
}

- (void)skipNumberOfBytes:(NSUInteger)numberOfBytes
{
    NSAssert([self canReadNumberOfBytes:numberOfBytes], @"Passed end of data");

    _currentPosition += numberOfBytes;
}

- (BOOL)canReadNumberOfBytes:(NSUInteger)numberOfBytes
{
    NSUInteger currentLength = _currentPosition - (const uint8_t *)_data.bytes;
    return (currentLength + numberOfBytes <= _data.length);
}

- (char)readChar
{
    NSAssert(sizeof(char) == 1, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(char)], @"Passed end of data");

    char value = *((char *)_currentPosition);
    [self skipNumberOfBytes:sizeof(char)];

    return value;
}

- (unsigned char)readUnsignedChar
{
    return (unsigned char)[self readChar];
}

- (short)readShort
{
    NSAssert(sizeof(short) == 2, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(short)], @"Passed end of data");

    short value = *((short *)_currentPosition);
    if (_bigEndian) {
        value = OSSwapConstInt16(value);
    } else {
        value = value;
    }
    [self skipNumberOfBytes:sizeof(short)];

    return value;
}

- (unsigned short)readUnsignedShort
{
    return (unsigned short)[self readShort];
}

- (int)readInt
{
    NSAssert(sizeof(int) == 4, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(int)], @"Passed end of data");

    int value = *((int *)_currentPosition);
    if (_bigEndian) {
        value = OSSwapConstInt32(value);
    } else {
        value = value;
    }
    [self skipNumberOfBytes:sizeof(int)];

    return value;
}

- (unsigned int)readUnsignedInt
{
    return (unsigned int)[self readInt];
}

- (long long)readLongLong
{
    NSAssert(sizeof(long long) == 8, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(long long)], @"Passed end of data");

    long long value = *((long long *)_currentPosition);
    if (_bigEndian) {
        value = OSSwapConstInt64(value);
    } else {
        value = value;
    }
    [self skipNumberOfBytes:sizeof(long long)];

    return value;
}

- (unsigned long long)readUnsignedLongLong
{
    return (unsigned long long)[self readLongLong];
}

- (NSString *)readNullTerminatedStringWithEncoding:(NSStringEncoding)encoding
{
    const uint8_t *start = _currentPosition;
    while (*_currentPosition++ != '\0') {
        NSAssert([self canReadNumberOfBytes:0], @"Passed end of data");
    }

    NSUInteger numberOfBytes = _currentPosition - start - 1;
    NSString *result = [[NSString alloc] initWithBytes:(const void *)start length:numberOfBytes encoding:encoding];

    return result;
}

- (NSString *)readStringWithNumberOfBytes:(NSUInteger)numberOfBytes encoding:(NSStringEncoding)encoding
{
    NSAssert([self canReadNumberOfBytes:numberOfBytes], @"Passed end of data");

    NSString *result = [[NSString alloc] initWithBytes:(const void *)_currentPosition length:numberOfBytes encoding:encoding];
    [self skipNumberOfBytes:numberOfBytes];

    return result;
}

- (NSMutableData *)readDataWithNumberOfBytes:(NSUInteger)numberOfBytes
{
    NSAssert([self canReadNumberOfBytes:numberOfBytes], @"Passed end of data");

    NSMutableData *result = [NSMutableData dataWithBytes:(const void *)_currentPosition length:numberOfBytes];
    [self skipNumberOfBytes:numberOfBytes];

    return result;
}

@end
