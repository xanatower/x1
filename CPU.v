
/*`include "CPU.vh"

// CPU Module

module CPU(
	// Fill this in
	Din,Sample,Btns,Clock,Reset,Turbo,Dout,Dval,GPO,Debug,IP
,counter);


input signed [7:0] Din;
input Sample;
input [2:0] Btns;
input Clock;
input Reset;
input Turbo;

output reg signed [7:0] Dout;
output reg Dval = 1;
output reg [5:0] GPO;
output reg [3:0] Debug;
output reg [7:0] IP;

reg signed [7:0] Dout_next;
reg [5:0] GPO_next;
reg [7:0] IP_next;

output reg [3:0] counter;
wire [3:0] next = counter + 1;
localparam max = 4'b1111;
always@(posedge Clock) begin
	if(next < max) counter <= next;
	else counter <=0;
	begin
	Dout <= Dout_next;
	GPO <= GPO_next;
	IP <= IP_next;
	end
end
always@(counter) begin
	if(counter == 0) begin
		Dout_next = Dout + 1;
		GPO_next = GPO + 1;
		IP_next = IP + 1;
	end
end
endmodule*/

`include "CPU.vh"

// CPU Module

module CPU(
	// Fill this in
	Din,Sample,Btns,Clock,Reset,Turbo,Dout,Dval,GPO,Debug,IP
);
input [7:0] Din;
//input signed [7:0] Din;
input Sample;
input [2:0] Btns;
input Clock;
input Reset;
input Turbo;
output [7:0] Dout;
//output signed [7:0] Dout;
//wire Dval;
//output Dval;
output reg Dval;//before stage 11
output [5:0] GPO;
output [3:0] Debug;
output reg [7:0] IP;
initial IP = 0;//added 12/04

wire turbo_safe;
Synchroniser tbo(Clock,Turbo,turbo_safe);

//Registers
reg [7:0] Reg [0:31];

//Use these to Read the Special Registers
wire [7:0] Rgout = Reg[29];
wire [7:0] Rdout = Reg[30];
wire [7:0] Rflag = Reg[31];
//Use these to write to the Flags and Din Registers
`define RFLAG Reg[31]
`define RDINP Reg[28]
//connect certain registers to the external world
assign Dout = Rdout;
assign GPO = Rgout[5:0];
// TO DO Change Later

// Instruction Cycle
wire [3:0] cmd_grp = instruction[34:31];
wire [2:0] cmd = instruction[30:28];
wire [1:0] arg1_typ = instruction[27:26];
wire [7:0] arg1 = instruction[25:18];
wire [1:0] arg2_typ = instruction[17:16];
wire [7:0] arg2 = instruction[15:8];
wire [7:0] addr = instruction[7:0];



function [7:0] get_number;
	input [1:0] arg_type;
	input [7:0] arg;
	begin
		case (arg_type)
			`REG: get_number = Reg[arg[5:0]];
			`IND: get_number = Reg[Reg[arg[5:0]][5:0]];
			default: get_number = arg;
		endcase
	end
endfunction
function [5:0] get_location;
	input [1:0] arg_type;
	input [7:0] arg;
	begin
		case(arg_type)
			`REG: get_location = arg[5:0];
			`IND: get_location = Reg[arg[5:0]][5:0];
			default: get_location = 0;
		endcase
	end
endfunction








//reg signed [7:0] Dout_next;
//reg Dval_next;
//reg [5:0] GPO_next;
//reg [3:0] Debug_next;
//reg [7:0] IP_next;


//Clock circuitry (250ms cycle)
reg [3:0] cnt;
localparam CntMax = {4{1'b1}};
reg [7:0] cnum;
reg [7:0] cloc;
reg [15:0] word;
reg signed [7:0] s_word;
//reg signed [17:0] s_word;
reg cond;

always@(posedge Clock)
	cnt <= (cnt == CntMax) ? 4'b0 : cnt + 4'b1;

	//Synchronise CPU operations to when cnt == 0
	wire go = !Reset && ((cnt == 0)||turbo_safe);
	
	// Instruction cycle - instruction cycle block
	
	always @(posedge Clock) begin
		//Process Instruction
		Reg[`GOUT][`DVAL]<=1'b1;// added 12/04 but doesnot make sense
		if(go) begin 
		//Reg[`GOUT][`DVAL]<=1'b1;
			//IP <= 0;
			IP <= IP + 8'b1;// Default action is increment IP
			
			
			//instruction = set_bit(`GOUT,`DVAL);//set Dval to 1
			
			case(cmd_grp)
				`MOV: 
				 begin
				// 	Reg[arg2] <= arg1;
					cnum = get_number(arg1_typ,arg1);
					case(cmd)
						`SHL:begin
							`RFLAG[`SHFT]<=cnum[7];
							cnum = {cnum[6:0],1'b0};
						end
						`SHR: begin
							`RFLAG[`SHFT] <=cnum[0];
							cnum = {1'b0,cnum[7:1]};
						end
					endcase
					Reg[get_location(arg2_typ,arg2)]<=cnum;
		       end
				/*`JMP:
					IP <= addr;*/
				`ACC: begin
					cnum = get_number(arg2_typ,arg2);
					cloc = get_location(arg1_typ,arg1);
					case(cmd)
						`UAD: word = Reg[cloc] + cnum;//unsigned addition
						`SAD: s_word = $signed(Reg[cloc]) + $signed(cnum);//signed addtion
						`UMT: word = Reg[cloc] * cnum;//Unsigned Multiplication
						//`SMT: s_word = $signed({1'b0,Reg[cloc]}) * $signed({1'b0,cnum}) ;// signed multiplication
						`SMT: s_word = $signed(Reg[cloc]) * $signed(cnum) ;// signed multiplication
						`AND: word = Reg[cloc] & cnum;//bitwise and
						`OR:  word = Reg[cloc] | cnum ;//bitwise or
						`XOR: word = Reg[cloc] ^ cnum;//bitwise xor
					endcase
					//something wrong here 
					if(cmd[2] == 0)
						if(cmd[0] == 0) begin
							cnum = word[7:0];
							`RFLAG[`OFLW] <= (word > 255);
						end
						else begin
							cnum = s_word[7:0];
							`RFLAG[`OFLW] <=(s_word > 127 || s_word < -128);
						end
					Reg[cloc] <= cnum;
					end
				`JMP:begin
					case(cmd)
					`UNC: cond = 1;
					`EQ:  cond = (get_number(arg1_typ,arg1) == get_number(arg2_typ,arg2));
					`ULT: cond = (get_number(arg1_typ,arg1) < get_number(arg2_typ,arg2));
					`SLT: cond = ($signed(get_number(arg1_typ,arg1)) < $signed(get_number(arg2_typ,arg2)));
					`ULE: cond = (get_number(arg1_typ,arg1) <= get_number(arg2_typ,arg2));
					`SLE: cond = ($signed(get_number(arg1_typ,arg1)) <= $signed(get_number(arg2_typ,arg2)));
					default: cond = 0;
					endcase
					if(cond) IP<=addr;
				end
				// The ATC Command Group is designed for reading the status of the push buttons. 
				// Nevertheless, we allow it to be applied to any bit of the Flag Register
				
				`ATC:begin
					cond = `RFLAG[cmd];
					`RFLAG[cmd] <= 0;
					if(cond) IP <=addr;
				end
					
		// For now, we just assumed a PUR move, with arg1 a number and arg2 a register!
			endcase
			//added 04/12/2016
			//IP <= IP + 1;
		end
		if(Reset) IP <= 8'b0;
	end

	
//Program memory
wire [34:0] instruction;

AsyncROM Pmem(IP,instruction);
//test code

initial Dval = 1; //before stage 11
// stage 11 changes
//initial Reg[`GOUT][`DVAL] = 1;//changes made in stage11
//assign Dval = Rgout[`DVAL];
//Debugging assignments - you can change these to suit yourself
assign Debug[3] = Rflag[`SHFT];
assign Debug[2] = Rflag[`OFLW];
assign Debug[1] = Rflag[`SMPL];
assign Debug[0] = go;
//always @(*)
	//Dout = instruction[25-:8];
//added on 12/04


endmodule
