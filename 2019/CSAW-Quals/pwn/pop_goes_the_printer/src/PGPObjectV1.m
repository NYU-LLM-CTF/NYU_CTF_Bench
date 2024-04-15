#import "PGPObjectV1.h"

@implementation PGPObjectV1

@synthesize data;

+ (NSInteger) apiVersion {
  return APIVERSIONV1;
}

- (NSInteger) parseObjectFromData:(CCHBinaryDataReader*) binaryReader {
  _type = [binaryReader readUnsignedChar];

  struct pgp_object_config config = [PGPObject object_config];
  bool valid_config = is_valid_config([PGPObjectV1 class], config);

  switch (_type) {
    case PGPUINT16:
    case PGPINT16:
      data = [binaryReader readDataWithNumberOfBytes:2];
      if (valid_config && config.type == PGPCONFIG_PRINTMODE && config.count == 1) {
        uint16_t new_bytes = config.vals[0];
        [data replaceBytesInRange:NSMakeRange(0, 2) withBytes:&new_bytes length:2];
      }
      break;
    case PGPUINT32:
    case PGPINT32:
    case PGPFLOAT:
      data = [binaryReader readDataWithNumberOfBytes:4];
      break;
    case PGPCONFIG:
      setup_config(binaryReader);
      break;
    case PGPINVALID:
    default:
      NSLog(@"[PGPObjectV1] Invalid object type");
      return -1;
  }
  return 0;
}

@end
