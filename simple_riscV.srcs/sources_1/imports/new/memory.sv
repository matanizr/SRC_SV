`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2025 14:40:53
// Design Name: 
// Module Name: memory
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

module memory #(
    parameter w = 32,
    parameter mem_size = 1024
    )(    
    //inout  logic[w-1:0]   bus,   //just for tb
    input  logic          clk,
    input  logic          rst,
    input  logic          read, write, Wait,
    input  logic          MAin,
    input  logic          MDout, MDbus,
    
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out,
    
    input  logic[w-1:0]   memory[0:mem_size-1]
    );
    
    localparam            addr_bits = $clog2(mem_size); 
    
    logic[w-1:0]          MD;
    logic[addr_bits-1:0]  MA;    
    
    logic                 strobe;
    assign                strobe = ~Wait;

    always_ff @(posedge clk) begin
        if      (rst)   MA <= '0;
        else if (MAin)  MA <= bus_in[addr_bits-1:0];
    end

    always_ff @(posedge clk) begin
        if      (rst)             MD         <= '0;
        else if (MDbus)           MD         <= bus_in;
        else if (read  && strobe) MD         <= memory[MA];
        else if (write && strobe) memory[MA] <= MD;
    end

    assign bus_out = (MDout) ? MD : 'bz;
endmodule






