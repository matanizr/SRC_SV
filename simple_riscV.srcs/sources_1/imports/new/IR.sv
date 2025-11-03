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
    //inout  logic[w-1:0]  bus,   //just for tb
    input  logic         clk, rst,
    input  logic         c1, c2, IRin,
    output logic[4:0]    to_control_unit,
    output logic[2:0]    IR_to_condition_unit,
    
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out,
    output logic[w-1:0]   IR_for_reg
    );
    logic[w-1:0]         out_bus;
    logic[w-1:0]         inst;
    
    assign IR_for_reg = inst;
    assign IR_to_condition_unit = inst[2:0];
    
    always_ff @(posedge clk) begin
        if      (rst)  inst <= '0;
        else if (IRin) inst <= bus_in;
    end
    
    always_comb begin
        out_bus = '0;
        unique case (1'b1)
            c1: out_bus = {{10{inst[21]}}, inst[21:0]};
            c2: out_bus = {{15{inst[16]}}, inst[16:0]};
            default : out_bus = '0;
        endcase
    end
    
    assign to_control_unit = inst[31:27];
    
    assign bus_out = (c1 | c2) ? out_bus : 'bz;      
endmodule
