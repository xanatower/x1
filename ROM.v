`include "CPU.vh"

// Asynchronous ROM (Program Memory)

module AsyncROM(
	// You fill this in... 
	input [7:0] Addr, output reg [34:0] data
);
always@(Addr) begin
	//data = set_bit(`GOUT,`DVAL);//set Dval to one: added for stage 11
	case(Addr)
		/*0: data = {`MOV,`PUR,`NUM,8'd1,`REG,`DOUT,`N8};
		1: data = {`MOV,`PUR,`NUM,8'd3,`REG,`DOUT,`N8};
		2: data = {`MOV,`PUR,`NUM,8'd5,`REG,`DOUT,`N8};
		3: data = {`MOV,`PUR,`NUM,8'd7,`REG,`DOUT,`N8};
		4: data = {`MOV,`PUR,`NUM,8'd9,`REG,`DOUT,`N8};
		5: data = {`MOV,`PUR,`NUM,8'd11,`REG,`DOUT,`N8};
		6: data = {`MOV,`PUR,`NUM,8'd13,`REG,`DOUT,`N8};
		7: data = {`MOV,`PUR,`NUM,8'd15,`REG,`DOUT,`N8};
		8: data = {`MOV,`PUR,`NUM,8'd17,`REG,`DOUT,`N8};
		9: data = {`MOV,`PUR,`NUM,8'd19,`REG,`DOUT,`N8};
		10: data = {`MOV,`PUR,`NUM,8'd15,`REG,`GOUT,`N8};
		11: data = {`MOV,`PUR,`NUM,8'd26,`REG,`GOUT,`N8};
		12: data = {`MOV,`PUR,`NUM,8'd38,`REG,`GOUT,`N8};
		13: data = {`JMP,`UNC,`N10,`N10,8'd4};*/
		/*Test for stage 8*/
		//0: data = {`MOV,`PUR,`NUM,8'd0,`REG,`DOUT,`N8};
		//4: data = {`ACC,`UAD,`REG,`DOUT,`NUM,8'd15,`N8};
		//8: data = {`JMP,`UNC,`N10,`N10,8'd4};
		/*Test for stage 9*/
		/*0: data = {`MOV,`PUR,`NUM,8'd1,`REG,`DOUT,`N8};
		4: data = {`ACC,`SMT,`REG,`DOUT,`NUM,-8'd2,`N8};
		7: data = {`JMP,`SLT,`REG,`DOUT,`NUM, 8'd64,8'd4};
		10: data = {`MOV,`PUR,`NUM,8'd100,`REG,`DOUT,`N8};
		13: data = {`ACC,`SAD,`REG,`DOUT,`NUM,-8'd7,`N8};
		16: data = {`JMP,`SLE,`NUM,8'd0,`REG,`DOUT,8'd13};
		20: data = {`JMP,`UNC,`N10,`N10,8'd0};
		1, 5, 8, 11, 14, 17, 21: data = move(`FLAG, `GOUT);*/
		/*Test code for stage 10*/
		/*
		
		///0: data = set_bit(`GOUT,`DVAL);//test doesnt seem to be correct
		0: data = set(`DOUT, 1);
		//1: data = set(`GOUT,`DVAL);
		//'3: data = set_bit(`GOUT,`DVAL);
		//4: data = acc_rn(`SMT, `DOUT, -2);
		4: data = {`MOV,`SHL,`REG,`DOUT,`REG,`DOUT,`N8};
		//5: data = set(`GOUT,`DVAL);
		//8: data = atc(`OFLW, 16);
		8: data = atc(`SHFT,16);
		//9: data = set(`GOUT,`DVAL);
		12: data = jmp(4);
		//13: data = set(`GOUT,`DVAL);
		16: data = set(`DOUT, 250);
		//17: data = set(`GOUT,`DVAL);
		20: data = acc_rn(`UAD, `DOUT, 1);
		//21: data = set(`GOUT,`DVAL);
		24: data = atc(`OFLW, 8);
		//25: data = set(`GOUT,`DVAL);
		28: data = jmp(20);
//default: data = 35'b0; // NOP
		//2, 6, 10, 14, 19, 22, 26: data = move(`FLAG, `GOUT);
		1,5,9,13,17,21,25:data = move(`FLAG,`GOUT);
		//4: data = {`MOV,`SHL,`REG,`DOUT,`REG,`DOUT,`N8};
		//8: data = atc(`SHFT,16);
		default: data = 35'b0;
		//default: data = clr_bit(`GOUT,`DVAL);//set Dval to one: added for stage 11*/
		
		//test for stage 11
		0: data = set(`DOUT, 1);
		5: data= set_bit(`DOUT, 2);
		10: data = clr_bit(`DOUT, 2);
		default: data = move(`DOUT, `DOUT);
		
	endcase
	//data = set_bit(`GOUT,`DVAL);
	//data = jmp(0);//added on 12/04/2016
end
	function [34:0] set;
		input [7:0] reg_num;
		input [7:0] value;
		set = {`MOV,`PUR,`NUM,value,`REG,reg_num,`N8};
	endfunction
	function [34:0] move;
		input [7:0] src_reg;
		input [7:0] dst_reg;
		move = {`MOV,`PUR,`REG,src_reg,`REG,dst_reg,`N8};
	endfunction
	function [34:0] jmp;
		input [7:0] addr;
		jmp = {`JMP,`UNC,`N10,`N10,addr};
	endfunction
	function [34:0] atc;
		input [2:0] bit;
		input [7:0] addr;
		atc = {`ATC, bit, `N10, `N10, addr};
	endfunction
	function [34:0] acc_rn;
		input [2:0] op;
		input [7:0] reg_num;
		input [7:0] value;
		acc_rn = {`ACC, op, `REG, reg_num, `NUM, value, `N8};
	endfunction
	function [34:0] set_bit;
		input [7:0] reg_num;
		input [2:0] bit;
		set_bit = {`ACC,`OR,`REG,reg_num,`NUM,8'b1<<bit,`N8};
	endfunction
function [34:0] clr_bit;
		input [7:0] reg_num;
		input [2:0] bit;
		clr_bit = {`ACC,`AND,`REG,reg_num,`NUM,~(8'b1<<bit),`N8};
	endfunction
endmodule

