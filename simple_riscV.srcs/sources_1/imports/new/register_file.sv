`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 22:37:14
// Design Name: 
// Module Name: register_file
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


module regfile #(
    parameter int w=32,
    parameter int n=32
    )(
    input logic         clk,
    //inout logic[w-1:0]  bus,              //just to tb
    input logic         Gra, Grb, Grc,
    input logic         Rin, Rout, BAout,
    input logic[4:0]    ra, rb, rc,
    //output logic[w-1:0] Ra_check, Rb_check, Rc_check   // just for TB 
    
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out     
    );    
    
    logic[w-1:0]          regs[n-1:0];    
    logic[$clog2(n)-1:0]  addr_sel;    
    logic[w-1:0]          read_data;
    
    always_comb begin
        addr_sel = '0;
        unique0 case (1'b1)
            Gra : addr_sel = ra;
            Grb : addr_sel = rb;
            Grc : addr_sel = rc;           
        endcase
    end
    
    always_comb begin
    read_data = regs[addr_sel];
        if (BAout && addr_sel == 0) read_data = '0;        
    end
    
    always_ff @(posedge clk) begin 
        if (Rin) regs[addr_sel] <= bus_in;
    end
    
    assign bus_out = (Rout || BAout) ? read_data : 'bz;  
    
    //assign Ra_check = regs[ra];   // just for TB
    //assign Rb_check = regs[rb];   // just for TB
    //assign Rc_check = regs[rc];   // just for TB
       
endmodule
    