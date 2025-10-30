`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2025 00:30:48
// Design Name: 
// Module Name: tb_SRC
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


module tb_SRC;

logic[31:0]   memory[0:1023];
logic clk = 1, rst = 0, strt = 0;


always #5 clk = ~clk;

SRC_top dut (
    .rst(rst),
    .clk(clk),
    .strt(strt) );

    
initial begin     
    rst = 1;                        @(posedge clk);
    rst = 0;  strt = 1;             @(posedge clk);
    strt = 0;            repeat(50) @(posedge clk);  
    $display("finish");  
    $finish;
end
endmodule

