`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 19:44:36
// Design Name: 
// Module Name: control_unit
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
import opCodesPkg::*;

module counter  (
    input  logic          enable, load, rst, clk,
    input  logic[3:0]     countIn,
    output logic[3:0]     count
    );
        
    always_ff @(posedge clk) begin
        if      (rst)    count <= 4'b0000;
        else if (load)   count <= countIn;
        else if (enable) count <= (count == 4'd15) ? 4'd0 : count + 1;
    end    
endmodule

module control_step_decoder (
    input  logic[3:0]  count,
    output logic[15:0] T 
    );
    always_comb begin
        T        = 16'b0;
        T[count] = 1'b1;
    end    
endmodule

module decoder (
    input  logic[4:0]            opCode,    
    output logic[n_ops_max-1:0]  op
    );
    always_comb begin
        op = '0;
        unique case(opCode)
            LD   : op[1]  = 1;
            LDR  : op[2]  = 1;
            ST   : op[3]  = 1;
            STR  : op[4]  = 1;
            LA   : op[5]  = 1;
            LAR  : op[6]  = 1;
            BR   : op[8]  = 1;
            BRL  : op[9]  = 1;
            ADD  : op[12] = 1;
            ADDI : op[13] = 1;
            SUB  : op[14] = 1;
            NEG  : op[15] = 1;
            AND  : op[20] = 1;
            ANDI : op[21] = 1;
            OR   : op[22] = 1;
            ORI  : op[23] = 1;
            NOT  : op[24] = 1;
            SHR  : op[26] = 1;
            SHRA : op[27] = 1;
            SHL  : op[28] = 1;
            SHC  : op[29] = 1;
        endcase 
    end    
endmodule

module control_unit(
    input              clk, rst, Done, strt, stop,  
    input  logic[3:0]  countIn,
    input  logic[4:0]  opCode,
    output logic[34:0] ctrl_signals
    );
    logic       read, write, Wait;
    logic       Enable, R, W;
    logic       loadCounter;
    logic[3:0]  count;
    logic[15:0] T;
    
    clocking_logic  clk_logic(
        .clk(clk), .rst(rst), .read(read), .write(write), .Wait(Wait), .Done(Done), .strt(strt), .stop(stop),
        .Enable(Enable), .R(R), .W(W)
    );    
    
    counter  ctr(
        .clk(clk), .rst(rst), .enable(Enable), .load(loadCounter), .countIn(countIn), .count(count)
    );
    
    control_step_decoder  ctrl_stp_dcdr(
        .count(count), .T(T)
    );
    
    control_sginal_encoder  ctrl_sig_encdr (
        .T(T), .opCode(opCode), .ctrl_signals(ctrl_signals)
    );
    
    
endmodule 


module control_sginal_encoder (
    input  logic[15:0] T,
    input  logic[4:0]  opCode,
    output logic[34:0] ctrl_signals
    );
    logic Gra, Grb, Grc, Rin, Rout, BAout, CtoB, Shr, Shl, Shc, Shra, Not, Inc4, Add, Sub, Or, And, Ain, Cin, Cout;
    logic CONin, IRin, C1out, C2out, PCin, PCout, MAin, MDout, MDbus, Read, Write, Wait, Ld, Decr;
    logic End;
    

    
    
    always_comb begin    
        ////////rst all the ctrl signals/////
        ctrl_signals = '0;
        Gra=0; Grb=0; Grc=0; Rin=0; Rout=0; BAout=0; CtoB=0; Shr=0; Shl=0; Shc=0; Shra=0; Not=0;
        Inc4=0; Add=0; Sub=0; Or=0; And=0; Ain=0; Cin=0; Cout=0; CONin=0; IRin=0; C1out=0; C2out=0;
        PCin=0; PCout=0; MAin=0; MDout=0; MDbus=0; Read=0; Write=0; Wait=0; Ld=0; Decr=0; End=0;
        
        ////////////////fetch//////////////////////////////      
        if (T[0]) begin
            PCout = 1; MAin  = 1; Inc4  = 1; Cin   = 1;  end                
        if (T[1]) begin
            Read  = 1; Wait  = 1; Cout  = 1; PCin  = 1; end            
        if (T[2]) begin
            MDout  = 1; IRin  = 1; end    
                                 
        ////////////////add////////////////////////////////        
        if (T[3] && opCode == ADD) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && opCode == ADD) begin
            Grc = 1; Rout = 1; Add = 1; Cin = 1; end                
        if (T[5] && opCode == ADD) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end            
        
        
        
        ////////Generated Control Signals///////////////////
        ctrl_signals[0]  = Gra; 
        ctrl_signals[1]  = Grb;
        ctrl_signals[2]  = Grc;
        ctrl_signals[3]  = Rin;
        ctrl_signals[4]  = Rout;
        ctrl_signals[5]  = BAout;
        ctrl_signals[6]  = CtoB;
        ctrl_signals[7]  = Shr;
        ctrl_signals[8]  = Shl;
        ctrl_signals[9]  = Shc;
        ctrl_signals[10] = Shra;
        ctrl_signals[11] = Not;
        ctrl_signals[12] = Inc4;
        ctrl_signals[13] = Add;
        ctrl_signals[14] = Sub;
        ctrl_signals[15] = Or;
        ctrl_signals[16] = And;
        ctrl_signals[17] = Ain;
        ctrl_signals[18] = Cin;
        ctrl_signals[19] = Cout;
        ctrl_signals[20] = CONin;
        ctrl_signals[21] = IRin;
        ctrl_signals[22] = C1out;
        ctrl_signals[23] = C2out;
        ctrl_signals[24] = PCin;
        ctrl_signals[25] = PCout;
        ctrl_signals[26] = MAin;
        ctrl_signals[27] = MDout;
        ctrl_signals[28] = MDbus;
        ctrl_signals[29] = Read;
        ctrl_signals[30] = Write;
        ctrl_signals[31] = Wait;
        ctrl_signals[32] = Ld;
        ctrl_signals[33] = Decr;
        ctrl_signals[34] = End;
    end    
endmodule









