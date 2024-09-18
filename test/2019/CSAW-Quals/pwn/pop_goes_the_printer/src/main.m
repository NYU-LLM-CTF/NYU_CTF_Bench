//
//  main.m
//  Pop Goes The Printer
//
//  Created by Christopher Thompson on 10/30/17.
//  Copyright © 2017 Christopher Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGPPrintManager.h"
#import "PGPObject.h"
#import "PGPObjectV1.h"
#import "PGPObjectV2.h"

int main(int argc, const char * argv[]) {
  // TODO
  // Figure out how to swizzle API versions
  // Find way to expose global objc class, PGPPrintJobV1 or 2, being vulnerable to uninitialized variable which can be controlled by the user
  // Have class method called in one func, and then access stack variable in another method
  // Get arbituary write by creating a fake dtable which has one of the blocks pointing to some writeable location
  // Keep doing this to get arbituary write and write out your ROP chain
  // Change method to something actually used and use a stack pivot
  NSAutoreleasePool *myPool = [[NSAutoreleasePool alloc] init];

  PGPPrintManager* manager = [[PGPPrintManager alloc] init];
  [manager sendGreetz];

  while (true) {
    [manager getNextJob];
  }

  [manager release];
  return 0;
}
