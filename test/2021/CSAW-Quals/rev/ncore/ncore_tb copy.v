`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

  `define ADD  4'd0
  `define SUB  4'd1
  `define AND  4'd2
  `define OR   4'd3
  `define RES 4'd4
  `define MOVF 4'd5
  `define MOVT 4'd6
  `define ENT  4'd7
  `define EXT  4'd8 
  `define JGT  4'd9
  `define JEQ  4'd10
  `define JMP  4'd11
  `define INC  4'd12
  `define MOVFS 4'd13

module ncore_tb;
  reg [7:0] safe_rom [0:255];
  reg [7:0] ram [0:255];
  reg [31:0] regfile [0:3];
  reg [31:0] key;
  reg emode;
  wire [3:0] opcode;
  assign opcode = ram[pc][3:0];
  integer pc;
  reg clk;
  // file descriptors
  int       read_file_descriptor;
  // memory
  logic [7:0] mem [15:0];



  task increment_pc();
    pc = pc + 2;
  endtask

  task load_safeROM();
    $display("loading safe rom, safely...");
    $readmemh("flag.hex",safe_rom);
  endtask

  task load_ram();
    $display("loading user controlled memory...");
    $readmemh("ram.hex",ram);
  endtask

  task open_file();
    $display("Opening file");
    read_file_descriptor=$fopen("flag.txt","rb");
  endtask

  task readBinFile2Mem ();
    int n_Temp;
    n_Temp = $fread(mem, read_file_descriptor);
    $display("n_Temp = %0d",n_Temp);
  endtask

  task close_file();
    $display("Closing the file");
    $fclose(read_file_descriptor);
  endtask

  task printMem();
    foreach(mem[i])
      $display("mem[%0d] = %h",i,mem[i]);
  endtask

  task print_res();
    integer i;
    for( i=0; i<10; i = i + 1) begin
      $display("%h ",ram[i]);
    end
  endtask

  always 
    #10 clk = ~clk;

  always @(posedge clk) begin: inclk
    case(opcode) 
     `ADD, `SUB, `OR, `AND: ;  
     default: ;
    endcase
  end:inclk

   initial 
    begin: initial_block
        emode = 0;
        load_safeROM();
        load_ram();
        $display("A %h, B: %h",safe_rom[0],safe_rom[1]);
        print_res();
        #40000
        $finish;    
    end :initial_block



endmodule