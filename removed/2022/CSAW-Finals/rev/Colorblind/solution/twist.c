/*  twist.c  version 1.1  may 6, 2002  */


#include  <stdio.h>
#include  <stdlib.h>
#include  <string.h>


typedef struct cube
        {
        int             edges[24];
        int             corners[24];
        }
        Cube;


#define  MAX_INPUT_LENGTH                 1024


/*  number the corner cubies  */

#define  CORNER_UFR                          0
#define  CORNER_URB                          1
#define  CORNER_UBL                          2
#define  CORNER_ULF                          3
#define  CORNER_DRF                          4
#define  CORNER_DFL                          5
#define  CORNER_DLB                          6
#define  CORNER_DBR                          7

#define  CORNER_FRU                          8
#define  CORNER_RBU                          9
#define  CORNER_BLU                         10
#define  CORNER_LFU                         11
#define  CORNER_RFD                         12
#define  CORNER_FLD                         13
#define  CORNER_LBD                         14
#define  CORNER_BRD                         15

#define  CORNER_RUF                         16
#define  CORNER_BUR                         17
#define  CORNER_LUB                         18
#define  CORNER_FUL                         19
#define  CORNER_FDR                         20
#define  CORNER_LDF                         21
#define  CORNER_BDL                         22
#define  CORNER_RDB                         23


/*  number the edge cubies  */

#define  EDGE_UF                             0
#define  EDGE_UR                             1
#define  EDGE_UB                             2
#define  EDGE_UL                             3
#define  EDGE_DF                             4
#define  EDGE_DR                             5
#define  EDGE_DB                             6
#define  EDGE_DL                             7
#define  EDGE_FR                             8
#define  EDGE_FL                             9
#define  EDGE_BR                            10
#define  EDGE_BL                            11

#define  EDGE_FU                            12
#define  EDGE_RU                            13
#define  EDGE_BU                            14
#define  EDGE_LU                            15
#define  EDGE_FD                            16
#define  EDGE_RD                            17
#define  EDGE_BD                            18
#define  EDGE_LD                            19
#define  EDGE_RF                            20
#define  EDGE_LF                            21
#define  EDGE_RB                            22
#define  EDGE_LB                            23


static char            *edge_cubie_str[] = {"UF", "UR", "UB", "UL",
                                            "DF", "DR", "DB", "DL",
                                            "FR", "FL", "BR", "BL",
                                            "FU", "RU", "BU", "LU",
                                            "FD", "RD", "BD", "LD",
                                            "RF", "LF", "RB", "LB"};

static char            *corner_cubie_str[] = {"UFR", "URB", "UBL", "ULF",
                                              "DRF", "DFL", "DLB", "DBR", 
                                              "FRU", "RBU", "BLU", "LFU",
                                              "RFD", "FLD", "LBD", "BRD", 
                                              "RUF", "BUR", "LUB", "FUL",
                                              "FDR", "LDF", "BDL", "RDB"};


/* ========================================================================= */
   void  perm_n_init(int  nn, int  array_out[])
/* ------------------------------------------------------------------------- */

{
int                     ii;


for (ii = 0; ii < nn; ii++)
    array_out[ii] = ii;

return;
}


/* ========================================================================= */
   void  perm_n_inverse(int  nn, int  perm_in[], int  perm_out[])
/* ------------------------------------------------------------------------- */

{
int                     ii;


for (ii = 0; ii < nn; ii++)
    perm_out[perm_in[ii]] = ii;

return;
}


/* ========================================================================= */
   void  two_cycle(int  arr[], int  ind0, int  ind1)
/* ------------------------------------------------------------------------- */

{
int                     temp;


temp = arr[ind0];
arr[ind0] = arr[ind1];
arr[ind1] = temp;

return;
}


/* ========================================================================= */
   void  four_cycle(int  arr[], int  ind0, int  ind1, int  ind2, int  ind3)
/* ------------------------------------------------------------------------- */

{
int                     temp;


temp = arr[ind0];
arr[ind0] = arr[ind1];
arr[ind1] = arr[ind2];
arr[ind2] = arr[ind3];
arr[ind3] = temp;

return;
}


/* ========================================================================= */
   void  cube_init(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
perm_n_init(24, p_cube->edges);
perm_n_init(24, p_cube->corners);

return;
}


/* ========================================================================= */
   void  cube_inverse(Cube  *p_cube_in, Cube  *p_cube_out)
