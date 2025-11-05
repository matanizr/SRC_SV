`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : general-purpose registers unit
// Module Name : regfile
// Description : The register file stores the CPU’s general-purpose registers and provides fast read and write access to them
//////////////////////////////////////////////////////////////////////////////////


module regfile #(
    parameter int w=32,      //bus width
    parameter int n=32       // number of registers
    )(
    input logic         clk,
    //inout logic[w-1:0]  bus,              //just to tb
    input logic         Gra, Grb, Grc,      //signals that point to the correct register to use
    input logic         Rin, Rout, BAout,
    input logic[4:0]    ra, rb, rc,         //the registers in the operation
    
    input  logic[w-1:0]   bus_in,           //input from the bus
    output logic[w-1:0]   bus_out           //output to the bus
    );     
    
    logic[w-1:0]          regs[n-1:0];      //the registers (32 x 4 bytes)
    logic[$clog2(n)-1:0]  addr_sel;         //point ra/rb/rc
    logic[w-1:0]          read_data;
    
    always_comb begin
        addr_sel = '0;
        unique0 case (1'b1)                //select the register according to the input signals
            Gra : addr_sel = ra;
            Grb : addr_sel = rb;
            Grc : addr_sel = rc;           
        endcase
    end
    
    always_comb begin
    read_data = regs[addr_sel];                        //take the data from the chosen register
        if (BAout && addr_sel == 0) read_data = '0;    //sends zero when BAout is used (instead of Rout) to read from register 0    
    end
    
    always_ff @(posedge clk) begin 
        if (Rin) regs[addr_sel] <= bus_in;             //write to the register on posedge clock if Rin=1
    end
    
    assign bus_out = (Rout || BAout) ? read_data : 'bz;  //send read_data to the bus if Rout=1 or BAout=1
       
endmodule
    