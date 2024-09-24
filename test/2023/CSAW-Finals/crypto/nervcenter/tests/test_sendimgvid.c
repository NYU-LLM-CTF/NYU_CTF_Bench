#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include "utils.h"
#include "image.h"

int main(void) {
    int fd = open("/dev/null", O_RDWR);
    int r = 0;

    r = load_image_resources();
    if (r != 0) {
        printf("load_image_resources failed\n");
        return 1;
    }

    const char *nonexist_img = "doesnotexist";
    r = sendimg(fd, nonexist_img, 0);
    if (r != -1) {
        printf("sendimg succeeded for non-existent resource '%s'\n",
                nonexist_img);
        return 1;
    }
    const char *exist_img = "./nerv_wide.txt";
    r = sendimg(fd, exist_img, 0);
    if (r != 0) {
        printf("sendimg failed for existent resource '%s'\n",
                exist_img);
        return 1;
    }

    int num_frames = 0;
    const char *nonexist_vid = "doesnotexist";
    // use high fps so that the test doesn't take too long
    num_frames = sendvid(fd, nonexist_vid, 9999);
    if (num_frames != 0) {
        printf("sendvid played non-zero frames (%d) for non-existent resource '%s'\n",
                num_frames, nonexist_vid);
        return 1;
    }

    const char *exist_vid = "./credits";
    num_frames = sendvid(fd, exist_vid, 9999);
    if (num_frames != 2159) {
        printf("sendvid played zero frames for existent resource '%s'\n",
                exist_vid);
        return 1;
    }

    unload_image_resources();

    return 0;
}
