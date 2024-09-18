#include <stddef.h>
#include <stdint.h>
#include "huffman.h"
#include "dont_obf.h"

int compress(char chr, struct node *i) {
  if (i->text == (char)0xff) {
    int ret = compress(chr, i->left);
    if (ret == 1)
      bitstream_write(0);
    else {
      ret = compress(chr, i->right);
      if (ret == 1)
        bitstream_write(1);
      else {
        return 0;
      }
    }
    return 1;
  } else if (i->text == chr) {
    return 1;
  }
  return 0;
}
