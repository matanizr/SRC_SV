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
    input  logic         clk, rst,
    input  logic         Ain, Cin, Cout,
    //input  alu_op_t      op,                //just for tb
    //inout[w-1:0]         bus,                //just for tb
    output logic[w-1:0]  c_check, a_check,
    output logic         Vf, Nf, Zf, Cf,
    
    input  logic          BtoC, Shr, Shl, Shc, Shra, Not, Inc4, Add, Sub, Or, And,
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out
    ); 
    logic[w-1:0] A, B, C;
    logic[w-1:0] result;   
    
    assign B       = bus_in;
    assign c_check = C;
    assign a_check = A;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            A      <= '0;
            C      <= '0;
            result <=  0; end            
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
                                  
            unique case(1'b1)
                Add  : begin
                       sum_ext = {1'b0,A} + {1'b0,B};
                       Cf      <= sum_ext[w];    
                       Vf      <= (A[w-1] == B[w-1]) && (result[w-1] != A[w-1]); end              
                Sub  : begin
                       Cf      <= (A < B);
                       Vf      <= (A[w-1] != B[w-1]) && (result[w-1] != A[w-1]); end            
                Shr  : Cf      <= B[0];
                Shra : Cf      <= B[0];
                Shl  : Cf      <= B[w-1];
                Shc  : Cf      <= B[w-1];
                default : ;           
            endcase 
        end
    end   
    
    assign bus_out = (Cout) ? C : 'bz;    
endmodule


