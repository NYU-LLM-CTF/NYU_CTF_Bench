#import "PGPPrintManager.h"

/**
 * Keeps track of the current print job, when to flush jobs,
 *
 * The vuln is going to be a use after free where the current print job gets
 * completed, but it is then accessed again without another print job being ready
 * There needs to be a divergence/overwrite in a boolean flag which says whether or not
 * a print job exists or not.
 */

@implementation PGPPrintManager

- (id) init {
  if((self = [super init])) {
    _jobSecurity = [[PGPSecurity alloc] init];
    _printJobs = [[PGPPrintQueue alloc] init];
    _currentJob = NULL;
  }
  return self;
}

- (void) sendGreetz {
  [PGPIO doWrite:@"=== PGPPrintServer ==="];
  [PGPIO doWrite:@"%llu", _jobSecurity.challenge];
}

- (int) getNextJob {
  NSMutableData* out = [NSMutableData alloc];
  if ([PGPIO doRead:out] != 0) {
    NSLog(@"[PGPPrintManager] Done reading jobs, exiting");
    exit(0);
  }

  PGPPrintJob* job = [[PGPPrintJob alloc] init];
  if ([job parseNetworkPacket:out] != 0) {
    NSLog(@"[PGPPrintManager] Unable to parse network packet");
    return -1;
  }

  if (![_jobSecurity checkForSecurity:[job challenge]]) {
    [job release];
    return -1;
  }

  if ([job shouldQueueJob]) {
    [self addJob:job];
    goto KBRO;
  }

  if ([job shouldRunAllJobs]) {
    [self runJobs];
    goto KBRO;
  }

  if ([job shouldRunJob]) {
    [job printJob];
  }
  [job release];

KBRO:
  if ([_printJobs count] > 256) {
    [self flushJobs];
  }

  [PGPIO doWrite:@"k bro"];
  return 0;
}

- (void) runJobs {
  NSInteger jobCount = [_printJobs count];
  for (int i = 0; i < jobCount; i++) {
    [self printCurrentJob];
  }
}

- (void) addJob:(PGPPrintJob*)job {
  [_printJobs enqueue:job];
  _currentJob = job;
}

- (void) flushJobs {
  NSLog(@"[PGPPrintManager] Flushing jobs from printer!");
  NSInteger jobCount = [_printJobs count];
  for (int i = 0; i < jobCount; i++) {
    PGPPrintJob* job = [_printJobs dequeue];
    [job release];
  }
  _currentJob = NULL;
}

- (void) printCurrentJob {
  if (_currentJob != NULL) {
    [_currentJob printJob];
    [_currentJob release];
    _currentJob = NULL;
    if ([_printJobs count] > 0) {
      _currentJob = [_printJobs dequeue];
    }
  }
}

- (void) dealloc {
  [_jobSecurity release];
  [self flushJobs];
  [_printJobs release];
  [super dealloc];
}

@end
