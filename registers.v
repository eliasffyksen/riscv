
module registers (
    input rst,
    input clk,
    input [4:0] r1_addr,
    input [4:0] r2_addr,
    input [4:0] rd1_addr, // Write back from exec
    input [4:0] rd2_addr, // Write back from mem
    input [31:0] rd1_data,
    input [31:0] rd2_data,
    output reg [31:0]  r1_data,
    output reg [31:0]  r2_data
);

reg [31:0] r [0:31];

always @ (r1_addr, rd2_addr, rd2_data, rd1_addr, rd1_data)
    if (r1_addr == 0) r1_data <= 0;
    else if (r1_addr == rd2_addr) r1_data <= rd2_data;
    else if (r1_addr == rd1_addr) r1_data <= rd1_data;
    else r1_data <= r[r1_addr];

always @ (r2_addr, rd2_addr, rd2_data, rd1_addr, rd1_data)
    if (r2_addr == 0) r2_data <= 0;
    else if (r2_addr == rd2_addr) r2_data <= rd2_data;
    else if (r2_addr == rd1_addr) r2_data <= rd1_data;
    else r2_data <= r[r2_addr];

reg [6:0] i;
always @ (posedge clk, posedge rst)
if (rst)
    for (i = 0; i < 32; i++) r[i] <= 0;
else if (clk) begin
    if (rd1_addr) r[rd1_addr] <= rd1_data;
    if (rd2_addr) r[rd2_addr] <= rd2_data;
end

endmodule