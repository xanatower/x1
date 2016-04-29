// Command Group
`define NOP 4'b0000
`define JMP 4'b1000
`define ATC 4'b0100
`define MOV 4'b0010
`define ACC 4'b0001

// Command (JMP)
`define UNC 3'b000
`define EQ  3'b010
`define ULT 3'b100
`define SLT 3'b101
`define ULE 3'b110
`define SLE 3'b111

// Command (MOV)
`define PUR 3'b000
`define SHL 3'b001
`define SHR 3'b010

// Command (ACC)
`define UAD 3'b000
`define SAD 3'b001
`define UMT 3'b010
`define SMT 3'b011
`define AND 3'b100
`define OR  3'b101
`define XOR 3'b110

// Argument Type
`define NUM 2'b00
`define REG 2'b01
`define IND 2'b10

// Zeros
`define N8  8'd0
`define N10 10'd0

// Special Registers (8-bit version for instructions only)
`define DINP 8'd28
`define GOUT 8'd29
`define DOUT 8'd30
`define FLAG 8'd31

// Bits in Special Registers
`define DVAL 3'd7
`define SHFT 3'd5
`define OFLW 3'd4
`define SMPL 3'd3
