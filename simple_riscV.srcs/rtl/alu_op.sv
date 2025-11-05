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
    typedef enum logic [10:0]{
        BtoC_ = 11'b10000000000,
        shr_  = 11'b01000000000,
        shl_  = 11'b00100000000,
        shc_  = 11'b00010000000,
        shra_ = 11'b00001000000,
        Not_  = 11'b00000100000,
        inc4_ = 11'b00000010000,
        add_  = 11'b00000001000,
        sub_  = 11'b00000000100,
        Or_   = 11'b00000000010,
        And_  = 11'b00000000001
    } alu_op_t;
endpackage : alu_op


