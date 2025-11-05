`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : condition unit
// Module Name : con_u
// Description : The condition unit evaluates the opcode and the current bus value to generate the condition signal used for conditional execution
//////////////////////////////////////////////////////////////////////////////////

module con_u #(parameter w = 32)(
    //inout  logic[w-1:0] bus,     //just for tb
    input  logic        clk, rst,  // clock and reset signal
    input  logic        con_in,    //signal to send the condition result to the control unit
    output logic        con_out,   //the condition result to the bus
    
    input  logic[w-1:0] bus_in,    //input from the bus
    input  logic[2:0] op_code      //opcode from the IR defining which condition to check
    );
    logic  s_b;     //sign-bit
    logic  cond;    //condition result
    
    assign s_b  = bus_in[w-1];
    
    /////////condition evaluation determined by the opcode from the IR//////////
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
        if      (rst)     con_out <= 1'b0;     // reset con_out if rst=1
        else if (con_in)  con_out <= cond;     // send the result to the bus if con_in = 1
    end
endmodule

