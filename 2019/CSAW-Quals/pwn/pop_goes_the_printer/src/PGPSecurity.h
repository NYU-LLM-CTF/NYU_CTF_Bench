#import <Foundation/Foundation.h>

@interface PGPSecurity : NSObject {
  uint64_t challenge;
}

@property (nonatomic) uint64_t challenge;

- (id) init;
- (BOOL) checkForSecurity:(uint64_t) response;

@end

void beAWinner();
