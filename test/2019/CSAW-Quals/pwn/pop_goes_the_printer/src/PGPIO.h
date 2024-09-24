#import <Foundation/Foundation.h>

@interface PGPIO : NSObject
{
}

+ (NSInteger) doRead:(NSMutableData*) outData;
+ (void) doWrite:(NSString *) format, ...;
+ (void) doDataWrite:(NSData*) data;

@end
