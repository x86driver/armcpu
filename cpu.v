parameter WIDTH = 32;
parameter NUMREGS = 32;
parameter MEMSIZE = (1 << 13);

reg [7:0] MEM[0:MEMSIZE - 1];
reg [WIDTH-1:0] R[0:NUMREGS-1];
reg [WIDTH-1:0] PC;
reg [WIDTH-1:0] IR;
reg C;
reg V;
reg Z;
reg N;
reg RUN;

reg [WIDTH-1:0] op1;
reg [WIDTH-1:0] op2;
reg [WIDTH:0] result;

`define MOV 4'b1101

`define AL 4'b1110

`define COND IR[31:28]
`define OPCODE IR[24:21]
`define SETCOND IR[20]
`define Rn IR[19:16]
`define Rd IR[15:12]
`define Rotate_4 IR[11:8]
`define Immed_8 IR[7:0]

`define Rm IR[3:0]

`define OP1 IR[27:25];

module DOREMI
  initial begin
     integer num_instrs;
     
     $readmemh("v.out", MEM);

     RUN = 1;
     PC = 0;
     num_instrs = 0;

     while (RUN == 1) begin
	num_instrs = num_instrs + 1;
	fetch;
	execute;
	print_trace;
     end

     $display("\nTotal number of instructions executed: %d\n\n", num_instrs);
     $finish;

  end // initial begin
endmodule // DOREMI

task fetch;
   begin
      IR = read_mem(PC);
      PC = PC + 4;
   end
endtask // fetch

function [WIDTH-1:0] read_mem;
   input [WIDTH-1:0] addr;

   read_mem = {(MEM[addr], MEM[addr+1], MEM[addr+2], MEM[addr+3])};

endfunction //

task execute;
   begin

      if (`COND == AL) begin
	 case (`OP1)

	   3'b000: begin	// register
	      case (`OPCODE)

		`MOV: begin
	   end
	   
	   3'b001: begin	// immediate
	     case (`OPCODE) 

	       `MOV: begin
		  R[`Rd] = R[`Rm];
	       end
	     endcase // case (`OPCODE)
	   end
	   

      
