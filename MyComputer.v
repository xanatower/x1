
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module MyComputer(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
//	input 		          		CLOCK2_50,
//	input 		          		CLOCK3_50,
//	input 		          		CLOCK4_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);



wire [7:0] Dout;//reg to wire

wire Dval;//reg to wire

//wire GPO_LEDR;
//assign GPO_LERD=LEDR[5:0];

//wire Debug_LEDR;
//assign Debug_LEDR=LEDR[9:6];

wire [7:0] IP;//reg to wire

/*CPU MyCpu(SW[0:7], ~KEY[3], ~KEY[0:2], CLOCK_50, SW[9], SW[8], Dout[7:0], Dval,
LEDR[5:0], LEDR[9:6], IP[7:0]);*/
//shoud it be [0:7]???


/*module CPU(input [7:0] Din, input Sample, input [2:0] Btns, input Clock, input Reset, input Turbo, 
output reg[7:0] Dout, output reg Dval, output reg[5:0] GPO, output reg[4:0] Debug, output reg[7:0] IP);*/

//CPU MyCpu(SW[7:0], ~KEY[3], ~KEY[2:0], CLOCK_50, SW[9], SW[8],
 //Dout[7:0], Dval, GPO_LEDR, Debug_LEDR, IP[7:0]);
 
 CPU MyCpu(SW[7:0], ~KEY[3], ~KEY[2:0], CLOCK_50, SW[9], SW[8],
 Dout[7:0], Dval, LEDR[5:0], LEDR[9:6], IP[7:0]);
 

Disp2cNum(Dout[7:0], Dval, HEX0, HEX1, HEX2, HEX3);
DispHex(IP[7:0], HEX4, HEX5);




//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================



endmodule