/* ------------------------------------------------------------------------- */

{
perm_n_inverse(24, p_cube_in->edges, p_cube_out->edges);
perm_n_inverse(24, p_cube_in->corners, p_cube_out->corners);

return;
}


/* ========================================================================= */
   void  print_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
printf("%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s\n",
       edge_cubie_str[p_cube->edges[0]], edge_cubie_str[p_cube->edges[1]],
       edge_cubie_str[p_cube->edges[2]], edge_cubie_str[p_cube->edges[3]],
       edge_cubie_str[p_cube->edges[4]], edge_cubie_str[p_cube->edges[5]],
       edge_cubie_str[p_cube->edges[6]], edge_cubie_str[p_cube->edges[7]],
       edge_cubie_str[p_cube->edges[8]], edge_cubie_str[p_cube->edges[9]],
       edge_cubie_str[p_cube->edges[10]], edge_cubie_str[p_cube->edges[11]],
   corner_cubie_str[p_cube->corners[0]], corner_cubie_str[p_cube->corners[1]],
   corner_cubie_str[p_cube->corners[2]], corner_cubie_str[p_cube->corners[3]],
   corner_cubie_str[p_cube->corners[4]], corner_cubie_str[p_cube->corners[5]],
   corner_cubie_str[p_cube->corners[6]], corner_cubie_str[p_cube->corners[7]]);

return;
}


/* ========================================================================= */
   void  print_inverse_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
Cube                    cube_struc;


cube_inverse(p_cube, &cube_struc);
print_cube(&cube_struc);

return;
}


/* ========================================================================= */
   void  twist_f_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_FLD, CORNER_FDR, CORNER_FRU, CORNER_FUL);
four_cycle(p_cube->corners, CORNER_DFL, CORNER_RFD, CORNER_UFR, CORNER_LFU);
four_cycle(p_cube->corners, CORNER_LDF, CORNER_DRF, CORNER_RUF, CORNER_ULF);
four_cycle(p_cube->edges, EDGE_FL, EDGE_FD, EDGE_FR, EDGE_FU);
four_cycle(p_cube->edges, EDGE_LF, EDGE_DF, EDGE_RF, EDGE_UF);

return;
}


/* ========================================================================= */
   void  twist_f2_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
two_cycle(p_cube->corners, CORNER_FLD, CORNER_FRU);
two_cycle(p_cube->corners, CORNER_FDR, CORNER_FUL);
two_cycle(p_cube->corners, CORNER_DFL, CORNER_UFR);
two_cycle(p_cube->corners, CORNER_RFD, CORNER_LFU);
two_cycle(p_cube->corners, CORNER_LDF, CORNER_RUF);
two_cycle(p_cube->corners, CORNER_DRF, CORNER_ULF);
two_cycle(p_cube->edges, EDGE_FL, EDGE_FR);
two_cycle(p_cube->edges, EDGE_FD, EDGE_FU);
two_cycle(p_cube->edges, EDGE_LF, EDGE_RF);
two_cycle(p_cube->edges, EDGE_DF, EDGE_UF);

return;
}


/* ========================================================================= */
   void  twist_f3_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_FLD, CORNER_FUL, CORNER_FRU, CORNER_FDR);
four_cycle(p_cube->corners, CORNER_DFL, CORNER_LFU, CORNER_UFR, CORNER_RFD);
four_cycle(p_cube->corners, CORNER_LDF, CORNER_ULF, CORNER_RUF, CORNER_DRF);
four_cycle(p_cube->edges, EDGE_FL, EDGE_FU, EDGE_FR, EDGE_FD);
four_cycle(p_cube->edges, EDGE_LF, EDGE_UF, EDGE_RF, EDGE_DF);

return;
}


/* ========================================================================= */
   void  twist_r_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_RFD, CORNER_RDB, CORNER_RBU, CORNER_RUF);
four_cycle(p_cube->corners, CORNER_DRF, CORNER_BRD, CORNER_URB, CORNER_FRU);
four_cycle(p_cube->corners, CORNER_FDR, CORNER_DBR, CORNER_BUR, CORNER_UFR);
four_cycle(p_cube->edges, EDGE_RF, EDGE_RD, EDGE_RB, EDGE_RU);
four_cycle(p_cube->edges, EDGE_FR, EDGE_DR, EDGE_BR, EDGE_UR);

return;
}


