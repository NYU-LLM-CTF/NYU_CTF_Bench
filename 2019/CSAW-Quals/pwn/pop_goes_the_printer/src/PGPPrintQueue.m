#import "PGPPrintQueue.h"

@implementation PGPPrintQueue

- (id) init {
    if ((self = [super init])) {
      _data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) enqueue:(PGPPrintJob*) anObject {
    [_data addObject:anObject];
}

- (PGPPrintJob*) dequeue {
    PGPPrintJob* headObject = [_data objectAtIndex:0];
    if (headObject != nil) {
        [_data removeObjectAtIndex:0];
    }
    return headObject;
}

- (NSInteger) count {
  return [_data count];
}

@end
