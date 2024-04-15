#import <Foundation/Foundation.h>

#import "PGPObject.h"
#import "CCHBinaryDataReader.h"

@interface PGPObjectV2 : NSObject  {
  NSMutableData *data;
  NSUInteger _type;
}

@property (nonatomic, readonly) NSMutableData *data;

- (NSInteger) parseObjectFromData:(CCHBinaryDataReader*) binaryReader;

@end
