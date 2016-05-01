`include "CPU.vh"

// Asynchronous ROM (Program Memory)

module AsyncROM(
 
	input [7:0] Addr, output reg [34:0] data
);
always@(Addr)
	
	case(Addr)
		0: data = {`MOV,`PUR,`NUM,8'd1,`REG,`DOUT,`N8};
		1: data = {`MOV,`PUR,`NUM,8'd3,`REG,`DOUT,`N8};
		2: data = {`MOV,`PUR,`NUM,8'd5,`REG,`DOUT,`N8};
		3: data = {`MOV,`PUR,`NUM,8'd7,`REG,`DOUT,`N8};
		4: data = {`MOV,`PUR,`NUM,8'd9,`REG,`DOUT,`N8};
		5: data = {`MOV,`PUR,`NUM,8'd11,`REG,`DOUT,`N8};
		6: data = {`MOV,`PUR,`NUM,8'd13,`REG,`DOUT,`N8};
		7: data = {`MOV,`PUR,`NUM,8'd15,`REG,`DOUT,`N8};
		8: data = {`MOV,`PUR,`NUM,8'd17,`REG,`DOUT,`N8};
		9: data = {`MOV,`PUR,`NUM,8'd19,`REG,`DOUT,`N8};
		default: data=35'b0;
	endcase
endmodule

