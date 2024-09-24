#import <Foundation/Foundation.h>

#define PGPINVALID 255

#define PGPUINT16   1
#define PGPINT16    2
#define PGPUINT32   3
#define PGPINT32    4
#define PGPFLOAT    5
#define PGPCONFIG   6
#define PGPSTRING   7
#define PGPBINARY   8
#define PGPCOLOR    9

#define PGPCONFIG_INVALID 0
#define PGPCONFIG_PRINTMODE 1
#define PGPCONFIG_COLORPALLET 2
#define PGPCONFIG_INFO 3
#define PGPCONFIG_EDIT 4
#define PGPCONFIG_MAX 5

#define APIVERSIONV1 1
#define APIVERSIONV2 2

#import "CCHBinaryDataReader.h"

struct pgp_object_config {
  uint8_t type;
  uint8_t count;
  uint64_t *vals;
};

int setup_config(CCHBinaryDataReader* binaryReader);
bool is_valid_config(Class currentClass, struct pgp_object_config config);

@interface PGPObject : NSObject {
  NSMutableData *data;
  NSUInteger _type;
}

@property (nonatomic, readonly) NSMutableData *data;

- (id) init;
- (NSInteger) parseObjectFromData:(CCHBinaryDataReader*) binaryReader;
- (NSData *) flattenObj;
- (void) dealloc;

+(struct pgp_object_config)object_config;

@end
