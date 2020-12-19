
`include "defenitions.v"

module instr_decode(
    input rst,
    input clk,
    input [31:0] ir_in,
    input [31:0] r1_data,
    input [31:0] r2_data,
    output reg [4:0] r1_addr,
    output reg [4:0] r2_addr,
    output wire [4:0] rd,
    output reg [31:0] op1,
    output reg [31:0] op2,
    output reg [12:0] offset,
    output wire [6:0] opcode,
    output wire [2:0] funct3,
    output wire [6:0] funct7
);

reg [31:0] ir;
wire rs1, rs2;

assign opcode = ir[6:0];
assign rs1 = ir[19:15];
assign rs2 = ir[24:20];
assign rd = ir[11:7];
assign funct3 = ir[14:12];
assign funct7 = ir[31:25];

always @ (posedge clk, posedge rst)
if (rst) ir <= 0;
else if (clk) ir <= ir_in;

always @ (*)
begin
    case (opcode)
    0: begin
        op1 <= 0;
        op2 <= 0;
        offset <= 0;
    end
    `OPCODE_OP: begin
        r1_addr <= rs1;
        op1 <= r1_data;
        r2_addr <= rs2;
        op2 <= r2_data;
    end
    `OPCODE_OP_IMM: begin
        r1_addr <= rs1;
        op1 <= r1_data;
        if (funct3 == `FUNCT3_SLL || funct3 == `FUNCT3_SRLA)
            op2 <= ir[24:20];
        else
            op2 <= { {20{ir[31]}}, ir[31:20] };
    end
    `OPCODE_BRANCH: begin
        r1_addr <= rs1;
        op1 <= r1_data;
        r2_addr <= rs2;
        op2 <= r2_data;
        offset <= { {20{ir[31]}}, ir[11], ir[30:25], ir[11:8], 1'b0 };
    end
    endcase
end

endmodule