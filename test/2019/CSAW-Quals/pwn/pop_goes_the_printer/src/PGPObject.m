#import "PGPObject.h"

#import "CCHBinaryDataReader.h"


static struct pgp_object_config object_config = {
  .type = 0,
  .count = 0,
  .vals = NULL
};

@implementation PGPObject

@synthesize data;

- (id) init {
  if ((self = [super init])) {
    _type = -1;
    data = NULL;
  }
  return self;
}

+(struct pgp_object_config)object_config { return object_config; }

int setup_config(CCHBinaryDataReader* binaryReader) {
  NSMutableData *some_vals;
  uint64_t to_copy, copy_val, *new_config;
  uint64_t group_size = 0;

  to_copy = [binaryReader readUnsignedChar];
  if (to_copy > 8) {
    return -1;
  }

  object_config.type = [binaryReader readUnsignedChar];
  if (object_config.type > PGPCONFIG_MAX) {
    return -1;
  }
  
  switch (object_config.type) {
    case PGPCONFIG_INVALID:
      return -1;
    case PGPCONFIG_PRINTMODE:
      // Set the printing mode
      group_size = 1;
      new_config = calloc(to_copy, sizeof(uint8_t) * group_size);
      break;
    case PGPCONFIG_COLORPALLET:
      // Set the color pallet for the print job
      group_size = 5;
      new_config = calloc(to_copy, sizeof(uint8_t) * group_size);
      memset(new_config, '\xff', sizeof(uint8_t) * group_size);
      break;
    case PGPCONFIG_INFO:
      // Set the printer info
      group_size = 4;
      new_config = calloc(to_copy, sizeof(uint8_t) * group_size);
      break;
    default:
      group_size = 8;
  }

  some_vals = [binaryReader readDataWithNumberOfBytes:group_size * to_copy];

  for (int i = 0; i < to_copy; i++) {
    copy_val = 0;
    [some_vals getBytes:&copy_val range:NSMakeRange(i * group_size, group_size)];
    new_config[i] = copy_val;
  }

  object_config.count = to_copy;

  free(object_config.vals);
  object_config.vals = new_config;
  return 0;
}

bool is_valid_config(Class currentClass, struct pgp_object_config config) {
  Class classToCheck = currentClass;

  if (config.type == PGPCONFIG_INVALID || config.vals == NULL) {
    return false;
  }

  // Color pallet is only implemented in versions >= 2
  if (((NSInteger)[classToCheck apiVersion]) < 2 && config.type == PGPCONFIG_COLORPALLET) {
    return false;
  }
  return true;
}

- (NSInteger) parseObjectFromData:(CCHBinaryDataReader*) binaryReader {
  NSLog(@"[PGPObject] Please select API Version");
  return -1;
}

- (NSData *) flattenObj {
  NSMutableString* retString = nil;
  const uint8_t* dataBytes = (uint8_t *)[data bytes];
  if (dataBytes == NULL) {
    return NULL;
  }

  uint64_t dataBytesNum = *(uint64_t *)dataBytes;
  switch (_type) {
    case PGPUINT16:
      retString = [NSMutableString stringWithFormat:@"%hu", (uint16_t)dataBytesNum];
      break;
    case PGPINT16:
      retString = [NSMutableString stringWithFormat:@"%hd", (int16_t)dataBytesNum];
      break;
    case PGPUINT32:
      retString = [NSMutableString stringWithFormat:@"%u", (uint32_t)dataBytesNum];
      break;
    case PGPINT32:
      retString = [NSMutableString stringWithFormat:@"%d", (int32_t)dataBytesNum];
      break;
    case PGPFLOAT:
      retString = [NSMutableString stringWithFormat:@"%f", (float)dataBytesNum];
      break;
    case PGPSTRING:
      retString = [[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
      break;
    case PGPBINARY:
      return [NSData dataWithData:data];
    case PGPCOLOR:
      retString = [NSMutableString stringWithFormat:@"\x1b[%d;%d;%d;%d;%dm", dataBytes[0], dataBytes[1], dataBytes[2], dataBytes[3], dataBytes[4]];
      break;
    case PGPCONFIG:
      return [[NSData alloc] init];
    case PGPINVALID:
    default:
      NSLog(@"[PGPObject] Invalid object");
      return NULL;
  }
  return [retString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) dealloc {
  [data release];
  [super dealloc];
}

@end
