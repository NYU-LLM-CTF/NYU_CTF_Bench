#include "pad.h"
#include <sysutil/sysutil.h>
#include <sys/systime.h>

unsigned temp_pad = 0, new_pad = 0, old_pad = 0;

padInfo padinfo;
padData paddata;
int pad_alive=0;

unsigned ps3pad_read()
{
    int n;

    padActParam actparam;

    unsigned butt = 0;

    pad_alive = 0;

    sysUtilCheckCallback();

    ioPadGetInfo(&padinfo);

    for(n = 0; n < MAX_PADS; n++) {
            
        if(padinfo.status[n])  {
         
            ioPadGetData(n, &paddata);
            pad_alive = 1;
            butt = (paddata.button[2] << 8) | (paddata.button[3] & 0xff);
			/*
			if (paddata.button[6] < 0x10 || paddata.button[4] < 0x10)
                butt |= BUTTON_LEFT;
            else if (paddata.button[6] > 0xe0 || paddata.button[4] > 0xe0 )
                butt |= BUTTON_RIGHT;
            if (paddata.button[7] < 0x10 || paddata.button[5] < 0x10)
                butt |= BUTTON_UP;
            else if (paddata.button[7] > 0xe0 || paddata.button[5] > 0xe0 )
                butt |= BUTTON_DOWN;
			*/
            break;
        
        }
    }

		
    temp_pad = butt;

    new_pad = temp_pad & (~old_pad); old_pad = temp_pad;


return butt;
}
