`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2025 14:09:59
// Design Name: 
// Module Name: opCodesPkg
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

package opCodesPkg;

localparam int n_ops_max = 32;
localparam int opc_w = 5;

  typedef enum logic [opc_w-1:0] {
    //NOP  = 5'd0,
    LD   = 5'd1,
    LDR  = 5'd2,
    ST   = 5'd3,
    STR  = 5'd4,
    LA   = 5'd5,
    LAR  = 5'd6,
    BR   = 5'd8,
    BRL  = 5'd9,
    //EEN  = 5'd10,
    //EDI  = 5'd11,
    ADD  = 5'd12,
    ADDI = 5'd13,
    SUB  = 5'd14,
    NEG  = 5'd15,
    //SVI  = 5'd16,
    //RI   = 5'd17,
    AND  = 5'd20,
    ANDI = 5'd21,
    OR   = 5'd22,
    ORI  = 5'd23,
    NOT  = 5'd24,
    SHR  = 5'd26,
    SHRA = 5'd27,
    SHL  = 5'd28,
    SHC  = 5'd29
    //RFI  = 5'd30,
    //STOP = 5'd31
  } opcode_e;

endpackage : opCodesPkg



