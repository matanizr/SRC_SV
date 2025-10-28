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
    //inout  logic[w-1:0] bus,    // just for tb
    input  logic          clk, rst,
    input  logic          ld, decr,
    output logic          n_is_zero,    
    //output logic[4:0]     tb_shifts,     // just for tb
    
    input  logic[w-1:0]   bus_in
    );    
    logic[4:0] shifts;     
    
    //assign tb_shifts = shifts;       // just for tb
    assign n_is_zero = ~(|shifts);   //n=1 for no more shifts
    
    always_ff @(posedge clk) begin
            if      (rst)                shifts <= '0;
            else if (ld)                 shifts <= bus_in[4:0];
            else if (decr & !n_is_zero)  shifts <= shifts - 1;        
    end    
endmodule
