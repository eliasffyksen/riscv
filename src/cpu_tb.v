
module cpu_tb ();

wire [31:0] mem_data_in;
wire [31:0] mem_addr;
wire mem_ren;
wire mem_wen;
wire [31:0] mem_data_out;

reg clk;
reg rst;
initial clk = 0;
always #50 clk = !clk;

initial begin
    rst = 1;
    #75 rst = 0;
end

memory mem (
    .clk(clk),
    .data_in(mem_data_in),
    .addr(mem_addr),
    .mem_ren(mem_ren),
    .mem_wen(mem_wen),
    .data_out(mem_data_out)
);

cpu cpu (
    .data_in(mem_data_out),
    .rst(rst),
    .clk(clk),
    .addr(mem_addr),
    .data_out(mem_data_in),
    .mem_ren(mem_ren),
    .mem_wen(mem_wen)
);

initial begin
    $readmemh("source_files/test1.hex", mem.m);
    $dumpfile("cpu_tb.vcd");
    $dumpvars;
    #1000 $finish;
end

endmodule