`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2025 02:02:04
// Design Name: 
// Module Name: shift_control
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


module shift_control #(parameter w = 32) (
    inout  logic[w-1:0] bus,
    input  logic       clk,
    input  logic       ld, decr, rst,
    output logic       n,
    
    output logic[4:0]  tb_shifts     // just for tb
    );
    logic[4:0] shifts;    
    
    assign tb_shifts = shifts;       // just for tb
    assign n         = ~(|shifts);   //n=1 for no more shifts
    
    always_ff @(posedge clk) begin
            if      (rst)         shifts <= '0;
            else if (ld)          shifts <= bus[4:0];
            else if (decr && !n)  shifts <= shifts - 1;        
    end    
endmodule