/* ========================================================================= */
   void  twist_r2_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
two_cycle(p_cube->corners, CORNER_RFD, CORNER_RBU);
two_cycle(p_cube->corners, CORNER_RDB, CORNER_RUF);
two_cycle(p_cube->corners, CORNER_DRF, CORNER_URB);
two_cycle(p_cube->corners, CORNER_BRD, CORNER_FRU);
two_cycle(p_cube->corners, CORNER_FDR, CORNER_BUR);
two_cycle(p_cube->corners, CORNER_DBR, CORNER_UFR);
two_cycle(p_cube->edges, EDGE_RF, EDGE_RB);
two_cycle(p_cube->edges, EDGE_RD, EDGE_RU);
two_cycle(p_cube->edges, EDGE_FR, EDGE_BR);
two_cycle(p_cube->edges, EDGE_DR, EDGE_UR);

return;
}


/* ========================================================================= */
   void  twist_r3_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_RFD, CORNER_RUF, CORNER_RBU, CORNER_RDB);
four_cycle(p_cube->corners, CORNER_DRF, CORNER_FRU, CORNER_URB, CORNER_BRD);
four_cycle(p_cube->corners, CORNER_FDR, CORNER_UFR, CORNER_BUR, CORNER_DBR);
four_cycle(p_cube->edges, EDGE_RF, EDGE_RU, EDGE_RB, EDGE_RD);
four_cycle(p_cube->edges, EDGE_FR, EDGE_UR, EDGE_BR, EDGE_DR);

return;
}


/* ========================================================================= */
   void  twist_u_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_URB, CORNER_UBL, CORNER_ULF, CORNER_UFR);
four_cycle(p_cube->corners, CORNER_BUR, CORNER_LUB, CORNER_FUL, CORNER_RUF);
four_cycle(p_cube->corners, CORNER_RBU, CORNER_BLU, CORNER_LFU, CORNER_FRU);
four_cycle(p_cube->edges, EDGE_UR, EDGE_UB, EDGE_UL, EDGE_UF);
four_cycle(p_cube->edges, EDGE_RU, EDGE_BU, EDGE_LU, EDGE_FU);

return;
}


/* ========================================================================= */
   void  twist_u2_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
two_cycle(p_cube->corners, CORNER_URB, CORNER_ULF);
two_cycle(p_cube->corners, CORNER_UBL, CORNER_UFR);
two_cycle(p_cube->corners, CORNER_BUR, CORNER_FUL);
two_cycle(p_cube->corners, CORNER_LUB, CORNER_RUF);
two_cycle(p_cube->corners, CORNER_RBU, CORNER_LFU);
two_cycle(p_cube->corners, CORNER_BLU, CORNER_FRU);
two_cycle(p_cube->edges, EDGE_UR, EDGE_UL);
two_cycle(p_cube->edges, EDGE_UB, EDGE_UF);
two_cycle(p_cube->edges, EDGE_RU, EDGE_LU);
two_cycle(p_cube->edges, EDGE_BU, EDGE_FU);

return;
}


/* ========================================================================= */
   void  twist_u3_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_URB, CORNER_UFR, CORNER_ULF, CORNER_UBL);
four_cycle(p_cube->corners, CORNER_BUR, CORNER_RUF, CORNER_FUL, CORNER_LUB);
four_cycle(p_cube->corners, CORNER_RBU, CORNER_FRU, CORNER_LFU, CORNER_BLU);
four_cycle(p_cube->edges, EDGE_UR, EDGE_UF, EDGE_UL, EDGE_UB);
four_cycle(p_cube->edges, EDGE_RU, EDGE_FU, EDGE_LU, EDGE_BU);

return;
}


/* ========================================================================= */
   void  twist_b_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_BRD, CORNER_BDL, CORNER_BLU, CORNER_BUR);
four_cycle(p_cube->corners, CORNER_DBR, CORNER_LBD, CORNER_UBL, CORNER_RBU);
four_cycle(p_cube->corners, CORNER_RDB, CORNER_DLB, CORNER_LUB, CORNER_URB);
four_cycle(p_cube->edges, EDGE_BR, EDGE_BD, EDGE_BL, EDGE_BU);
four_cycle(p_cube->edges, EDGE_RB, EDGE_DB, EDGE_LB, EDGE_UB);

return;
}


/* ========================================================================= */
   void  twist_b2_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
