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

import alu_op::*;

module ALU #(parameter int w = 32)(
    input  logic         clk, rst,
    input  logic         Ain, Cin, Cout,
    input  alu_op_t      op,
    inout[w-1:0]         bus,
    output logic[w-1:0]  c_check, a_check,
    output logic         Vf, Nf, Zf, Cf
    ); 
    logic[w-1:0] A, B, C;
    logic[w-1:0] result;    
    
    assign B       = bus;
    assign c_check = C;
    assign a_check = A;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            A      <= '0;
            C      <= '0;
            result <=  0; end            
        else begin
            if (Ain) A <= bus;
            if (Cin) C <= result; 
        end
    end
    
    //arithmetical op
    always_comb begin
        unique case(op)
            BtoC : result = B;
            shr  : result = B >> 1;
            shl  : result = B << 1;
            shc  : result = {B[w-2:0], B[w-1]};
            shra : result = $signed(B) >>> 1;
            Not  : result = ~B;
            inc4 : result = B + 4;
            add  : result = A + B;             
            sub  : result = A - B;
            Or   : result = A | B;
            And  : result = A & B;
            
            default : result = '0; 
        endcase 
    end
    
    //flags
    logic[w:0] sum_ext;
    
    always_ff @(posedge clk) begin
        if (rst) begin 
            Zf <= 1'b1;
            Nf <= 1'b0;
            Cf <= 1'b0;
            Vf <= 1'b0; 
        end        
        else if(Cin) begin            
            Zf <= (result == '0);
            Nf <= (result[w-1]); 
            Cf <= 1'b0;
            Vf <= 1'b0;
                                  
            unique case(op)
                add  : begin
                       sum_ext = {1'b0,A} + {1'b0,B};
                       Cf      <= sum_ext[w];    
                       Vf      <= (A[w-1] == B[w-1]) && (result[w-1] != A[w-1]); end              
                sub  : begin
                       Cf      <= (A < B);
                       Vf      <= (A[w-1] != B[w-1]) && (result[w-1] != A[w-1]); end            
                shr  : Cf      <= B[0];
                shra : Cf      <= B[0];
                shl  : Cf      <= B[w-1];
                shc  : Cf      <= B[w-1];
                default : ;           
            endcase 
        end
    end   
    
    assign bus = (Cout) ? C : 'bz;    
endmodule


