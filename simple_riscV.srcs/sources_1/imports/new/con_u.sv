`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.09.2025 17:10:21
// Design Name: 
// Module Name: con_u
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

module con_u #(parameter w = 32)(
    //inout  logic[w-1:0] bus,     //just for tb
    input  logic        clk, rst,
    input  logic        con_in,
    output logic        con_out,
    
    input  logic[w-1:0] bus_in,
    input  logic[2:0] op_code
    );
    logic        s_b;
    logic        cond;
    
    assign       s_b     = bus_in[w-1];
    
    always_comb begin 
        unique case(op_code)
            3'd0 : cond = 0;
            3'd1 : cond = 1;
            3'd2 : cond = ~(|bus_in);
            3'd3 : cond = (|bus_in);
            3'd4 : cond = ~s_b;
            3'd5 : cond = s_b;
            default : cond = 1'b0;
        endcase
    end    

    always_ff @(posedge clk) begin
        if      (rst)     con_out <= 1'b0;
        else if (con_in)  con_out <= cond;
    end
endmodule

