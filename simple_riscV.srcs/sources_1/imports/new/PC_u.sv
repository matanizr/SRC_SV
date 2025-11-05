`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : program count register
// Module Name : PC_u
// Description : the PC holds the address for the next instruction in the program
//////////////////////////////////////////////////////////////////////////////////

module PC_u #(parameter w = 32)(
    input logic         clk, rst,   //clock and reset signal
    input logic         PCin, PCout, //signals for PC-in and PC-out
    //inout logic[w-1:0]  bus,        //just for tb
    
    input  logic[w-1:0]   bus_in,    //input from the bus
    output logic[w-1:0]   bus_out    //output to the bus
    );    
    logic[w-1:0] pc_addr;
        
    always_ff @(posedge clk) begin
         if      (rst)  pc_addr <= '0;     //reset the address inside the PC
         else if (PCin) pc_addr <= bus_in;  //get address from the bus to the PC register when PCin=1
    end
        
    assign bus_out = PCout ? pc_addr : 'bz;   //send to the bus the address inside the PC register
endmodule
