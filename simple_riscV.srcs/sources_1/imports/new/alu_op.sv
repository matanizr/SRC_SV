`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2025 14:45:09
// Design Name: 
// Module Name: alu_op
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

parameter int n_ops_alu = 11;

package alu_op;
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
endpackage : alu_op