two_cycle(p_cube->corners, CORNER_BRD, CORNER_BLU);
two_cycle(p_cube->corners, CORNER_BDL, CORNER_BUR);
two_cycle(p_cube->corners, CORNER_DBR, CORNER_UBL);
two_cycle(p_cube->corners, CORNER_LBD, CORNER_RBU);
two_cycle(p_cube->corners, CORNER_RDB, CORNER_LUB);
two_cycle(p_cube->corners, CORNER_DLB, CORNER_URB);
two_cycle(p_cube->edges, EDGE_BR, EDGE_BL);
two_cycle(p_cube->edges, EDGE_BD, EDGE_BU);
two_cycle(p_cube->edges, EDGE_RB, EDGE_LB);
two_cycle(p_cube->edges, EDGE_DB, EDGE_UB);

return;
}


/* ========================================================================= */
   void  twist_b3_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_BRD, CORNER_BUR, CORNER_BLU, CORNER_BDL);
four_cycle(p_cube->corners, CORNER_DBR, CORNER_RBU, CORNER_UBL, CORNER_LBD);
four_cycle(p_cube->corners, CORNER_RDB, CORNER_URB, CORNER_LUB, CORNER_DLB);
four_cycle(p_cube->edges, EDGE_BR, EDGE_BU, EDGE_BL, EDGE_BD);
four_cycle(p_cube->edges, EDGE_RB, EDGE_UB, EDGE_LB, EDGE_DB);

return;
}


/* ========================================================================= */
   void  twist_l_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_LBD, CORNER_LDF, CORNER_LFU, CORNER_LUB);
four_cycle(p_cube->corners, CORNER_DLB, CORNER_FLD, CORNER_ULF, CORNER_BLU);
four_cycle(p_cube->corners, CORNER_BDL, CORNER_DFL, CORNER_FUL, CORNER_UBL);
four_cycle(p_cube->edges, EDGE_LB, EDGE_LD, EDGE_LF, EDGE_LU);
four_cycle(p_cube->edges, EDGE_BL, EDGE_DL, EDGE_FL, EDGE_UL);

return;
}


/* ========================================================================= */
   void  twist_l2_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
two_cycle(p_cube->corners, CORNER_LBD, CORNER_LFU);
two_cycle(p_cube->corners, CORNER_LDF, CORNER_LUB);
two_cycle(p_cube->corners, CORNER_DLB, CORNER_ULF);
two_cycle(p_cube->corners, CORNER_FLD, CORNER_BLU);
two_cycle(p_cube->corners, CORNER_BDL, CORNER_FUL);
two_cycle(p_cube->corners, CORNER_DFL, CORNER_UBL);
two_cycle(p_cube->edges, EDGE_LB, EDGE_LF);
two_cycle(p_cube->edges, EDGE_LD, EDGE_LU);
two_cycle(p_cube->edges, EDGE_BL, EDGE_FL);
two_cycle(p_cube->edges, EDGE_DL, EDGE_UL);

return;
}


/* ========================================================================= */
   void  twist_l3_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_LBD, CORNER_LUB, CORNER_LFU, CORNER_LDF);
four_cycle(p_cube->corners, CORNER_DLB, CORNER_BLU, CORNER_ULF, CORNER_FLD);
four_cycle(p_cube->corners, CORNER_BDL, CORNER_UBL, CORNER_FUL, CORNER_DFL);
four_cycle(p_cube->edges, EDGE_LB, EDGE_LU, EDGE_LF, EDGE_LD);
four_cycle(p_cube->edges, EDGE_BL, EDGE_UL, EDGE_FL, EDGE_DL);

return;
}


/* ========================================================================= */
   void  twist_d_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_DFL, CORNER_DLB, CORNER_DBR, CORNER_DRF);
four_cycle(p_cube->corners, CORNER_LDF, CORNER_BDL, CORNER_RDB, CORNER_FDR);
four_cycle(p_cube->corners, CORNER_FLD, CORNER_LBD, CORNER_BRD, CORNER_RFD);
four_cycle(p_cube->edges, EDGE_DF, EDGE_DL, EDGE_DB, EDGE_DR);
four_cycle(p_cube->edges, EDGE_FD, EDGE_LD, EDGE_BD, EDGE_RD);

return;
}


/* ========================================================================= */
   void  twist_d2_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
