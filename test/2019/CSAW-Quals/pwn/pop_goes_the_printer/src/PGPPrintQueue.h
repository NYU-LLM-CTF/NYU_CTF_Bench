#import <Foundation/Foundation.h>
#import "PGPPrintJob.h"

@interface PGPPrintQueue : NSObject {
    NSMutableArray *_data;
}

- (void) enqueue:(PGPPrintJob*) anObject;
- (PGPPrintJob*) dequeue;
- (NSInteger) count;

@end
