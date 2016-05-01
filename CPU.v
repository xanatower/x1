
`include "CPU.vh"

// CPU Module

module CPU(
	// Fill this in
	Din,Sample,Btns,Clock,Reset,Turbo,Dout,Dval,GPO,Debug,IP
);


	input signed [7:0] Din;
	input Sample;
	input [2:0] Btns;
	input Clock;
	input Reset;
	input Turbo;

	output wire [7:0] Dout;
	output reg Dval = 1;
	output wire [5:0] GPO;
	output reg [3:0] Debug;
	output reg [7:0] IP;

	
	//clock circuity
	reg [27:0] cnt;
	localparam Cntmax=12500000;
	
	always@(posedge Clock)
		cnt<=(cnt==Cntmax)?0:cnt+1;
		
	//Synchronise CPU operation	
	wire go =!Reset&&(cnt==0);
	
	/*
	//Instruction cycle
	always@(posedge Clock)begin
		if(go)IP<=IP+8'b1;
		if(Reset)IP<=8'b0;
		
	end
	
	
	
	
	initial Dval=1;
	always@(*)
		Dout=instruction[25-:8];*/
		
	//program mem
	wire [34:0] instruction;
	AsyncROM Pmem(IP, instruction);
	
	// Registers
	reg [7:0] Reg [0:31];
	// Use these to Read the Special Registers
	wire [7:0] Rgout = Reg[29];
	wire [7:0] Rdout = Reg[30];
	wire [7:0] Rflag = Reg[31];
	// Use these to Write to the Flags and Din Registers
	`define RFLAG Reg[31]
	`define RDINP Reg[28]
	// Connect certain registers to the external world
	assign Dout = Rdout;
	assign GPO = Rgout[5:0];
	// TO DO: Change Later
	initial Dval = 1;
	
	// Instruction Cycle
	wire [3:0] cmd_grp = instruction[34:31];
	wire [2:0] cmd = instruction[30:28];
	wire [1:0] arg1_typ = instruction[27:26];
	wire [7:0] arg1 = instruction[25:18];
	wire [1:0] arg2_typ = instruction[17:16];
	wire [7:0] arg2 = instruction[15:8];
	wire [7:0] addr = instruction[7:0];
	
	always @(posedge Clock) begin
	if (go) begin
		IP <= IP + 8'b1; // Default action is to increment IP
		case (cmd_grp)
			`MOV:
				Reg[arg2] <= arg1;
		// For now, we just assumed a PUR move, with arg1 a number and arg2 a register!
		endcase
	end
	if(Reset)IP<=8'b0;
	
	end
		
	
	
	

endmodule



