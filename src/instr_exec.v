
`include "defenitions.v"

module instr_exec(
    input clk,
    input rst,
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] op1,
    input [31:0] op2,
    input [12:0] offset,
    input [31:0] pc,
    input [4:0] rd,
    output reg [4:0] reg_addr,
    output reg [31:0] reg_data,
    output reg [31:0] mem_addr,
    output reg mem_ren,
    output reg mem_wen,
    output reg [31:0] pc_data,
    output reg pc_set,
    output reg load,
    output reg store,
    output reg addr,
    output reg rs // Register source passed to instr_mem
);

always @ (posedge clk, posedge rst)
if (rst) begin
    reg_addr <= 0;
    pc_set <= 0;
end
else if (clk) begin
    case (opcode)
    0, default: begin
        mem_wen <= 0;
        mem_ren <= 0;
        reg_addr <= 0;
        pc_set <= 0;
        load <= 0;
        store <= 0;
    end
    `OPCODE_OP, `OPCODE_OP_IMM: begin
        reg_addr <= rd;
        pc_set <= 0;
        load <= 0;
        store <= 0;
        case (funct3)
        `FUNCT3_ADDSUB:
            if (!funct7) reg_data <= op1 + op2; // ADD
            else reg_data <= op1 + ~op2 + 1'b1; // SUB
        `FUNCT3_SLL: reg_data <= op1 << op2[4:0];
        `FUNCT3_SLT: reg_data <= ($signed(op1) < $signed(op2)) ? 1 : 0;
        `FUNCT3_SLTU: reg_data <= (op1 < op2) ? 1 : 0;
        `FUNCT3_XOR: reg_data <= op1 ^ op2;
        `FUNCT3_SRLA:
            if (!funct7) reg_data <= op1 >> op2[4:0]; // SRL
            else reg_data <= op1 >>> op2[4:0]; // SRA
        `FUNCT3_OR: reg_data <= op1 | op2;
        `FUNCT3_AND: reg_data <= op1 & op2;
        endcase
    end
    `OPCODE_BRANCH: begin
        reg_addr <= 0;
        pc_data <= pc + { {19{offset[12]}}, offset[12:0] };
        load <= 0;
        store <= 0;
        case (funct3)
        `FUNCT3_EQ: pc_set <= op1 == op2;
        `FUNCT3_NE: pc_set <= op1 != op2;
        `FUNCT3_LT: pc_set <= $signed(op1) < $signed(op2);
        `FUNCT3_GE: pc_set <= $signed(op2) >= $signed(op2);
        `FUNCT3_LTU: pc_set <= op1 < op2;
        `FUNCT3_GEU: pc_set <= op1 >= op2;
        default: pc_set <= 0;
        endcase
    end
    `OPCODE_LOAD: begin
        load <= 1;
        store <= 0;
        rs <= rd;
        addr <= pc + offset;
    end
    endcase
end

endmodule