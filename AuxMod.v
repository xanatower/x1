// Add more auxillary modules here...

// DeBounce_v.v


//////////////////////// Button Debounceer ///////////////////////////////////////
//***********************************************************************
// FileName: DeBounce_v.v
// FPGA: MachXO2 7000HE
// IDE: Diamond 2.0.1 
//
// HDL IS PROVIDED "AS IS." DIGI-KEY EXPRESSLY DISCLAIMS ANY
// WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
// BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
// DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
// PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
// BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
// ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
// DIGI-KEY ALSO DISCLAIMS ANY LIABILITY FOR PATENT OR COPYRIGHT
// INFRINGEMENT.
//
// Version History
// Version 1.0 04/11/2013 Tony Storey
// Initial Public Release
// Small Footprint Button Debouncer

/*module  DeBounce 
	(
	input 			clk, n_reset, button_in,				// inputs
	output reg 	DB_out													// output
	);
//// ---------------- internal constants --------------
	parameter N = 11 ;		// (2^ (21-1) )/ 38 MHz = 32 ms debounce time
////---------------- internal variables ---------------
	reg  [N-1 : 0]	q_reg;							// timing regs
	reg  [N-1 : 0]	q_next;
	reg DFF1, DFF2;									// input flip-flops
	wire q_add;											// control flags
	wire q_reset;
//// ------------------------------------------------------

////contenious assignment for counter control
	assign q_reset = (DFF1  ^ DFF2);		// xor input flip flops to look for level chage to reset counter
	assign  q_add = ~(q_reg[N-1]);			// add to counter when q_reg msb is equal to 0
	
//// combo counter to manage q_next	
	always @ ( q_reset, q_add, q_reg)
		begin
			case( {q_reset , q_add})
				2'b00 :
						q_next <= q_reg;
				2'b01 :
						q_next <= q_reg + 1;
				default :
						q_next <= { N {1'b0} };
			endcase 	
		end
	
//// Flip flop inputs and q_reg update
	always @ ( posedge clk )
		begin
			if(n_reset ==  1'b0)
				begin
					DFF1 <= 1'b0;
					DFF2 <= 1'b0;
					q_reg <= { N {1'b0} };
				end
			else
				begin
					DFF1 <= button_in;
					DFF2 <= DFF1;
					q_reg <= q_next;
				end
		end
	
//// counter control
	always @ ( posedge clk )
		begin
			if(q_reg[N-1] == 1'b1)
					DB_out <= DFF2;
			else
					DB_out <= DB_out;
		end

	endmodule*/




// Display a Hexadecimal Digit, a Negative Sign, or a Blank, on a 7-segment Display
module SSeg(input [3:0] bin, input neg, input enable, output reg [6:0] segs);
	always @(*)
		if (enable) begin
			if (neg) segs = 7'b011_1111;
			else begin
				case (bin)
					0: segs = 7'b100_0000;
					1: segs = 7'b111_1001;
					2: segs = 7'b010_0100;
					3: segs = 7'b011_0000;
					4: segs = 7'b001_1001;
					5: segs = 7'b001_0010;
					6: segs = 7'b000_0010;
					7: segs = 7'b111_1000;
					8: segs = 7'b000_0000;
					9: segs = 7'b001_1000;
					10: segs = 7'b000_1000;
					11: segs = 7'b000_0011;
					12: segs = 7'b100_0110;
					13: segs = 7'b010_0001;
					14: segs = 7'b000_0110;
					15: segs = 7'b000_1110;
				endcase
			end
		end
		else segs = 7'b111_1111;
endmodule

`timescale 1 ns / 100 ps
module Debounce(clk,signal,debounced_signal);
	input signal,clk;
	output reg debounced_signal;
    wire sync_signal;
	Synchroniser sync (.clk(clk),.signal(signal),.synchronized_signal(sync_signal));
   wire signal_changed = sync_signal ^ next;
	//localparam max = {22{1'b1}};
	localparam max = {4{1'b1}};
	wire add = ~(counter == max);
	wire keep = ~add | (~signal_changed);
	//parameter N = 22;
	//reg [21:0] counter;
	reg[3:0] counter;
	always@(posedge clk) begin
	//counter = counter + 1;
	//if(keep) counter <= 22'b0;
	if(keep) counter <= 4'b0;
	else counter <= counter + 4'b1;
	//else counter <= counter + 22'b1;
	end
	wire next;
	always@(posedge clk) begin
		if(counter == max) debounced_signal <= ~next;
		else debounced_signal <= debounced_signal;
	end
	assign next = debounced_signal;
endmodule
/*module Debounce (input Clock,Signal, output reg debounced_Signal);
	wire synchronized_out;
	parameter N = 21;
	reg [N-1:0] q_reg;
	reg [N-1:0] q_next;
	wire reset;
	wire add;
	// assignments
	assign reset = Signal ^ synchronized_out;
	assign add = ~(q_reg[N-1]);
	//initializing synchronizer
	Synchroniser sych (.clk(Clock),.signal(Signal),.synchronized_signal(synchronized_out));
	//counter
	always @(add,reset,q_reg)
		begin
			case ({add,reset})
				2'b00: q_reg <= q_next;
				2'b10: q_reg <= q_next + 1;
				default: q_reg <= {N{1'b0}};
			endcase
		end
	//controller-- need to be changed
	always @(posedge Clock)
		begin
			if(q_reg[N-1] == 1'b1)
				debounced_Signal <= synchronized_out;
			else
				debounced_Signal <= debounced_Signal;
		end

endmodule*/
module Disp2cNum(input signed [7:0] x, input enable, output [6:0] H3,H2,H1,H0/*, output [7:0] xo0_check,xo1_check,xo2_check,xo3_check*/);
  
	wire neg = (x<0);
	wire [7:0] ux = neg ? -x : x;
	
	
	wire [7:0] xo0,xo1,xo2,xo3;
	wire eno0,eno1,eno2,eno3;
	
	
	DispDec h0(ux,neg,enable,xo0,eno0,H0);
	DispDec h1(xo0,neg,eno0,xo1,eno1,H1);
	DispDec h2(xo1,neg,eno1,xo2,eno2,H2);
	DispDec h3(xo2,neg,eno2,xo3,eno3,H3);
	//assign xo0_check = xo0;
	//assign xo1_check = xo1;
	//assign xo2_check = xo2;
	//assign xo3_check = xo3;
	
endmodule


module DispDec(input [7:0] x, input neg,enable,output reg [7:0] xo, output reg eno,output [6:0] segs);
	wire [3:0] digit;
	wire n = (x == 1'b0 && neg == 1'b1) ? neg : 1'b0;
	assign digit = x%4'd10;
	SSeg converter (digit,n,enable,segs);
	
	always@(x) begin
		xo = x /8'd10;
	end
	always@(x or neg or enable or segs) begin
		if(x/10 == 0 && neg == 0)
		eno = 0;
		else eno = enable;
		if(segs == 7'b011_1111)
		eno = 0;
		//else eno = enable;
	end
	
	
	
endmodule


module DispHex(input [7:0] value, output [6:0] display0,display1);
	SSeg sseg0 (value[7:4],0,1,display0);
	SSeg sseg1 (value[3:0],0,1,display1);
endmodule

module Synchroniser(input clk,input signal,output reg synchronized_signal);
	reg meta;

	always @(posedge clk) begin
		meta <= signal;
		synchronized_signal <= meta;
	end
endmodule

