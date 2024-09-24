#import <Foundation/Foundation.h>

#define PGPRUNJOB 1 << 0
#define PGPQUEUEJOB 1 << 1
#define PGPRUNALLJOBS 1 << 2

#define PGPLATESTVERSION 2

@interface PGPPrintJob : NSObject  {
  NSString* _author;
  NSMutableArray* _objs;
  uint8_t _version;
  uint8_t _cmdBits;
  uint64_t challenge;
}

@property (nonatomic) uint64_t challenge;

- (id) init;
- (NSInteger) changeAPIVersion;
- (NSInteger) parseNetworkPacket:(NSData*)data;
- (BOOL) shouldQueueJob;
- (BOOL) shouldRunJob;
- (BOOL) shouldRunAllJobs;
- (void) printJob;
- (void) dealloc;

@end
