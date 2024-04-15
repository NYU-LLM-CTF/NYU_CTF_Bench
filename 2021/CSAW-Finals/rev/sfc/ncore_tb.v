// ________                  _____              ______   
// __  ___/____________________  /_____________ ___  /   
// _____ \___  __ \  _ \  ___/  __/_  ___/  __ `/_  /    
// ____/ /__  /_/ /  __/ /__ / /_ _  /   / /_/ /_  /     
// /____/ _  .___/\___/\___/ \__/ /_/    \__,_/ /_/      
//        /_/                                            
// ______________       __________                       
// ___  ____/__(_)_________(_)_  /_____                  
// __  /_   __  /__  __ \_  /_  __/  _ \                 
// _  __/   _  / _  / / /  / / /_ /  __/                 
// /_/      /_/  /_/ /_//_/  \__/ \___/                  
                                                      
// _________                                             
// __  ____/_________________                            
// _  /    _  __ \_  ___/  _ \                           
// / /___  / /_/ /  /   /  __/                           
// \____/  \____//_/    \___/            
// by OSIRIS SUPER-COOL CPU DIVISION                 
// Compile with: iverilog -g2012 -o nco ncore_tb.v                                        

`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

  `define ADD  4'd0
  `define SUB  4'd1
  `define MOVF 4'd2
  `define MOVT 4'd3
  `define ENT  4'd4
  `define EXT  4'd5 
  `define JGT  4'd6
  `define JEQ  4'd7
  `define JMP  4'd8
  `define INC  4'd9
  `define MOVFS 4'd10
  `define FLUSH 4'd11
  `define RDTM 4'd12
  `define MOVFU 4'd13
  `define MOVFI 4'd14
  `define MOVFSI 4'd15

  `define RDY 0
  `define MSTAGE_1 1
  `define MSTAGE_2 2
  `define LOCKED 3
  `define DSTAGE_1 4
  `define DSTAGE_2 5

  `define BRANCH_PRED_MAX 3

