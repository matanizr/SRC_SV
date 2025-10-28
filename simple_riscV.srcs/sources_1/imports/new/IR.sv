`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2025 00:31:20
// Design Name: 
// Module Name: IR
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

module IR #(parameter w = 32) (
    inout  logic[w-1:0]  bus,   //just for tb
    input  logic         clk, rst,
    input  logic         c1, c2, IRin,
    output logic[4:0]    to_control_unit,
    
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out     
    );
    logic[w-1:0]         out_bus;
    logic[w-1:0]         inst;
    
    always_ff @(posedge clk) begin
        if      (rst)  inst <= '0;
        else if (IRin) inst <= bus;
    end
    
    always_comb begin
        out_bus = '0;
        unique case (1'b1)
            c1 : begin
                 out_bus[21:0]  = inst[21:0];
                 out_bus[31:22] = {10{inst[21]}}; end
            c2 : begin
                 out_bus[16:0]  = inst[16:0];
                 out_bus[31:17] = {15{inst[16]}}; end
            default : /*no state been chose*/;
        endcase
    end
    
    assign to_control_unit = inst[31:27];
    
    assign bus = (c1 || c2) ? out_bus : 'bz;      
endmodule
