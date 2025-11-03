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
    output logic[w-1:0]   bus_out  
    
    //ref     logic[w-1:0]   memory[0:mem_size-1],       
    //input   logic[w-1:0]   memory_in[0:mem_size-1],
    //output  logic[w-1:0]   memory_out[0:mem_size-1],
    );        
    logic[w-1:0]          memory[0:mem_size-1];
    localparam            addr_bits = $clog2(mem_size);
    
    initial begin   
    //////test for branch - (Ra = x, Rb =  br, Rc = indicator) -  if(con=1)  Rc = 1;/////    
    /*memory[0] = 32'b00010000010000000000000000000000;
    memory[1] = 32'b00000000000000000000000000000001;
    memory[2] = 32'b00010000100000000000000000000000;
    memory[3] = 32'b00000000000000000000000000001001;    
    memory[4] = 32'b00010000110000000000000000000000;
    memory[5] = 32'b00000000000000000000000000000001;
    memory[6] = 32'b01000000000001000001000000000100;
    memory[7] = 32'b00010000110000000000000000000000;    
    memory[8] = 32'b00000000000000000000000000000000;    
    memory[9] = 32'b11111000000000000000000000000000;*/
    
    
    memory[0] = 32'b00010000010000000000000000000000;
    memory[1] = 32'b00000000000000000000000000000001;
    memory[2] = 32'b00010000100000000000000000000000;
    memory[3] = 32'b00000000000000000000000000001001;  
    memory[4] = 32'b11100000110000100010000000000000;  
    memory[5] = 32'b11111000000000000000000000000000;   
    end 
    
    logic[w-1:0]          MD;
    logic[addr_bits-1:0]  MA;    
    
    logic                 strobe;
    assign                strobe = ~Wait;

    always_ff @(posedge clk) begin
        if      (rst)   MA <= '0;
        else if (MAin)  MA <= bus_in[addr_bits-1:0];
    end
    
    always_ff @(posedge clk) begin
        if      (rst)             MD           <= '0;
        else if (MDbus)           MD           <= bus_in;
        else if (read  & strobe)  MD           <= memory[MA];            
        else if (write & strobe)  memory[MA]   <= MD;
    end

    assign bus_out = (MDout) ? MD : 'bz;
endmodule






