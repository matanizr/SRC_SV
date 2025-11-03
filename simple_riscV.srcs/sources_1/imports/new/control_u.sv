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

//import alu_op::*;
import opCodesPkg::*;

module counter  (
    input  logic        enable, load, rst, clk, End,
    output logic[3:0]   count
    );
        
    always_ff @(posedge clk) begin
        if      (rst | End)        count <= 4'b0000;
        else if (load)             count <= 4'b0110;
        else if (enable & !load)   count <= (count == 4'd15) ? 4'd0 : count + 1;
    end    
endmodule

module control_step_decoder (
    input  logic[3:0]   count,
    output logic[15:0]  T 
    );
    always_comb begin
        T        = 16'b0;
        T[count] = 1'b1;
    end    
endmodule

module decoder (
    input  logic[4:0]   opCode,    
    output logic[31:0]  op
    );
    always_comb begin
        op = '0;
        op[opCode] = 1;
    end    
endmodule

module control_signal_encoder (
    input  logic[15:0]  T,
    input  logic[31:0]  op,
    input  logic        con,
    input  logic        n_is_zero,
    output logic[36:0]  ctrl_signals
    );
    logic Gra, Grb, Grc, Rin, Rout, BAout, BtoC, Shr, Shl, Shc, Shra, Not, Inc4, Add, Sub, Or, And, Ain, Cin, Cout;
    logic CONin, IRin, C1out, C2out, PCin, PCout, MAin, MDout, MDbus, Read, Write, Wait, Ld, Decr, Goto6, Stop;
    logic End;
    
    always_comb begin    
        ////////rst all the ctrl signals/////
        ctrl_signals = '0;
        Gra=0; Grb=0; Grc=0; Rin=0; Rout=0; BAout=0; BtoC=0; Shr=0; Shl=0; Shc=0; Shra=0; Not=0;
        Inc4=0; Add=0; Sub=0; Or=0; And=0; Ain=0; Cin=0; Cout=0; CONin=0; IRin=0; C1out=0; C2out=0;PCin=0; 
        PCout=0; MAin=0; MDout=0; MDbus=0; Read=0; Write=0; Wait=0; Ld=0; Decr=0; End=0; Goto6=0; Stop=0;
        
        ////////////////fetch//////////////////////////////      
        if (T[0]) begin
            PCout = 1; MAin  = 1; Inc4  = 1; Cin   = 1;  end                
        if (T[1]) begin
            Read  = 1; Cout  = 1; PCin  = 1; end            
        if (T[2]) begin
            MDout  = 1; IRin  = 1; end    
        
        ///////////////stop////////////////////////////////
        if (T[3] && op[STOP] == 1) begin
            Stop = 1; end                        
        ////////////////add////////////////////////////////        
        if (T[3] && op[ADD] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[ADD] == 1) begin
            Grc = 1; Rout = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[ADD] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end
        ///////////////sub/////////////////////////////////
        if (T[3] && op[SUB] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[SUB] == 1) begin
            Grc = 1; Rout = 1; Sub = 1; Cin = 1; end                
        if (T[5] && op[SUB] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end      
        ///////////////ldr/////////////////////////////////
        if (T[3] && op[LDR] == 1) begin
            PCout = 1; Ain = 1; end
        if (T[4] && op[LDR] == 1) begin
            C1out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[LDR] == 1) begin
            Cout = 1; MAin = 1; end  
        if (T[6] && op[LDR] == 1) begin
            Read = 1; end  
        if (T[7] && op[LDR] == 1) begin
            MDout = 1; Gra = 1; Rin = 1; End = 1; end  
        ///////////////neg/////////////////////////////////
        if (T[3] && op[NEG] == 1) begin
            Grc = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[NEG] == 1) begin
            Grc = 1; Rout = 1; Sub = 1; Cin = 1; end                
        if (T[5] && op[NEG] == 1) begin
            Cout = 1; Ain = 1; end  
        if (T[6] && op[NEG] == 1) begin
            Cin = 1; Grc = 1; Rout = 1;  Sub = 1; end  
        if (T[7] && op[NEG] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end  
        ///////////////or/////////////////////////////////
        if (T[3] && op[OR] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[OR] == 1) begin
            Grc = 1; Rout = 1; Or = 1; Cin = 1; end                
        if (T[5] && op[OR] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end  
        ///////////////BR////////////////////////////////
        if (T[3] && op[BR] == 1) begin
            Grc = 1; Rout = 1; CONin = 1; end              
        if (T[4] && op[BR] == 1) begin
            if(con == 1) begin 
                Rout = 1; Grb = 1; PCin = 1; end
            End = 1; end 
        ///////////////shl/////////////////////////////////
        if (T[3] && op[SHL] == 1) begin
            C1out = 1; Ld = 1; end
        if (T[4] && op[SHL] == 1) begin
            if (n_is_zero == 1) begin
            Grc = 1; Rout = 1; Ld = 1; end 
            end               
        if (T[5] && op[SHL] == 1) begin
            Grb = 1; Rout = 1; BtoC = 1; Cin = 1; end  
        if (T[6] && op[SHL] == 1) begin
            if (n_is_zero != 1) begin 
            Cout = 1; Shl = 1; Cin = 1;  Decr = 1; Goto6 = 1; end  
            end
        if (T[7] && op[SHL] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end  
            
            
////////Generated Control Signals///////////////////    
        ctrl_signals[0]  = Gra; 
        ctrl_signals[1]  = Grb;
        ctrl_signals[2]  = Grc;
        ctrl_signals[3]  = Rin;
        ctrl_signals[4]  = Rout;
        ctrl_signals[5]  = BAout;
        ctrl_signals[6]  = BtoC;
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
        ctrl_signals[35] = Goto6;
        ctrl_signals[36] = Stop;
    end    
endmodule


module control_unit(
    input  logic       clk, rst, Done, strt, con, n_is_zero,
    input  logic[4:0]  opCode,    
    output logic[36:0] ctrl_signals
    );
    logic[3:0]   countIn;
    logic        read, write, Wait;
    logic        Enable, R, W;
    logic[3:0]   count;
    logic[15:0]  T;
    logic[31:0]  op;
    
    
    clocking_logic  clk_logic(
        .clk(clk), .rst(rst), .read(ctrl_signals[29]), .write(ctrl_signals[30]), .Wait(Wait),
        .Done(Done), .strt(strt), .stop(ctrl_signals[36]), .Enable(Enable), .R(R), .W(W)
    );    
    
    counter  ctr(
        .clk(clk), .rst(rst), .enable(Enable), .load(ctrl_signals[35]), .count(count), .End(ctrl_signals[34])
    );
    
    control_step_decoder  ctrl_stp_dcdr(
        .count(count), .T(T)
    );
    
    decoder dcdr (
        .opCode(opCode), .op(op)
    );
    
    control_signal_encoder  ctrl_sig_encdr (
        .T(T), .op(op), .ctrl_signals(ctrl_signals), .con(con), .n_is_zero(n_is_zero)
    );    
endmodule 