module ncore_tb;
  reg [7:0] safe_rom [0:255];
  reg [7:0] ram [0:255];
  reg [7:0] cache [0:1];
  reg [7:0] cache_v [0:1];
  reg cache_rdy [0:2];
  reg [31:0] regfile [0:3];
  reg [31:0] key [0:0];
  reg [31:0] tck = 32'd0;
  reg emode;
  wire [3:0] opcode;
  integer pc = 0;
  // assign opcode = ram[pc][3:0];
  reg clk = 0;
  reg [31:0] tmp = 32'd0;
  // file descriptors
  int       read_file_descriptor;
  // memory
  logic [7:0] mem [15:0];
  integer state = `RDY;
  integer cc = 0;
  integer addr = 0;
  integer branch_pred = 0;
  integer wrong_attmpt = 0;
  reg is_ram = 1;

  task increment_pc();
    pc = pc + 2;
  endtask

  task load_safeROM();
    // $display("loading safe rom, safely...");
    $readmemh("flag.hex",safe_rom);
  endtask

  task load_ram();
    // $display("loading user controlled memory...");
    $readmemh("ram.hex",ram);
  endtask

  task open_file();
    // $display("Opening file");
    read_file_descriptor=$fopen("flag.txt","rb");
  endtask

  task set_key();
    int tmp;
    // key[0] = 0;
    // key[0] = $random();
    read_file_descriptor=$fopen("/dev/urandom","rb");
    tmp = $fread(key, read_file_descriptor);
    $readmemh("/dev/urandom",key);
  endtask

  task print_res();
    integer i;
    for( i=0; i<64; i = i + 1) begin
      $write("%h ",ram[255-i]);
    end
    $write("\n");
  endtask

  task init_regs();
    integer i = 0;
    for(i = 0; i<4; i++) begin
      regfile[i] = 32'd0;
    end
  endtask

  always begin
    #5 begin
      clk <= ~clk;
      tck <= tck + 1;
    end
  end

  always @(posedge clk) begin: inclk
    // $display("PC:%h | OPCODE: %d ADDR: %d",pc,ram[pc][3:0],ram[pc+1]);
    case(state)
    `LOCKED: begin
      
    end
    `DSTAGE_1: begin
      tmp <= ram[addr];
      state <= `DSTAGE_2;
    end
    `DSTAGE_2: begin
      regfile[ram[pc][5:4]] <= tmp;
      state <= `RDY;
      increment_pc();
    end 
    `MSTAGE_1: begin
      if (is_ram) begin
        cache_rdy[cc] <= 1;
        cache[cc] <= addr;
        cache_v[cc] <= ram[addr];
        cc <= (cc + 1)%2;
      end else begin
        cache_rdy[cc] <= 2;
        cache[cc] <= addr;
        cache_v[cc] <= safe_rom[addr];
        cc <= (cc + 1)%2;
    end
    state <= `MSTAGE_2;
    end
    `MSTAGE_2: begin
      regfile[ram[pc][5:4]] <= cache_v[(cc + 1)%2];
      state <= `RDY;
      increment_pc();
    end
    `RDY: begin
          case(ram[pc][3:0]) 
      `ADD: begin
        regfile[ram[pc][5:4]] <=  regfile[ram[pc][7:6]] + regfile[ram[pc+1][1:0]];
        increment_pc();
      end
      `INC: begin
        // $display("INC: R%d %d",ram[pc][5:4],regfile[ram[pc][5:4]]);
        regfile[ram[pc][5:4]] <=  regfile[ram[pc][5:4]] + 1;
        increment_pc();
      end
      `SUB: begin
        regfile[ram[pc][5:4]] <=  regfile[ram[pc][7:6]] -  regfile[ram[pc+1][1:0]];
        // $display("SUB: %d %d", regfile[ram[pc][7:6]] -  regfile[ram[pc+1][1:0]],ram[19]);
        increment_pc();
      end
      `MOVF: begin
        if ( (cache_rdy[0] == 1) && (cache[0] == ram[pc+1]) ) begin
           regfile[ram[pc][5:4]] <= cache_v[0];
           increment_pc();
        end else if ((cache_rdy[1] == 1) && (cache[1] == ram[pc+1])) begin
           regfile[ram[pc][5:4]] <= cache_v[1];
           increment_pc();
        end else begin
           state <= `MSTAGE_1;
           addr <= ram[pc+1];
           is_ram <= 1;
        end
      end
      `RDTM: begin
        regfile[ram[pc][5:4]] <= tck;
        increment_pc();
      end
      `MOVFU: begin
        if ((cache_rdy[0] == 1) && (cache[0] == ram[pc+1])) begin
           regfile[ram[pc][5:4]] <= cache_v[0];
           increment_pc();
        end else if ((cache_rdy[1] == 1) && (cache[1] == ram[pc+1])) begin
           regfile[ram[pc][5:4]] <= cache_v[1];
           increment_pc();
        end else begin
           state <= `DSTAGE_1;
           addr <= ram[pc+1];
           is_ram <= 1;
        end
      end
      `MOVFS: begin
        if(emode) begin 
        if ((cache_rdy[0] == 2) && (cache[0] == safe_rom[pc+1]) ) begin
           regfile[ram[pc][5:4]] <= cache_v[0];
           increment_pc();
        end else if ((cache_rdy[1] == 2) && (cache[1] == safe_rom[pc+1])) begin
           regfile[ram[pc][5:4]] <= cache_v[1];
           increment_pc();
        end else begin
           state <= `MSTAGE_1;
           addr <= ram[pc+1];
           is_ram <= 0;
        end
        end
        increment_pc();
      end
      `MOVFI: begin
        addr = ram[pc+1] + regfile[ram[pc][7:6]];
        is_ram <= 1;
        if ( (cache_rdy[0] == 1) && (cache[0] == addr) ) begin
           regfile[ram[pc][5:4]] <= cache_v[0];
           increment_pc();
        end else if ((cache_rdy[1] == 1) && (cache[1] == addr)) begin
           regfile[ram[pc][5:4]] <= cache_v[1];
           increment_pc();
        end else begin
           state <= `MSTAGE_1;
        end
      end
      `MOVFSI: begin
        if(emode) begin
          addr = safe_rom[pc+1] + regfile[ram[pc][7:6]];
          is_ram <= 1;
          if ( (cache_rdy[0] == 1) && (cache[0] == addr) ) begin
             regfile[ram[pc][5:4]] <= cache_v[0];
             increment_pc();
          end else if ((cache_rdy[1] == 1) && (cache[1] == addr)) begin
             regfile[ram[pc][5:4]] <= cache_v[1];
             increment_pc();
          end else begin
             state <= `MSTAGE_1;
          end
        end else begin
          state <= `LOCKED;
        end
      end
      `MOVT: begin
        if(cache[0] == ram[pc+1]) begin
          cache_rdy[0] <= 0;
        end
        if(cache[1] == ram[pc+1]) begin
          cache_rdy[1] <= 0;
        end
        // $display("write to %d : %d",ram[pc+1],regfile[ram[pc][5:4]][7:0]);
        ram[ram[pc+1]] <= regfile[ram[pc][5:4]][7:0];
        increment_pc();
      end
      `JGT: begin
        // $write("BP:%d",branch_pred);
        // TAKEN:      ram[pc+1] -> ram[ram[pc+1]][7:6]
        // NOT TAKEN:  pc + 2    -> ram[pc + 2][7:6]
        // ADDR T  : regfile[ram[ram[pc+1]][7:6]] + safe_rom[ram[pc+1]+1]
        // ADDR NT : regfile[ram[pc+2][7:6]] + safe_rom[pc+3] 
        if (branch_pred>=0) begin
          if (ram[ram[pc+1]][3:0] == `MOVFI) begin
            cache[cc] <= ram[ram[ram[pc+1]+1]] + regfile[ram[ram[pc+1]][7:6]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[ram[ram[ram[pc+1]+1]] + regfile[ram[ram[pc+1]][7:6]]];
          end
          if (ram[ram[pc+1]][3:0] == `MOVFSI) begin
            // $display("SPECULATIVE! %d", regfile[ram[ram[pc+1]][7:6]]);
            cache[cc] <= safe_rom[ram[ram[pc+1]+1]] + regfile[ram[ram[pc+1]][7:6]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[safe_rom[ram[ram[pc+1]+1]] + regfile[ram[ram[pc+1]][7:6]]];
          end
        end else begin
          if (ram[pc+2][3:0] == `MOVFI) begin
            cache[cc] <= regfile[ram[pc+2][7:6]] + ram[ram[pc+3]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[ram[ram[pc+3]] + regfile[ram[pc+2][7:6]]];
          end
          if (ram[pc+2][3:0] == `MOVFSI) begin
            //  $display("SPECULATIVE! %d %d %d %d",pc+3 ,safe_rom[pc+2+1],regfile[ram[pc+2][7:6]],safe_rom[ram[pc+3]] + regfile[ram[pc+2][7:6]]);
            cache[cc] <= safe_rom[ram[pc+3]] + regfile[ram[pc+2][7:6]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[safe_rom[ram[pc+3]] + regfile[ram[pc+2][7:6]]];
          end
        end
        if(regfile[ram[pc][5:4]]>regfile[ram[pc][7:6]]) begin
          pc <= ram[pc+1];
          branch_pred <= (branch_pred==`BRANCH_PRED_MAX)?branch_pred:branch_pred+1;
        end else begin
          branch_pred <= (branch_pred==(-`BRANCH_PRED_MAX))?branch_pred:branch_pred-1;
          pc <= pc+2;
        end
      end
       `JEQ: begin
        if (branch_pred>=0) begin
          if (ram[ram[pc+1]][3:0] == `MOVFI) begin
            cache[cc] <= ram[ram[pc+1]+1] + regfile[ram[ram[pc+1]][5:4]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[ram[ram[pc+1]+1]] + regfile[ram[ram[pc+1][5:4]]];
          end
          if (ram[ram[pc+1]][3:0] == `MOVFSI) begin
            cache[cc] <= safe_rom[ram[pc+1]+1] + regfile[ram[ram[pc+1]][5:4]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[safe_rom[ram[pc+1]+1]] + regfile[ram[ram[pc+1][5:4]]];
          end
        end else begin
          if (ram[pc+2][3:0] == `MOVFI) begin
            cache[cc] <= ram[pc+2+1] + regfile[ram[pc+2][5:4]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[ram[pc+2+1] + regfile[ram[pc+2][5:4]]];
          end
          if (ram[pc+2][3:0] == `MOVFSI) begin
            cache[cc] <= safe_rom[pc+2+1] + regfile[ram[pc+2][5:4]];
            cache_rdy[cc] <= 1;
            cache_v[cc] <= ram[safe_rom[pc+2+1] + regfile[ram[pc+2][5:4]]];
          end
        end
        if(regfile[ram[pc][5:4]] == regfile[ram[pc][7:6]]) begin
          pc <= ram[pc+1];
          branch_pred <= (branch_pred==`BRANCH_PRED_MAX)?branch_pred:branch_pred+1;
        end else begin
          branch_pred <= (branch_pred==(-`BRANCH_PRED_MAX))?branch_pred:branch_pred-1;
          pc <= pc+2;
        end
      end
       `JMP: begin
        pc <= ram[pc+1];
      end
       `ENT: begin
         // $display("%d | %d",regfile[0],key[0][13:0]);
        if(key[0] == regfile[0]) begin
          emode <= 1;
          regfile[3] <= 0;
          //  $display("ENT");
        end else begin
          if (wrong_attmpt > 5) begin
            state <= `LOCKED;
          end
          regfile[3] <= 1;
          wrong_attmpt <= wrong_attmpt + 1;
        end
        increment_pc();
      end
       `EXT: begin
        emode <= 0;
        increment_pc();
      end
        `FLUSH: begin
         cache_rdy[0] <= 0;
         cache_rdy[1] <= 0;
         increment_pc();
      end
      default: begin
        increment_pc();
      end
     endcase
    end
    default: begin
      
    end
    endcase

  end:inclk

   initial 
    begin: initial_block
        // $monitor(,$time,": PC: %d",pc);
        // $monitor(,$time,": R0: %d,R1: %d,R2: %d,R3: %d",regfile[0],regfile[1],regfile[2],regfile[3]);
        init_regs();
        emode = 1;
        set_key();
        // $display("key: %d",key[0]);
        load_safeROM();
        load_ram();
        // $display("A %h, B: %h",safe_rom[0],safe_rom[1]);
        #400000;
        print_res(); 
        $finish;
    end :initial_block



endmodule
