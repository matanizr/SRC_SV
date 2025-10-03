`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 22:39:33
// Design Name: 
// Module Name: tb_register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_register_file;
localparam int w=16, n=8;
logic                 clk=0, we=0;
logic [$clog2(n)-1:0] ra, rb, wa;
logic [w-1:0]         wd, rd_a, rd_b;

always #5 clk = ~clk;
regfile #(.w(w), .n(n)) dut (.*);
initial begin
    //write R3=100, R5=7
    ra = 3; rb = 5; @(posedge clk);
    wd=16'd100; wa=3; we=1; @(posedge clk); we=0;
    wd=16'd7  ; wa=5; we=1; @(posedge clk); we=0;   
    
    //assert (rd_a == 16'd100 && rd_b == 16'd7) else $error("read fail");    
    if (rd_a == 16'd100 && rd_b == 16'd7) 
        $display("success");
    else 
        $display("fail");     
    @(posedge clk) 
$finish;
end
endmodule
