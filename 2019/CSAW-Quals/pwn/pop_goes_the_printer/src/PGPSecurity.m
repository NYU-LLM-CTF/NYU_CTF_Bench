#import "PGPSecurity.h"

#include <stdlib.h>

@implementation PGPSecurity

@synthesize challenge;

- (id) init {
  self = [super init];

#ifdef LINUX
  challenge = (random() << 32) | random();
#else
  arc4random_buf(&(challenge), sizeof(uint64_t));
#endif
  return self;
}

- (BOOL) checkForSecurity:(uint64_t) response {
  uint64_t part1 = challenge >> 16 & 0xffff;
  int64_t  part2 = challenge & 0xffff;
  uint64_t part3 = challenge >> 24 & 0xffff;
  int64_t part4 = challenge >> 40 & 0xffff;
  uint64_t part5 = challenge >> 48 & 0xff;
  int64_t part6 = challenge >> 8 & 0xffffff;

  uint64_t const1 = 0xaa55121d;
  uint64_t const2 = 0x09dea8f58120a8ef;
  float const3 = 0x71829394;

  uint64_t checkme = ((part1 * const3) + part2);
  checkme += ((part3 * part4) ^ part5) / const2;
  checkme -= (part6 * const3) / const1;

  if (checkme != response) {
    return false;
  } else {
    return true;
  }
}

@end
