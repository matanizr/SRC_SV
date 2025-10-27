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
    parameter int n=32,
    parameter int Ra_MSB = 16, Ra_LSB = 12,
    parameter int Rb_MSB = 21, Rb_LSB = 17,
    parameter int Rc_MSB = 26, Rc_LSB = 22
    )(
    input logic         clk,
    inout logic[w-1:0]  bus,
    input logic[w-1:0]  IR,
    input logic         Gra, Grb, Grc,
    input logic         Rin, Rout, BAout
    //output logic[w-1:0] Ra_check, Rb_check, Rc_check   // just for TB  
    );    
    
    logic [w-1:0]         regs[n-1:0];
    logic [$clog2(n)-1:0] ra, rb, rc;   
    
    //read the register address from the IR 
    assign ra = IR[Ra_MSB:Ra_LSB];    
    assign rb = IR[Rb_MSB:Rb_LSB];
    assign rc = IR[Rc_MSB:Rc_LSB];
    
    logic [$clog2(n)-1:0] addr_sel;
    
    logic[w-1:0]  read_data;
    localparam logic [$clog2(n)-1:0]  R_last = logic'((n-1)); //The register that generates zero
    
    assign bus = (Rout || BAout) ? read_data : 'bz;  
    
    always_comb begin
        addr_sel = '0;
        unique case (1'b1)
            Gra : addr_sel = ra;
            Grb : addr_sel = rb;
            Grc : addr_sel = rc;           
        endcase
    end
    
    always_comb begin
    read_data = regs[addr_sel];
        if (BAout && addr_sel == R_last) read_data = '0;        
    end
    
    always_ff @(posedge clk) begin 
        if (Rin) regs[addr_sel] <= bus;
    end
    
    //assign Ra_check = regs[ra];   // just for TB
    //assign Rb_check = regs[rb];   // just for TB
    //assign Rc_check = regs[rc];   // just for TB
       
endmodule
    








/*
module regfile #(parameter int w=16, n=8)(
    input  logic                 clk,
    input  logic                 we,
    input  logic [$clog2(n)-1:0] ra, rb, wa,
    input  logic [w-1:0]         wd,
    output logic [w-1:0]         rd_a, rd_b
    );
    
    //sinchronic write
    logic [w-1:0] mem [n];
    always_ff @(posedge clk) begin
       if (we) mem[wa] <= wd;   
    end
    
    //asinchronic read
    assign rd_a = mem[ra];
    assign rd_b = mem[rb];
endmodule
*/