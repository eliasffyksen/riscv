
`define STATE_NONE 3'b000
`define STATE_FETCH 3'b001
`define STATE_DECODE 3'b010
`define STATE_EXEC 3'b011

module cpu(
    input [31:0] data_in,
    input rst,
    input clk,
    output wire [31:0] addr,
    output wire [31:0] data_out,
    output wire mem_ren,
    output wire mem_wen
);

wire fetch;
wire decode;
wire execute;
reg [2:0] state;
reg [2:0] next_state;

wire [31:0] fetch_ir, fetch_pc;

wire [4:0] r1_addr, r2_addr, rd1_addr, rd2_addr, decode_rd;
wire [31:0] r1_data, r2_data, rd1_data, rd2_data, decode_op1, decode_op2;
wire [12:0] decode_offset;
wire [6:0] decode_opcode, decode_funct7;
wire [2:0] decode_funct3;

assign fetch = state == `STATE_FETCH;
assign decode = state == `STATE_DECODE;
assign execute = state == `STATE_EXEC;

assign mem_ren = fetch;
assign mem_wen = 1'b0;
assign data_out = 0;

always @ (posedge clk, posedge rst)
    if (rst) state <= `STATE_NONE;
    else if (clk) state <= next_state;

always @ (*)
    case (state)
    `STATE_FETCH: next_state <= `STATE_DECODE;
    `STATE_DECODE: next_state <= `STATE_EXEC;
    `STATE_EXEC: next_state <= `STATE_FETCH;
    default: next_state <= `STATE_FETCH;
    endcase

registers registers (
    .rst(rst),
    .clk(clk),
    .r1_addr(r1_addr),
    .r2_addr(r2_addr),
    .rd1_addr(rd1_addr),
    .rd2_addr(rd2_addr),
    .rd1_data(rd1_data),
    .rd2_data(rd2_data),
    .r1_data(r1_data),
    .r2_data(r2_data)
);

instr_fetch instr_fetch (
    .clk(fetch),
    .rst(rst),
    .pc_set(1'b0),
    .pc_data(32'b0),
    .mem_data(data_in),
    .mem_addr(addr),
    .ir(fetch_ir),
    .pc(fetch_pc)
);

instr_decode instr_decode (
    .clk(decode),
    .rst(rst),
    .ir_in(fetch_ir),
    .r1_data(r1_data),
    .r2_data(r2_data),
    .r1_addr(r1_addr),
    .r2_addr(r2_addr),
    .rd(decode_rd),
    .op1(decode_op1),
    .op2(decode_op2),
    .offset(decode_offset),
    .opcode(decode_opcode),
    .funct3(decode_funct3),
    .funct7(decode_funct7)
);

instr_exec instr_exec (
    .clk(execute),
    .rst(rst),
    .opcode(decode_opcode),
    .funct3(decode_funct3),
    .funct7(decode_funct7),
    .op1(decode_op1),
    .op2(decode_op2),
    .offset(decode_offset),
    .pc(fetch_pc),
    .rd(decode_rd),
    .reg_addr(rd1_addr),
    .reg_data(rd1_data)
);

endmodule