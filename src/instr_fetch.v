
module instr_fetch(
    input rst,
    input clk,
    input pc_set,
    input [31:0] pc_data,
    input [31:0] mem_data,
    output reg [31:0] mem_addr,
    output wire [31:0] ir,
    output reg [31:0] pc
);

assign ir = mem_data;

always @ (posedge clk, posedge rst)
begin
    if (rst) pc = 0;
    else if (clk)
    begin
        if (pc_set)
        begin
            mem_addr <= pc_data;
            pc <= pc_data + 4;
        end
        else
        begin
            mem_addr <= pc;
            pc <= pc + 4;
        end
    end
end

endmodule