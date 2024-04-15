#import <Foundation/Foundation.h>

#import "PGPPrintQueue.h"
#import "PGPPrintJob.h"
#import "PGPSecurity.h"
#import "PGPIO.h"

@interface PGPPrintManager : NSObject {
  PGPSecurity* _jobSecurity;
  PGPPrintQueue* _printJobs;
  PGPPrintJob* _currentJob;
}

- (id) init;
- (void) sendGreetz;
- (int) getNextJob;
- (void) runJobs;
- (void) addJob:(PGPPrintJob*)job;
- (void) printCurrentJob;
- (void) flushJobs;
- (void) dealloc;

@end
