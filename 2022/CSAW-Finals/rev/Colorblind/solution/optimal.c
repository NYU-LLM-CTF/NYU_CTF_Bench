/*  optimal cube solver  by  michael reid  reid@math.ucf.edu  */
/*  version 2.1  june 3, 2004  */
/*  symmetry mechanism added  */
/*  malloc.h removed, long string fixed  */


#define  USE_METRIC        QUARTER_TURN_METRIC
#define  SEARCH_LIMIT                        0
#define  USE_SYMMETRY                        1
#define  ONE_SOLUTION_ONLY                   0


#include  <stdio.h>
#include  <stdlib.h>
#include  <string.h>
#include  <setjmp.h>
#include  <signal.h>


#define  QUARTER_TURN_METRIC                 0
#define  FACE_TURN_METRIC                    1

#define  N_SYM                              16
#define  N_TWIST                            18
#define  N_CORNER                         2187
#define  N_ELOC                            495
#define  N_ELOC_CONV                      4096
#define  N_EFLIP                          2048
#define  N_FULLEDGE         (N_ELOC * N_EFLIP)
#define  N_EDGEQUOT                      64430
#define  N_CORNERPERM                    40320
#define  N_SLICEEDGE                     11880

#define  N_CUBESYM                          48
#define  N_SYMSUBGRP                        98
#define  SUBGRP_TRIVIAL                     97

#define  N_DIST_CHARS                  ((N_EDGEQUOT * N_CORNER) / 2)
#define  BACKWARDS_SWITCH_POINT    ((2 * N_EDGEQUOT * N_CORNER) / 5)

#define  CORNER_START                        0
#define  EDGE_START                      64244
#define  CORNERPERM_START                    0
#define  UD_SLICEEDGE_START                494
#define  RL_SLICEEDGE_START                 54
#define  FB_SLICEEDGE_START                209

#define  MAX_PERM_N                         12
#define  MAX_CHECK_PERM_N                   24

#define  MAX_TWISTS                         43

#define  TWIST_F                             0
#define  TWIST_F2                            1
#define  TWIST_F3                            2
#define  TWIST_R                             3
#define  TWIST_R2                            4
#define  TWIST_R3                            5
#define  TWIST_U                             6
#define  TWIST_U2                            7
#define  TWIST_U3                            8
#define  TWIST_B                             9
#define  TWIST_B2                           10
#define  TWIST_B3                           11
#define  TWIST_L                            12
#define  TWIST_L2                           13
#define  TWIST_L3                           14
#define  TWIST_D                            15
#define  TWIST_D2                           16
#define  TWIST_D3                           17

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


#define  FACE_F                              0
#define  FACE_R                              1
#define  FACE_U                              2
#define  FACE_B                              3
#define  FACE_L                              4
#define  FACE_D                              5


#define  N_FOLLOW                          873

#define  FOLLOW_INVALID                      0

#define  N_SYLLABLE                         32

#define  SYLLABLE_INVALID                    0
#define  SYLLABLE_NONE                       1
#define  SYLLABLE_F                          2
#define  SYLLABLE_F2                         3
#define  SYLLABLE_F3                         4
#define  SYLLABLE_R                          5
#define  SYLLABLE_R2                         6
#define  SYLLABLE_R3                         7
#define  SYLLABLE_U                          8
#define  SYLLABLE_U2                         9
#define  SYLLABLE_U3                        10
#define  SYLLABLE_B                         11
#define  SYLLABLE_B2                        12
#define  SYLLABLE_B3                        13
#define  SYLLABLE_L                         14
#define  SYLLABLE_L2                        15
#define  SYLLABLE_L3                        16
#define  SYLLABLE_D                         17
#define  SYLLABLE_D2                        18
#define  SYLLABLE_D3                        19
#define  SYLLABLE_FB                        20
#define  SYLLABLE_FB2                       21
#define  SYLLABLE_FB3                       22
#define  SYLLABLE_F2B2                      23
#define  SYLLABLE_RL                        24
#define  SYLLABLE_RL2                       25
#define  SYLLABLE_RL3                       26
#define  SYLLABLE_R2L2                      27
#define  SYLLABLE_UD                        28
#define  SYLLABLE_UD2                       29
#define  SYLLABLE_UD3                       30
#define  SYLLABLE_U2D2                      31



#define  DIST(c, e)     (((e) & 0x1) ? (((int)distance[c][(e) >> 1]) >> 4)   \
                                     : (((int)distance[c][(e) >> 1]) & 0xF))


typedef struct cube
        {
        int             edges[24];
        int             corners[24];
        }
        Cube;


typedef struct coset_coord
        {
        int             corner_state;
        int             edge_state;
        int             sym_state;
        }
        Coset_coord;


typedef struct full_cube
        {
        Cube            cubies;
        int             cornerperm;
        int             ud_sliceedge;
        int             rl_sliceedge;
        int             fb_sliceedge;
        Coset_coord     ud;
        Coset_coord     rl;
        Coset_coord     fb;
        int             parity;
        int             sym_subgrp;
        }
        Full_cube;


typedef struct search_data
        {
        int             depth;
        int             found;
        int             found_quot;
        int            *multiplicities;
        int            *stabilizers;
        }
        Search_data;


typedef struct search_node
        {
        int             remain_depth;
        int             twist;
        int             follow_type;
        Coset_coord     ud;
        Coset_coord     rl;
        Coset_coord     fb;
        }
        Search_node;


typedef struct metric_data
        {
        int             metric;
        char            metric_char;
        int             twist_length[N_TWIST];
        int             increment;
        }
        Metric_data;


typedef struct options
        {
        int             use_symmetry;
        int             search_limit;
        int             one_solution_only;
        }
        Options;


typedef struct subgroup_list
        {
        int             n_subgroups;
        int           (*subgroups)[N_CUBESYM];
        }
        Subgroup_list;



static unsigned char   *sym_x_invsym_to_sym[N_SYM];

static unsigned char   *invsym_on_twist_ud[N_SYM];
static unsigned char   *invsym_on_twist_rl[N_SYM];
static unsigned char   *invsym_on_twist_fb[N_SYM];

static unsigned short  *twist_on_corner[N_TWIST];
static unsigned short  *sym_on_corner[N_SYM];

static unsigned short  *fulledge_to_edge;
static unsigned char   *fulledge_to_sym;

static unsigned short  *twist_on_edge[N_TWIST];
static unsigned char   *twist_x_edge_to_sym[N_TWIST];

static unsigned short  *twist_on_cornerperm[N_TWIST];
static unsigned short  *twist_on_sliceedge[N_TWIST];

static unsigned short  *twist_on_follow[N_TWIST];

static unsigned char   *distance[N_CORNER];

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

static Metric_data     *p_current_metric;
static Options         *p_current_options;

static unsigned int     n_nodes;
static unsigned int     n_tests;
static int              sol_found;

static sigjmp_buf       jump_env;


/* ========================================================================= */
   void  exit_w_error_message(char  *msg)
/* ------------------------------------------------------------------------- */

{
printf("\n%s\n", msg);
exit(EXIT_FAILURE);

return;
}


/* ========================================================================= */
   void  user_interrupt(int  unused_arg)
/* ------------------------------------------------------------------------- */

{
printf("\n-- user interrupt --\n");
fflush(stdout);
siglongjmp(jump_env, 1);

return;
}


/* ========================================================================= */
   void  perm_n_unpack(int  nn, int  indx, int  array_out[])
/* ------------------------------------------------------------------------- */

{
int                     ii, jj;


for (ii = nn - 1; ii >= 0; ii--)
    {
    array_out[ii] = indx % (nn - ii);
    indx /= (nn - ii);

    for (jj = ii + 1; jj < nn; jj++)
        if (array_out[jj] >= array_out[ii])
           array_out[jj]++;
    }

return;
}


/* ========================================================================= */
   int  perm_n_pack(int  nn, int  array_in[])
/* ------------------------------------------------------------------------- */

{
int                     indx, ii, jj;


indx = 0;

for (ii = 0; ii < nn; ii++)
    {
    indx *= (nn - ii);

    for (jj = ii + 1; jj < nn; jj++)
        if (array_in[jj] < array_in[ii])
           indx++;
    }

return indx;
}


/* ========================================================================= */
   int  perm_n_check(int  nn, int  array_in[])
/* ------------------------------------------------------------------------- */

{
int                     count[MAX_CHECK_PERM_N], ii;


for (ii = 0; ii < nn; ii++)
    count[ii] = 0;

for (ii = 0; ii < nn; ii++)
    {
    if ((array_in[ii] < 0) || (array_in[ii] >= nn))
       return 1;

    count[array_in[ii]]++;
    }

for (ii = 0; ii < nn; ii++)
    if (count[ii] != 1)
       return 1;

return 0;
}


/* ========================================================================= */
   int  perm_n_parity(int  nn, int  array_in[])
/* ------------------------------------------------------------------------- */

{
int                     temp_array[MAX_CHECK_PERM_N];
int                     ii, jj, n_cycles;


for (ii = 0; ii < nn; ii++)
    temp_array[ii] = 0;

n_cycles = 0;

for (ii = 0; ii < nn; ii++)
    if (temp_array[ii] == 0)
       {
       n_cycles++;
       jj = ii;
       while (temp_array[jj] == 0)
             {
             temp_array[jj] = 1;
             jj = array_in[jj];
             }
       }

return (n_cycles + nn) % 2;
}


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
   void  perm_n_compose(int  nn, int  perm0_in[], int  perm1_in[],
                                                  int  perm_out[])
/* ------------------------------------------------------------------------- */

{
int                     ii;


for (ii = 0; ii < nn; ii++)
    perm_out[ii] = perm0_in[perm1_in[ii]];

return;
}


/* ========================================================================= */
   void  perm_n_conjugate(int  nn, int  arr_in[], int  conjugator[],
                                                  int  array_out[])
/* ------------------------------------------------------------------------- */

{
int                     ii;


for (ii = 0; ii < nn; ii++)
    array_out[conjugator[ii]] = conjugator[arr_in[ii]];

return;
}


/* ========================================================================= */
   void  two_cycle(int  array[], int  ind0, int  ind1)
/* ------------------------------------------------------------------------- */

{
int                     temp;


temp = array[ind0];
array[ind0] = array[ind1];
array[ind1] = temp;

return;
}


/* ========================================================================= */
   void  three_cycle(int  array[], int  ind0, int  ind1, int  ind2)
/* ------------------------------------------------------------------------- */

{
int                     temp;


temp = array[ind0];
array[ind0] = array[ind1];
array[ind1] = array[ind2];
array[ind2] = temp;

return;
}


/* ========================================================================= */
   void  four_cycle(int  array[], int  ind0, int  ind1, int  ind2, int  ind3)
/* ------------------------------------------------------------------------- */

