`include "CPU.vh"

// CPU Module

module CPU(input [7:0] Din, input Sample, input [2:0] Btns, input Clock, input Reset, input Turbo, 
output reg[7:0] Dout, output reg Dval, output reg[5:0] GPO, output reg[4:0] Debug, output reg[7:0] IP);
	
	
	
	
	//reset feature
	always@(posedge Clock or posedge Reset) begin
	if(Reset) begin
		Dout<=8'b00000000;
		Dval<=1'b0;;
		GPO<=8'b000000;
		Debug<=8'b00000;
		IP<=8'b00000000;
	
	
	end
	else 
		begin
		GPO<=8'b111111;
		end
	
	end


endmodule

