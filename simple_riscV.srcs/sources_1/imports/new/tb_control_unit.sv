`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.10.2025 13:17:50
// Design Name: 
// Module Name: tb_control_unit
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


module tb_control_unit;

import alu_op::*;
import opCodesPkg::*;

logic clk = 1, rst = 0, Done = 1, strt = 0;
logic[4:0]  opCode  = 4'b0;
logic[3:0]  countIn = 3'b0;

always #5 clk = ~clk;

clocking cb @(posedge clk);
    default input #1step output #0; 
    output clk, rst, Done, strt, opCode, countIn; 
endclocking

control_unit dut (
    .clk(clk), .rst(rst), .Done(Done), .strt(strt), .opCode
);

initial begin
                                   @(cb);
    cb.rst    <= 1;                @(cb);
    cb.rst    <= 0;
    cb.strt   <= 1;                @(cb);
    cb.strt   <= 0;
    cb.opCode <= ADD;    repeat(9) @(cb);
    cb.opCode <= STOP;   repeat(4) @(cb);          
    $finish;    
end


endmodule
