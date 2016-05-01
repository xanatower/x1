
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
		
	//Synchronise CPU operation	//now added the turbo feature to bypass the slow clock
	wire go =!Reset&&( (cnt==0) || turbo_safe);
	
	/*
	//Instruction cycle
	always@(posedge Clock)begin
		if(go)IP<=IP+8'b1;
		if(Reset)IP<=8'b0;
		
	end
	
	initial Dval=1;
	always@(*)
		Dout=instruction[25-:8];*/
	
	
	
	//Turbo Switch
	wire turbo_safe;
	//use a flipflop on the turbo signal to avoid meta
	Synchroniser tbo(Clock, Turbo, turbo_safe);
	
		
	//program mem
	
	//iNSTRUCTION POINTER
	wire [34:0] instruction;
	AsyncROM Pmem(IP, instruction);
	
	// Registers
	reg [7:0] Reg [0:31];
	// Use these to Read the Special Registers
	wire [7:0] Rgout = Reg[29];//GPO out
	
	wire [7:0] Rdout = Reg[30];//Dout
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
	
	//here are the functions added for stage 7
	function [7:0] get_number;
		input [1:0] arg_type;
		input [7:0] arg;
		begin
		case (arg_type)
		`REG: get_number = Reg[arg[5:0]];
		`IND: get_number = Reg[ Reg[arg[5:0]][5:0] ];
		default: get_number = arg;
		endcase
		end
	endfunction
	
	function [5:0] get_location;
		input [1:0] arg_type;
		input [7:0] arg;
		begin
		case (arg_type)
		`REG: get_location = arg[5:0];
		`IND: get_location = Reg[arg[5:0]][5:0];
		default: get_location = 0;
		endcase
		end
	endfunction
	
	
	reg[7:0] cnum;
	
	
	always @(posedge Clock) begin
	if (go) begin
		IP <= IP + 8'b1; // Default action is to increment IP
		case (cmd_grp)
			`MOV: begin
				cnum = get_number(arg1_typ, arg1);
				
				case (cmd)
					`SHL: begin
						`RFLAG[`SHFT] <= cnum[7];
						cnum = {cnum[6:0], 1'b0};
					end
					`SHR: begin
						`RFLAG[`SHFT] <= cnum[0];
						cnum = {1'b0, cnum[7:1]};
					end
				endcase
			end
		endcase
				
		Reg[ get_location(arg2_typ, arg2) ] <= cnum;
	end
		
	
	if(Reset)IP<=8'b0;
	end
		
	
	
	

endmodule



