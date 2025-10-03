`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 20:47:17
// Design Name: 
// Module Name: PC_u
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

module PC_u #(parameter w = 32)(
    input logic         clk, rst,
    input logic         PCin, PCout,
    inout logic[w-1:0]  bus
    );
    logic[w-1:0] pc_addr;
    always_ff @(posedge clk) begin
         if (rst)        pc_addr <= '0;
         else if (PCin)  pc_addr <= bus;
    end   
    
    assign bus = PCout ? pc_addr : 'bz;    
endmodule
