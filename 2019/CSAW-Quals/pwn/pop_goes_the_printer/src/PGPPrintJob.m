#import "PGPPrintJob.h"
#import "PGPIO.h"
#import "PGPObject.h"
#import "PGPObjectV1.h"
#import "PGPObjectV2.h"
#import <objc/runtime.h>

@implementation PGPPrintJob

@synthesize challenge;

#define MAX_OBJ_COUNT 255

- (id) init {
  self = [super init];
  if (self) {
    _objs = [[NSMutableArray alloc] init];
    _author = @"Rick Astley";
    _cmdBits = 0;
  }
  return self;
}

- (NSInteger) changeAPIVersion {
  Class objectClass = objc_getClass("PGPObject");
  Class objectV1Class = objc_getClass("PGPObjectV1");
  Class objectV2Class = objc_getClass("PGPObjectV2");
  SEL parseObjectFromDataSel = @selector(parseObjectFromData:);

  Method originalMethod = class_getInstanceMethod(objectClass, parseObjectFromDataSel);

  Method swizzledMethod;
  switch (_version) {
    case 1:
      swizzledMethod = class_getInstanceMethod(objectV1Class, parseObjectFromDataSel);
      break;
    case 2:
      swizzledMethod = class_getInstanceMethod(objectV2Class, parseObjectFromDataSel);
      break;
    default:
      NSLog(@"[PGPNetworkPacket] Version not supported!");
      return -1;
  }

  if (originalMethod != swizzledMethod) {
    class_replaceMethod(objectClass,
        parseObjectFromDataSel,
        method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod));
  }
  return 0;
}

- (NSInteger) parseNetworkPacket:(NSData*)data {
  CCHBinaryDataReader *binaryDataReader = [[[CCHBinaryDataReader alloc]
      initWithData:[NSMutableData dataWithData:data] options:CCHBinaryDataReaderBigEndian] autorelease];

  if (![binaryDataReader canReadNumberOfBytes:4]) {
    NSLog(@"[PGPNetworkPacket] Unable to read header");
    return -1;
  }

  NSString *header = [binaryDataReader readStringWithNumberOfBytes:4 encoding:NSASCIIStringEncoding];
  if (![header isEqualToString:@"PGP\x42"]) {
    NSLog(@"[PGPNetworkPacket] Invalid packet header");
    return -1;
  }

  if (![binaryDataReader canReadNumberOfBytes:2]) {
    NSLog(@"[PGPNetworkPacket] Unable to read version");
    return -1;
  }

  _version = [binaryDataReader readUnsignedShort];
  if (_version > PGPLATESTVERSION) {
    NSLog(@"[PGPNetworkPacket] Version not supported");
    return -1;
  }

  if (![binaryDataReader canReadNumberOfBytes:8]) {
    NSLog(@"[PGPNetworkPacket] Unable to read challenge");
    return -1;
  }

  challenge = [binaryDataReader readLongLong];

  if (![binaryDataReader canReadNumberOfBytes:1]) {
    NSLog(@"[PGPNetworkPacket] Unable to read cmd bits");
    return -1;
  }

  _cmdBits = [binaryDataReader readUnsignedChar];

  if (![binaryDataReader canReadNumberOfBytes:2]) {
    NSLog(@"[PGPNetworkPacket] Unable to read object count");
    return -1;
  }

  size_t objectCount = [binaryDataReader readUnsignedShort];
  if (objectCount > MAX_OBJ_COUNT) {
    NSLog(@"[PGPNetworkPacket] Too many objects!");
    return -1;
  }

  if ([self changeAPIVersion] != 0) {
    return -1;
  }

  uint16_t i = 0;
  while (i < objectCount) {
    PGPObject* obj = [[PGPObject alloc] init];
    NSInteger rc = [obj parseObjectFromData:binaryDataReader];
    if (rc != 0) {
      return -1;
    }

    [_objs addObject:obj];
    i++;
  }
  return 0;
}

- (BOOL) shouldQueueJob {
  return (_cmdBits & PGPQUEUEJOB) != 0;
}

- (BOOL) shouldRunJob {
  return (_cmdBits & PGPRUNJOB) != 0;
}

- (BOOL) shouldRunAllJobs {
  return (_cmdBits & PGPRUNALLJOBS) != 0;
}

- (void) printJob {
  NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterFullStyle];

  [PGPIO doWrite:@"=== PGPPrinter 4.0 ===\n"];
  [PGPIO doWrite:@"Author: %@\n", _author];
  [PGPIO doWrite:@"Date: %@\n", dateString];


  for (int i = 0; i < [_objs count]; i++) {
    [PGPIO doDataWrite:[[_objs objectAtIndex:i] flattenObj]];
  }
  [PGPIO doWrite:@"\x1b[0m\n"];

  [dateString release];
}

- (void) dealloc {
  for (int i = 0; i < [_objs count]; i++) {
    [[_objs objectAtIndex:i] release];
  }
  [_objs release];
  [super dealloc];
}

@end
