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

typedef enum logic [3:0]{
    BtoC = 4'b0000,
    shr  = 4'b0001,
    shl  = 4'b0010,
    shc  = 4'b0011,
    shra = 4'b0100,
    Not  = 4'b0101,
    inc4 = 4'b0110,
    add  = 4'b0111,
    sub  = 4'b1000,
    Or   = 4'b1001,
    And  = 4'b1010
} alu_op_t;

module ALU #(parameter int w = 32)(
    input  logic         clk, rst,
    input  logic         Ain, Cin, Cout,
    input  alu_op_t      op,
    inout[w-1:0]         bus,
    output logic[w-1:0]  c_check, a_check
    ); 
    logic[w-1:0] A, B, C;
    logic[w-1:0] result;
    
    assign B       = bus;
    assign c_check = C;
    assign a_check = A;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            A <= '0;
            C <= '0; end
        else begin
            if (Ain) A <= bus;
            if (Cin) C <= result; 
        end
    end
    
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
            default : result = 0;
        endcase 
    end
        
    assign bus = (Cout) ? C : 'bz;    
endmodule







/*
typedef enum logic [3:0]{
    BtoC = 4'b0000,
    shr = 4'b0001,
    shl = 4'b0010,
    shc  = 4'b0011,
    shra = 4'b0100,
    Not = 4'b0101,
    inc4 = 4'b0110,
    add = 4'b0111,
    sub = 4'b1000,
    Or = 4'b1001,
    And = 4'b1010
} alu_op_t;

module ALU_block #(parameter int w = 32)(
    input logic         clk,
    input logic         Ain, Cin, Cout,
    input logic         BtoC_f, shr_f, shl_f, shc_f, shra_f, Not_f, inc4_f, add_f, sub_f, Or_f, And_f,
    inout logic[w-1:0]  bus   
    ); 
    logic[w-1:0]  A_Q, C_D;    
    reg_load #(.w(w)) reg_A(
        .clk(clk), .in(Ain), .D(bus), .Q(A_Q)
    );
    reg_bus_out #(.w(w)) reg_C(
        .clk(clk), .D(C_D), .bus(bus), .in(Cin), .out(Cout)
    );
    alu_op_t op;
    always_comb begin
        op = BtoC;
        unique case (1'b1)
            BtoC_f: op = BtoC;
            shr_f : op = shr;
            shl_f : op = shl;
            shc_f : op = shc;
            shra_f: op = shra;
            Not_f : op = Not;
            inc4_f: op = inc4;
            add_f : op = add;
            sub_f : op = sub;
            Or_f  : op = Or;
            And_f : op = And;
            default: ;
        endcase
    end
    ALU #(.w(w)) U_ALU(
        .A(A_Q), .B(bus), .C(C_D), .op(op)   
    );    

endmodule

module ALU #(parameter int w = 32)(
    input  logic[w-1:0]  A, B,
    input  alu_op_t      op, 
    output logic[w-1:0]  C
    );        
    always_comb begin
        case(op)
            BtoC : C = B;
            shr  : C = B >> 1;
            shl  : C = B << 1;
            shc  : C = {B[w-2:0], B[w-1]};
            shra : C = $signed(B) >>> 1;
            Not  : C = ~B;
            inc4 : C = B + 4;
            add  : C = A + B;
            sub  : C = A - B;
            Or   : C = A | B;
            And  : C = A & B;
            default : C = 0;
        endcase     
    end       
endmodule

module reg_load #(parameter int w = 32)(
    input  logic        clk,    
    input  logic        in,
    input  logic[w-1:0] D,
    output logic[w-1:0] Q
    );
    always_ff @(posedge clk) if (in) Q <= D;
endmodule

module reg_bus_out #(parameter int w = 32)(
    input  logic        clk,    
    input  logic        in, out,
    input  logic[w-1:0] D,
    output logic[w-1:0] Q,
    inout logic[w-1:0] bus
    );
    always_ff @(posedge clk) if (in)  Q <= D;       
    
    assign bus = out ? Q : 'bz;
endmodule*/

    

