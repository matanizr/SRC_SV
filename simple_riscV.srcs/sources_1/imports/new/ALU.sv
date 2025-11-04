`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2025 15:13:03
// Design Name: 
// Module Name: ALU
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

module ALU #(parameter int w = 32)(
    input  logic          clk, rst,
    input  logic          Ain, Cin, Cout,
    input  logic          BtoC, Shr, Shl, Shc, Shra, Not, Inc4, Add, Sub, Or, And,
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out
    //input  alu_op_t      op,                 //just for tb
    //inout[w-1:0]         bus,                //just for tb
    //output logic[w-1:0]  c_check, a_check,   //just for tb
    ); 
    logic[w-1:0] A, B, C;
    logic[w-1:0] result;   
    
    assign B       = bus_in;
    //assign c_check = C;                      //just for tb
    //assign a_check = A;                      //just for tb
    
    always_ff @(posedge clk) begin
        if (rst) begin
            A      <= '0;
            C      <= '0; end            
        else begin
            if (Ain) A <= bus_in;
            if (Cin) C <= result; 
        end
    end    
    
    //arithmetical op
    always_comb begin
        unique case(1'b1)
            BtoC : result = B;
            Shr  : result = B >> 1;
            Shl  : result = B << 1;
            Shc  : result = {B[w-2:0], B[w-1]};
            Shra : result = $signed(B) >>> 1;
            Not  : result = ~B;
            Inc4 : result = B + 1;
            Add  : result = A + B;             
            Sub  : result = A - B;
            Or   : result = A | B;
            And  : result = A & B;           
            default : result = '0; 
        endcase 
    end
        
    assign bus_out = (Cout) ? C : 'bz;    
endmodule
