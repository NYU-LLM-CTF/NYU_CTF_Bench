#import "PGPIO.h"

@implementation PGPIO

+ (NSInteger)doRead:(NSMutableData*) outData {
  NSFileHandle *inputFile = [NSFileHandle fileHandleWithStandardInput];

  NSData *data = [inputFile availableData];
  if ([data length] == 0) {
    NSLog(@"[PGPIO] EOF");
    [inputFile release];
    return -1;
  }

  [outData initWithData:data];

  [inputFile release];
  [data release];
  return 0;
}

+ (void)doWrite:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *formattedString = [[NSString alloc] initWithFormat: format
                                                  arguments: args];
    va_end(args);
    [(NSFileHandle *)[NSFileHandle fileHandleWithStandardOutput]
        writeData: [formattedString dataUsingEncoding: NSNEXTSTEPStringEncoding]];

    [formattedString release];
}

+ (void)doDataWrite:(NSData*) data {
  [(NSFileHandle *)[NSFileHandle fileHandleWithStandardOutput] writeData: data];
}

@end
