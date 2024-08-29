README file for optimal Rubik's cube solver


1. Preliminaries.

After you  gunzip  and  untar  the file you should have (besides the
tar file) three files:

     % ls -l
     -rw-------    1 501      100          4629 2004-06-03 00:05 README
     -rw-------    1 501      100        133158 2004-06-03 00:05 optimal.c
     -rw-------    1 501      100         20552 2004-06-03 00:05 twist.c

README is the file you are presently examining.  optimal.c  is the
source code for the optimal solver.  twist.c  is the source code to
a related utility (see below).


2. System requirements

At least 80Mb RAM for the optimal cube solver.  With less than 80Mb
it probably won't run at any reasonable speed.  I'm not even sure it
will run well with 80Mb, so 88Mb or 96Mb is preferred.

If you get it running on your system, I would appreciate if you let me
know, so that I know it works on that type of system.  Please send me
e-mail to let me know that you have it working!!

The program was developed on a Linux system, but should use only
ANSI standard C.


3. Compiling the optimal solver

The source file is  optimal.c .  It is presently configured to search by
quarter turns.  If you want to search by face turns, change line #5 to

     #define  USE_METRIC           FACE_TURN_METRIC

You can also change the value of  SEARCH_LIMIT  if you desire.
This will limit how far the program searches.  The default value of 0
means no limit.

My preferred method of compilation is

     % gcc -Wall -O2 optimal.c

but feel free to use something else.


4. Startup time

Startup time is significant.  On my processor (200 MHz PentiumPro), it
takes about 11 minutes to generate all the tables.  While it's working
on this, be sure to read the next section about input format.

This is greatly reduced on newer computers.  On a 933MHz P3, it should
only take 2 or 3 minutes.


5. Input to the optimal solver

A solved cube is represented as

     UF UR UB UL DF DR DB DL FR FL BR BL UFR URB UBL ULF DRF DFL DLB DBR

To input a scrambled cube, first give the cubie that's in the  UF  location,
then the cubie in the  UR  location, and so forth, according to this list
above.  For example, "cube in a cube" would be

     UF UR RD RB LU LF DB DL FR UB DF BL UFR RFD RDB RBU LFU LUB DLB LDF

This input should all be on one line.  Some people have expressed their
displeasure with this system.  I can't say I disagree, but I can't think
of any system that's easy.  So your ideas here would be useful.  Read on
to the next section about using  "twist.c"  to convert a sequence of twists
into a cube in the desired format.

Sequences that are produced as output solve the cube from the input state.

You may also interrupt a search by typing  Ctrl-C .  Instead of exiting,
it will prompt you for another cube.  (To exit, type  Ctrl-D .)


6. Using  "twist.c"

This is just a hack.  Input to this program is a sequence of twists, all
on one line.  It outputs two cubes, the position created by applying the
sequence to a solved cube, and the inverse position.  The twists should
be in the form   F  F2  F'  etc.  this program doesn't require any
optimization.  I compile it using

     % gcc -o twist.out -Wall twist.c


7. Miscellaneous

The number of nodes overflows on long searches.  With  gcc  this can be
fixed by changing the global variable  n_nodes  to type  long long int.


8. To do list

     a. Experiment with other "pattern databases."
     b. Perhaps unroll subfunctions in  initialize_distance_table
        to reduce startup time.
     c. Consider solving the inverse position if this is a little
        bit easier


9. Changes since last version

The main change is that I have implemented automatic symmetry reductions.
This means that the program will analyze the symmetry of the input
position, and use this to reduce the search space.  If you input a
position with 12-fold symmetry, it will run 12 times as fast.
This feature is turned on by default.  You can turn it off by  #define-ing
the symbol  USE_SYMMETRY  to  0 .

Some other minor things: fixed a bug in  twist.c  when there's white
space at the end of the input line.  I also reverted to new-style
function declarations.  And the program should run fine without needing
excess stack space.


10. Feedback

e-mail me with any questions, comments, etc. at  reid@math.ucf.edu .
Currently, there is a pointer to the files on the web page

     http://www.math.ucf.edu/~reid/Rubik/optimal_solver.html

Good luck, and enjoy the program.  If you make any interesting discoveries
with the program, please share them with me and the cube-lovers mailing list.

June 3, 2004