{
int                     temp;


temp = array[ind0];
array[ind0] = array[ind1];
array[ind1] = array[ind2];
array[ind2] = array[ind3];
array[ind3] = temp;

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
   void  cube_init(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
perm_n_init(24, p_cube->edges);
perm_n_init(24, p_cube->corners);

return;
}


/* ========================================================================= */
   int  cube_compare(Cube  *cube0, Cube  *cube1)
/* ------------------------------------------------------------------------- */

{
int           ii;

for (ii = 0; ii < 24; ii++)
    {
    if (cube0->edges[ii] < cube1->edges[ii])
       return -1;
    else if (cube0->edges[ii] > cube1->edges[ii])
       return 1;
    }

for (ii = 0; ii < 24; ii++)
    {
    if (cube0->corners[ii] < cube1->corners[ii])
       return -1;
    else if (cube0->corners[ii] > cube1->corners[ii])
       return 1;
    }

return 0;
}


/* ========================================================================= */
   void  cube_compose(Cube  *in_cube0, Cube  *in_cube1, Cube  *out_cube)
/* ------------------------------------------------------------------------- */

{
perm_n_compose(24, in_cube0->edges, in_cube1->edges, out_cube->edges);
perm_n_compose(24, in_cube0->corners, in_cube1->corners, out_cube->corners);

return;
}


/* ========================================================================= */
   void  cube_conjugate(Cube  *p_cube_in, Cube  *p_conjugator,
                                          Cube  *p_cube_out)
/* ------------------------------------------------------------------------- */

{
perm_n_conjugate(24, p_cube_in->edges, p_conjugator->edges, p_cube_out->edges);
perm_n_conjugate(24, p_cube_in->corners, p_conjugator->corners,
                                                          p_cube_out->corners);

return;
}


/* ========================================================================= */
   int  cube_is_solved(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
Cube                    temp_cube;


cube_init(&temp_cube);

return (cube_compare(p_cube, &temp_cube) == 0);
}


/* ========================================================================= */
   int  metric_q_length(int  twist)
/* ------------------------------------------------------------------------- */

{
if ((twist == TWIST_F) || (twist == TWIST_F3) ||
    (twist == TWIST_R) || (twist == TWIST_R3) ||
    (twist == TWIST_U) || (twist == TWIST_U3) ||
    (twist == TWIST_B) || (twist == TWIST_B3) ||
    (twist == TWIST_L) || (twist == TWIST_L3) ||
    (twist == TWIST_D) || (twist == TWIST_D3))
   return 1;
else if ((twist == TWIST_F2) || (twist == TWIST_R2) || (twist == TWIST_U2) ||
         (twist == TWIST_B2) || (twist == TWIST_L2) || (twist == TWIST_D2))
        return 2;
else
   exit_w_error_message("metric_q_length : invalid twist");

return 0;
}


/* ========================================================================= */
   int  metric_f_length(int  twist)
/* ------------------------------------------------------------------------- */

{
if ((twist == TWIST_F) || (twist == TWIST_F2) || (twist == TWIST_F3) ||
    (twist == TWIST_R) || (twist == TWIST_R2) || (twist == TWIST_R3) ||
    (twist == TWIST_U) || (twist == TWIST_U2) || (twist == TWIST_U3) ||
    (twist == TWIST_B) || (twist == TWIST_B2) || (twist == TWIST_B3) ||
    (twist == TWIST_L) || (twist == TWIST_L2) || (twist == TWIST_L3) ||
    (twist == TWIST_D) || (twist == TWIST_D2) || (twist == TWIST_D3))
   return 1;
else
   exit_w_error_message("metric_f_length : invalid twist");

return 0;
}


/* ========================================================================= */
   void  calc_metric_q_length(int  lengths[N_TWIST])
/* ------------------------------------------------------------------------- */

{
int                     twist;


for (twist = 0; twist < N_TWIST; twist++)
    lengths[twist] = metric_q_length(twist);

return;
}


/* ========================================================================= */
   void  calc_metric_f_length(int  lengths[N_TWIST])
/* ------------------------------------------------------------------------- */

{
int                     twist;


for (twist = 0; twist < N_TWIST; twist++)
    lengths[twist] = metric_f_length(twist);

return;
}


/* ========================================================================= */
   void  init_metric(Metric_data  *p_metric_data, int  use_metric)
/* ------------------------------------------------------------------------- */

{
if ((use_metric != QUARTER_TURN_METRIC) && (use_metric != FACE_TURN_METRIC))
   exit_w_error_message("init_metric : unknown metric");

p_metric_data->metric = use_metric;

if (p_metric_data->metric == QUARTER_TURN_METRIC)
   {
   printf("using quarter turn metric\n");
   p_metric_data->metric_char = 'q';
   calc_metric_q_length(p_metric_data->twist_length);
   p_metric_data->increment = 2;
   }
else
   {
   printf("using face turn metric\n");
   p_metric_data->metric_char = 'f';
   calc_metric_f_length(p_metric_data->twist_length);
   p_metric_data->increment = 1;
   }

p_current_metric = p_metric_data;

return;
}


/* ========================================================================= */
   void  init_options(Metric_data  *p_metric_data, Options  *p_user_options)
/* ------------------------------------------------------------------------- */

{
init_metric(p_metric_data, USE_METRIC);

p_user_options->search_limit = SEARCH_LIMIT;
if (p_user_options->search_limit <= 0)
   printf("no search limit\n");
else
   printf("search limit: %d%c\n", p_user_options->search_limit,
                                                p_current_metric->metric_char);

p_user_options->use_symmetry = USE_SYMMETRY;
if (p_user_options->use_symmetry)
   printf("using symmetry reductions\n");
else
   printf("not using symmetry reductions\n");

p_user_options->one_solution_only = ONE_SOLUTION_ONLY;
if (p_user_options->one_solution_only)
   printf("only finding one solution\n");
else
   printf("finding all solutions\n");

printf("\n");
p_current_options = p_user_options;

return;
}


/* ========================================================================= */
   void  calc_group_table(int  group_table[N_CUBESYM][N_CUBESYM])
/* ------------------------------------------------------------------------- */

{
int                     sym_array[N_CUBESYM][6];
int                     sym_pack[N_CUBESYM];
int                     temp_array[6];
int                     ii, jj, kk, pack;


perm_n_init(6, sym_array[0]);
perm_n_init(6, sym_array[1]);

four_cycle(sym_array[1], FACE_F, FACE_L, FACE_B, FACE_R);

for (ii = 2; ii < 4; ii++)
    perm_n_compose(6, sym_array[1], sym_array[ii - 1], sym_array[ii]);

perm_n_init(6, sym_array[4]);

two_cycle(sym_array[4], FACE_U, FACE_D);
two_cycle(sym_array[4], FACE_R, FACE_L);

for (ii = 5; ii < 8; ii++)
    perm_n_compose(6, sym_array[4], sym_array[ii - 4], sym_array[ii]);

perm_n_init(6, sym_array[8]);

two_cycle(sym_array[8], FACE_U, FACE_D);

for (ii = 9; ii < 16; ii++)
    perm_n_compose(6, sym_array[8], sym_array[ii - 8], sym_array[ii]);

perm_n_init(6, sym_array[16]);

three_cycle(sym_array[16], FACE_U, FACE_F, FACE_R);
three_cycle(sym_array[16], FACE_D, FACE_B, FACE_L);

for (ii = 17; ii < 48; ii++)
    perm_n_compose(6, sym_array[16], sym_array[ii - 16], sym_array[ii]);

for (ii = 0; ii < N_CUBESYM; ii++)
    sym_pack[ii] = perm_n_pack(6, sym_array[ii]);

for (ii = 0; ii < N_CUBESYM; ii++)
    for (jj = 0; jj < N_CUBESYM; jj++)
        {
        perm_n_compose(6, sym_array[ii], sym_array[jj], temp_array);
        pack = perm_n_pack(6, temp_array);

        for (kk = 0; kk < N_CUBESYM; kk++)
            if (sym_pack[kk] == pack)
               {
               group_table[ii][jj] = kk;
               break;
               }

        if (kk == N_CUBESYM)
           exit_w_error_message("calc_group_table : product not found");
        }

return;
}


/* ========================================================================= */
   void  init_sym_x_invsym_to_sym(void)
/* ------------------------------------------------------------------------- */

{
unsigned char         (*mem_ptr)[N_SYM];
int                     group_table[N_CUBESYM][N_CUBESYM];
int                     group_inverse[N_CUBESYM];
int                     ii, jj;


/*  initialize global array   sym_x_invsym_to_sym   */

mem_ptr =
        (unsigned char (*)[N_SYM])malloc(sizeof(unsigned char [N_SYM][N_SYM]));
if (mem_ptr == NULL)
   exit_w_error_message("init_sym_x_invsym_to_sym : couldn't get memory");

for (ii = 0; ii < N_SYM; ii++)
    sym_x_invsym_to_sym[ii] = mem_ptr[ii];

calc_group_table(group_table);

for (ii = 0; ii < N_SYM; ii++)
    {
    for (jj = 0; jj < N_SYM; jj++)
        if (group_table[ii][jj] == 0)
           {
           group_inverse[ii] = jj;
           break;
           }

    if (jj == N_SYM)
       exit_w_error_message("init_sym_x_invsym_to_sym : inverse not found");
    }

for (ii = 0; ii < N_SYM; ii++)
    for (jj = 0; jj < N_SYM; jj++)
        sym_x_invsym_to_sym[ii][jj] =
                             (unsigned char)group_table[ii][group_inverse[jj]];

return;
}


/* ========================================================================= */
   void  calc_sym_on_twist(int  sym_on_twist[N_CUBESYM][N_TWIST])
/* ------------------------------------------------------------------------- */

{
int                     sym;


perm_n_init(N_TWIST, sym_on_twist[0]);
perm_n_init(N_TWIST, sym_on_twist[1]);

four_cycle(sym_on_twist[1], TWIST_F , TWIST_L , TWIST_B , TWIST_R );
four_cycle(sym_on_twist[1], TWIST_F2, TWIST_L2, TWIST_B2, TWIST_R2);
four_cycle(sym_on_twist[1], TWIST_F3, TWIST_L3, TWIST_B3, TWIST_R3);

for (sym = 2; sym < 4; sym++)
    perm_n_compose(N_TWIST, sym_on_twist[1], sym_on_twist[sym - 1],
                                                            sym_on_twist[sym]);

perm_n_init(N_TWIST, sym_on_twist[4]);

two_cycle(sym_on_twist[4], TWIST_R , TWIST_L );
two_cycle(sym_on_twist[4], TWIST_R2, TWIST_L2);
two_cycle(sym_on_twist[4], TWIST_R3, TWIST_L3);
two_cycle(sym_on_twist[4], TWIST_U , TWIST_D );
two_cycle(sym_on_twist[4], TWIST_U2, TWIST_D2);
two_cycle(sym_on_twist[4], TWIST_U3, TWIST_D3);

for (sym = 5; sym < 8; sym++)
    perm_n_compose(N_TWIST, sym_on_twist[4], sym_on_twist[sym - 4],
                                                            sym_on_twist[sym]);

perm_n_init(N_TWIST, sym_on_twist[8]);

two_cycle(sym_on_twist[8], TWIST_F, TWIST_F3);
two_cycle(sym_on_twist[8], TWIST_R, TWIST_R3);
two_cycle(sym_on_twist[8], TWIST_B, TWIST_B3);
two_cycle(sym_on_twist[8], TWIST_L, TWIST_L3);
two_cycle(sym_on_twist[8], TWIST_U , TWIST_D3);
two_cycle(sym_on_twist[8], TWIST_U2, TWIST_D2);
two_cycle(sym_on_twist[8], TWIST_U3, TWIST_D );

for (sym = 9; sym < 16; sym++)
    perm_n_compose(N_TWIST, sym_on_twist[8], sym_on_twist[sym - 8],
                                                            sym_on_twist[sym]);

perm_n_init(N_TWIST, sym_on_twist[16]);

three_cycle(sym_on_twist[16], TWIST_F , TWIST_R , TWIST_U );
three_cycle(sym_on_twist[16], TWIST_F2, TWIST_R2, TWIST_U2);
three_cycle(sym_on_twist[16], TWIST_F3, TWIST_R3, TWIST_U3);
three_cycle(sym_on_twist[16], TWIST_B , TWIST_L , TWIST_D );
three_cycle(sym_on_twist[16], TWIST_B2, TWIST_L2, TWIST_D2);
three_cycle(sym_on_twist[16], TWIST_B3, TWIST_L3, TWIST_D3);

for (sym = 17; sym < 48; sym++)
    perm_n_compose(N_TWIST, sym_on_twist[16], sym_on_twist[sym - 16],
                                                            sym_on_twist[sym]);

return;
}


/* ========================================================================= */
   void  init_invsym_on_twist(void)
/* ------------------------------------------------------------------------- */

{
unsigned char         (*mem_ptr)[N_SYM][N_TWIST];
int                     sym_on_twist[N_CUBESYM][N_TWIST];
int                     ud_to_rl[N_TWIST], sym, twist;


/*   allocate and initialize global arrays                                 */
/*   invsym_on_twist_ud ,  invsym_on_twist_fb   and   invsym_on_twist_rl   */

mem_ptr = (unsigned char (*)[N_SYM][N_TWIST])
                             malloc(sizeof(unsigned char [3][N_SYM][N_TWIST]));
if (mem_ptr == NULL)
   exit_w_error_message("init_invsym_on_twist : couldn't get memory");

for (sym = 0; sym < N_SYM; sym++)
    {
    invsym_on_twist_ud[sym] = mem_ptr[0][sym];
    invsym_on_twist_rl[sym] = mem_ptr[1][sym];
    invsym_on_twist_fb[sym] = mem_ptr[2][sym];
    }

calc_sym_on_twist(sym_on_twist);

for (sym = 0; sym < N_SYM; sym++)
    for (twist = 0; twist < N_TWIST; twist++)
        invsym_on_twist_ud[sym][twist] =
          (unsigned char)sym_on_twist[(int)sym_x_invsym_to_sym[0][sym]][twist];

perm_n_init(N_TWIST, ud_to_rl);

three_cycle(ud_to_rl, TWIST_F , TWIST_R , TWIST_U );
three_cycle(ud_to_rl, TWIST_F2, TWIST_R2, TWIST_U2);
three_cycle(ud_to_rl, TWIST_F3, TWIST_R3, TWIST_U3);
three_cycle(ud_to_rl, TWIST_B , TWIST_L , TWIST_D );
three_cycle(ud_to_rl, TWIST_B2, TWIST_L2, TWIST_D2);
three_cycle(ud_to_rl, TWIST_B3, TWIST_L3, TWIST_D3);

for (sym = 0; sym < N_SYM; sym++)
    for (twist = 0; twist < N_TWIST; twist++)
        invsym_on_twist_rl[sym][twist] =
                                      invsym_on_twist_ud[sym][ud_to_rl[twist]];

for (sym = 0; sym < N_SYM; sym++)
    for (twist = 0; twist < N_TWIST; twist++)
        invsym_on_twist_fb[sym][twist] =
                                      invsym_on_twist_rl[sym][ud_to_rl[twist]];

return;
}


/* ========================================================================= */
   void  generate_subgroup(int  group_table[N_CUBESYM][N_CUBESYM],
                           int   gen_set[N_CUBESYM])
/* ------------------------------------------------------------------------- */

/*  gen_set[]  is both input and output  */

{
int                 found, ii, jj;


gen_set[0] = 1;
found = 1;

while (found)
      {
      found = 0;

      for (ii = 0; ii < N_CUBESYM; ii++)
          if (gen_set[ii] != 0)
             for (jj = 0; jj < N_CUBESYM; jj++)
                 if ((gen_set[jj] != 0) && (gen_set[group_table[ii][jj]] == 0))
                    {
                    gen_set[group_table[ii][jj]] = 1;
                    found = 1;
                    }
      }

return;
}


/* ========================================================================= */
   void  calc_subgroups_recursive(int  group_table[N_CUBESYM][N_CUBESYM],
                                  int  contain_list[N_CUBESYM],
                                  int  avoid_list[N_CUBESYM],
                                  Subgroup_list  *p_output)
/* ------------------------------------------------------------------------- */

{
int                 local_contain_list[N_CUBESYM], ii, jj;


for (ii = 0; ii < N_CUBESYM; ii++)
    if (contain_list[ii] && avoid_list[ii])
       return;

for (ii = 0; ii < N_CUBESYM; ii++)
    if ((contain_list[ii] == 0) && (avoid_list[ii] == 0))
       break;

if (ii < N_CUBESYM)
   {
   for (jj = 0; jj < N_CUBESYM; jj++)
       local_contain_list[jj] = contain_list[jj];
   local_contain_list[ii] = 1;
   generate_subgroup(group_table, local_contain_list);
   calc_subgroups_recursive(group_table, local_contain_list, avoid_list,
                                                                     p_output);
   avoid_list[ii] = 1;
   calc_subgroups_recursive(group_table, contain_list, avoid_list, p_output);
   avoid_list[ii] = 0;
   }
else
   {
   if (p_output->n_subgroups >= N_SYMSUBGRP)
      exit_w_error_message("calc_subgroups_recursive : too many subgroups");

   for (ii = 0; ii < N_CUBESYM; ii++)
       p_output->subgroups[p_output->n_subgroups][ii] = contain_list[ii];

   p_output->n_subgroups++;
   }

return;
}


/* ========================================================================= */
   void  calc_subgroup_list(int  subgroup_list[N_SYMSUBGRP][N_CUBESYM])
/* ------------------------------------------------------------------------- */

{
Subgroup_list   output_list;
int             group_table[N_CUBESYM][N_CUBESYM];
int             contain_list[N_CUBESYM];
int             avoid_list[N_CUBESYM];
int             ii;


calc_group_table(group_table);

output_list.n_subgroups = 0;
output_list.subgroups = subgroup_list;

contain_list[0] = 1;

for (ii = 1; ii < N_CUBESYM; ii++)
    contain_list[ii] = 0;

for (ii = 0; ii < N_CUBESYM; ii++)
    avoid_list[ii] = 0;

calc_subgroups_recursive(group_table, contain_list, avoid_list, &output_list);

if (output_list.n_subgroups != N_SYMSUBGRP)
   exit_w_error_message("calc_subgroup_list : wrong number of subgroups");

return;
}


/* ========================================================================= */
   int  is_single_twist(int  syllable)
/* ------------------------------------------------------------------------- */

{
if ((syllable == SYLLABLE_F) || (syllable == SYLLABLE_F2) ||
                                (syllable == SYLLABLE_F3) ||
    (syllable == SYLLABLE_R) || (syllable == SYLLABLE_R2) ||
                                (syllable == SYLLABLE_R3) ||
    (syllable == SYLLABLE_U) || (syllable == SYLLABLE_U2) ||
                                (syllable == SYLLABLE_U3) ||
    (syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                (syllable == SYLLABLE_B3) ||
    (syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                (syllable == SYLLABLE_L3) ||
    (syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                (syllable == SYLLABLE_D3))
   return 1;

return 0;
}


/* ========================================================================= */
   int  syllable_to_twist(int  syllable)
/* ------------------------------------------------------------------------- */

{
if (syllable == SYLLABLE_F)
   return TWIST_F;
else if (syllable == SYLLABLE_F2)
        return TWIST_F2;
else if (syllable == SYLLABLE_F3)
        return TWIST_F3;
else if (syllable == SYLLABLE_R)
        return TWIST_R;
else if (syllable == SYLLABLE_R2)
        return TWIST_R2;
else if (syllable == SYLLABLE_R3)
        return TWIST_R3;
else if (syllable == SYLLABLE_U)
        return TWIST_U;
else if (syllable == SYLLABLE_U2)
        return TWIST_U2;
else if (syllable == SYLLABLE_U3)
        return TWIST_U3;
else if (syllable == SYLLABLE_B)
        return TWIST_B;
else if (syllable == SYLLABLE_B2)
        return TWIST_B2;
else if (syllable == SYLLABLE_B3)
        return TWIST_B3;
else if (syllable == SYLLABLE_L)
        return TWIST_L;
else if (syllable == SYLLABLE_L2)
        return TWIST_L2;
else if (syllable == SYLLABLE_L3)
        return TWIST_L3;
else if (syllable == SYLLABLE_D)
        return TWIST_D;
else if (syllable == SYLLABLE_D2)
        return TWIST_D2;
else if (syllable == SYLLABLE_D3)
        return TWIST_D3;
else
   exit_w_error_message("syllable_to_twist : invalid input");

return -1;
}


/* ========================================================================= */
   void  syllable_to_two_twists(int  syllable, int  twists_out[2])
/* ------------------------------------------------------------------------- */

{
if (syllable == SYLLABLE_FB)
   {
   twists_out[0] = TWIST_F;
   twists_out[1] = TWIST_B;
   }
else if (syllable == SYLLABLE_FB2)
        {
        twists_out[0] = TWIST_F;
        twists_out[1] = TWIST_B2;
        }
else if (syllable == SYLLABLE_FB3)
        {
        twists_out[0] = TWIST_F;
        twists_out[1] = TWIST_B3;
        }
else if (syllable == SYLLABLE_F2B2)
        {
        twists_out[0] = TWIST_F2;
        twists_out[1] = TWIST_B2;
        }
else if (syllable == SYLLABLE_RL)
        {
        twists_out[0] = TWIST_R;
        twists_out[1] = TWIST_L;
        }
else if (syllable == SYLLABLE_RL2)
        {
        twists_out[0] = TWIST_R;
        twists_out[1] = TWIST_L2;
        }
else if (syllable == SYLLABLE_RL3)
        {
        twists_out[0] = TWIST_R;
        twists_out[1] = TWIST_L3;
        }
else if (syllable == SYLLABLE_R2L2)
        {
        twists_out[0] = TWIST_R2;
        twists_out[1] = TWIST_L2;
        }
else if (syllable == SYLLABLE_UD)
        {
        twists_out[0] = TWIST_U;
        twists_out[1] = TWIST_D;
        }
else if (syllable == SYLLABLE_UD2)
        {
        twists_out[0] = TWIST_U;
        twists_out[1] = TWIST_D2;
        }
else if (syllable == SYLLABLE_UD3)
        {
        twists_out[0] = TWIST_U;
        twists_out[1] = TWIST_D3;
        }
else if (syllable == SYLLABLE_U2D2)
        {
        twists_out[0] = TWIST_U2;
        twists_out[1] = TWIST_D2;
        }
else
   exit_w_error_message("syllable_to_two_twists : invalid input");

return;
}


/* ========================================================================= */
   int  twists_in_wrong_order(int  twists[2])
/* ------------------------------------------------------------------------- */

{
if (((twists[0] == TWIST_B) || (twists[0] == TWIST_B2) ||
                                   (twists[0] == TWIST_B3)) &&
    ((twists[1] == TWIST_F) || (twists[1] == TWIST_F2) ||
                                   (twists[1] == TWIST_F3)))
   return 1;

if (((twists[0] == TWIST_L) || (twists[0] == TWIST_L2) ||
                                   (twists[0] == TWIST_L3)) &&
    ((twists[1] == TWIST_R) || (twists[1] == TWIST_R2) ||
                                   (twists[1] == TWIST_R3)))
   return 1;

if (((twists[0] == TWIST_D) || (twists[0] == TWIST_D2) ||
                                   (twists[0] == TWIST_D3)) &&
    ((twists[1] == TWIST_U) || (twists[1] == TWIST_U2) ||
                                   (twists[1] == TWIST_U3)))
   return 1;

return 0;
}


/* ========================================================================= */
   void  clean_up_sequence(int  twist_sequence[], int  n_twists)
/* ------------------------------------------------------------------------- */

{
int             ii;


for (ii = 1; ii < n_twists; ii++)
    if (twists_in_wrong_order(&twist_sequence[ii - 1]) != 0)
       two_cycle(twist_sequence, ii - 1, ii);

return;
}


/* ========================================================================= */
   int  which_subgroup(int  subgroup[N_CUBESYM],
                       int  subgroup_list[N_SYMSUBGRP][N_CUBESYM])
/* ------------------------------------------------------------------------- */

{
int             subgrp, sym;


for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
    {
    for (sym = 0; sym < N_CUBESYM; sym++)
        if ((subgroup[sym] == 0) != (subgroup_list[subgrp][sym] == 0))
           break;

    if (sym == N_CUBESYM)
       return subgrp;
    }

return -1;
}


/* ========================================================================= */
   void  calc_syllable_on_sym(int  subgroup_list[N_SYMSUBGRP][N_CUBESYM],
                              int  sym_on_twist[N_CUBESYM][N_TWIST],
                              int  syllable_on_sym[N_SYLLABLE][N_SYMSUBGRP])
/* ------------------------------------------------------------------------- */

{
int             subgroup[N_CUBESYM], temp_subgroup[N_CUBESYM];
int             twist_arr[2], temp_arr[2];
int             syllable, sym, subgrp, twist;


for (syllable = 0; syllable < N_SYLLABLE; syllable++)
    {
    if ((syllable == SYLLABLE_INVALID) || (syllable == SYLLABLE_NONE))
       {
       subgroup[0] = 1;
       for (sym = 1; sym < N_CUBESYM; sym++)
           subgroup[sym] = 0;
       }
    else if (is_single_twist(syllable))
            {
            twist = syllable_to_twist(syllable);
            for (sym = 0; sym < N_CUBESYM; sym++)
                subgroup[sym] = (sym_on_twist[sym][twist] == twist);
            }
    else
       {
       syllable_to_two_twists(syllable, twist_arr);

       for (sym = 0; sym < N_CUBESYM; sym++)
           {
           temp_arr[0] = sym_on_twist[sym][twist_arr[0]];
           temp_arr[1] = sym_on_twist[sym][twist_arr[1]];
           clean_up_sequence(temp_arr, 2);
           if ((temp_arr[0] == twist_arr[0]) &&
               (temp_arr[1] == twist_arr[1]))
              subgroup[sym] = 1;
           else
              subgroup[sym] = 0;
           }
       }

    for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
        {
        for (sym = 0; sym < N_CUBESYM; sym++)
            temp_subgroup[sym] = (subgroup[sym] && subgroup_list[subgrp][sym]);

        syllable_on_sym[syllable][subgrp] = which_subgroup(temp_subgroup,
                                                                subgroup_list);
        if (syllable_on_sym[syllable][subgrp] < 0)
           exit_w_error_message("calc_syllable_on_sym : subgroup not found");
        }
    }

return;
}


/* ========================================================================= */
   int  twist_on_syllable(int  twist, int  syllable)
/* ------------------------------------------------------------------------- */

{
if (syllable == SYLLABLE_INVALID)
   return SYLLABLE_INVALID;

if (twist == TWIST_F)
   {
   if ((syllable == SYLLABLE_F) || (syllable == SYLLABLE_F2) ||
                                   (syllable == SYLLABLE_F3) ||
       (syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                   (syllable == SYLLABLE_B3) ||
       (syllable == SYLLABLE_FB) || (syllable == SYLLABLE_FB2) ||
       (syllable == SYLLABLE_FB3) || (syllable == SYLLABLE_F2B2))
      return SYLLABLE_INVALID;
   else
      return SYLLABLE_F;
   }
else if (twist == TWIST_F2)
        {
        if ((syllable == SYLLABLE_F) || (syllable == SYLLABLE_F2) ||
                                        (syllable == SYLLABLE_F3) ||
            (syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                        (syllable == SYLLABLE_B3) ||
            (syllable == SYLLABLE_FB) || (syllable == SYLLABLE_FB2) ||
            (syllable == SYLLABLE_FB3) || (syllable == SYLLABLE_F2B2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_F2;
        }
else if (twist == TWIST_F3)
        {
        if ((syllable == SYLLABLE_F) || (syllable == SYLLABLE_F2) ||
                                        (syllable == SYLLABLE_F3) ||
            (syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                        (syllable == SYLLABLE_B3) ||
            (syllable == SYLLABLE_FB) || (syllable == SYLLABLE_FB2) ||
            (syllable == SYLLABLE_FB3) || (syllable == SYLLABLE_F2B2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_F3;
        }
else if (twist == TWIST_R)
        {
        if ((syllable == SYLLABLE_R) || (syllable == SYLLABLE_R2) ||
                                        (syllable == SYLLABLE_R3) ||
            (syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                        (syllable == SYLLABLE_L3) ||
            (syllable == SYLLABLE_RL) || (syllable == SYLLABLE_RL2) ||
            (syllable == SYLLABLE_RL3) || (syllable == SYLLABLE_R2L2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_R;
        }
else if (twist == TWIST_R2)
        {
        if ((syllable == SYLLABLE_R) || (syllable == SYLLABLE_R2) ||
                                        (syllable == SYLLABLE_R3) ||
            (syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                        (syllable == SYLLABLE_L3) ||
            (syllable == SYLLABLE_RL) || (syllable == SYLLABLE_RL2) ||
            (syllable == SYLLABLE_RL3) || (syllable == SYLLABLE_R2L2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_R2;
        }
else if (twist == TWIST_R3)
        {
        if ((syllable == SYLLABLE_R) || (syllable == SYLLABLE_R2) ||
                                        (syllable == SYLLABLE_R3) ||
            (syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                        (syllable == SYLLABLE_L3) ||
            (syllable == SYLLABLE_RL) || (syllable == SYLLABLE_RL2) ||
            (syllable == SYLLABLE_RL3) || (syllable == SYLLABLE_R2L2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_R3;
        }
else if (twist == TWIST_U)
        {
        if ((syllable == SYLLABLE_U) || (syllable == SYLLABLE_U2) ||
                                        (syllable == SYLLABLE_U3) ||
            (syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                        (syllable == SYLLABLE_D3) ||
            (syllable == SYLLABLE_UD) || (syllable == SYLLABLE_UD2) ||
            (syllable == SYLLABLE_UD3) || (syllable == SYLLABLE_U2D2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_U;
        }
else if (twist == TWIST_U2)
        {
        if ((syllable == SYLLABLE_U) || (syllable == SYLLABLE_U2) ||
                                        (syllable == SYLLABLE_U3) ||
            (syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                        (syllable == SYLLABLE_D3) ||
            (syllable == SYLLABLE_UD) || (syllable == SYLLABLE_UD2) ||
            (syllable == SYLLABLE_UD3) || (syllable == SYLLABLE_U2D2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_U2;
        }
else if (twist == TWIST_U3)
        {
        if ((syllable == SYLLABLE_U) || (syllable == SYLLABLE_U2) ||
                                        (syllable == SYLLABLE_U3) ||
            (syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                        (syllable == SYLLABLE_D3) ||
            (syllable == SYLLABLE_UD) || (syllable == SYLLABLE_UD2) ||
            (syllable == SYLLABLE_UD3) || (syllable == SYLLABLE_U2D2))
           return SYLLABLE_INVALID;
        else
           return SYLLABLE_U3;
        }
else if (twist == TWIST_B)
        {
        if ((syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                        (syllable == SYLLABLE_B3) ||
            (syllable == SYLLABLE_FB) || (syllable == SYLLABLE_FB2) ||
            (syllable == SYLLABLE_FB3) || (syllable == SYLLABLE_F2B2))
           return SYLLABLE_INVALID;
        else if (syllable == SYLLABLE_F)
                return SYLLABLE_FB;
        else if (syllable == SYLLABLE_F2)
                return SYLLABLE_FB2;
        else if (syllable == SYLLABLE_F3)
                return SYLLABLE_FB3;
        else
           return SYLLABLE_B;
        }
else if (twist == TWIST_B2)
        {
        if ((syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                        (syllable == SYLLABLE_B3) ||
            (syllable == SYLLABLE_FB) || (syllable == SYLLABLE_FB2) ||
            (syllable == SYLLABLE_FB3) || (syllable == SYLLABLE_F2B2))
           return SYLLABLE_INVALID;
        else if ((syllable == SYLLABLE_F) || (syllable == SYLLABLE_F3))
                return SYLLABLE_FB2;
        else if (syllable == SYLLABLE_F2)
                return SYLLABLE_F2B2;
        else
           return SYLLABLE_B2;
        }
else if (twist == TWIST_B3)
        {
        if ((syllable == SYLLABLE_B) || (syllable == SYLLABLE_B2) ||
                                        (syllable == SYLLABLE_B3) ||
            (syllable == SYLLABLE_FB) || (syllable == SYLLABLE_FB2) ||
            (syllable == SYLLABLE_FB3) || (syllable == SYLLABLE_F2B2))
           return SYLLABLE_INVALID;
        else if (syllable == SYLLABLE_F)
                return SYLLABLE_FB3;
        else if (syllable == SYLLABLE_F2)
                return SYLLABLE_FB2;
        else if (syllable == SYLLABLE_F3)
                return SYLLABLE_FB;
        else
           return SYLLABLE_B3;
        }
else if (twist == TWIST_L)
        {
        if ((syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                        (syllable == SYLLABLE_L3) ||
            (syllable == SYLLABLE_RL) || (syllable == SYLLABLE_RL2) ||
            (syllable == SYLLABLE_RL3) || (syllable == SYLLABLE_R2L2))
           return SYLLABLE_INVALID;
        else if (syllable == SYLLABLE_R)
                return SYLLABLE_RL;
        else if (syllable == SYLLABLE_R2)
                return SYLLABLE_RL2;
        else if (syllable == SYLLABLE_R3)
                return SYLLABLE_RL3;
        else
           return SYLLABLE_L;
        }
else if (twist == TWIST_L2)
        {
        if ((syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                        (syllable == SYLLABLE_L3) ||
            (syllable == SYLLABLE_RL) || (syllable == SYLLABLE_RL2) ||
            (syllable == SYLLABLE_RL3) || (syllable == SYLLABLE_R2L2))
           return SYLLABLE_INVALID;
        else if ((syllable == SYLLABLE_R) || (syllable == SYLLABLE_R3))
                return SYLLABLE_RL2;
        else if (syllable == SYLLABLE_R2)
                return SYLLABLE_R2L2;
        else
           return SYLLABLE_L2;
        }
else if (twist == TWIST_L3)
        {
        if ((syllable == SYLLABLE_L) || (syllable == SYLLABLE_L2) ||
                                        (syllable == SYLLABLE_L3) ||
            (syllable == SYLLABLE_RL) || (syllable == SYLLABLE_RL2) ||
            (syllable == SYLLABLE_RL3) || (syllable == SYLLABLE_R2L2))
           return SYLLABLE_INVALID;
        else if (syllable == SYLLABLE_R)
                return SYLLABLE_RL3;
        else if (syllable == SYLLABLE_R2)
                return SYLLABLE_RL2;
        else if (syllable == SYLLABLE_R3)
                return SYLLABLE_RL;
        else
           return SYLLABLE_L3;
        }
else if (twist == TWIST_D)
        {
        if ((syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                        (syllable == SYLLABLE_D3) ||
            (syllable == SYLLABLE_UD) || (syllable == SYLLABLE_UD2) ||
            (syllable == SYLLABLE_UD3) || (syllable == SYLLABLE_U2D2))
           return SYLLABLE_INVALID;
        else if (syllable == SYLLABLE_U)
                return SYLLABLE_UD;
        else if (syllable == SYLLABLE_U2)
                return SYLLABLE_UD2;
        else if (syllable == SYLLABLE_U3)
                return SYLLABLE_UD3;
        else
           return SYLLABLE_D;
        }
else if (twist == TWIST_D2)
        {
        if ((syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                        (syllable == SYLLABLE_D3) ||
            (syllable == SYLLABLE_UD) || (syllable == SYLLABLE_UD2) ||
            (syllable == SYLLABLE_UD3) || (syllable == SYLLABLE_U2D2))
           return SYLLABLE_INVALID;
        else if ((syllable == SYLLABLE_U) || (syllable == SYLLABLE_U3))
                return SYLLABLE_UD2;
        else if (syllable == SYLLABLE_U2)
                return SYLLABLE_U2D2;
        else
           return SYLLABLE_D2;
        }
else if (twist == TWIST_D3)
        {
        if ((syllable == SYLLABLE_D) || (syllable == SYLLABLE_D2) ||
                                        (syllable == SYLLABLE_D3) ||
            (syllable == SYLLABLE_UD) || (syllable == SYLLABLE_UD2) ||
            (syllable == SYLLABLE_UD3) || (syllable == SYLLABLE_U2D2))
           return SYLLABLE_INVALID;
        else if (syllable == SYLLABLE_U)
                return SYLLABLE_UD3;
        else if (syllable == SYLLABLE_U2)
                return SYLLABLE_UD2;
        else if (syllable == SYLLABLE_U3)
                return SYLLABLE_UD;
        else
           return SYLLABLE_D3;
        }
else
   exit_w_error_message("twist_on_syllable : invalid twist");

return SYLLABLE_INVALID;
}


/* ========================================================================= */
   int  not_minimal_one_twist(int  subgroup[N_CUBESYM],
                              int  sym_on_twist[N_CUBESYM][N_TWIST],
                              int  twist)
/* ------------------------------------------------------------------------- */

{
int                     sym;


for (sym = 0; sym < N_CUBESYM; sym++)
    if (subgroup[sym] && (sym_on_twist[sym][twist] < twist))
       return 1;

return 0;
}


/* ========================================================================= */
   int  not_minimal_two_twists(int  subgroup[N_CUBESYM],
                               int  sym_on_twist[N_CUBESYM][N_TWIST],
                               int  twist0, int  twist1)
/* ------------------------------------------------------------------------- */

{
int                     twist_arr[2], sym;


for (sym = 0; sym < N_CUBESYM; sym++)
    if (subgroup[sym])
       {
       twist_arr[0] = sym_on_twist[sym][twist0];
       twist_arr[1] = sym_on_twist[sym][twist1];
       clean_up_sequence(twist_arr, 2);
       if ((twist_arr[0] < twist0) ||
           ((twist_arr[0] == twist0) && (twist_arr[1] < twist1)))
          return 1;
       }

return 0;
}


/* ========================================================================= */
   void  calc_twist_on_sylsubgrp(int
                           tw_on_sylsubgrp[N_TWIST][N_SYLLABLE * N_SYMSUBGRP])
/* ------------------------------------------------------------------------- */

{
int             subgroup_list[N_SYMSUBGRP][N_CUBESYM];
int             sym_on_twist[N_CUBESYM][N_TWIST];
int             syllable_on_subgrp[N_SYLLABLE][N_SYMSUBGRP];
int             syllable, subgrp, subgrp_before, subgrp_after, twist;
int             new_syllable, new_subgrp;


calc_subgroup_list(subgroup_list);
calc_sym_on_twist(sym_on_twist);
calc_syllable_on_sym(subgroup_list, sym_on_twist, syllable_on_subgrp);

for (syllable = 0; syllable < N_SYLLABLE; syllable++)
    for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
        {
        if (is_single_twist(syllable))
           {
           subgrp_before = subgrp;
           subgrp_after = syllable_on_subgrp[syllable][subgrp];
           }
        else
           {
           subgrp_before = SUBGRP_TRIVIAL;

           if (syllable == SYLLABLE_INVALID)
              subgrp_after = SUBGRP_TRIVIAL;
           else
              subgrp_after = subgrp;
           }

        for (twist = 0; twist < N_TWIST; twist++)
            {
            new_syllable = twist_on_syllable(twist, syllable);

            if (is_single_twist(new_syllable))
               {
               if (not_minimal_one_twist(subgroup_list[subgrp_after],
                                sym_on_twist, syllable_to_twist(new_syllable)))
                  new_syllable = SYLLABLE_INVALID;
               }
            else if (new_syllable != SYLLABLE_INVALID)
                    {
                    if (not_minimal_two_twists(subgroup_list[subgrp_before],
                             sym_on_twist, syllable_to_twist(syllable), twist))
                       new_syllable = SYLLABLE_INVALID;
                    }

            if (new_syllable == SYLLABLE_INVALID)
               new_subgrp = SUBGRP_TRIVIAL;
            else if (is_single_twist(new_syllable))
                    new_subgrp = subgrp_after;
            else
               new_subgrp = syllable_on_subgrp[new_syllable][subgrp_before];

            tw_on_sylsubgrp[twist][syllable * N_SYMSUBGRP + subgrp] =
                                     new_syllable * N_SYMSUBGRP + new_subgrp;
            }
        }

return;
}


/* ========================================================================= */
   void  init_twist_on_follow(void)
/* ------------------------------------------------------------------------- */

{
unsigned short        (*mem_ptr)[N_FOLLOW];
int                     tw_on_sylsubgrp[N_TWIST][N_SYLLABLE * N_SYMSUBGRP];
int                     occurs[N_SYLLABLE * N_SYMSUBGRP];
int                     sylsubgrp_to_follow[N_SYLLABLE * N_SYMSUBGRP];
int                     follow_to_sylsubgrp[N_FOLLOW];
int                     syllable, subgrp, found, twist, count, follow;


calc_twist_on_sylsubgrp(tw_on_sylsubgrp);

for (syllable = 0; syllable < N_SYLLABLE; syllable++)
    for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
        occurs[syllable * N_SYMSUBGRP + subgrp] = 0;

for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
    occurs[SYLLABLE_NONE * N_SYMSUBGRP + subgrp] = 1;

found = 1;

while (found)
      {
      found = 0;
      for (syllable = 0; syllable < N_SYLLABLE; syllable++)
          for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
              for (twist = 0; twist < N_TWIST; twist++)
                  if (occurs[tw_on_sylsubgrp[twist]
                                     [syllable * N_SYMSUBGRP + subgrp]] == 0)
                     {
                     occurs[tw_on_sylsubgrp[twist]
                                      [syllable * N_SYMSUBGRP + subgrp]] = 1;
                     found = 1;
                     }
      }

count = 0;

for (syllable = 0; syllable < N_SYLLABLE; syllable++)
    for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
        {
        if (occurs[syllable * N_SYMSUBGRP + subgrp] == 0)
           sylsubgrp_to_follow[syllable * N_SYMSUBGRP + subgrp] = -1;
        else
           {
           sylsubgrp_to_follow[syllable * N_SYMSUBGRP + subgrp] = count;
           follow_to_sylsubgrp[count] = syllable * N_SYMSUBGRP + subgrp;
           count++;
           }
        }

if (count != N_FOLLOW)
   exit_w_error_message("init_twist_on_follow : wrong number of  follow's");

for (subgrp = 0; subgrp < N_SYMSUBGRP; subgrp++)
    if (sylsubgrp_to_follow[SYLLABLE_NONE * N_SYMSUBGRP + subgrp]
                                                                 != 1 + subgrp)
       exit_w_error_message("init_twist_on_follow : indexing error");

mem_ptr = (unsigned short (*)[N_FOLLOW])
                            malloc(sizeof(unsigned short [N_TWIST][N_FOLLOW]));
if (mem_ptr == NULL)
   exit_w_error_message("init_twist_on_follow : couldn't get memory");

for (twist = 0; twist < N_TWIST; twist++)
    twist_on_follow[twist] = mem_ptr[twist];

for (twist = 0; twist < N_TWIST; twist++)
    for (follow = 0; follow < N_FOLLOW; follow++)
        twist_on_follow[twist][follow] =
            (unsigned short)sylsubgrp_to_follow[tw_on_sylsubgrp[twist]
                                                [follow_to_sylsubgrp[follow]]];

return;
}


/* ========================================================================= */
   void  corner_unpack(int  corner, int  array_out[8])
/* ------------------------------------------------------------------------- */

/*  input:  corner
   output:  array_out[]  */

{
int                     ii;


for (ii = 0; ii < 7; ii++)
    {
    array_out[ii] = corner % 3;
    corner = corner / 3;
    }

array_out[7] = (2 * (array_out[0] + array_out[1] + array_out[2] + array_out[3]
                            + array_out[4] + array_out[5] + array_out[6])) % 3;

return;
}


/* ========================================================================= */
   int  corner_pack(int  array_in[8])
/* ------------------------------------------------------------------------- */

/*  input:  array_in[]  */

{
int                     corner, ii;


corner = 0;
for (ii = 6; ii >= 0; ii--)
    corner = 3 * corner + array_in[ii];

return corner;
}


/* ========================================================================= */
   void  corner_adjust(int  array[8], int  ind0, int  ind1, int  ind2,
                                                            int  ind3)
/* ------------------------------------------------------------------------- */

{
array[ind0] = (array[ind0] + 1) % 3;
array[ind1] = (array[ind1] + 2) % 3;
array[ind2] = (array[ind2] + 1) % 3;
array[ind3] = (array[ind3] + 2) % 3;

return;
}


/* ========================================================================= */
   int  twist_f_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_DFL, CORNER_DRF, CORNER_UFR, CORNER_ULF);
corner_adjust(temp_arr, CORNER_DFL, CORNER_DRF, CORNER_UFR, CORNER_ULF);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_r_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_DRF, CORNER_DBR, CORNER_URB, CORNER_UFR);
corner_adjust(temp_arr, CORNER_DRF, CORNER_DBR, CORNER_URB, CORNER_UFR);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_u_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_UFR, CORNER_URB, CORNER_UBL, CORNER_ULF);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_b_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_DBR, CORNER_DLB, CORNER_UBL, CORNER_URB);
corner_adjust(temp_arr, CORNER_DBR, CORNER_DLB, CORNER_UBL, CORNER_URB);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_l_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_DLB, CORNER_DFL, CORNER_ULF, CORNER_UBL);
corner_adjust(temp_arr, CORNER_DLB, CORNER_DFL, CORNER_ULF, CORNER_UBL);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_d_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_DFL, CORNER_DLB, CORNER_DBR, CORNER_DRF);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   void  init_twist_on_corner(void)
/* ------------------------------------------------------------------------- */

{
int                     twist, corner;


/*  allocate and initialize global array   twist_on_corner    */

twist_on_corner[0] =
          (unsigned short *)malloc(sizeof(unsigned short [N_TWIST][N_CORNER]));
if (twist_on_corner[0] == NULL)
   exit_w_error_message("init_twist_on_corner : couldn't get memory");

for (twist = 1; twist < N_TWIST; twist++)
    twist_on_corner[twist] = &twist_on_corner[0][twist * N_CORNER];

for (corner = 0; corner < N_CORNER; corner++)
    {
    twist_on_corner[TWIST_F][corner] =
                                     (unsigned short)twist_f_on_corner(corner);
    twist_on_corner[TWIST_R][corner] =
                                     (unsigned short)twist_r_on_corner(corner);
    twist_on_corner[TWIST_U][corner] =
                                     (unsigned short)twist_u_on_corner(corner);
    twist_on_corner[TWIST_B][corner] =
                                     (unsigned short)twist_b_on_corner(corner);
    twist_on_corner[TWIST_L][corner] =
                                     (unsigned short)twist_l_on_corner(corner);
    twist_on_corner[TWIST_D][corner] =
                                     (unsigned short)twist_d_on_corner(corner);
    }
for (corner = 0; corner < N_CORNER; corner++)
    {
    twist_on_corner[TWIST_F2][corner] =
              twist_on_corner[TWIST_F][(int)twist_on_corner[TWIST_F][corner]];
    twist_on_corner[TWIST_R2][corner] =
              twist_on_corner[TWIST_R][(int)twist_on_corner[TWIST_R][corner]];
    twist_on_corner[TWIST_U2][corner] =
              twist_on_corner[TWIST_U][(int)twist_on_corner[TWIST_U][corner]];
    twist_on_corner[TWIST_B2][corner] =
              twist_on_corner[TWIST_B][(int)twist_on_corner[TWIST_B][corner]];
    twist_on_corner[TWIST_L2][corner] =
              twist_on_corner[TWIST_L][(int)twist_on_corner[TWIST_L][corner]];
    twist_on_corner[TWIST_D2][corner] =
              twist_on_corner[TWIST_D][(int)twist_on_corner[TWIST_D][corner]];
    }
for (corner = 0; corner < N_CORNER; corner++)
    {
    twist_on_corner[TWIST_F3][corner] =
              twist_on_corner[TWIST_F2][(int)twist_on_corner[TWIST_F][corner]];
    twist_on_corner[TWIST_R3][corner] =
              twist_on_corner[TWIST_R2][(int)twist_on_corner[TWIST_R][corner]];
    twist_on_corner[TWIST_U3][corner] =
              twist_on_corner[TWIST_U2][(int)twist_on_corner[TWIST_U][corner]];
    twist_on_corner[TWIST_B3][corner] =
              twist_on_corner[TWIST_B2][(int)twist_on_corner[TWIST_B][corner]];
    twist_on_corner[TWIST_L3][corner] =
              twist_on_corner[TWIST_L2][(int)twist_on_corner[TWIST_L][corner]];
    twist_on_corner[TWIST_D3][corner] =
              twist_on_corner[TWIST_D2][(int)twist_on_corner[TWIST_D][corner]];
    }

return;
}


/* ========================================================================= */
   int  sym_cu_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
four_cycle(temp_arr, CORNER_UFR, CORNER_URB, CORNER_UBL, CORNER_ULF);
four_cycle(temp_arr, CORNER_DRF, CORNER_DBR, CORNER_DLB, CORNER_DFL);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  sym_cf2_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


corner_unpack(corner, temp_arr);
two_cycle(temp_arr, CORNER_UFR, CORNER_DFL);
two_cycle(temp_arr, CORNER_ULF, CORNER_DRF);
two_cycle(temp_arr, CORNER_UBL, CORNER_DBR);
two_cycle(temp_arr, CORNER_URB, CORNER_DLB);

return corner_pack(temp_arr);
}


/* ========================================================================= */
   int  sym_rud_on_corner(int  corner)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8], ii;


corner_unpack(corner, temp_arr);
two_cycle(temp_arr, CORNER_UFR, CORNER_DRF);
two_cycle(temp_arr, CORNER_ULF, CORNER_DFL);
two_cycle(temp_arr, CORNER_UBL, CORNER_DLB);
two_cycle(temp_arr, CORNER_URB, CORNER_DBR);

for (ii = 0; ii < 8; ii++)
    temp_arr[ii] = (2 * temp_arr[ii]) % 3;

return corner_pack(temp_arr);
}


/* ========================================================================= */
   void  init_sym_on_corner(void)
/* ------------------------------------------------------------------------- */

{
int                     corner, sym;


/*  allocate and initialize global array   sym_on_corner    */

sym_on_corner[0] =
            (unsigned short *)malloc(sizeof(unsigned short [N_SYM][N_CORNER]));
if (sym_on_corner[0] == NULL)
   exit_w_error_message("init_sym_on_corner : couldn't get memory");

for (sym = 1; sym < N_SYM; sym++)
    sym_on_corner[sym] = &sym_on_corner[0][sym * N_CORNER];

for (corner = 0; corner < N_CORNER; corner++)
    sym_on_corner[0][corner] = (unsigned short)corner;

for (corner = 0; corner < N_CORNER; corner++)
    sym_on_corner[1][corner] = (unsigned short)sym_cu_on_corner(corner);

for (sym = 2; sym < 4; sym++)
    for (corner = 0; corner < N_CORNER; corner++)
        sym_on_corner[sym][corner] =
                         sym_on_corner[1][(int)sym_on_corner[sym - 1][corner]];

for (corner = 0; corner < N_CORNER; corner++)
    sym_on_corner[4][corner] = (unsigned short)sym_cf2_on_corner(corner);

for (sym = 5; sym < 8; sym++)
    for (corner = 0; corner < N_CORNER; corner++)
        sym_on_corner[sym][corner] =
                         sym_on_corner[4][(int)sym_on_corner[sym - 4][corner]];

for (corner = 0; corner < N_CORNER; corner++)
    sym_on_corner[8][corner] = (unsigned short)sym_rud_on_corner(corner);

for (sym = 9; sym < 16; sym++)
    for (corner = 0; corner < N_CORNER; corner++)
        sym_on_corner[sym][corner] =
                         sym_on_corner[8][(int)sym_on_corner[sym - 8][corner]];

return;
}


/* ========================================================================= */
   void  calc_edgeloc_conv(int  conv_tab[N_ELOC], int  unconv_tab[N_ELOC_CONV])
/* ------------------------------------------------------------------------- */

{
int                     ii, loc0, loc1, loc2, loc3, count;


for (ii = 0; ii < N_ELOC; ii++)
    conv_tab[ii] = -1;

for (ii = 0; ii < N_ELOC_CONV; ii++)
    unconv_tab[ii] = -1;

count = 0;
for (loc0 = 0; loc0 < 9; loc0++)
    for (loc1 = loc0 + 1; loc1 < 10; loc1++)
        for (loc2 = loc1 + 1; loc2 < 11; loc2++)
            for (loc3 = loc2 + 1; loc3 < 12; loc3++)
                {
                if (count >= N_ELOC)
                   exit_w_error_message("calc_edgeloc_conv : too many eloc's");
                conv_tab[count] = (1 << loc0) | (1 << loc1) |
                                  (1 << loc2) | (1 << loc3);
                unconv_tab[conv_tab[count]] = count;
                count++;
                }

if (count != N_ELOC)
   exit_w_error_message("calc_edgeloc_conv : wrong number of  eloc's");

return;
}


/* ========================================================================= */
   int  edgeloc_conv_or_unconv(int  eloc_conv_or_unconv, int  convert_flag)
/* ------------------------------------------------------------------------- */

{
static int              eloc_conv[N_ELOC];
static int              eloc_unconv[N_ELOC_CONV];
static int              initialized = 0;
int                     el_conv, el_unconv;


if (initialized == 0)
   {
   calc_edgeloc_conv(eloc_conv, eloc_unconv);
   initialized = 1;
   }

if (convert_flag)
   {
   if ((eloc_conv_or_unconv < 0) || (eloc_conv_or_unconv >= N_ELOC))
      exit_w_error_message("edgeloc_conv_or_unconv : invalid input");

   el_conv = eloc_conv[eloc_conv_or_unconv];

   if (el_conv < 0)
      exit_w_error_message("edgeloc_conv_or_unconv : corrupted data");

   return el_conv;
   }
else
   {
   if ((eloc_conv_or_unconv < 0) || (eloc_conv_or_unconv >= N_ELOC_CONV))
      exit_w_error_message("edgeloc_conv_or_unconv : invalid input");

   el_unconv = eloc_unconv[eloc_conv_or_unconv];

   if (el_unconv < 0)
      exit_w_error_message("edgeloc_conv_or_unconv : corrupted data");

   return el_unconv;
   }
}


/* ========================================================================= */
   int  edgeloc_conv(int  eloc_unconv)
/* ------------------------------------------------------------------------- */

{
return edgeloc_conv_or_unconv(eloc_unconv, 1);
}


/* ========================================================================= */
   int  edgeloc_unconv(int  eloc_conv)
/* ------------------------------------------------------------------------- */

{
return edgeloc_conv_or_unconv(eloc_conv, 0);
}


/* ========================================================================= */
   void  eloc_unpack(int  eloc, int  array_out[12])
/* ------------------------------------------------------------------------- */

/*  input:  eloc
   output:  array_out[]  */

{
int                     conv, ii;


conv = edgeloc_conv(eloc);

for (ii = 0; ii < 12; ii++)
    {
    array_out[ii] = conv % 2;
    conv = conv / 2;
    }

return;
}


/* ========================================================================= */
   int  eloc_pack(int  array_in[12])
/* ------------------------------------------------------------------------- */

{
int                     ii, conv;


conv = 0;
for (ii = 11; ii >= 0; ii--)
    conv = 2 * conv + array_in[ii];

return edgeloc_unconv(conv);
}


/* ========================================================================= */
   int  twist_f_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_FL, EDGE_DF, EDGE_FR, EDGE_UF);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_r_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_FR, EDGE_DR, EDGE_BR, EDGE_UR);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_u_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_UF, EDGE_UR, EDGE_UB, EDGE_UL);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_b_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_BR, EDGE_DB, EDGE_BL, EDGE_UB);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_l_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_BL, EDGE_DL, EDGE_FL, EDGE_UL);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_d_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_DF, EDGE_DL, EDGE_DB, EDGE_DR);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   void  calc_twist_on_eloc(int  table[N_TWIST][N_ELOC])
/* ------------------------------------------------------------------------- */

{
int                     edgeloc;


for (edgeloc = 0; edgeloc < N_ELOC; edgeloc++)
    {
    table[TWIST_F][edgeloc] = twist_f_on_eloc(edgeloc);
    table[TWIST_R][edgeloc] = twist_r_on_eloc(edgeloc);
    table[TWIST_U][edgeloc] = twist_u_on_eloc(edgeloc);
    table[TWIST_B][edgeloc] = twist_b_on_eloc(edgeloc);
    table[TWIST_L][edgeloc] = twist_l_on_eloc(edgeloc);
    table[TWIST_D][edgeloc] = twist_d_on_eloc(edgeloc);
    }

perm_n_compose(N_ELOC, table[TWIST_F], table[TWIST_F], table[TWIST_F2]);
perm_n_compose(N_ELOC, table[TWIST_R], table[TWIST_R], table[TWIST_R2]);
perm_n_compose(N_ELOC, table[TWIST_U], table[TWIST_U], table[TWIST_U2]);
perm_n_compose(N_ELOC, table[TWIST_B], table[TWIST_B], table[TWIST_B2]);
perm_n_compose(N_ELOC, table[TWIST_L], table[TWIST_L], table[TWIST_L2]);
perm_n_compose(N_ELOC, table[TWIST_D], table[TWIST_D], table[TWIST_D2]);

perm_n_compose(N_ELOC, table[TWIST_F2], table[TWIST_F], table[TWIST_F3]);
perm_n_compose(N_ELOC, table[TWIST_R2], table[TWIST_R], table[TWIST_R3]);
perm_n_compose(N_ELOC, table[TWIST_U2], table[TWIST_U], table[TWIST_U3]);
perm_n_compose(N_ELOC, table[TWIST_B2], table[TWIST_B], table[TWIST_B3]);
perm_n_compose(N_ELOC, table[TWIST_L2], table[TWIST_L], table[TWIST_L3]);
perm_n_compose(N_ELOC, table[TWIST_D2], table[TWIST_D], table[TWIST_D3]);

return;
}


/* ========================================================================= */
   int  sym_cu_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
four_cycle(temp_arr, EDGE_UF, EDGE_UR, EDGE_UB, EDGE_UL);
four_cycle(temp_arr, EDGE_DF, EDGE_DR, EDGE_DB, EDGE_DL);
four_cycle(temp_arr, EDGE_FR, EDGE_BR, EDGE_BL, EDGE_FL);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  sym_cf2_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
two_cycle(temp_arr, EDGE_UF, EDGE_DF);
two_cycle(temp_arr, EDGE_UR, EDGE_DL);
two_cycle(temp_arr, EDGE_UB, EDGE_DB);
two_cycle(temp_arr, EDGE_UL, EDGE_DR);
two_cycle(temp_arr, EDGE_FR, EDGE_FL);
two_cycle(temp_arr, EDGE_BR, EDGE_BL);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   int  sym_rud_on_eloc(int  eloc)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eloc_unpack(eloc, temp_arr);
two_cycle(temp_arr, EDGE_UF, EDGE_DF);
two_cycle(temp_arr, EDGE_UR, EDGE_DR);
two_cycle(temp_arr, EDGE_UB, EDGE_DB);
two_cycle(temp_arr, EDGE_UL, EDGE_DL);

return eloc_pack(temp_arr);
}


/* ========================================================================= */
   void  calc_sym_on_eloc(int  table[N_SYM][N_ELOC])
/* ------------------------------------------------------------------------- */

{
int                     edgeloc, sym;


perm_n_init(N_ELOC, table[0]);

for (edgeloc = 0; edgeloc < N_ELOC; edgeloc++)
    table[1][edgeloc] = sym_cu_on_eloc(edgeloc);

for (sym = 2; sym < 4; sym++)
    perm_n_compose(N_ELOC, table[1], table[sym - 1], table[sym]);

for (edgeloc = 0; edgeloc < N_ELOC; edgeloc++)
    table[4][edgeloc] = sym_cf2_on_eloc(edgeloc);

for (sym = 5; sym < 8; sym++)
    perm_n_compose(N_ELOC, table[4], table[sym - 4], table[sym]);

for (edgeloc = 0; edgeloc < N_ELOC; edgeloc++)
    table[8][edgeloc] = sym_rud_on_eloc(edgeloc);

for (sym = 9; sym < 16; sym++)
    perm_n_compose(N_ELOC, table[8], table[sym - 8], table[sym]);

return;
}


/* ========================================================================= */
   void  eflip_unpack(int  eflip, int  array_out[12])
/* ------------------------------------------------------------------------- */

{
int                     ii;


for (ii = 0; ii < 11; ii++)
    {
    array_out[ii] = eflip % 2;
    eflip = eflip / 2;
    }

array_out[11] = (array_out[0] + array_out[1] + array_out[2] + array_out[3] +
                 array_out[4] + array_out[5] + array_out[6] + array_out[7] +
                 array_out[8] + array_out[9] + array_out[10]) % 2;

return;
}


/* ========================================================================= */
   int  eflip_pack(int  array_in[12])
/* ------------------------------------------------------------------------- */

{
int                     eflip, ii;


eflip = 0;
for (ii = 10; ii >= 0; ii--)
    eflip = 2 * eflip + array_in[ii];

return eflip;
}


/* ========================================================================= */
   void  eflip_adjust(int  array[12], int  ind0, int  ind1, int  ind2,
                                                            int  ind3)
/* ------------------------------------------------------------------------- */

{
array[ind0] = 1 - array[ind0];
array[ind1] = 1 - array[ind1];
array[ind2] = 1 - array[ind2];
array[ind3] = 1 - array[ind3];

return;
}


/* ========================================================================= */
   int  twist_f_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
four_cycle(temp_arr, EDGE_FL, EDGE_DF, EDGE_FR, EDGE_UF);
eflip_adjust(temp_arr, EDGE_FL, EDGE_DF, EDGE_FR, EDGE_UF);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_r_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
four_cycle(temp_arr, EDGE_FR, EDGE_DR, EDGE_BR, EDGE_UR);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_u_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
four_cycle(temp_arr, EDGE_UR, EDGE_UB, EDGE_UL, EDGE_UF);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_b_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
four_cycle(temp_arr, EDGE_BR, EDGE_DB, EDGE_BL, EDGE_UB);
eflip_adjust(temp_arr, EDGE_BR, EDGE_DB, EDGE_BL, EDGE_UB);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_l_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
four_cycle(temp_arr, EDGE_BL, EDGE_DL, EDGE_FL, EDGE_UL);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_d_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
four_cycle(temp_arr, EDGE_DL, EDGE_DB, EDGE_DR, EDGE_DF);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   void  calc_twist_on_eflip(int  table[N_TWIST][N_EFLIP])
/* ------------------------------------------------------------------------- */

{
int                     edgeflip;


for (edgeflip = 0; edgeflip < N_EFLIP; edgeflip++)
    {
    table[TWIST_F][edgeflip] = twist_f_on_eflip(edgeflip);
    table[TWIST_R][edgeflip] = twist_r_on_eflip(edgeflip);
    table[TWIST_U][edgeflip] = twist_u_on_eflip(edgeflip);
    table[TWIST_B][edgeflip] = twist_b_on_eflip(edgeflip);
    table[TWIST_L][edgeflip] = twist_l_on_eflip(edgeflip);
    table[TWIST_D][edgeflip] = twist_d_on_eflip(edgeflip);
    }

perm_n_compose(N_EFLIP, table[TWIST_F], table[TWIST_F], table[TWIST_F2]);
perm_n_compose(N_EFLIP, table[TWIST_R], table[TWIST_R], table[TWIST_R2]);
perm_n_compose(N_EFLIP, table[TWIST_U], table[TWIST_U], table[TWIST_U2]);
perm_n_compose(N_EFLIP, table[TWIST_B], table[TWIST_B], table[TWIST_B2]);
perm_n_compose(N_EFLIP, table[TWIST_L], table[TWIST_L], table[TWIST_L2]);
perm_n_compose(N_EFLIP, table[TWIST_D], table[TWIST_D], table[TWIST_D2]);

perm_n_compose(N_EFLIP, table[TWIST_F2], table[TWIST_F], table[TWIST_F3]);
perm_n_compose(N_EFLIP, table[TWIST_R2], table[TWIST_R], table[TWIST_R3]);
perm_n_compose(N_EFLIP, table[TWIST_U2], table[TWIST_U], table[TWIST_U3]);
perm_n_compose(N_EFLIP, table[TWIST_B2], table[TWIST_B], table[TWIST_B3]);
perm_n_compose(N_EFLIP, table[TWIST_L2], table[TWIST_L], table[TWIST_L3]);
perm_n_compose(N_EFLIP, table[TWIST_D2], table[TWIST_D], table[TWIST_D3]);

return;
}


/* ========================================================================= */
   int  sym_cu2_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
two_cycle(temp_arr, EDGE_UF, EDGE_UB);
two_cycle(temp_arr, EDGE_UR, EDGE_UL);
two_cycle(temp_arr, EDGE_DF, EDGE_DB);
two_cycle(temp_arr, EDGE_DR, EDGE_DL);
two_cycle(temp_arr, EDGE_FR, EDGE_BL);
two_cycle(temp_arr, EDGE_FL, EDGE_BR);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  sym_cf2_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
two_cycle(temp_arr, EDGE_UF, EDGE_DF);
two_cycle(temp_arr, EDGE_UR, EDGE_DL);
two_cycle(temp_arr, EDGE_UB, EDGE_DB);
two_cycle(temp_arr, EDGE_UL, EDGE_DR);
two_cycle(temp_arr, EDGE_FR, EDGE_FL);
two_cycle(temp_arr, EDGE_BR, EDGE_BL);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   int  sym_rud_on_eflip(int  eflip)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


eflip_unpack(eflip, temp_arr);
two_cycle(temp_arr, EDGE_UF, EDGE_DF);
two_cycle(temp_arr, EDGE_UR, EDGE_DR);
two_cycle(temp_arr, EDGE_UB, EDGE_DB);
two_cycle(temp_arr, EDGE_UL, EDGE_DL);

return eflip_pack(temp_arr);
}


/* ========================================================================= */
   void  calc_sym_on_eflip(int  table[N_SYM / 2][N_EFLIP])
/* ------------------------------------------------------------------------- */

{
int                     edgeflip, sym;


perm_n_init(N_EFLIP, table[0]);

for (edgeflip = 0; edgeflip < N_EFLIP; edgeflip++)
    table[1][edgeflip] = sym_cu2_on_eflip(edgeflip);

for (edgeflip = 0; edgeflip < N_EFLIP; edgeflip++)
    table[2][edgeflip] = sym_cf2_on_eflip(edgeflip);

perm_n_compose(N_EFLIP, table[2], table[1], table[3]);

for (edgeflip = 0; edgeflip < N_EFLIP; edgeflip++)
    table[4][edgeflip] = sym_rud_on_eflip(edgeflip);

for (sym = 5; sym < 8; sym++)
    perm_n_compose(N_EFLIP, table[4], table[sym - 4], table[sym]);

return;
}


/* ========================================================================= */
   int  sym_cu_on_fulledge(int  fulledge)
/* ------------------------------------------------------------------------- */

{
int                     edgeloc_arr[12], edgeflip_arr[12], temp_arr[12], ii;


eloc_unpack(fulledge / N_EFLIP, edgeloc_arr);
eflip_unpack(fulledge % N_EFLIP, edgeflip_arr);

for (ii = 0; ii < 12; ii++)
    temp_arr[ii] = (edgeloc_arr[ii] != edgeflip_arr[ii]);

four_cycle(temp_arr, EDGE_UR, EDGE_UB, EDGE_UL, EDGE_UF);
four_cycle(temp_arr, EDGE_DR, EDGE_DB, EDGE_DL, EDGE_DF);
four_cycle(temp_arr, EDGE_BR, EDGE_BL, EDGE_FL, EDGE_FR);
eflip_adjust(temp_arr, EDGE_FR, EDGE_FL, EDGE_BR, EDGE_BL);

return sym_cu_on_eloc(fulledge / N_EFLIP) * N_EFLIP + eflip_pack(temp_arr);
}


/* ========================================================================= */
   void  init_fulledge_to_edgequot(int  sym_on_eloc[N_SYM][N_ELOC],
                                   int  sym_on_eflip[N_SYM / 2][N_EFLIP],
                                   int  edge_to_fulledge[N_EDGEQUOT],
                                   int  stabilizers[N_EDGEQUOT],
                                   int  multiplicities[N_EDGEQUOT])
/* ------------------------------------------------------------------------- */

{
int                     count, sym_count, fulledge, cu_fulledge, sym, min_sym;
int                     min_full, new_full, stab;


fulledge_to_edge =
                 (unsigned short *)malloc(sizeof(unsigned short [N_FULLEDGE]));
fulledge_to_sym = (unsigned char *)malloc(sizeof(unsigned char [N_FULLEDGE]));

if ((fulledge_to_edge == NULL) || (fulledge_to_sym == NULL))
   exit_w_error_message("init_fulledge_to_edgequot : couldn't get memory");

count = 0;

for (fulledge = 0; fulledge < N_FULLEDGE; fulledge++)
    {
    min_full = fulledge;
    min_sym = 0;
    stab = 0;
    sym_count = 0;
    cu_fulledge = sym_cu_on_fulledge(fulledge);

    for (sym = 0; sym < (N_SYM / 2); sym++)
        {
        new_full = sym_on_eloc[2 * sym][fulledge / N_EFLIP] * N_EFLIP +
                                         sym_on_eflip[sym][fulledge % N_EFLIP];
        if (min_full > new_full)
           {
           min_full = new_full;
           min_sym = 2 * sym;
           }
        else if (min_full == new_full)
           {
           stab |= (1 << (2 * sym));
           sym_count++;
           }

        new_full = sym_on_eloc[2 * sym][cu_fulledge / N_EFLIP] * N_EFLIP +
                                      sym_on_eflip[sym][cu_fulledge % N_EFLIP];
        if (min_full > new_full)
           {
           min_full = new_full;
           min_sym = 2 * sym + 1;
           }
        else if (min_full == new_full)
           {
           stab |= (1 << (2 * sym + 1));
           sym_count++;
           }
        }

    if (min_sym == 0)
       {
       if (count >= N_EDGEQUOT)
          exit_w_error_message(
                           "init_fulledge_to_edgequot : too many  edgequot's");
       edge_to_fulledge[count] = fulledge;
       stabilizers[count] = stab;
       multiplicities[count] = N_SYM / sym_count;
       fulledge_to_edge[fulledge] = (unsigned short)count;
       fulledge_to_sym[fulledge] = sym_x_invsym_to_sym[0][0];
       count++;
       }
    else
       {
       fulledge_to_edge[fulledge] = fulledge_to_edge[min_full];
       fulledge_to_sym[fulledge] = sym_x_invsym_to_sym[0][min_sym];
       }
    }

if (count != N_EDGEQUOT)
   exit_w_error_message(
                    "init_fulledge_to_edgequot : wrong number of  edgequot's");

return;
}


/* ========================================================================= */
   void  init_twist_on_edge(int  twist_on_eloc[N_TWIST][N_ELOC],
                            int  twist_on_eflip[N_TWIST][N_EFLIP],
                            int  edge_to_fulledge[N_EDGEQUOT])
/* ------------------------------------------------------------------------- */

{
int                     twist, edge, fulledge, new_edge;


/*  allocate and initialize global arrays         */
/*  twist_on_edge   and    twist_x_edge_to_sym    */

twist_on_edge[0] =
        (unsigned short *)malloc(sizeof(unsigned short [N_TWIST][N_EDGEQUOT]));
twist_x_edge_to_sym[0] =
          (unsigned char *)malloc(sizeof(unsigned char [N_TWIST][N_EDGEQUOT]));

if ((twist_on_edge[0] == NULL) || (twist_x_edge_to_sym[0] == NULL))
   exit_w_error_message("init_twist_on_edge : couldn't get memory");

for (twist = 1; twist < N_TWIST; twist++)
    {
    twist_on_edge[twist] = &twist_on_edge[0][twist * N_EDGEQUOT];
    twist_x_edge_to_sym[twist] = &twist_x_edge_to_sym[0][twist * N_EDGEQUOT];
    }

for (twist = 0; twist < N_TWIST; twist++)
    for (edge = 0; edge < N_EDGEQUOT; edge++)
        {
        fulledge = edge_to_fulledge[edge];
        new_edge = twist_on_eloc[twist][fulledge / N_EFLIP] * N_EFLIP +
                                   twist_on_eflip[twist][fulledge % N_EFLIP];
        twist_on_edge[twist][edge] = fulledge_to_edge[new_edge];
        twist_x_edge_to_sym[twist][edge] =
                        sym_x_invsym_to_sym[0][(int)fulledge_to_sym[new_edge]];
        }

return;
}


/* ========================================================================= */
   void  init_edge_quotient(int  stabilizers[N_EDGEQUOT],
                            int  multiplicities[N_EDGEQUOT])
/* ------------------------------------------------------------------------- */

{
int                     twist_on_eloc[N_TWIST][N_ELOC];
int                     twist_on_eflip[N_TWIST][N_EFLIP];
int                     sym_on_eloc[N_SYM][N_ELOC];
int                     sym_on_eflip[N_SYM / 2][N_EFLIP];
int                     edge_to_fulledge[N_EDGEQUOT];


calc_twist_on_eloc(twist_on_eloc);
calc_sym_on_eloc(sym_on_eloc);
calc_twist_on_eflip(twist_on_eflip);
calc_sym_on_eflip(sym_on_eflip);
init_fulledge_to_edgequot(sym_on_eloc, sym_on_eflip, edge_to_fulledge,
                                                  stabilizers, multiplicities);
init_twist_on_edge(twist_on_eloc, twist_on_eflip, edge_to_fulledge);

return;
}


/* ========================================================================= */
   void  cornerperm_unpack(int  cperm, int  array_out[8])
/* ------------------------------------------------------------------------- */

{
perm_n_unpack(8, cperm, array_out);

return;
}


/* ========================================================================= */
   int  cornerperm_pack(int  array_in[8])
/* ------------------------------------------------------------------------- */

{
return perm_n_pack(8, array_in);
}


/* ========================================================================= */
   int  twist_f_on_cperm(int  cperm)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


cornerperm_unpack(cperm, temp_arr);
four_cycle(temp_arr, CORNER_DFL, CORNER_DRF, CORNER_UFR, CORNER_ULF);

return cornerperm_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_r_on_cperm(int  cperm)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


cornerperm_unpack(cperm, temp_arr);
four_cycle(temp_arr, CORNER_DRF, CORNER_DBR, CORNER_URB, CORNER_UFR);

return cornerperm_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_u_on_cperm(int  cperm)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


cornerperm_unpack(cperm, temp_arr);
four_cycle(temp_arr, CORNER_URB, CORNER_UBL, CORNER_ULF, CORNER_UFR);

return cornerperm_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_b_on_cperm(int  cperm)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


cornerperm_unpack(cperm, temp_arr);
four_cycle(temp_arr, CORNER_DBR, CORNER_DLB, CORNER_UBL, CORNER_URB);

return cornerperm_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_l_on_cperm(int  cperm)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


cornerperm_unpack(cperm, temp_arr);
four_cycle(temp_arr, CORNER_DLB, CORNER_DFL, CORNER_ULF, CORNER_UBL);

return cornerperm_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_d_on_cperm(int  cperm)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[8];


cornerperm_unpack(cperm, temp_arr);
four_cycle(temp_arr, CORNER_DFL, CORNER_DLB, CORNER_DBR, CORNER_DRF);

return cornerperm_pack(temp_arr);
}


/* ========================================================================= */
   void  init_twist_on_cornerperm(void)
/* ------------------------------------------------------------------------- */

{
int                     cp, twist;


/*  allocate and initialize global array    twist_on_cornerperm    */

twist_on_cornerperm[0] =
      (unsigned short *)malloc(sizeof(unsigned short [N_TWIST][N_CORNERPERM]));
if (twist_on_cornerperm[0] == NULL)
   exit_w_error_message("init_twist_on_cornerperm : couldn't get memory");

for (twist = 1; twist < N_TWIST; twist++)
    twist_on_cornerperm[twist] = &twist_on_cornerperm[0][twist * N_CORNERPERM];

for (cp = 0; cp < N_CORNERPERM; cp++)
    {
    twist_on_cornerperm[TWIST_F][cp] = (unsigned short)twist_f_on_cperm(cp);
    twist_on_cornerperm[TWIST_R][cp] = (unsigned short)twist_r_on_cperm(cp);
    twist_on_cornerperm[TWIST_U][cp] = (unsigned short)twist_u_on_cperm(cp);
    twist_on_cornerperm[TWIST_B][cp] = (unsigned short)twist_b_on_cperm(cp);
    twist_on_cornerperm[TWIST_L][cp] = (unsigned short)twist_l_on_cperm(cp);
    twist_on_cornerperm[TWIST_D][cp] = (unsigned short)twist_d_on_cperm(cp);
    }
for (cp = 0; cp < N_CORNERPERM; cp++)
    {
    twist_on_cornerperm[TWIST_F2][cp] =
          twist_on_cornerperm[TWIST_F][(int)twist_on_cornerperm[TWIST_F][cp]];
    twist_on_cornerperm[TWIST_R2][cp] =
          twist_on_cornerperm[TWIST_R][(int)twist_on_cornerperm[TWIST_R][cp]];
    twist_on_cornerperm[TWIST_U2][cp] =
          twist_on_cornerperm[TWIST_U][(int)twist_on_cornerperm[TWIST_U][cp]];
    twist_on_cornerperm[TWIST_B2][cp] =
          twist_on_cornerperm[TWIST_B][(int)twist_on_cornerperm[TWIST_B][cp]];
    twist_on_cornerperm[TWIST_L2][cp] =
          twist_on_cornerperm[TWIST_L][(int)twist_on_cornerperm[TWIST_L][cp]];
    twist_on_cornerperm[TWIST_D2][cp] =
          twist_on_cornerperm[TWIST_D][(int)twist_on_cornerperm[TWIST_D][cp]];
    }
for (cp = 0; cp < N_CORNERPERM; cp++)
    {
    twist_on_cornerperm[TWIST_F3][cp] =
          twist_on_cornerperm[TWIST_F2][(int)twist_on_cornerperm[TWIST_F][cp]];
    twist_on_cornerperm[TWIST_R3][cp] =
          twist_on_cornerperm[TWIST_R2][(int)twist_on_cornerperm[TWIST_R][cp]];
    twist_on_cornerperm[TWIST_U3][cp] =
          twist_on_cornerperm[TWIST_U2][(int)twist_on_cornerperm[TWIST_U][cp]];
    twist_on_cornerperm[TWIST_B3][cp] =
          twist_on_cornerperm[TWIST_B2][(int)twist_on_cornerperm[TWIST_B][cp]];
    twist_on_cornerperm[TWIST_L3][cp] =
          twist_on_cornerperm[TWIST_L2][(int)twist_on_cornerperm[TWIST_L][cp]];
    twist_on_cornerperm[TWIST_D3][cp] =
          twist_on_cornerperm[TWIST_D2][(int)twist_on_cornerperm[TWIST_D][cp]];
    }

return;
}


/* ========================================================================= */
   void  sliceedge_unpack(int  sliceedge, int  array_out[12])
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[4], ii, count;


eloc_unpack(sliceedge % N_ELOC, array_out);
perm_n_unpack(4, sliceedge / N_ELOC, temp_arr);

count = 0;
for (ii = 0; ii < 12; ii++)
    if (array_out[ii] != 0)
       {
       if (count >= 4)
          exit_w_error_message("sliceedge_unpack : corrupted data");

       array_out[ii] = 1 + temp_arr[count++];
       }

return;
}


/* ========================================================================= */
   int  sliceedge_pack(int  array_in[12])
/* ------------------------------------------------------------------------- */

{
int                     eloc_arr[12], temp_arr[4], ii, count;


count = 0;
for (ii = 0; ii < 12; ii++)
    {
    if (array_in[ii] != 0)
       {
       if (count >= 4)
          exit_w_error_message("sliceedge_pack : invalid input");

       temp_arr[count++] = array_in[ii] - 1;
       }

    eloc_arr[ii] = (array_in[ii] != 0);
    }

return perm_n_pack(4, temp_arr) * N_ELOC + eloc_pack(eloc_arr);
}


/* ========================================================================= */
   int  twist_f_on_sliceedge(int  sliceedge)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


sliceedge_unpack(sliceedge, temp_arr);
four_cycle(temp_arr, EDGE_FL, EDGE_DF, EDGE_FR, EDGE_UF);

return sliceedge_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_r_on_sliceedge(int  sliceedge)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


sliceedge_unpack(sliceedge, temp_arr);
four_cycle(temp_arr, EDGE_FR, EDGE_DR, EDGE_BR, EDGE_UR);

return sliceedge_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_u_on_sliceedge(int  sliceedge)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


sliceedge_unpack(sliceedge, temp_arr);
four_cycle(temp_arr, EDGE_UR, EDGE_UB, EDGE_UL, EDGE_UF);

return sliceedge_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_b_on_sliceedge(int  sliceedge)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


sliceedge_unpack(sliceedge, temp_arr);
four_cycle(temp_arr, EDGE_BR, EDGE_DB, EDGE_BL, EDGE_UB);

return sliceedge_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_l_on_sliceedge(int  sliceedge)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


sliceedge_unpack(sliceedge, temp_arr);
four_cycle(temp_arr, EDGE_BL, EDGE_DL, EDGE_FL, EDGE_UL);

return sliceedge_pack(temp_arr);
}


/* ========================================================================= */
   int  twist_d_on_sliceedge(int  sliceedge)
/* ------------------------------------------------------------------------- */

{
int                     temp_arr[12];


sliceedge_unpack(sliceedge, temp_arr);
four_cycle(temp_arr, EDGE_DL, EDGE_DB, EDGE_DR, EDGE_DF);

return sliceedge_pack(temp_arr);
}


/* ========================================================================= */
   void  init_twist_on_sliceedge(void)
/* ------------------------------------------------------------------------- */

{
int                     twist, sl;


/*  allocate and initialize global array    twist_on_sliceedge    */

twist_on_sliceedge[0] =
     (unsigned short *)malloc(sizeof(unsigned short [N_TWIST][N_SLICEEDGE]));
if (twist_on_sliceedge[0] == NULL)
   exit_w_error_message("init_twist_on_sliceedge : couldn't get memory");

for (twist = 1; twist < N_TWIST; twist++)
    twist_on_sliceedge[twist] = &twist_on_sliceedge[0][twist * N_SLICEEDGE];

for (sl = 0; sl < N_SLICEEDGE; sl++)
    {
    twist_on_sliceedge[TWIST_F][sl] = (unsigned short)twist_f_on_sliceedge(sl);
    twist_on_sliceedge[TWIST_R][sl] = (unsigned short)twist_r_on_sliceedge(sl);
    twist_on_sliceedge[TWIST_U][sl] = (unsigned short)twist_u_on_sliceedge(sl);
    twist_on_sliceedge[TWIST_B][sl] = (unsigned short)twist_b_on_sliceedge(sl);
    twist_on_sliceedge[TWIST_L][sl] = (unsigned short)twist_l_on_sliceedge(sl);
    twist_on_sliceedge[TWIST_D][sl] = (unsigned short)twist_d_on_sliceedge(sl);
    }
for (sl = 0; sl < N_SLICEEDGE; sl++)
    {
    twist_on_sliceedge[TWIST_F2][sl] =
            twist_on_sliceedge[TWIST_F][(int)twist_on_sliceedge[TWIST_F][sl]];
    twist_on_sliceedge[TWIST_R2][sl] =
            twist_on_sliceedge[TWIST_R][(int)twist_on_sliceedge[TWIST_R][sl]];
    twist_on_sliceedge[TWIST_U2][sl] =
            twist_on_sliceedge[TWIST_U][(int)twist_on_sliceedge[TWIST_U][sl]];
    twist_on_sliceedge[TWIST_B2][sl] =
            twist_on_sliceedge[TWIST_B][(int)twist_on_sliceedge[TWIST_B][sl]];
    twist_on_sliceedge[TWIST_L2][sl] =
            twist_on_sliceedge[TWIST_L][(int)twist_on_sliceedge[TWIST_L][sl]];
    twist_on_sliceedge[TWIST_D2][sl] =
            twist_on_sliceedge[TWIST_D][(int)twist_on_sliceedge[TWIST_D][sl]];
    }
for (sl = 0; sl < N_SLICEEDGE; sl++)
    {
    twist_on_sliceedge[TWIST_F3][sl] =
            twist_on_sliceedge[TWIST_F2][(int)twist_on_sliceedge[TWIST_F][sl]];
    twist_on_sliceedge[TWIST_R3][sl] =
            twist_on_sliceedge[TWIST_R2][(int)twist_on_sliceedge[TWIST_R][sl]];
    twist_on_sliceedge[TWIST_U3][sl] =
            twist_on_sliceedge[TWIST_U2][(int)twist_on_sliceedge[TWIST_U][sl]];
    twist_on_sliceedge[TWIST_B3][sl] =
            twist_on_sliceedge[TWIST_B2][(int)twist_on_sliceedge[TWIST_B][sl]];
    twist_on_sliceedge[TWIST_L3][sl] =
            twist_on_sliceedge[TWIST_L2][(int)twist_on_sliceedge[TWIST_L][sl]];
    twist_on_sliceedge[TWIST_D3][sl] =
            twist_on_sliceedge[TWIST_D2][(int)twist_on_sliceedge[TWIST_D][sl]];
    }

return;
}


/* ========================================================================= */
   int  make_current(int  corner, int  edge, Search_data  *p_data)
/* ------------------------------------------------------------------------- */

{
if (DIST(corner, edge) > p_data->depth)
   {
   if (edge & 0x1)
      {
      distance[corner][edge >> 1] &= 0x0F;
      distance[corner][edge >> 1] |= (unsigned char)((p_data->depth) << 4);
      }
   else
      {
      distance[corner][edge >> 1] &= 0xF0;
      distance[corner][edge >> 1] |= (unsigned char)(p_data->depth);
      }

   p_data->found_quot++;
   p_data->found += (p_data->multiplicities)[edge];

   return 1;
   }

return 0;
}


/* ========================================================================= */
   void  make_current_all(int  corner, int  edge, Search_data  *p_data)
/* ------------------------------------------------------------------------- */

{
int                     sym, stab;


if (make_current(corner, edge, p_data))
   {
   stab = (p_data->stabilizers)[edge];
   for (sym = 1; sym < N_SYM; sym++)
       {
       stab /= 2;

       if (stab % 2)
          make_current((int)sym_on_corner[sym][corner], edge, p_data);
       }
   }

return;
}


/* ========================================================================= */
   void  make_neighbors_current(int  corner, int  edge, Search_data  *p_data)
/* ------------------------------------------------------------------------- */

{
int                     twist, new_edge, new_corner, sym;


for (twist = 0; twist < N_TWIST; twist++)
    {
    if (p_current_metric->twist_length[twist] != 1)
       continue;

    new_edge = (int)twist_on_edge[twist][edge];
    sym = (int)twist_x_edge_to_sym[twist][edge];
    new_corner = (int)sym_on_corner[sym][(int)twist_on_corner[twist][corner]];
    make_current_all(new_corner, new_edge, p_data);
    }

return;
}


/* ========================================================================= */
   int  neighbors_are_previous(int  corner, int  edge, Search_data  *p_data)
/* ------------------------------------------------------------------------- */

{
int                     twist, new_edge, sym, new_corner;


for (twist = 0; twist < N_TWIST; twist++)
    {
    if (p_current_metric->twist_length[twist] != 1)
       continue;

    new_edge = (int)twist_on_edge[twist][edge];
    sym = (int)twist_x_edge_to_sym[twist][edge];
    new_corner = (int)sym_on_corner[sym][(int)twist_on_corner[twist][corner]];

    if (DIST(new_corner, new_edge) < p_data->depth)
       return 1;
    }

return 0;
}


/* ========================================================================= */
   void  init_distance_table(int  edge_stabilizers[N_EDGEQUOT],
                             int  edge_multiplicities[N_EDGEQUOT])
/* ------------------------------------------------------------------------- */

{
Search_data             sdata_struc;
int                     total_found_quot, corner, edge, ii, msg_given;


/*  allocate and initialize global array   distance   */

distance[0] = (unsigned char *)malloc(sizeof(unsigned char [N_DIST_CHARS]));
if (distance[0] == NULL)
   exit_w_error_message("init_distance_table : couldn't get memory");

for (corner = 1; corner < N_CORNER; corner++)
    distance[corner] = &distance[0][corner * (N_EDGEQUOT / 2)];

for (ii = 0; ii < N_DIST_CHARS; ii++)
    distance[0][ii] = (unsigned char)255;

msg_given = 0;

sdata_struc.depth = 0;
sdata_struc.found_quot = 0;
sdata_struc.found = 0;
sdata_struc.stabilizers = edge_stabilizers;
sdata_struc.multiplicities = edge_multiplicities;
total_found_quot = 0;

printf("distance     positions     (quotient)\n");

make_current_all(CORNER_START, EDGE_START, &sdata_struc);

while (sdata_struc.found)
      {
      printf("%7d%c %13d     (%8d)\n", sdata_struc.depth,
                      p_current_metric->metric_char, sdata_struc.found,
                                                       sdata_struc.found_quot);
      total_found_quot += sdata_struc.found_quot;
      sdata_struc.found_quot = 0;
      sdata_struc.found = 0;

      if (++(sdata_struc.depth) == 15)
         break;                            /*  shouldn't happen  */

      if (total_found_quot == 2 * N_DIST_CHARS)
         break;

      if (total_found_quot < BACKWARDS_SWITCH_POINT)  /*  search forward  */
         {
         for (corner = 0; corner < N_CORNER; corner++)
             for (edge = 0; edge < N_EDGEQUOT; edge++)
                 if (DIST(corner, edge) == sdata_struc.depth - 1)
                    make_neighbors_current(corner, edge, &sdata_struc);
         }
      else  /*  search backward  */
         {
         if (msg_given == 0)
            {
            printf("     switching to backwards searching\n");
            msg_given = 1;
            }

         for (corner = 0; corner < N_CORNER; corner++)
             for (edge = 0; edge < N_EDGEQUOT; edge++)
                 if ((DIST(corner, edge) == 15) &&
                     neighbors_are_previous(corner, edge, &sdata_struc))
                    make_current_all(corner, edge, &sdata_struc);
         }
      }

return;
}


/* ========================================================================= */
   void  init_globals(void)
/* ------------------------------------------------------------------------- */

{
int                    *edge_stabilizers;
int                    *edge_multiplicities;


printf("initializing transformation tables\n");
init_sym_x_invsym_to_sym();
init_invsym_on_twist();
init_twist_on_follow();
init_twist_on_corner();
init_sym_on_corner();

edge_stabilizers = (int *)malloc(sizeof(int [2 * N_EDGEQUOT]));
if (edge_stabilizers == NULL)
   exit_w_error_message("init_globals : couldn't get memory");

edge_multiplicities = &edge_stabilizers[N_EDGEQUOT];

init_edge_quotient(edge_stabilizers, edge_multiplicities);
init_twist_on_cornerperm();
init_twist_on_sliceedge();
printf("initializing distance table ... this will take several minutes\n");
init_distance_table(edge_stabilizers, edge_multiplicities);

free((void *)edge_stabilizers);

return;
}


/* ========================================================================= */
   int  string_to_cube(char  string[], Cube  *p_cube, int  give_err_msg)
/* ------------------------------------------------------------------------- */

/*  input:  string[]  */

{
char                    edge_str[12][3], corner_str[8][4];
int                     edge_arr[12], corner_arr[8];
int                     ii, jj, twist, flip, edge_par, corner_par, stat;


stat = 0;

if (sscanf(string, "%2s %2s %2s %2s %2s %2s %2s %2s %2s %2s %2s %2s %3s %3s %3s %3s %3s %3s %3s %3s",
           edge_str[0], edge_str[1], edge_str[2], edge_str[3],
           edge_str[4], edge_str[5], edge_str[6], edge_str[7],
           edge_str[8], edge_str[9], edge_str[10], edge_str[11],
           corner_str[0], corner_str[1], corner_str[2], corner_str[3],
           corner_str[4], corner_str[5], corner_str[6], corner_str[7]) < 20)
   {
   if (give_err_msg)
      printf("invalid input!\n");
   return 1;
   }

for (ii = 0; ii < 12; ii++)
    {
    for (jj = 0; jj < 24; jj++)
        if (strcmp(edge_str[ii], edge_cubie_str[jj]) == 0)
           {
           p_cube->edges[ii] = jj;
           break;
           }
    if (jj == 24)
       {
       if (give_err_msg)
          printf("invalid edge cubie: %s\n", edge_str[ii]);
       stat = 1;
       }
    }

for (ii = 0; ii < 8; ii++)
    {
    for (jj = 0; jj < 24; jj++)
        if (strcmp(corner_str[ii], corner_cubie_str[jj]) == 0)
           {
           p_cube->corners[ii] = jj;
           break;
           }
    if (jj == 24)
       {
       if (give_err_msg)
          printf("invalid corner cubie: %s\n", corner_str[ii]);
       stat = 1;
       }
    }

if (stat)
   return stat;

/*  fill out the remaining oriented edges and corners  */

for (ii = 12; ii < 24; ii++)
    p_cube->edges[ii] = (12 + p_cube->edges[ii - 12]) % 24;

for (ii = 8; ii < 24; ii++)
    p_cube->corners[ii] = (8 + p_cube->corners[ii - 8]) % 24;

/*  now check to see that it's a legal cube  */

if (perm_n_check(24, p_cube->edges))
   {
   if (give_err_msg)
      printf("bad edge cubies\n");
   stat = 1;
   }

if (perm_n_check(24, p_cube->corners))
   {
   if (give_err_msg)
      printf("bad corner cubies\n");
   stat = 1;
   }

if (stat)
   return stat;

flip = 0;
for (ii = 0; ii < 12; ii++)
    flip += (p_cube->edges[ii] / 12);

if ((flip % 2) != 0)
   {
   if (give_err_msg)
      printf("flip any edge cubie!\n");
   stat = 1;
   }

twist = 0;
for (ii = 0; ii < 8; ii++)
    twist += (p_cube->corners[ii] / 8);

twist %= 3;

if (twist != 0)
   {
   if (give_err_msg)
      printf("twist any corner cubie %sclockwise!\n",
              (twist == 1) ? "counter" : "");
   stat = 1;
   }

for (ii = 0; ii < 12; ii++)
    edge_arr[ii] = p_cube->edges[ii] % 12;

edge_par = perm_n_parity(12, edge_arr);

for (ii = 0; ii < 8; ii++)
    corner_arr[ii] = p_cube->corners[ii] % 8;

corner_par = perm_n_parity(8, corner_arr);

if (edge_par != corner_par)
   {
   if (give_err_msg)
      printf("swap any two edge cubies or any two corner cubies!\n");
   stat = 1;
   }

return stat;
}


/* ========================================================================= */
   int  user_enters_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
char                     line_str[256];


printf("\nenter cube (Ctrl-D to exit):\n");

line_str[0] = '\n';

while (line_str[0] == '\n')           /*  ignore blank lines  */
      {
      if (fgets(line_str, 256, stdin) == NULL)
         return -1;

      if (line_str[0] == '%')         /*  echo comments  */
         {
         printf("%s", line_str);
         line_str[0] = '\n';
         }
      }

return string_to_cube(line_str, p_cube, 1);
}


/* ========================================================================= */
   void  calc_cube_urf(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
cube_init(p_cube);
three_cycle(p_cube->edges, EDGE_UF, EDGE_FR, EDGE_RU);
three_cycle(p_cube->edges, EDGE_UB, EDGE_FL, EDGE_RD);
three_cycle(p_cube->edges, EDGE_DB, EDGE_BL, EDGE_LD);
three_cycle(p_cube->edges, EDGE_DF, EDGE_BR, EDGE_LU);
three_cycle(p_cube->edges, EDGE_FU, EDGE_RF, EDGE_UR);
three_cycle(p_cube->edges, EDGE_BU, EDGE_LF, EDGE_DR);
three_cycle(p_cube->edges, EDGE_BD, EDGE_LB, EDGE_DL);
three_cycle(p_cube->edges, EDGE_FD, EDGE_RB, EDGE_UL);
three_cycle(p_cube->corners, CORNER_UFR, CORNER_FRU, CORNER_RUF);
three_cycle(p_cube->corners, CORNER_DLB, CORNER_BDL, CORNER_LBD);
three_cycle(p_cube->corners, CORNER_URB, CORNER_FUL, CORNER_RFD);
three_cycle(p_cube->corners, CORNER_UBL, CORNER_FLD, CORNER_RDB);
three_cycle(p_cube->corners, CORNER_RBU, CORNER_ULF, CORNER_FDR);
three_cycle(p_cube->corners, CORNER_BLU, CORNER_LDF, CORNER_DBR);
three_cycle(p_cube->corners, CORNER_BUR, CORNER_LFU, CORNER_DRF);
three_cycle(p_cube->corners, CORNER_LUB, CORNER_DFL, CORNER_BRD);

return;
}


/* ========================================================================= */
   void  cube_to_coset_coord(Cube  *p_cube, Coset_coord  *p_coset_coord)
/* ------------------------------------------------------------------------- */

/*  output:  *p_coset_coord  */

{
int                     corner_arr[8], edge_arr[12];
int                     ii, eflip, eloc, sym, corner;


for (ii = 0; ii < 12; ii++)
    edge_arr[ii] = p_cube->edges[ii] / 12;
eflip = eflip_pack(edge_arr);

for (ii = 0; ii < 12; ii++)
    edge_arr[ii] = (p_cube->edges[ii] % 12) / 8;
eloc = eloc_pack(edge_arr);

p_coset_coord->edge_state = (int)fulledge_to_edge[eloc * N_EFLIP + eflip];
p_coset_coord->sym_state = sym = (int)fulledge_to_sym[eloc * N_EFLIP + eflip];

for (ii = 0; ii < 8; ii++)
    corner_arr[ii] = p_cube->corners[ii] / 8;

corner = corner_pack(corner_arr);
p_coset_coord->corner_state =
                  (int)sym_on_corner[(int)sym_x_invsym_to_sym[0][sym]][corner];

return;
}


/* ========================================================================= */
   void  process_full_cube(Full_cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
Cube                    cube1, cube2, cube_urf;
int                     edges_to_ud[12], edges_to_rl[12], edges_to_fb[12];
int                     cornerperm_arr[8], sliceedge_arr[12], ii;


/*  p_cube->cubies  already filled in  */
/*  fill in other fields of  p_cube    */

for (ii = 0; ii < 8; ii++)
    cornerperm_arr[ii] = p_cube->cubies.corners[ii] % 8;

p_cube->cornerperm = cornerperm_pack(cornerperm_arr);
p_cube->parity = perm_n_parity(8, cornerperm_arr);


for (ii = 0; ii < 12; ii++)
    edges_to_ud[ii] = edges_to_fb[ii] = edges_to_rl[ii] = 0;

edges_to_ud[EDGE_FR] = 1;
edges_to_ud[EDGE_FL] = 2;
edges_to_ud[EDGE_BR] = 3;
edges_to_ud[EDGE_BL] = 4;

edges_to_rl[EDGE_UF] = 1;
edges_to_rl[EDGE_UB] = 2;
edges_to_rl[EDGE_DF] = 3;
edges_to_rl[EDGE_DB] = 4;

edges_to_fb[EDGE_UR] = 1;
edges_to_fb[EDGE_UL] = 2;
edges_to_fb[EDGE_DR] = 3;
edges_to_fb[EDGE_DL] = 4;


for (ii = 0; ii < 12; ii++)
    sliceedge_arr[ii] = edges_to_ud[(p_cube->cubies.edges[ii]) % 12];
p_cube->ud_sliceedge = sliceedge_pack(sliceedge_arr);

for (ii = 0; ii < 12; ii++)
    sliceedge_arr[ii] = edges_to_fb[(p_cube->cubies.edges[ii]) % 12];
p_cube->fb_sliceedge = sliceedge_pack(sliceedge_arr);

for (ii = 0; ii < 12; ii++)
    sliceedge_arr[ii] = edges_to_rl[(p_cube->cubies.edges[ii]) % 12];
p_cube->rl_sliceedge = sliceedge_pack(sliceedge_arr);


cube_to_coset_coord(&p_cube->cubies, &p_cube->ud);

calc_cube_urf(&cube_urf);

cube_conjugate(&p_cube->cubies, &cube_urf, &cube1);
cube_to_coset_coord(&cube1, &p_cube->rl);

cube_conjugate(&cube1, &cube_urf, &cube2);
cube_to_coset_coord(&cube2, &p_cube->fb);

return;
}


/* ========================================================================= */
   void  set_cube_symmetry(Full_cube  *p_cube, Cube  sym_cubes[N_CUBESYM],
                           int  subgroup_list[N_SYMSUBGRP][N_CUBESYM])
/* ------------------------------------------------------------------------- */

{
Cube                    temp_cube;
int                     subgroup[N_CUBESYM], sym, count;


if (p_current_options->use_symmetry)
   {
   count = 0;

   for (sym = 0; sym < N_CUBESYM; sym++)
       {
       cube_conjugate(&p_cube->cubies, &sym_cubes[sym], &temp_cube);
       subgroup[sym] = (cube_compare(&p_cube->cubies, &temp_cube) == 0);
       if (subgroup[sym])
          count++;
       }

   p_cube->sym_subgrp = which_subgroup(subgroup, subgroup_list);

   if (p_cube->sym_subgrp < 0)
      exit_w_error_message("set_cube_symmetry : unknown symmetry group");

   if (count > 1)
      printf("position has %d-fold symmetry (subgroup #%d)\n", count,
                                                           p_cube->sym_subgrp);
   else
      printf("asymmetric position\n");
   }
else
   p_cube->sym_subgrp = SUBGRP_TRIVIAL;

return;
}


/* ========================================================================= */
   void  output_solution(Search_node  *node_arr)
/* ------------------------------------------------------------------------- */

{
static char            *twist_string[] = {"F ", "F2", "F'", "R ", "R2", "R'",
                                          "U ", "U2", "U'", "B ", "B2", "B'",
                                          "L ", "L2", "L'", "D ", "D2", "D'"};
Search_node            *p_node;
int                     turn_list[MAX_TWISTS];
int                     ii, count, q_length, f_length;


count = 0;

for (p_node = node_arr; p_node->remain_depth > 0; p_node++)
    turn_list[count++] = p_node[1].twist;

q_length = f_length = 0;

for (ii = 0; ii < count; ii++)
    {
    q_length += metric_q_length(turn_list[ii]);
    f_length += metric_f_length(turn_list[ii]);
    }

for (ii = 0; ii < count; ii++)
    printf(" %s", twist_string[turn_list[ii]]);

if (p_current_metric->metric == QUARTER_TURN_METRIC)
   printf("  (%dq*, %df)\n", q_length, f_length);
else
   printf("  (%df*, %dq)\n", f_length, q_length);
fflush(stdout);

sol_found = 1;

return;
}


/* ========================================================================= */
   int  test_for_solution(Full_cube  *p_cube, Search_node  *node_arr)
/* ------------------------------------------------------------------------- */

{
register Search_node   *p_node;
register int            cornerperm, sliceedge;


n_tests++;

cornerperm = p_cube->cornerperm;
for (p_node = node_arr; p_node->remain_depth > 0; p_node++)
    cornerperm = (int)twist_on_cornerperm[p_node[1].twist][cornerperm];

if (cornerperm != CORNERPERM_START)
   return 0;                                  /*  not a solution  */

sliceedge = p_cube->ud_sliceedge;
for (p_node = node_arr; p_node->remain_depth > 0; p_node++)
    sliceedge = (int)twist_on_sliceedge[p_node[1].twist][sliceedge];

if (sliceedge != UD_SLICEEDGE_START)
   return 0;                                  /*  not a solution  */

sliceedge = p_cube->rl_sliceedge;
for (p_node = node_arr; p_node->remain_depth > 0; p_node++)
    sliceedge = (int)twist_on_sliceedge[p_node[1].twist][sliceedge];

if (sliceedge != RL_SLICEEDGE_START)
   return 0;                                  /*  not a solution  */

sliceedge = p_cube->fb_sliceedge;
for (p_node = node_arr; p_node->remain_depth > 0; p_node++)
    sliceedge = (int)twist_on_sliceedge[p_node[1].twist][sliceedge];

if (sliceedge != FB_SLICEEDGE_START)
   return 0;                                  /*  not a solution  */

output_solution(node_arr);                    /*  solution !  */

return 1;
}


/* ========================================================================= */
   void  search_tree(Full_cube  *p_cube, Search_node  *node_arr)
/* ------------------------------------------------------------------------- */

{
register Search_node   *p_node;
register int            twist, virtual_twist, new_sym_factor;


p_node = node_arr;

while (p_node >= node_arr)
      {
      if (p_node->remain_depth == 0)
         {
         if (test_for_solution(p_cube, node_arr) &&
             p_current_options->one_solution_only)
            return;
         p_node--;
         }
      else
         {
         for (twist = p_node[1].twist + 1; twist < N_TWIST; twist++)
             {
             p_node[1].follow_type =
                              (int)twist_on_follow[twist][p_node->follow_type];

             if (p_node[1].follow_type == FOLLOW_INVALID)
                continue;

             p_node[1].remain_depth = p_node->remain_depth -
                                         p_current_metric->twist_length[twist];
             if (p_node[1].remain_depth < 0)
                continue;

             n_nodes++;

             virtual_twist =
                          (int)invsym_on_twist_ud[p_node->ud.sym_state][twist];
             new_sym_factor =
                (int)twist_x_edge_to_sym[virtual_twist][p_node->ud.edge_state];
             p_node[1].ud.edge_state =
                      (int)twist_on_edge[virtual_twist][p_node->ud.edge_state];
             p_node[1].ud.sym_state =
                (int)sym_x_invsym_to_sym[p_node->ud.sym_state][new_sym_factor];
             p_node[1].ud.corner_state = (int)sym_on_corner[new_sym_factor]
                [(int)twist_on_corner[virtual_twist][p_node->ud.corner_state]];

             if (p_node[1].remain_depth <
                      DIST(p_node[1].ud.corner_state, p_node[1].ud.edge_state))
                continue;


             virtual_twist =
                          (int)invsym_on_twist_rl[p_node->rl.sym_state][twist];
             new_sym_factor =
                (int)twist_x_edge_to_sym[virtual_twist][p_node->rl.edge_state];
             p_node[1].rl.edge_state =
                      (int)twist_on_edge[virtual_twist][p_node->rl.edge_state];
             p_node[1].rl.sym_state =
                (int)sym_x_invsym_to_sym[p_node->rl.sym_state][new_sym_factor];
             p_node[1].rl.corner_state = (int)sym_on_corner[new_sym_factor]
                [(int)twist_on_corner[virtual_twist][p_node->rl.corner_state]];

             if (p_node[1].remain_depth <
                      DIST(p_node[1].rl.corner_state, p_node[1].rl.edge_state))
                continue;


             virtual_twist =
                          (int)invsym_on_twist_fb[p_node->fb.sym_state][twist];
             new_sym_factor =
                (int)twist_x_edge_to_sym[virtual_twist][p_node->fb.edge_state];
             p_node[1].fb.edge_state =
                      (int)twist_on_edge[virtual_twist][p_node->fb.edge_state];
             p_node[1].fb.sym_state =
                (int)sym_x_invsym_to_sym[p_node->fb.sym_state][new_sym_factor];
             p_node[1].fb.corner_state = (int)sym_on_corner[new_sym_factor]
                [(int)twist_on_corner[virtual_twist][p_node->fb.corner_state]];

             if (p_node[1].remain_depth <
                      DIST(p_node[1].fb.corner_state, p_node[1].fb.edge_state))
                continue;


             p_node[1].twist = twist;
             break;
             }

         if (twist == N_TWIST)
            p_node--;
         else
            {
            p_node++;
            p_node[1].twist = -1;
            }
         }
      }

return;
}


/* ========================================================================= */
   void  calc_sym_cubes(Cube  sym_conj[N_CUBESYM])
/* ------------------------------------------------------------------------- */

{
int                     ii;


cube_init(&sym_conj[0]);
cube_init(&sym_conj[1]);

four_cycle(sym_conj[1].edges, EDGE_UF, EDGE_UL, EDGE_UB, EDGE_UR);
four_cycle(sym_conj[1].edges, EDGE_DF, EDGE_DL, EDGE_DB, EDGE_DR);
four_cycle(sym_conj[1].edges, EDGE_FR, EDGE_LF, EDGE_BL, EDGE_RB);
four_cycle(sym_conj[1].edges, EDGE_FU, EDGE_LU, EDGE_BU, EDGE_RU);
four_cycle(sym_conj[1].edges, EDGE_FD, EDGE_LD, EDGE_BD, EDGE_RD);
four_cycle(sym_conj[1].edges, EDGE_RF, EDGE_FL, EDGE_LB, EDGE_BR);
four_cycle(sym_conj[1].corners, CORNER_UFR, CORNER_ULF, CORNER_UBL, CORNER_URB);
four_cycle(sym_conj[1].corners, CORNER_DRF, CORNER_DFL, CORNER_DLB, CORNER_DBR);
four_cycle(sym_conj[1].corners, CORNER_FRU, CORNER_LFU, CORNER_BLU, CORNER_RBU);
four_cycle(sym_conj[1].corners, CORNER_RFD, CORNER_FLD, CORNER_LBD, CORNER_BRD);
four_cycle(sym_conj[1].corners, CORNER_RUF, CORNER_FUL, CORNER_LUB, CORNER_BUR);
four_cycle(sym_conj[1].corners, CORNER_FDR, CORNER_LDF, CORNER_BDL, CORNER_RDB);

for (ii = 2; ii < 4; ii++)
    cube_compose(&sym_conj[1], &sym_conj[ii - 1], &sym_conj[ii]);

cube_init(&sym_conj[4]);

two_cycle(sym_conj[4].edges, EDGE_UF, EDGE_DF);
two_cycle(sym_conj[4].edges, EDGE_UR, EDGE_DL);
two_cycle(sym_conj[4].edges, EDGE_UB, EDGE_DB);
two_cycle(sym_conj[4].edges, EDGE_UL, EDGE_DR);
two_cycle(sym_conj[4].edges, EDGE_FR, EDGE_FL);
two_cycle(sym_conj[4].edges, EDGE_BR, EDGE_BL);
two_cycle(sym_conj[4].edges, EDGE_FU, EDGE_FD);
two_cycle(sym_conj[4].edges, EDGE_RU, EDGE_LD);
two_cycle(sym_conj[4].edges, EDGE_BU, EDGE_BD);
two_cycle(sym_conj[4].edges, EDGE_LU, EDGE_RD);
two_cycle(sym_conj[4].edges, EDGE_RF, EDGE_LF);
two_cycle(sym_conj[4].edges, EDGE_RB, EDGE_LB);
two_cycle(sym_conj[4].corners, CORNER_UFR, CORNER_DFL);
two_cycle(sym_conj[4].corners, CORNER_ULF, CORNER_DRF);
two_cycle(sym_conj[4].corners, CORNER_UBL, CORNER_DBR);
two_cycle(sym_conj[4].corners, CORNER_URB, CORNER_DLB);
two_cycle(sym_conj[4].corners, CORNER_FRU, CORNER_FLD);
two_cycle(sym_conj[4].corners, CORNER_LFU, CORNER_RFD);
two_cycle(sym_conj[4].corners, CORNER_BLU, CORNER_BRD);
two_cycle(sym_conj[4].corners, CORNER_RBU, CORNER_LBD);
two_cycle(sym_conj[4].corners, CORNER_RUF, CORNER_LDF);
two_cycle(sym_conj[4].corners, CORNER_FUL, CORNER_FDR);
two_cycle(sym_conj[4].corners, CORNER_LUB, CORNER_RDB);
two_cycle(sym_conj[4].corners, CORNER_BUR, CORNER_BDL);

for (ii = 5; ii < 8; ii++)
    cube_compose(&sym_conj[4], &sym_conj[ii - 4], &sym_conj[ii]);

cube_init(&sym_conj[8]);

two_cycle(sym_conj[8].edges, EDGE_UF, EDGE_DF);
two_cycle(sym_conj[8].edges, EDGE_UR, EDGE_DR);
two_cycle(sym_conj[8].edges, EDGE_UB, EDGE_DB);
two_cycle(sym_conj[8].edges, EDGE_UL, EDGE_DL);
two_cycle(sym_conj[8].edges, EDGE_FU, EDGE_FD);
two_cycle(sym_conj[8].edges, EDGE_RU, EDGE_RD);
two_cycle(sym_conj[8].edges, EDGE_BU, EDGE_BD);
two_cycle(sym_conj[8].edges, EDGE_LU, EDGE_LD);
two_cycle(sym_conj[8].corners, CORNER_UFR, CORNER_DRF);
two_cycle(sym_conj[8].corners, CORNER_ULF, CORNER_DFL);
two_cycle(sym_conj[8].corners, CORNER_UBL, CORNER_DLB);
two_cycle(sym_conj[8].corners, CORNER_URB, CORNER_DBR);
two_cycle(sym_conj[8].corners, CORNER_FRU, CORNER_FDR);
two_cycle(sym_conj[8].corners, CORNER_LFU, CORNER_LDF);
two_cycle(sym_conj[8].corners, CORNER_BLU, CORNER_BDL);
two_cycle(sym_conj[8].corners, CORNER_RBU, CORNER_RDB);
two_cycle(sym_conj[8].corners, CORNER_RUF, CORNER_RFD);
two_cycle(sym_conj[8].corners, CORNER_FUL, CORNER_FLD);
two_cycle(sym_conj[8].corners, CORNER_LUB, CORNER_LBD);
two_cycle(sym_conj[8].corners, CORNER_BUR, CORNER_BRD);

for (ii = 9; ii < 16; ii++)
    cube_compose(&sym_conj[8], &sym_conj[ii - 8], &sym_conj[ii]);

calc_cube_urf(&sym_conj[16]);

for (ii = 17; ii < 48; ii++)
    cube_compose(&sym_conj[16], &sym_conj[ii - 16], &sym_conj[ii]);

return;
}


/* ========================================================================= */
   void  pretty_print_unsigned_int(unsigned int  nn)
/* ------------------------------------------------------------------------- */

{
int                     digits[4], ii, started;


for (ii = 0; ii < 4; ii++)
    {
    digits[ii] = nn % 1000;
    nn /= 1000;
    }

started = 0;

for (ii = 3; ii >= 0; ii--)
    {
    if (started)
       {
       if (digits[ii] >= 100)
          printf("%3d", digits[ii]);
       else if (digits[ii] >= 10)
               printf("0%2d", digits[ii]);
       else
          printf("00%1d", digits[ii]);
       }
    else
       {
       if (digits[ii] >= 100)
          {
          printf("%3d", digits[ii]);
          started = 1;
          }
       else if (digits[ii] >= 10)
               {
               printf(" %2d", digits[ii]);
               started = 1;
               }
       else if ((digits[ii] >= 1) || (ii == 0))
               {
               printf("  %1d", digits[ii]);
               started = 1;
               }
       else
          printf("   ");
       }

    if (ii > 0)
       printf("%c", started ? ',' : ' ');
    }

return;
}


/* ========================================================================= */
   void  solve_cube(Cube  *p_cube)
/* ------------------------------------------------------------------------- */

{
static Cube             sym_cubes[N_CUBESYM];
static int              subgroup_list[N_SYMSUBGRP][N_CUBESYM];
static int              initialized = 0;
Full_cube               full_cube_struct;
Search_node             node_arr[MAX_TWISTS];
int                     ii, start_depth, search_limit;


if (initialized == 0)
   {
   calc_sym_cubes(sym_cubes);
   calc_subgroup_list(subgroup_list);
   initialized = 1;
   }

print_cube(p_cube);
if (cube_is_solved(p_cube))
   {
   printf("cube is already solved!\n");
   return;
   }

cube_conjugate(p_cube, &sym_cubes[0], &full_cube_struct.cubies);
process_full_cube(&full_cube_struct);

set_cube_symmetry(&full_cube_struct, sym_cubes, subgroup_list);

node_arr[0].follow_type = 1 + full_cube_struct.sym_subgrp;
node_arr[0].ud.corner_state = full_cube_struct.ud.corner_state;
node_arr[0].ud.edge_state = full_cube_struct.ud.edge_state;
node_arr[0].ud.sym_state = full_cube_struct.ud.sym_state;

node_arr[0].rl.corner_state = full_cube_struct.rl.corner_state;
node_arr[0].rl.edge_state = full_cube_struct.rl.edge_state;
node_arr[0].rl.sym_state = full_cube_struct.rl.sym_state;

node_arr[0].fb.corner_state = full_cube_struct.fb.corner_state;
node_arr[0].fb.edge_state = full_cube_struct.fb.edge_state;
node_arr[0].fb.sym_state = full_cube_struct.fb.sym_state;

sol_found = 0;
if ((p_current_metric->metric == QUARTER_TURN_METRIC) &&
    (full_cube_struct.parity == 0))
   start_depth = 2;
else
   start_depth = 1;

search_limit = p_current_options->search_limit;
if ((search_limit <= 0) || (search_limit >= MAX_TWISTS))
   search_limit = MAX_TWISTS - 1;

for (ii = start_depth; ii <= search_limit; ii += p_current_metric->increment)
    {
    n_nodes = (long long int)0;
    n_tests = (unsigned int)0;
    node_arr[0].remain_depth = ii;
    node_arr[1].twist = -1;
    search_tree(&full_cube_struct, node_arr);

    if ((p_current_options->one_solution_only == 0) || (sol_found == 0))
       {
       printf("depth %2d%c completed  (", ii, p_current_metric->metric_char);
       pretty_print_unsigned_int(n_nodes);
       printf(" nodes, ");
       pretty_print_unsigned_int(n_tests);
       printf(" tests)\n");
       fflush(stdout);
       }

    if (sol_found)
       break;
    }

return;
}


/* ========================================================================= */
   int  main(void)
/* ------------------------------------------------------------------------- */

{
Metric_data             metric_data;
Options                 user_options;
Cube                    cube_struct;
int                     stat;


init_options(&metric_data, &user_options);
init_globals();

signal(SIGINT, SIG_IGN);

while (1)
      {
      stat = user_enters_cube(&cube_struct);
      if (stat < 0)
         break;

      if (stat == 0)
         {
         if (sigsetjmp(jump_env, 1) == 0)
            {
            signal(SIGINT, user_interrupt);
            solve_cube(&cube_struct);
            }

         signal(SIGINT, SIG_IGN);
         }
      }

exit(EXIT_SUCCESS);

return 0;  /*  haha  */
}