two_cycle(p_cube->corners, CORNER_DFL, CORNER_DBR);
two_cycle(p_cube->corners, CORNER_DLB, CORNER_DRF);
two_cycle(p_cube->corners, CORNER_LDF, CORNER_RDB);
two_cycle(p_cube->corners, CORNER_BDL, CORNER_FDR);
two_cycle(p_cube->corners, CORNER_FLD, CORNER_BRD);
two_cycle(p_cube->corners, CORNER_LBD, CORNER_RFD);
two_cycle(p_cube->edges, EDGE_DF, EDGE_DB);
two_cycle(p_cube->edges, EDGE_DL, EDGE_DR);
two_cycle(p_cube->edges, EDGE_FD, EDGE_BD);
two_cycle(p_cube->edges, EDGE_LD, EDGE_RD);

return;
}


/* ========================================================================= */
   void  twist_d3_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
four_cycle(p_cube->corners, CORNER_DFL, CORNER_DRF, CORNER_DBR, CORNER_DLB);
four_cycle(p_cube->corners, CORNER_LDF, CORNER_FDR, CORNER_RDB, CORNER_BDL);
four_cycle(p_cube->corners, CORNER_FLD, CORNER_RFD, CORNER_BRD, CORNER_LBD);
four_cycle(p_cube->edges, EDGE_DF, EDGE_DR, EDGE_DB, EDGE_DL);
four_cycle(p_cube->edges, EDGE_FD, EDGE_RD, EDGE_BD, EDGE_LD);

return;
}


/* ========================================================================= */
   int  user_twists_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
char                    line_str[2][MAX_INPUT_LENGTH], tw_str[3];
int                     num, ii;


printf("\nenter sequence:\n");

if (fgets(line_str[0], MAX_INPUT_LENGTH, stdin) == NULL)
   return -1;

if (line_str[0][0] == '\n')
   return -1;

ii = 0;

while (1)
      {
      num = sscanf(line_str[ii], "%2s%[^\n]", tw_str, line_str[1 - ii]);

      if (num < 1)
         break;

      ii = 1 - ii;

      if (strcmp(tw_str, "F") == 0)
         twist_f_cube(p_cube);
      else if (strcmp(tw_str, "F2") == 0)
         twist_f2_cube(p_cube);
      else if (strcmp(tw_str, "F'") == 0)
         twist_f3_cube(p_cube);
      else if (strcmp(tw_str, "R") == 0)
         twist_r_cube(p_cube);
      else if (strcmp(tw_str, "R2") == 0)
         twist_r2_cube(p_cube);
      else if (strcmp(tw_str, "R'") == 0)
         twist_r3_cube(p_cube);
      else if (strcmp(tw_str, "U") == 0)
         twist_u_cube(p_cube);
      else if (strcmp(tw_str, "U2") == 0)
         twist_u2_cube(p_cube);
      else if (strcmp(tw_str, "U'") == 0)
         twist_u3_cube(p_cube);
      else if (strcmp(tw_str, "B") == 0)
         twist_b_cube(p_cube);
      else if (strcmp(tw_str, "B2") == 0)
         twist_b2_cube(p_cube);
      else if (strcmp(tw_str, "B'") == 0)
         twist_b3_cube(p_cube);
      else if (strcmp(tw_str, "L") == 0)
         twist_l_cube(p_cube);
      else if (strcmp(tw_str, "L2") == 0)
         twist_l2_cube(p_cube);
      else if (strcmp(tw_str, "L'") == 0)
         twist_l3_cube(p_cube);
      else if (strcmp(tw_str, "D") == 0)
         twist_d_cube(p_cube);
      else if (strcmp(tw_str, "D2") == 0)
         twist_d2_cube(p_cube);
      else if (strcmp(tw_str, "D'") == 0)
         twist_d3_cube(p_cube);
      else if (strcmp(tw_str, ".") == 0)
         ;
      else
         {
         printf("invalid twist: %s\n", tw_str);
         return 1;
         }

      if (num == 1)
         break;
      }

return 0;
}


/* ========================================================================= */
   int  main(void)
/* ------------------------------------------------------------------------- */

{
Cube                    cube_struc;
int                     stat;


while (1)
      {
      cube_init(&cube_struc);
      stat = user_twists_cube(&cube_struc);

      if (stat < 0)
         break;

      if (stat == 0)
         {
         print_cube(&cube_struc);
         print_inverse_cube(&cube_struc);
         }
      }

exit(EXIT_SUCCESS);

return 0;
}
