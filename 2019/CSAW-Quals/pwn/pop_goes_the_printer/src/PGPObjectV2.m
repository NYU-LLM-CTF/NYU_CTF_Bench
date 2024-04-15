#import "PGPObjectV2.h"

@implementation PGPObjectV2

@synthesize data;

+ (NSInteger) apiVersion {
  return APIVERSIONV2;
}

- (NSInteger) parseObjectFromData:(CCHBinaryDataReader*) binaryReader {
  struct pgp_object_config config = [PGPObject object_config];
  bool valid_config = is_valid_config([PGPObjectV2 class], config);

  unsigned short len;
  uint8_t color;
  uint64_t color_bytes;

  _type = [binaryReader readUnsignedChar];
  switch (_type) {
    case PGPUINT16:
    case PGPINT16:
      data = [binaryReader readDataWithNumberOfBytes:2];
      break;
    case PGPUINT32:
    case PGPINT32:
    case PGPFLOAT:
      data = [binaryReader readDataWithNumberOfBytes:4];
      break;
    case PGPSTRING:
      len = [binaryReader readUnsignedShort];
      data = [binaryReader readDataWithNumberOfBytes:len];
      break;
    case PGPBINARY:
      len = [binaryReader readUnsignedShort];

      size_t binDataLen = len * 2 + 1;
      uint8_t* binaryData = malloc(binDataLen);
      for (int i = 0; i < len; i += 2) {
        binaryData[i] = '1';
        binaryData[i + 1] = '0';
      }
      binaryData[len*2] = '\0';

      data = [NSMutableData dataWithBytes:binaryData length:binDataLen];
      free(binaryData);
      break;
    case PGPCOLOR:
      color = [binaryReader readUnsignedChar];
      if (valid_config && config.type == PGPCONFIG_COLORPALLET) {
        color_bytes = config.vals[color];
        data = [NSMutableData dataWithBytes:&color_bytes length:4];
      } else {
        return -1;
      }
      break;
    case PGPCONFIG:
      setup_config(binaryReader);
      break;
    case PGPINVALID:
    default:
      NSLog(@"[PGPObjectV2] Invalid object type");
      return -1;
  }
  return 0;
}

@end
