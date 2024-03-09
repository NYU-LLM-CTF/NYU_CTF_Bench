#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>
#include <unistd.h>
#include <math.h>
#include <time.h>
#include <audio/audio.h>

#include <ppu-lv2.h>

#include <io/pad.h>

#include <tiny3d.h>
#include <libfont.h>

#include <ft2build.h>
#include <freetype/freetype.h> 
#include <freetype/ftglyph.h>

#include "PS_ttf_bin.h"
#include "pad.h"

#define ENC(X) 
#define DEC(X)


//*******************************************************
//GUI
//*******************************************************

int ttf_inited = 0;

FT_Library freetype;
FT_Face face;

int TTFLoadFont(char * path, void * from_memory, int size_from_memory)
{
    if(!ttf_inited)
        FT_Init_FreeType(&freetype);
    ttf_inited = 1;

    if(path) {
        if(FT_New_Face(freetype, path, 0, &face)) return -1;
    } else {
        if(FT_New_Memory_Face(freetype, from_memory, size_from_memory, 0, &face)) return -1;
        }

    return 0;
}

void TTFUnloadFont()
{
   FT_Done_FreeType(freetype);
   ttf_inited = 0;
}

void TTF_to_Bitmap(u8 chr, u8 * bitmap, short *w, short *h, short *y_correction)
{
    FT_Set_Pixel_Sizes(face, (*w), (*h));
    
    FT_GlyphSlot slot = face->glyph;

    memset(bitmap, 0, (*w) * (*h));

    if(FT_Load_Char(face, (char) chr, FT_LOAD_RENDER )) {(*w) = 0; return;}

    int n, m, ww;

    *y_correction = (*h) - 1 - slot->bitmap_top;
    
    ww = 0;

    for(n = 0; n < slot->bitmap.rows; n++) {
        for (m = 0; m < slot->bitmap.width; m++) {

            if(m >= (*w) || n >= (*h)) continue;
            
            bitmap[m] = (u8) slot->bitmap.buffer[ww + m];
        }
    
    bitmap += *w;

    ww += slot->bitmap.width;
    }

    *w = ((slot->advance.x + 31) >> 6) + ((slot->bitmap_left < 0) ? -slot->bitmap_left : 0);
    *h = slot->bitmap.rows;
}

void cls()
{
	tiny3d_Clear(0xff180018, TINY3D_CLEAR_ALL);
    
    tiny3d_AlphaTest(1, 0x10, TINY3D_ALPHA_FUNC_GEQUAL);

    tiny3d_BlendFunc(1, TINY3D_BLEND_FUNC_SRC_RGB_SRC_ALPHA | TINY3D_BLEND_FUNC_SRC_ALPHA_SRC_ALPHA,
						TINY3D_BLEND_FUNC_DST_RGB_ONE_MINUS_SRC_ALPHA | TINY3D_BLEND_FUNC_DST_ALPHA_ZERO,
						TINY3D_BLEND_RGB_FUNC_ADD | TINY3D_BLEND_ALPHA_FUNC_ADD);
}

void DrawPressure(float x, float y, float h)
{
    tiny3d_SetPolygon(TINY3D_QUADS);
       
    tiny3d_VertexPos(x    , y    , 0);
    tiny3d_VertexColor(0xa00000ff);

    tiny3d_VertexPos(x + 5, y    , 0);

    tiny3d_VertexPos(x + 5, y - h/10, 0);

    tiny3d_VertexPos(x    , y - h/10, 0);

    tiny3d_End();
}

void Init_Graph()
{
    tiny3d_Init(1024*1024);
    tiny3d_Project2D();

    u32 * texture_mem = tiny3d_AllocTexture(64*1024*1024);

    u32 * texture_pointer;

    if(!texture_mem) exit(0); 

    texture_pointer = texture_mem;

    ResetFont();
   // texture_pointer = (u32 *) AddFontFromBitmapArray((u8 *) font  , (u8 *) texture_pointer, 32, 255, 16, 32, 2, BIT0_FIRST_PIXEL);
	
	TTFLoadFont(NULL, (void *) PS_ttf_bin, PS_ttf_bin_size);
    texture_pointer = (u32 *) AddFontFromTTF((u8 *) texture_pointer, 32, 255, 32, 32, TTF_to_Bitmap);
    TTFUnloadFont();

    int videoscale_x = 0;
    int videoscale_y = 0;

    double sx = (double) Video_Resolution.width;
    double sy = (double) Video_Resolution.height;
    double psx = (double) (1000 + videoscale_x)/1000.0;
    double psy = (double) (1000 + videoscale_y)/1000.0;
    
    tiny3d_UserViewport(1, 
        (float) ((sx - sx * psx) / 2.0), 
        (float) ((sy - sy * psy) / 2.0), 
        (float) ((sx * psx) / 848.0),
        (float) ((sy * psy) / 512.0),
        (float) ((sx / 1920.0) * psx), 
        (float) ((sy / 1080.0) * psy));
}

//*******************************************************
//Main
//*******************************************************

// desired 5004 bytes (need to match, else fail)
// unsigned char desired = {

