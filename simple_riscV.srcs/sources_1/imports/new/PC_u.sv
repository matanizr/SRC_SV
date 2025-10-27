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
    logic        PCout_q;
        
    always_ff @(posedge clk) begin
         if (rst) begin
            pc_addr  <= '0;
            PCout_q  <= 1'b0; end     
         else begin
            PCout_q           <= PCout;
            if (PCin) pc_addr <= bus; end          
    end
        
    assign bus = PCout_q ? pc_addr : 'bz;    
endmodule
