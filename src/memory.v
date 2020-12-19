
module memory(
    input clk,
    input [31:0] data_in,
    input [31:0] addr,
    input mem_ren,
    input mem_wen,
    output reg [31:0] data_out
);

reg [7:0] m [0:1023];

always @ (mem_ren, addr)
    if (mem_ren) data_out <= { m[addr + 3], m[addr + 2], m[addr + 1], m[addr] };

endmodule
