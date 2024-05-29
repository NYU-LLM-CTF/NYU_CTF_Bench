#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#import <Foundation/Foundation.h>

@interface Turtle : NSObject

- (void) say: (NSString *) phrase;

@end

@implementation Turtle

- (void) say: (NSString *) phrase {
  NSLog(@"%@\n", phrase);
}

@end

int main(int argc, char **argv) {
  uint8_t buf[2048 + 0x10];
  setvbuf(stdout, 0, 2, 0);
  setvbuf(stdin, 0, 2, 0);

  Turtle *turtle = [[Turtle alloc] init];
  printf("Here is a Turtle: %p\n", turtle);

  read(0, buf, sizeof(buf));
  memcpy(turtle, buf, sizeof(buf));

  [turtle say: @"I am a turtle."];
  [turtle release];
}