// }
int main(void)
{
	printf("Starting homebrew");
	// int desired[1008] = {0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2048, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1024, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8192, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 512, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 256, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4096, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8192, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4096, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 512, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2048, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16384, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 256, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4096, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 256, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 512, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32768, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 512, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16384, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16384, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32768, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4096, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1024, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 16384, 0, 0, 0, 0, 0, 0, 0, 0, 0, 256, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

	ioPadInit(7);
	ioPadSetSensorMode(0,1);
	ioPadSetPressMode(0,1);
	padActParam actparam;
	
	Init_Graph();
	int y_max=512,x_max = 848;
	int x_center = 0;
	int x_L3,y_L3, x_R3, y_R3;

	int count = -16 * 4; 
	
	void* controller_check = memalign(0x10, 1008);
	memset(controller_check, 0x00, 1008);

	// allocate an integer array separate from controller check
	int* controller_memory = memalign(0x10, 1008);
	controller_memory[0] = 0;
	controller_memory[1] = 0;
	controller_memory[2] = 0;
	controller_memory[3] = 0;
	controller_memory[4] = 16; // TRIANGLE
	controller_memory[5] = 0;
	controller_memory[6] = 64; // CROSS
	controller_memory[7] = 0;
	controller_memory[8] = 0;
	controller_memory[9] = 0;
	controller_memory[10] = 0;
	controller_memory[11] = 0;
	controller_memory[12] = 0;
	controller_memory[13] = 0;
	controller_memory[14] = 0;
	controller_memory[15] = 0;
	controller_memory[16] = 0;
	controller_memory[17] = 0;
	controller_memory[18] = 4; // L1
	controller_memory[19] = 8; // R1
	controller_memory[20] = 0;
	controller_memory[21] = 0;
	controller_memory[22] = 0;
	controller_memory[23] = 0;
	controller_memory[24] = 0;
	controller_memory[25] = 0;
	controller_memory[26] = 0;
	controller_memory[27] = 0;
	controller_memory[28] = 0;
	controller_memory[29] = 0;
	controller_memory[30] = 0;
	controller_memory[31] = 0;
	controller_memory[32] = 1; // L2
	controller_memory[33] = 2; // R2
	controller_memory[34] = 0;
	controller_memory[35] = 0;
	controller_memory[36] = 0;
	controller_memory[37] = 0;
	controller_memory[38] = 0;
	controller_memory[39] = 0;
	controller_memory[40] = 0;
	controller_memory[41] = 0;
	controller_memory[42] = 0;
	controller_memory[43] = 0;
	controller_memory[44] = 0;
	controller_memory[45] = 0;
	controller_memory[46] = 0;
	controller_memory[47] = 0;
	controller_memory[48] = 0;
	controller_memory[49] = 0;
	controller_memory[50] = 0;
	controller_memory[51] = 0;
	controller_memory[52] = 16; // TRIANGLE
	controller_memory[53] = 0;
	controller_memory[54] = 0;
	controller_memory[55] = 0;
	controller_memory[56] = 0;
	controller_memory[57] = 0;
	controller_memory[58] = 0;
	controller_memory[59] = 2048; // START
	controller_memory[60] = 0;
	controller_memory[61] = 0;
	controller_memory[62] = 0;
	controller_memory[63] = 0;
	controller_memory[64] = 0;
	controller_memory[65] = 0;
	controller_memory[66] = 4; // L1
	controller_memory[67] = 0;
	controller_memory[68] = 0;
	controller_memory[69] = 0;
	controller_memory[70] = 0;
	controller_memory[71] = 128; // SQUARE
	controller_memory[72] = 0;
	controller_memory[73] = 0;
	controller_memory[74] = 0;
	controller_memory[75] = 0;
	controller_memory[76] = 0;
	controller_memory[77] = 0;
	controller_memory[78] = 0;
	controller_memory[79] = 0;
	controller_memory[80] = 0;
	controller_memory[81] = 2; // R2
	controller_memory[82] = 0;
	controller_memory[83] = 0;
	controller_memory[84] = 0;
	controller_memory[85] = 0;
	controller_memory[86] = 0;
	controller_memory[87] = 0;
	controller_memory[88] = 0;
	controller_memory[89] = 0;
	controller_memory[90] = 0;
	controller_memory[91] = 0;
	controller_memory[92] = 4096; // UP
	controller_memory[93] = 0;
	controller_memory[94] = 0;
	controller_memory[95] = 0;
	controller_memory[96] = 0;
	controller_memory[97] = 0;
	controller_memory[98] = 0;
	controller_memory[99] = 8; // R1
	controller_memory[100] = 0;
	controller_memory[101] = 0;
	controller_memory[102] = 0;
	controller_memory[103] = 0;
	controller_memory[104] = 0;
	controller_memory[105] = 512; // L3
	controller_memory[106] = 0;
	controller_memory[107] = 0;
	controller_memory[108] = 0;
	controller_memory[109] = 0;
	controller_memory[110] = 0;
	controller_memory[111] = 0;
	controller_memory[112] = 0;
	controller_memory[113] = 0;
	controller_memory[114] = 0;
	controller_memory[115] = 0;
	controller_memory[116] = 0;
	controller_memory[117] = 0;
	controller_memory[118] = 0;
	controller_memory[119] = 0;
	controller_memory[120] = 0;
	controller_memory[121] = 0;
	controller_memory[122] = 1024; // R3
	controller_memory[123] = 0;
	controller_memory[124] = 0;
	controller_memory[125] = 0;
	controller_memory[126] = 0;
	controller_memory[127] = 32768; // LEFT
	controller_memory[128] = 0;
	controller_memory[129] = 0;
	controller_memory[130] = 0;
	controller_memory[131] = 0;
	controller_memory[132] = 0;
	controller_memory[133] = 32; // CIRCLE
	controller_memory[134] = 64; // CROSS
	controller_memory[135] = 0;
	controller_memory[136] = 0;
	controller_memory[137] = 0;
	controller_memory[138] = 0;
	controller_memory[139] = 0;
	controller_memory[140] = 0;
	controller_memory[141] = 0;
	controller_memory[142] = 0;
	controller_memory[143] = 0;
	controller_memory[144] = 0;
	controller_memory[145] = 0;
	controller_memory[146] = 0;
	controller_memory[147] = 0;
	controller_memory[148] = 0;
	controller_memory[149] = 0;
	controller_memory[150] = 64; // CROSS
	controller_memory[151] = 0;
	controller_memory[152] = 0;
	controller_memory[153] = 0;
	controller_memory[154] = 0;
	controller_memory[155] = 0;
	controller_memory[156] = 0;
	controller_memory[157] = 8192; // RIGHT
	controller_memory[158] = 0;
	controller_memory[159] = 0;
	controller_memory[160] = 0;
	controller_memory[161] = 0;
	controller_memory[162] = 0;
	controller_memory[163] = 8; // R1
	controller_memory[164] = 0;
	controller_memory[165] = 32; // CIRCLE
	controller_memory[166] = 0;
	controller_memory[167] = 0;
	controller_memory[168] = 0;
	controller_memory[169] = 0;
	controller_memory[170] = 0;
	controller_memory[171] = 0;
	controller_memory[172] = 0;
	controller_memory[173] = 0;
	controller_memory[174] = 0;
	controller_memory[175] = 0;
	controller_memory[176] = 0;
	controller_memory[177] = 2; // R2
	controller_memory[178] = 0;
	controller_memory[179] = 0;
	controller_memory[180] = 0;
	controller_memory[181] = 0;
	controller_memory[182] = 0;
	controller_memory[183] = 0;
	controller_memory[184] = 0;
	controller_memory[185] = 0;
	controller_memory[186] = 0;
	controller_memory[187] = 0;
	controller_memory[188] = 4096; // UP
	controller_memory[189] = 0;
	controller_memory[190] = 0;
	controller_memory[191] = 0;
	controller_memory[192] = 0;
	controller_memory[193] = 0;
	controller_memory[194] = 0;
	controller_memory[195] = 0;
	controller_memory[196] = 0;
	controller_memory[197] = 0;
	controller_memory[198] = 0;
	controller_memory[199] = 0;
	controller_memory[200] = 256; // SELECT
	controller_memory[201] = 0;
	controller_memory[202] = 0;
	controller_memory[203] = 0;
	controller_memory[204] = 0;
	controller_memory[205] = 0;
	controller_memory[206] = 16384; // DOWN
	controller_memory[207] = 0;
	controller_memory[208] = 0;
	controller_memory[209] = 0;
	controller_memory[210] = 4; // L1
	controller_memory[211] = 0;
	controller_memory[212] = 0;
	controller_memory[213] = 0;
	controller_memory[214] = 0;
	controller_memory[215] = 0;
	controller_memory[216] = 256; // SELECT
	controller_memory[217] = 0;
	controller_memory[218] = 0;
	controller_memory[219] = 0;
	controller_memory[220] = 0;
	controller_memory[221] = 0;
	controller_memory[222] = 0;
	controller_memory[223] = 0;
	controller_memory[224] = 0;
	controller_memory[225] = 0;
	controller_memory[226] = 0;
	controller_memory[227] = 0;
	controller_memory[228] = 0;
	controller_memory[229] = 0;
	controller_memory[230] = 0;
	controller_memory[231] = 0;
	controller_memory[232] = 0;
	controller_memory[233] = 512; // L3
	controller_memory[234] = 0;
	controller_memory[235] = 0;
	controller_memory[236] = 0;
	controller_memory[237] = 8192; // RIGHT
	controller_memory[238] = 0;
	controller_memory[239] = 0;
	controller_memory[240] = 1; // L2
	controller_memory[241] = 0;
	controller_memory[242] = 0;
	controller_memory[243] = 0;
	controller_memory[244] = 0;
	controller_memory[245] = 0;
	controller_memory[246] = 64; // CROSS
	controller_memory[247] = 0;
	controller_memory[248] = 0;
	controller_memory[249] = 0;
	controller_memory[250] = 0;
	controller_memory[251] = 0;
	controller_memory[252] = 0;
	controller_memory[253] = 0;
	controller_memory[254] = 0;
	controller_memory[255] = 0;
	controller_memory[256] = 0;
	controller_memory[257] = 0;
	controller_memory[258] = 0;
	controller_memory[259] = 0;
	controller_memory[260] = 0;
	controller_memory[261] = 0;
	controller_memory[262] = 64; // CROSS
	controller_memory[263] = 0;
	controller_memory[264] = 0;
	controller_memory[265] = 0;
	controller_memory[266] = 0;
	controller_memory[267] = 0;
	controller_memory[268] = 4096; // UP
	controller_memory[269] = 0;
	controller_memory[270] = 0;
	controller_memory[271] = 0;
	controller_memory[272] = 0;
	controller_memory[273] = 0;
	controller_memory[274] = 0;
	controller_memory[275] = 0;
	controller_memory[276] = 16; // TRIANGLE
	controller_memory[277] = 0;
	controller_memory[278] = 0;
	controller_memory[279] = 0;
	controller_memory[280] = 0;
	controller_memory[281] = 0;
	controller_memory[282] = 1024; // R3
	controller_memory[283] = 0;
	controller_memory[284] = 0;
	controller_memory[285] = 0;
	controller_memory[286] = 0;
	controller_memory[287] = 0;
	controller_memory[288] = 0;
	controller_memory[289] = 0;
	controller_memory[290] = 0;
	controller_memory[291] = 8; // R1
	controller_memory[292] = 0;
	controller_memory[293] = 0;
	controller_memory[294] = 0;
	controller_memory[295] = 0;
	controller_memory[296] = 0;
	controller_memory[297] = 0;
	controller_memory[298] = 0;
	controller_memory[299] = 2048; // START
	controller_memory[300] = 0;
	controller_memory[301] = 0;
	controller_memory[302] = 0;
	controller_memory[303] = 0;
	controller_memory[304] = 0;
	controller_memory[305] = 0;
	controller_memory[306] = 0;
	controller_memory[307] = 8; // R1
	controller_memory[308] = 16; // TRIANGLE
	controller_memory[309] = 0;
	controller_memory[310] = 0;
	controller_memory[311] = 0;
	controller_memory[312] = 0;
	controller_memory[313] = 0;
	controller_memory[314] = 0;
	controller_memory[315] = 0;
	controller_memory[316] = 0;
	controller_memory[317] = 0;
	controller_memory[318] = 0;
	controller_memory[319] = 0;
	controller_memory[320] = 0;
	controller_memory[321] = 0;
	controller_memory[322] = 0;
	controller_memory[323] = 8; // R1
	controller_memory[324] = 0;
	controller_memory[325] = 0;
	controller_memory[326] = 0;
	controller_memory[327] = 0;
	controller_memory[328] = 0;
	controller_memory[329] = 0;
	controller_memory[330] = 0;
	controller_memory[331] = 2048; // START
	controller_memory[332] = 0;
	controller_memory[333] = 0;
	controller_memory[334] = 0;
	controller_memory[335] = 0;
	controller_memory[336] = 0;
	controller_memory[337] = 0;
	controller_memory[338] = 0;
	controller_memory[339] = 0;
	controller_memory[340] = 0;
	controller_memory[341] = 0;
	controller_memory[342] = 0;
	controller_memory[343] = 128; // SQUARE
	controller_memory[344] = 256; // SELECT
	controller_memory[345] = 0;
	controller_memory[346] = 0;
	controller_memory[347] = 0;
	controller_memory[348] = 0;
	controller_memory[349] = 0;
	controller_memory[350] = 0;
	controller_memory[351] = 0;
	controller_memory[352] = 0;
	controller_memory[353] = 0;
	controller_memory[354] = 0;
	controller_memory[355] = 8; // R1
	controller_memory[356] = 0;
	controller_memory[357] = 0;
	controller_memory[358] = 0;
	controller_memory[359] = 128; // SQUARE
	controller_memory[360] = 0;
	controller_memory[361] = 0;
	controller_memory[362] = 0;
	controller_memory[363] = 0;
	controller_memory[364] = 0;
	controller_memory[365] = 0;
	controller_memory[366] = 0;
	controller_memory[367] = 0;
	controller_memory[368] = 0;
	controller_memory[369] = 0;
	controller_memory[370] = 4; // L1
	controller_memory[371] = 0;
	controller_memory[372] = 16; // TRIANGLE
	controller_memory[373] = 0;
	controller_memory[374] = 0;
	controller_memory[375] = 0;
	controller_memory[376] = 0;
	controller_memory[377] = 0;
	controller_memory[378] = 0;
	controller_memory[379] = 0;
	controller_memory[380] = 0;
	controller_memory[381] = 0;
	controller_memory[382] = 0;
	controller_memory[383] = 0;
	controller_memory[384] = 0;
	controller_memory[385] = 0;
	controller_memory[386] = 0;
	controller_memory[387] = 0;
	controller_memory[388] = 0;
	controller_memory[389] = 0;
	controller_memory[390] = 0;
	controller_memory[391] = 0;
	controller_memory[392] = 256; // SELECT
	controller_memory[393] = 512; // L3
	controller_memory[394] = 0;
	controller_memory[395] = 0;
	controller_memory[396] = 0;
	controller_memory[397] = 0;
	controller_memory[398] = 0;
	controller_memory[399] = 0;
	controller_memory[400] = 0;
	controller_memory[401] = 2; // R2
	controller_memory[402] = 0;
	controller_memory[403] = 0;
	controller_memory[404] = 0;
	controller_memory[405] = 0;
	controller_memory[406] = 0;
	controller_memory[407] = 0;
	controller_memory[408] = 256; // SELECT
	controller_memory[409] = 0;
	controller_memory[410] = 0;
	controller_memory[411] = 0;
	controller_memory[412] = 0;
	controller_memory[413] = 0;
	controller_memory[414] = 0;
	controller_memory[415] = 0;
	controller_memory[416] = 0;
	controller_memory[417] = 0;
	controller_memory[418] = 0;
	controller_memory[419] = 8; // R1
	controller_memory[420] = 0;
	controller_memory[421] = 0;
	controller_memory[422] = 0;
	controller_memory[423] = 0;
	controller_memory[424] = 0;
	controller_memory[425] = 512; // L3
	controller_memory[426] = 0;
	controller_memory[427] = 0;
	controller_memory[428] = 0;
	controller_memory[429] = 0;
	controller_memory[430] = 0;
	controller_memory[431] = 0;
	controller_memory[432] = 1; // L2
	controller_memory[433] = 2; // R2
	controller_memory[434] = 0;
	controller_memory[435] = 0;
	controller_memory[436] = 0;
	controller_memory[437] = 0;
	controller_memory[438] = 0;
	controller_memory[439] = 0;
	controller_memory[440] = 0;
	controller_memory[441] = 0;
	controller_memory[442] = 0;
	controller_memory[443] = 0;
	controller_memory[444] = 0;
	controller_memory[445] = 0;
	controller_memory[446] = 0;
	controller_memory[447] = 0;
	controller_memory[448] = 0;
	controller_memory[449] = 0;
	controller_memory[450] = 4; // L1
	controller_memory[451] = 0;
	controller_memory[452] = 0;
	controller_memory[453] = 0;
	controller_memory[454] = 0;
	controller_memory[455] = 128; // SQUARE
	controller_memory[456] = 0;
	controller_memory[457] = 0;
	controller_memory[458] = 0;
	controller_memory[459] = 0;
	controller_memory[460] = 0;
	controller_memory[461] = 0;
	controller_memory[462] = 0;
	controller_memory[463] = 0;
	controller_memory[464] = 0;
	controller_memory[465] = 0;
	controller_memory[466] = 0;
	controller_memory[467] = 0;
	controller_memory[468] = 0;
	controller_memory[469] = 0;
	controller_memory[470] = 0;
	controller_memory[471] = 0;
	controller_memory[472] = 0;
	controller_memory[473] = 0;
	controller_memory[474] = 0;
	controller_memory[475] = 0;
	controller_memory[476] = 0;
	controller_memory[477] = 0;
	controller_memory[478] = 16384; // DOWN
	controller_memory[479] = 32768; // LEFT
	controller_memory[480] = 0;
	controller_memory[481] = 0;
	controller_memory[482] = 0;
	controller_memory[483] = 0;
	controller_memory[484] = 0;
	controller_memory[485] = 0;
	controller_memory[486] = 64; // CROSS
	controller_memory[487] = 0;
	controller_memory[488] = 0;
	controller_memory[489] = 0;
	controller_memory[490] = 0;
	controller_memory[491] = 2048; // START
	controller_memory[492] = 0;
	controller_memory[493] = 0;
	controller_memory[494] = 0;
	controller_memory[495] = 0;
	controller_memory[496] = 0;
	controller_memory[497] = 0;
	controller_memory[498] = 0;
	controller_memory[499] = 8; // R1
	controller_memory[500] = 0;
	controller_memory[501] = 0;
	controller_memory[502] = 0;
	controller_memory[503] = 0;
	controller_memory[504] = 0;
	controller_memory[505] = 0;
	controller_memory[506] = 0;
	controller_memory[507] = 2048; // START
	controller_memory[508] = 0;
	controller_memory[509] = 0;
	controller_memory[510] = 0;
	controller_memory[511] = 0;
	controller_memory[512] = 0;
	controller_memory[513] = 0;
	controller_memory[514] = 0;
	controller_memory[515] = 8; // R1
	controller_memory[516] = 0;
	controller_memory[517] = 0;
	controller_memory[518] = 64; // CROSS
	controller_memory[519] = 0;
	controller_memory[520] = 0;
	controller_memory[521] = 0;
	controller_memory[522] = 0;
	controller_memory[523] = 0;
	controller_memory[524] = 0;
	controller_memory[525] = 0;
	controller_memory[526] = 0;
	controller_memory[527] = 0;
	controller_memory[528] = 0;
	controller_memory[529] = 0;
	controller_memory[530] = 0;
	controller_memory[531] = 8; // R1
	controller_memory[532] = 0;
	controller_memory[533] = 0;
	controller_memory[534] = 0;
	controller_memory[535] = 0;
	controller_memory[536] = 0;
	controller_memory[537] = 0;
	controller_memory[538] = 0;
	controller_memory[539] = 0;
	controller_memory[540] = 0;
	controller_memory[541] = 0;
	controller_memory[542] = 0;
	controller_memory[543] = 32768; // LEFT
	controller_memory[544] = 0;
	controller_memory[545] = 0;
	controller_memory[546] = 0;
	controller_memory[547] = 0;
	controller_memory[548] = 0;
	controller_memory[549] = 0;
	controller_memory[550] = 0;
	controller_memory[551] = 0;
	controller_memory[552] = 0;
	controller_memory[553] = 0;
	controller_memory[554] = 0;
	controller_memory[555] = 0;
	controller_memory[556] = 4096; // UP
	controller_memory[557] = 0;
	controller_memory[558] = 0;
	controller_memory[559] = 32768; // LEFT
	controller_memory[560] = 0;
	controller_memory[561] = 0;
	controller_memory[562] = 0;
	controller_memory[563] = 0;
	controller_memory[564] = 0;
	controller_memory[565] = 32; // CIRCLE
	controller_memory[566] = 0;
	controller_memory[567] = 0;
	controller_memory[568] = 0;
	controller_memory[569] = 0;
	controller_memory[570] = 1024; // R3
	controller_memory[571] = 0;
	controller_memory[572] = 0;
	controller_memory[573] = 0;
	controller_memory[574] = 0;
	controller_memory[575] = 0;
	controller_memory[576] = 0;
	controller_memory[577] = 0;
	controller_memory[578] = 0;
	controller_memory[579] = 0;
	controller_memory[580] = 16; // TRIANGLE
	controller_memory[581] = 0;
	controller_memory[582] = 0;
	controller_memory[583] = 0;
	controller_memory[584] = 256; // SELECT
	controller_memory[585] = 0;
	controller_memory[586] = 0;
	controller_memory[587] = 0;
	controller_memory[588] = 0;
	controller_memory[589] = 0;
	controller_memory[590] = 0;
	controller_memory[591] = 0;
	controller_memory[592] = 0;
	controller_memory[593] = 0;
	controller_memory[594] = 0;
	controller_memory[595] = 0;
	controller_memory[596] = 0;
	controller_memory[597] = 0;
	controller_memory[598] = 0;
	controller_memory[599] = 0;
	controller_memory[600] = 0;
	controller_memory[601] = 0;
	controller_memory[602] = 0;
	controller_memory[603] = 0;
	controller_memory[604] = 4096; // UP
	controller_memory[605] = 0;
	controller_memory[606] = 0;
	controller_memory[607] = 32768; // LEFT
	controller_memory[608] = 0;
	controller_memory[609] = 0;
	controller_memory[610] = 0;
	controller_memory[611] = 0;
	controller_memory[612] = 16; // TRIANGLE
	controller_memory[613] = 0;
	controller_memory[614] = 0;
	controller_memory[615] = 0;
	controller_memory[616] = 0;
	controller_memory[617] = 0;
	controller_memory[618] = 0;
	controller_memory[619] = 0;
	controller_memory[620] = 0;
	controller_memory[621] = 0;
	controller_memory[622] = 16384; // DOWN
	controller_memory[623] = 0;
	controller_memory[624] = 0;
	controller_memory[625] = 0;
	controller_memory[626] = 0;
	controller_memory[627] = 0;
	controller_memory[628] = 16; // TRIANGLE
	controller_memory[629] = 0;
	controller_memory[630] = 0;
	controller_memory[631] = 0;
	controller_memory[632] = 0;
	controller_memory[633] = 0;
	controller_memory[634] = 1024; // R3
	controller_memory[635] = 0;
	controller_memory[636] = 0;
	controller_memory[637] = 0;
	controller_memory[638] = 0;
	controller_memory[639] = 0;
	controller_memory[640] = 0;
	controller_memory[641] = 0;
	controller_memory[642] = 0;
	controller_memory[643] = 0;
	controller_memory[644] = 0;
	controller_memory[645] = 0;
	controller_memory[646] = 0;
	controller_memory[647] = 0;
	controller_memory[648] = 0;
	controller_memory[649] = 0;
	controller_memory[650] = 0;
	controller_memory[651] = 0;
	controller_memory[652] = 4096; // UP
	controller_memory[653] = 0;
	controller_memory[654] = 0;
	controller_memory[655] = 32768; // LEFT
	controller_memory[656] = 0;
	controller_memory[657] = 2; // R2
	controller_memory[658] = 0;
	controller_memory[659] = 0;
	controller_memory[660] = 0;
	controller_memory[661] = 0;
	controller_memory[662] = 0;
	controller_memory[663] = 0;
	controller_memory[664] = 0;
	controller_memory[665] = 0;
	controller_memory[666] = 0;
	controller_memory[667] = 0;
	controller_memory[668] = 4096; // UP
	controller_memory[669] = 0;
	controller_memory[670] = 0;
	controller_memory[671] = 0;
	controller_memory[672] = 0;
	controller_memory[673] = 0;
	controller_memory[674] = 0;
	controller_memory[675] = 0;
	controller_memory[676] = 0;
	controller_memory[677] = 0;
	controller_memory[678] = 0;
	controller_memory[679] = 0;
	controller_memory[680] = 0;
	controller_memory[681] = 0;
	controller_memory[682] = 1024; // R3
	controller_memory[683] = 0;
	controller_memory[684] = 0;
	controller_memory[685] = 0;
	controller_memory[686] = 0;
	controller_memory[687] = 32768; // LEFT
	controller_memory[688] = 0;
	controller_memory[689] = 0;
	controller_memory[690] = 0;
	controller_memory[691] = 0;
	controller_memory[692] = 0;
	controller_memory[693] = 32; // CIRCLE
	controller_memory[694] = 0;
	controller_memory[695] = 0;
	controller_memory[696] = 0;
	controller_memory[697] = 512; // L3
	controller_memory[698] = 0;
	controller_memory[699] = 0;
	controller_memory[700] = 0;
	controller_memory[701] = 0;
	controller_memory[702] = 0;
	controller_memory[703] = 0;
	controller_memory[704] = 0;
	controller_memory[705] = 0;
	controller_memory[706] = 0;
	controller_memory[707] = 0;
	controller_memory[708] = 16; // TRIANGLE
	controller_memory[709] = 32; // CIRCLE
	controller_memory[710] = 0;
	controller_memory[711] = 0;
	controller_memory[712] = 0;
	controller_memory[713] = 0;
	controller_memory[714] = 0;
	controller_memory[715] = 0;
	controller_memory[716] = 0;
	controller_memory[717] = 0;
	controller_memory[718] = 0;
	controller_memory[719] = 0;
	controller_memory[720] = 0;
	controller_memory[721] = 0;
	controller_memory[722] = 4; // L1
	controller_memory[723] = 0;
	controller_memory[724] = 0;
	controller_memory[725] = 0;
	controller_memory[726] = 0;
	controller_memory[727] = 128; // SQUARE
	controller_memory[728] = 0;
	controller_memory[729] = 0;
	controller_memory[730] = 0;
	controller_memory[731] = 0;
	controller_memory[732] = 0;
	controller_memory[733] = 0;
	controller_memory[734] = 0;
	controller_memory[735] = 0;
	controller_memory[736] = 0;
	controller_memory[737] = 0;
	controller_memory[738] = 0;
	controller_memory[739] = 0;
	controller_memory[740] = 0;
	controller_memory[741] = 0;
	controller_memory[742] = 0;
	controller_memory[743] = 0;
	controller_memory[744] = 0;
	controller_memory[745] = 512; // L3
	controller_memory[746] = 0;
	controller_memory[747] = 0;
	controller_memory[748] = 4096; // UP
	controller_memory[749] = 0;
	controller_memory[750] = 0;
	controller_memory[751] = 0;
	controller_memory[752] = 0;
	controller_memory[753] = 0;
	controller_memory[754] = 4; // L1
	controller_memory[755] = 0;
	controller_memory[756] = 0;
	controller_memory[757] = 0;
	controller_memory[758] = 0;
	controller_memory[759] = 0;
	controller_memory[760] = 0;
	controller_memory[761] = 0;
	controller_memory[762] = 0;
	controller_memory[763] = 2048; // START
	controller_memory[764] = 0;
	controller_memory[765] = 0;
	controller_memory[766] = 0;
	controller_memory[767] = 0;
	controller_memory[768] = 0;
	controller_memory[769] = 0;
	controller_memory[770] = 0;
	controller_memory[771] = 0;
	controller_memory[772] = 0;
	controller_memory[773] = 0;
	controller_memory[774] = 64; // CROSS
	controller_memory[775] = 0;
	controller_memory[776] = 0;
	controller_memory[777] = 0;
	controller_memory[778] = 0;
	controller_memory[779] = 0;
	controller_memory[780] = 4096; // UP
	controller_memory[781] = 0;
	controller_memory[782] = 0;
	controller_memory[783] = 0;
	controller_memory[784] = 0;
	controller_memory[785] = 0;
	controller_memory[786] = 0;
	controller_memory[787] = 8; // R1
	controller_memory[788] = 16; // TRIANGLE
	controller_memory[789] = 0;
	controller_memory[790] = 0;
	controller_memory[791] = 0;
	controller_memory[792] = 0;
	controller_memory[793] = 0;
	controller_memory[794] = 0;
	controller_memory[795] = 0;
	controller_memory[796] = 0;
	controller_memory[797] = 0;
	controller_memory[798] = 0;
	controller_memory[799] = 0;
	controller_memory[800] = 0;
	controller_memory[801] = 0;
	controller_memory[802] = 0;
	controller_memory[803] = 0;
	controller_memory[804] = 0;
	controller_memory[805] = 0;
	controller_memory[806] = 0;
	controller_memory[807] = 0;
	controller_memory[808] = 0;
	controller_memory[809] = 512; // L3
	controller_memory[810] = 0;
	controller_memory[811] = 0;
	controller_memory[812] = 4096; // UP
	controller_memory[813] = 0;
	controller_memory[814] = 0;
	controller_memory[815] = 0;
	controller_memory[816] = 0;
	controller_memory[817] = 0;
	controller_memory[818] = 0;
	controller_memory[819] = 0;
	controller_memory[820] = 0;
	controller_memory[821] = 0;
	controller_memory[822] = 0;
	controller_memory[823] = 128; // SQUARE
	controller_memory[824] = 0;
	controller_memory[825] = 0;
	controller_memory[826] = 0;
	controller_memory[827] = 0;
	controller_memory[828] = 4096; // UP
	controller_memory[829] = 0;
	controller_memory[830] = 0;
	controller_memory[831] = 0;
	controller_memory[832] = 0;
	controller_memory[833] = 0;
	controller_memory[834] = 0;
	controller_memory[835] = 0;
	controller_memory[836] = 0;
	controller_memory[837] = 0;
	controller_memory[838] = 0;
	controller_memory[839] = 0;
	controller_memory[840] = 0;
	controller_memory[841] = 0;
	controller_memory[842] = 0;
	controller_memory[843] = 0;
	controller_memory[844] = 0;
	controller_memory[845] = 8192; // RIGHT
	controller_memory[846] = 0;
	controller_memory[847] = 32768; // LEFT
	controller_memory[848] = 1; // L2
	controller_memory[849] = 0;
	controller_memory[850] = 0;
	controller_memory[851] = 0;
	controller_memory[852] = 0;
	controller_memory[853] = 32; // CIRCLE
	controller_memory[854] = 0;
	controller_memory[855] = 0;
	controller_memory[856] = 0;
	controller_memory[857] = 0;
	controller_memory[858] = 0;
	controller_memory[859] = 0;
	controller_memory[860] = 0;
	controller_memory[861] = 0;
	controller_memory[862] = 0;
	controller_memory[863] = 0;
	controller_memory[864] = 0;
	controller_memory[865] = 0;
	controller_memory[866] = 4; // L1
	controller_memory[867] = 0;
	controller_memory[868] = 0;
	controller_memory[869] = 0;
	controller_memory[870] = 0;
	controller_memory[871] = 0;
	controller_memory[872] = 0;
	controller_memory[873] = 0;
	controller_memory[874] = 1024; // R3
	controller_memory[875] = 0;
	controller_memory[876] = 0;
	controller_memory[877] = 0;
	controller_memory[878] = 0;
	controller_memory[879] = 0;
	controller_memory[880] = 0;
	controller_memory[881] = 0;
	controller_memory[882] = 4; // L1
	controller_memory[883] = 0;
	controller_memory[884] = 0;
	controller_memory[885] = 0;
	controller_memory[886] = 0;
	controller_memory[887] = 0;
	controller_memory[888] = 256; // SELECT
	controller_memory[889] = 0;
	controller_memory[890] = 0;
	controller_memory[891] = 0;
	controller_memory[892] = 0;
	controller_memory[893] = 0;
	controller_memory[894] = 0;
	controller_memory[895] = 0;
	controller_memory[896] = 0;
	controller_memory[897] = 0;
	controller_memory[898] = 0;
	controller_memory[899] = 0;
	controller_memory[900] = 16; // TRIANGLE
	controller_memory[901] = 0;
	controller_memory[902] = 0;
	controller_memory[903] = 0;
	controller_memory[904] = 0;
	controller_memory[905] = 0;
	controller_memory[906] = 0;
	controller_memory[907] = 0;
	controller_memory[908] = 4096; // UP
	controller_memory[909] = 0;
	controller_memory[910] = 0;
	controller_memory[911] = 0;
	controller_memory[912] = 0;
	controller_memory[913] = 0;
	controller_memory[914] = 0;
	controller_memory[915] = 0;
	controller_memory[916] = 16; // TRIANGLE
	controller_memory[917] = 0;
	controller_memory[918] = 0;
	controller_memory[919] = 0;
	controller_memory[920] = 0;
	controller_memory[921] = 0;
	controller_memory[922] = 0;
	controller_memory[923] = 0;
	controller_memory[924] = 4096; // UP
	controller_memory[925] = 0;
	controller_memory[926] = 0;
	controller_memory[927] = 0;
	controller_memory[928] = 0;
	controller_memory[929] = 0;
	controller_memory[930] = 0;
	controller_memory[931] = 0;
	controller_memory[932] = 16; // TRIANGLE
	controller_memory[933] = 0;
	controller_memory[934] = 64; // CROSS
	controller_memory[935] = 0;
	controller_memory[936] = 0;
	controller_memory[937] = 0;
	controller_memory[938] = 0;
	controller_memory[939] = 0;
	controller_memory[940] = 0;
	controller_memory[941] = 0;
	controller_memory[942] = 0;
	controller_memory[943] = 0;
	controller_memory[944] = 0;
	controller_memory[945] = 0;
	controller_memory[946] = 4; // L1
	controller_memory[947] = 0;
	controller_memory[948] = 0;
	controller_memory[949] = 0;
	controller_memory[950] = 0;
	controller_memory[951] = 0;
	controller_memory[952] = 0;
	controller_memory[953] = 0;
	controller_memory[954] = 0;
	controller_memory[955] = 0;
	controller_memory[956] = 0;
	controller_memory[957] = 0;
	controller_memory[958] = 16384; // DOWN
	controller_memory[959] = 0;
	controller_memory[960] = 1; // L2
	controller_memory[961] = 0;
	controller_memory[962] = 4; // L1
	controller_memory[963] = 0;
	controller_memory[964] = 0;
	controller_memory[965] = 0;
	controller_memory[966] = 0;
	controller_memory[967] = 0;
	controller_memory[968] = 0;
	controller_memory[969] = 0;
	controller_memory[970] = 0;
	controller_memory[971] = 0;
	controller_memory[972] = 0;
	controller_memory[973] = 0;
	controller_memory[974] = 0;
	controller_memory[975] = 0;
	controller_memory[976] = 0;
	controller_memory[977] = 0;
	controller_memory[978] = 4; // L1
	controller_memory[979] = 0;
	controller_memory[980] = 0;
	controller_memory[981] = 32; // CIRCLE
	controller_memory[982] = 0;
	controller_memory[983] = 0;
	controller_memory[984] = 0;
	controller_memory[985] = 0;
	controller_memory[986] = 0;
	controller_memory[987] = 0;
	controller_memory[988] = 0;
	controller_memory[989] = 0;
	controller_memory[990] = 0;
	controller_memory[991] = 0;
	controller_memory[992] = 0;
	controller_memory[993] = 0;
	controller_memory[994] = 4; // L1
	controller_memory[995] = 0;
	controller_memory[996] = 0;
	controller_memory[997] = 0;
	controller_memory[998] = 0;
	controller_memory[999] = 0;
	controller_memory[1000] = 0;
	controller_memory[1001] = 0;
	controller_memory[1002] = 0;
	controller_memory[1003] = 0;
	controller_memory[1004] = 0;
	controller_memory[1005] = 8192; // RIGHT
	controller_memory[1006] = 0;
	controller_memory[1007] = 0;


	// init controller memroy to be all 0
	// int controller_memory[5008] = {0};
	printf("Let's check if your controller works...\n");
	
	sleep(1);
	while(count < 16 * 8) {
		sleep(2);
		printf("Count = %d\n", count);		
		if (count == -16)
		{
			DrawString(10, 40, "Get Ready...");		
		}
		else if (count == 0)
		{
			DrawString(10, 40, "GO!");
		}
		
		DrawFormatString(10, 10, "Count = %d\n", count);		

		tiny3d_Flip();
		cls();
		ps3pad_read();
		int x = 0, y=50;
		SetFontAutoCenter(1);
		SetFontSize(20,20);
		SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, "Hmm... I'm trying to poll these inputs right....");

		// printf("X= %d\n", paddata.SENSOR_X);
		SetFontAutoCenter(0);	
		
		if (old_pad  & BUTTON_L3 && old_pad  & BUTTON_R2) actparam.large_motor = paddata.PRE_R2; else actparam.large_motor = 0;
		if (old_pad  & BUTTON_L3 && old_pad  & BUTTON_R3) actparam.small_motor = 1; else actparam.small_motor = 0;
		ioPadSetActDirect(0, &actparam);
		
		y=y_max/2; x= x_center;
		if (old_pad  & BUTTON_LEFT) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawPressure(x-6, y+25, paddata.PRE_LEFT);
		x= DrawString(x, y, " } ");
		y-=30;
		if (old_pad  & BUTTON_UP) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " ~ ");
		DrawPressure(x-6, y+25, paddata.PRE_UP);
		y-=45;
		if (old_pad  & BUTTON_L1) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " L1 ");
		DrawPressure(x-6, y+25, paddata.PRE_L1);
		y-=30;
		if (old_pad  & BUTTON_L2) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " L2 ");
		DrawPressure(x-6, y+25, paddata.PRE_L2);
		y=y_max/2 + 30;
		if (old_pad  & BUTTON_DOWN) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawPressure(x-6, y+25, paddata.PRE_DOWN);
		x= DrawString(x, y, " | ");
		y=y_max/2;
		if (old_pad  & BUTTON_RIGHT) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawPressure(x-6, y+25, paddata.PRE_RIGHT);
		x = DrawString(x, y, " { ");
		/*
		y+=120;
		SetFontColor(0xffffffff, 0x0);
		DrawFormatString(x, y, "x= %d", paddata.button[6] - 128 );
		y+=30;
		DrawFormatString(x, y, "y= %d", paddata.button[7] - 128 );
		*/
		y=y_max/2 + 60;
		x_L3 = x + (paddata.button[6] - 128)/5;
		y_L3 = y + (paddata.button[7] - 128)/5;
		if (old_pad  & BUTTON_L3) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x_L3, y_L3, " L3 ");
		y=y_max/2; x+=30;
		if (old_pad  & BUTTON_SELECT) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		x = DrawString(x, y, " SELECT ");
		if(x<x_max/2) x_center = x_max/2 - x;
		x+=25; 
		if (old_pad  & BUTTON_START) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		x=DrawString(x, y, " START ");
		/*
		y+=120;
		SetFontColor(0xffffffff, 0x0);
		DrawFormatString(x, y, "x= %d", paddata.button[4] - 128 );
		y+=30;
		DrawFormatString(x, y, "y= %d", paddata.button[5] - 128 );
		*/

		y=y_max/2 + 60;
		x_R3 = x +(paddata.button[4] - 128)/5;
		y_R3 = y +(paddata.button[5] - 128)/5;
		if (old_pad  & BUTTON_R3) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x_R3, y_R3, " R3 ");
		y=y_max/2; x+=30;
		if (old_pad  & BUTTON_SQUARE) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawPressure(x-6, y+25, paddata.PRE_SQUARE);
		x=DrawString(x , y, " $ ");
		y-=30; 
		if (old_pad  & BUTTON_TRIANGLE) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " % ");
		DrawPressure(x-6, y+25, paddata.PRE_TRIANGLE);
		y-=45;
		if (old_pad  & BUTTON_R1) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " R1 ");
		DrawPressure(x-6, y+25, paddata.PRE_R1);
		y-=30;
		if (old_pad  & BUTTON_R2) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " R2 ");
		DrawPressure(x-6, y+25, paddata.PRE_R2);
		y=y_max/2+30;
		if (old_pad  & BUTTON_CROSS) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawPressure(x-6, y+25, paddata.PRE_CROSS);
		x=DrawString(x, y, " & ");
		y=y_max/2;
		if (old_pad  & BUTTON_CIRCLE) SetFontColor(0xffffffff, 0x00a000ff) ; else SetFontColor(0xffffffff, 0x0);
		DrawString(x, y, " # ");
		DrawPressure(x-6, y+25, paddata.PRE_CIRCLE);

		// check button pressed
		// get pressed buttons values

		int button_l2 = old_pad & BUTTON_L2;
		int button_r2 = old_pad & BUTTON_R2;
		int button_l1 = old_pad & BUTTON_L1;
		int button_r1 = old_pad & BUTTON_R1;

		int button_triangle = old_pad & BUTTON_TRIANGLE;
		int button_circle = old_pad & BUTTON_CIRCLE;
		int button_cross = old_pad & BUTTON_CROSS;
		int button_square = old_pad & BUTTON_SQUARE;

		int button_select = old_pad & BUTTON_SELECT;
		int button_l3 = old_pad & BUTTON_L3;
		int button_r3 = old_pad & BUTTON_R3;
		int button_start = old_pad & BUTTON_START;

		int button_up = old_pad & BUTTON_UP;
		int button_right = old_pad & BUTTON_RIGHT;
		int button_down = old_pad & BUTTON_DOWN;
		int button_left = old_pad & BUTTON_LEFT;

		// now check if the buttons correspond to the desired 
		// printf(controller_memory[0]);
		// printf(desired[count]);

		// if (count == -16)
		// {
		// 	printf("And..... GO! \n");
		// }

		if (count >= 0)
		{
			// if (count >= 0)
			// {
			// 	DrawFormatString(50, 100 , "X= %rd", paddata.SENSOR_X);
			// 	DrawFormatString(50, 130 , "Y= %d", paddata.SENSOR_Y);
			// 	DrawFormatString(50, 160, "Z= %d", paddata.SENSOR_Z);
			// 	DrawFormatString(50, 190, "G= %d", paddata.SENSOR_G);
			// }

			if (button_l2 != controller_memory[count] || 
			button_r2 != controller_memory[count + 1] || 
			button_l1 != controller_memory[count + 2] ||	
			button_r1 != controller_memory[count + 3] ||
			button_triangle != controller_memory[count + 4] ||
			button_circle != controller_memory[count + 5] ||
			button_cross != controller_memory[count + 6] ||
			button_square != controller_memory[count + 7] ||
			button_select != controller_memory[count + 8] ||
			button_l3 != controller_memory[count + 9] ||
			button_r3 != controller_memory[count + 10] ||
			button_start != controller_memory[count + 11] 
			// button_up != controller_memory[count + 12] ||
			// button_right != controller_memory[count + 13] ||
			// button_down != controller_memory[count + 14] ||
			// button_left != controller_memory[count + 15])
			)
			{
				printf("BUTTON R3 = %d\n", old_pad & BUTTON_R3); //1024
				printf("BUTTON L3 = %d\n", old_pad & BUTTON_L3); // 512
				printf("BUTTON R2 = %d\n", old_pad & BUTTON_R2); // 2
				printf("BUTTON L2 = %d\n", old_pad & BUTTON_L2); // 1
				printf("BUTTON R1 = %d\n", old_pad & BUTTON_R1); // 8 
				printf("BUTTON L1 = %d\n", old_pad & BUTTON_L1); // 4
				printf("BUTTON CROSS = %d\n", old_pad & BUTTON_CROSS); //64
				printf("BUTTON CIRCLE = %d\n", old_pad & BUTTON_CIRCLE); //32
				printf("BUTTON SQUARE = %d\n", old_pad & BUTTON_SQUARE); //128
				printf("BUTTON TRIANGLE = %d\n", old_pad & BUTTON_TRIANGLE); //16
				printf("BUTTON START = %d\n", old_pad & BUTTON_START); // 2048
				printf("BUTTON SELECT = %d\n", old_pad & BUTTON_SELECT); // 256
				// printf("BUTTON UP = %d\n", old_pad & BUTTON_UP);  //4096
				// printf("BUTTON DOWN = %d\n", old_pad & BUTTON_DOWN); // 16384
				// printf("BUTTON LEFT = %d\n", old_pad & BUTTON_LEFT); //32768
				// printf("BUTTON RIGHT = %d\n", old_pad & BUTTON_RIGHT); //8192
				
				printf("ah you did not catch me, good luck next time! \n");		
				sleep(1);
				return 0;
			}

		}

		controller_memory[count] = button_l2 * 2;
		controller_memory[count + 1] = button_r2 * 2;
		controller_memory[count + 2] = button_l1 * 2;
		controller_memory[count + 3] = button_r1 * 2;
		controller_memory[count + 4] = button_triangle * 2;
		controller_memory[count + 5] = button_circle * 2;
		controller_memory[count + 6] = button_cross * 2;
		controller_memory[count + 7] = button_square * 2;
		controller_memory[count + 8] = button_select * 2;
		controller_memory[count + 9] = button_l3 * 2;
		controller_memory[count + 10] = button_r3 * 2;
		controller_memory[count + 11] = button_start * 2;
		controller_memory[count + 12] = button_up * 2;
		controller_memory[count + 13] = button_right * 2;
		controller_memory[count + 14] = button_down * 2;
		controller_memory[count + 15] = button_left * 2;

		if (count == 16 * 1)
		{
			DrawString(10, 40, "The development kit, 'Linux (for PlayStation 2) release 1.0', is geared towards the Linux development community and will allow full access to the PlayStation 2 runtime environment and systems manuals. The kit includes an internal 40G-byte hard disk drive for the console, Ethernet adapter, Linux kernel 2.2.1, computer monitor adapter, USB keyboard and mouse and other software");
		}
		if (count == 16 * 2)
		{
			DrawString(10, 40, "As the global leader our mission at Sony Computer Entertainment is to create products that truly Inspire and entertain fans around the world and it's really amazing to witness such enthusiasm for our new platform so now on to PlayStation 3. It is powered by cell along with our partners IBM and Toshiba we have invested billions of dollars and hundreds of thousands of man-hours in creating a cell processor; it's a processor with power ritling that of super computers but is uniquely designed to support massive data processing required for Digital entertainment and other HD intensive applications. - Kaz Hirai");
		}
		if (count == 16 * 3)
		{
			DrawString(10, 40, "Air Force Research Laboratory's ribbon cutting will be a significant event in the history of supercomputing. Condor is a 500 TFLOPS supercomputer. Such capability exceeds any other interactive supercomputer currently used by the Department of Defense (a total of 84 dual, six core server processors function as headnodes, each coordinating the operation of 22 PS3's, to drive the Condor). The total cost of the Condor system was approximately $2 million, which is a cost savings of between 10 and 20 times for the equivalent capability - Mark Barnell");
		}
		if (count == 16 * 4)
		{
			DrawString(10, 40, "Now, let me first say that Homebrew is sometimes a misused term and so for the purposes of this answer I will exclude pirates and hackers with illegal intentions from the definition. I fully support the notion of game development at home using powerful tools available to anyone. We were one of the first companies to recognize this in 1996 with Net Yaroze on PS1. It's a vital, crucial aspect of the future growth of our industry and links well to the subtext of my earlier answers. When I started making games on the Commodore 64 in the 1980's, the way I learned to make games was by re-writing games that appeared in magazines. Really the best bit about a C64 was when you turned it on it said Ready with a flashing cursor - inviting you to experiment. You'd spend hours typing in the code, line-by-line, and then countless hours debugging it to make it work and then you'd realise the game was rubbish after all that effort! The next step was to re-write aspects of the game to change the graphics, the sound, the control system or the speed of the gameplay until you'd created something completely new. I might share this with a few friends but not for commercial gain at that time. But the process itself was invaluable in helping me learn to program, to design graphics, animations or sounds and was really the way I opened doors to get into the industry. Now, those industry doors are largely closed by the nature of the video game systems themselves being closed. So, if we can make certain aspects of PS3 open to the independent game development community, we will do our industry a service by providing opportunities for the next generation of creative and technical talent. Now having said all that, we still have to protect the investment and intellectual property rights of the industry so we will always seek the best ways to secure and protect our devices from piracy and unauthorized hacking that damages the business - Phil Harison");
		}
		if (count == 16 * 5)
		{
			DrawString(10, 40, "Thank you for choosing Yellow Dog Linux! When Sony Computer Entertainment designed the PLAYSTATION®3 (PS3™), it was fully intended that you, a PS3 owner could play games, watch movies, view photos, listen to music, and run a full­featured Linux operating system that transforms your PS3 into a home computer. Yellow Dog Linux for PS3 combines a simple to use graphical installer with leading­edge components and a foundation of must­have home, office, and server applications. Everything you need to browse the web, check and compose email, do your school homework or take your office work home is included with more than 2000 packages on the Install DVD.");
		}
		if (count == 16 * 6)
		{
			DrawString(10, 40, "I have read/write access to the entire system memory, and HV level access to the processor. In other words, I have hacked the PS3. The rest is just software. And reversing. I have a lot of reversing ahead of me, as I now have dumps of LV0 and LV1. I've also dumped the NAND without removing it or a modchip. 3 years, 2 months, 11 days...thats a pretty secure system. Took 5 weeks, 3 in Boston, 2 here, very simple hardware cleverly applied, and some not so simple software. As far as the exploit goes, I'm not revealing it yet. The theory isn't really patchable, but they can make implementations much harder. Also, for obvious reasons I can't post dumps. I'm hoping to find the decryption keys and post them, but they may be embedded in hardware. Hopefully keys are setup like the iPhone's KBAG - Geohot");
		}
		if (count == 16 * 7)
		{
			DrawString(10, 40, "PS3 Firmware (v3.21) Update: The next system software update for the PlayStation 3 (PS3) system will be released on April 1, 2010 (JST), and will disable the “Install Other OS” feature that was available on the PS3 systems prior to the current slimmer models, launched in September 2009. This feature enabled users to install an operating system, but due to security concerns, Sony Computer Entertainment will remove the functionality through the 3.21 system software update. In addition, disabling the “Other OS” feature will help ensure that PS3 owners will continue to have access to the broad range of gaming and entertainment content from SCE and its content partners on a more secure system. Consumers and organizations that currently use the “Other OS” feature can choose not to upgrade their PS3 systems.");
		}
		if (count == 16 * 8)
		{
			DrawString(10, 40, "Defendants George Hotz, “Bushing,” Hector Cantero, Sven Peter and “Segher” are computer hackers. Working individually and in concert with one another, Defendants recently bypassed effective technological protection measures (“TPMs”) employed by plaintiff Sony Computer Entertainment America LLP (“SCEA”) in its proprietary PlayStation®3 computer entertainment system (“PS3 System”). Through the Internet, Defendants are distributing software, tools and instructions (collectively, “Circumvention Devices”) that circumvent the TPMs in the PS3 System and facilitate the counterfeiting of video games. Already, pirated video games are being packaged and distributed with these circumvention devices. SCEA moves ex parte to put an immediate halt to the ongoing distribution of these illegal Circumvention Devices and avoid irreparable harm to SCEA and to other video game software developers stemming from video game piracy - Richard Seeborg");
		}
		if (count == 16 * 9)
		{
			DrawString(10, 40, "Sony is attempting to use the DMCA to deny computer scientists the right to speak about technical details of certain Sony products. This assault on free speech is intolerable and must not go unanswered. As a computer scientist, I am interested in how Sony PS3 protection works, how it was broken by Fail0verflow, the further contributions of George Hotz, and the steps needed to make the PS3 able to run Linux once again. Since I am actually a computer science professor, I am particularly interested in how this information can best be taught to others who desire to learn it. I do not believe there is anything improper, much less illegal, in teaching people computer science. - David S. Touretzky");
		}
		if (count == 16 * 10)
		{
			DrawString(10, 40, "Yo, it's Geohot; And for those that don't know; I'm getting sued by Sony; Let's take this out of the courtroom and into the streets; I'm a beast, at the least, you'll face me in the northeast; Get my ire up, light my fire; I'll go harder than Eminem went at Mariah; Call me a liar; Pound me in the ass with no lube, chafing; You're fucking with the dude who got the keys to your safe; And those that can't do bring suits; Cry to your Uncle Sam to settle disputes; Thought you'd tackle this with a little more tact; But then again fudgepackers, I don't know Jack; I shed a tear everytime I think of Lik Sang; But shit man, they're a corporation; And I'm a personification of freedom for all; You fill dockets, like thats a concept foreign to y'all; While lawyers muddy water and TROs stall; Out of business is jail for me; And you're suing me civilly; Exhibit this in the courtroom; Go on, do it, I dare you");
		}
		if (count == 16 * 11)
		{
			DrawString(10, 40, "IT IS HEREBY ORDERED AND ADJUDGED by consent of the Parties that Hotz... shall be and hereby are permanently enjoined and restrained from: engaging in any unauthorized access to any SONY PRODUCT under the law, engaging in any unauthorized access to any SONY PRODUCT under the terms of any SCEA or SCEA AFFILIATES' license agreement or terms of use applicable to that SONY PRODUCT, including reverse engineering, decompiling, or disassembling any portion of the Sony Product, using any tools to bypass, disable, or circumvent any encryption, security, or authentication mechanism in the Sony Product, using any hardware or softare to cause the Sony Product to accept or use unauthorized, illegal or pirated softare or hardware; and exploiting any Sony Product to design, develop, update or distribute unauthorized softare or hardware for use with the Sony Product... - Susan Illston");
		}
		if (count == 16 * 12)
		{
			DrawString(10, 40, "Plaintiffs Derrick Alba, Jason Baker, James Girardi, Jonathan Huber, and Anthony Ventura, hereby move for preliminary approval of the Stipulation of Class Action Settlement and Release; they reached with Defendant Sony Computer Entertainment America LLC, currently known as Sony Interactive Entertainment America LLC after nearly six years of litigation and many months of settlement negotiations. The action arose out of SCEA’s marketing and sale of the Sony PlayStation®3 (“PS3”). Plaintiffs allege that Defendant marketed the PS3 as having the ability to run an operating system (such as Linux) in addition to the native game operating system (henceforth referred to as “Other OS”), and that SCEA subsequently removed the “Other OS” functionality via firmware update 3.21, harming PS3 purchasers.  About 10 million consumers nationwide are eligible to submit a Claim Form to receive a cash payment in the amount of either $55.00 or $9.00. - Yvonne Gonzalez Rogers");
		}

		count += 16;
	}

	printf("Nice job, you did it ... check my regs :) \n");
	while(1) {}

	return 0;
}
