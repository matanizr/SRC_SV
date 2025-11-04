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
    rst = 1;                         @(posedge clk);
    rst = 0;  strt = 1;              @(posedge clk);
    strt = 0;            repeat(3000) @(posedge clk); 
    $display("finish");  
    $finish;
end
endmodule



/*module tb_control_unit;

import opCodesPkg::*;

logic         clk        = 1'b1;
logic         rst        = 1'b0;
logic         Done       = 1'b1;
logic         strt       = 1'b0;
logic         con        = 1'b0;
logic         n_is_zero  = 1'b0;
logic [4:0]   opCode     = '0;
logic [36:0]  ctrl_signals;

always #5 clk = ~clk;

clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, Done, strt, opCode, con, n_is_zero;
    input  ctrl_signals;
endclocking

control_unit dut (
    .clk(clk),
    .rst(rst),
    .Done(Done),
    .strt(strt),
    .con(con),
    .n_is_zero(n_is_zero),
    .opCode(opCode),
    .ctrl_signals(ctrl_signals)
);

initial begin

    @(cb);
    cb.rst      <= 1;              @(cb);
    cb.rst      <= 0;
    cb.strt     <= 1;              @(cb);
    cb.strt     <= 0;

    cb.opCode   <= LDR;    repeat (8) @(cb);
    cb.opCode   <= ADD;    repeat (6) @(cb);
    cb.opCode   <= SUB;    repeat (6) @(cb);
    cb.opCode   <= STOP;   repeat (4) @(cb);
    $finish;
end

always @(posedge clk) begin
    $display("%0t ctrl_signals = %b", $time, ctrl_signals);
end


endmodule*/