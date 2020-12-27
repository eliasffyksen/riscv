
module instr_mem(
    input clk,
    input rst,
    input load,
    input store,
    input [4:0] rs,
    input [31:0] addr,
    input  [31:0] mem_in,
    input [31:0] reg_data,
    output reg [4:0] reg_addr,
    output reg mem_wen,
    output reg mem_ren,
    output reg mem_addr,
    output reg [31:0] mem_out,
    output reg [4:0] rd,
    output [31:0] rd_data
);

assign mem_out = reg_data;
assign rd_data = mem_in;

always @ (posedge clk, posedge rst)
if (rst) begin
    mem_wen <= 0;
    mem_ren <= 0;
    rd <= 0;
end else if(clk) begin
    mem_addr <= addr;
    if (store) begin
        mem_ren <= 0;
        mem_wen <= 1;
        rd <= 0;
        reg_addr <= rs;
    end else if (load) begin
        mem_ren <= 1;
        mem_wen <= 0;
        rd <= rs;
        reg_addr <= 0;
    end else begin
        mem_ren <= 0;
        mem_wen <= 0;
        rd <= 0;
    end
end

endmodule;
