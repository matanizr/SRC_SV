`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : control unit
// Module Name : control unit, counter, control step decoder, decoder, control signal encoder.
// Description : wraper control unit integrating multiple functional modules
//////////////////////////////////////////////////////////////////////////////////

////////import enums for the opCodes///////////////////////////////
import opCodesPkg::*;

/////////the SRC step counter////////////////////////////////////////
module counter  (
    input  logic        enable, load, rst, clk, End,       //clock and other signals
    output logic[3:0]   count                              //counter for steps for every instruction
    );
        
    always_ff @(posedge clk) begin
        if      (rst | End)        count <= 4'b0000;  //Counter = 0 at the end of each instruction
        else if (load)             count <= 4'b0110;  //jump back to step 6 (loop for the shifts)
        else if (enable & !load)   count <= (count == 4'd15) ? 4'd0 : count + 1;   //reset the counter if rst=1 or if count get to 15(not suppose the happen)
    end    
endmodule

//////////step decoder for the instruction steps///////////
module control_step_decoder (
    input  logic[3:0]  count,
    output logic[7:0]  T 
    );
    always_comb begin
        T        = 8'b0;
        T[count] = 1'b1;   //T[n] is 'on' for the n step of every instruction
    end    
endmodule

/////////decoder for the opCodes signal for the control unit//////
module decoder (
    input  logic[4:0]   opCode,    
    output logic[31:0]  op
    );
    always_comb begin
        op = '0;        
        op[opCode] = 1;       //op[n] is 'on' for operation number n (from the ISA)
                
   ///////instruction that is not implemented///////
        op[NOP] = 1'b0;
        op[EEN] = 1'b0;
        op[EDI] = 1'b0;
        op[SVI] = 1'b0;
        op[RI]  = 1'b0;
        op[RFI] = 1'b0;
        op[7]   = 1'b0;
        op[18]  = 1'b0;
        op[19]  = 1'b0;
        op[25]  = 1'b0;
    end    
endmodule

////////Control signal generator for CPU operations///////
module control_signal_encoder (
    input  logic[7:0]   T,
    input  logic[31:0]  op,
    input  logic        con,
    input  logic        n_is_zero,
    
    output logic[36:0]  ctrl_signals
    );
    (* keep = "true" *) logic _unused;
    logic Gra, Grb, Grc, Rin, Rout, BAout, BtoC, Shr, Shl, Shc, Shra, Not, Inc4, Add, Sub, Or, And, Ain, Cin, Cout;
    logic CONin, IRin, C1out, C2out, PCin, PCout, MAin, MDout, MDbus, Read, Write, Wait, Ld, Decr, Goto6, Stop;
    logic End;
    
    ///demi use for the unsued opCodes bits (to avoid synthesis warnings)
    assign _unused = |{ op[RFI], op[25], op[19], op[18], op[RI], op[SVI], op[EDI], op[EEN], op[7], op[NOP] };
    
    always_comb begin    
        ////////rst all the ctrl signals/////
        ctrl_signals = '0;
        Gra=0; Grb=0; Grc=0; Rin=0; Rout=0; BAout=0; BtoC=0; Shr=0; Shl=0; Shc=0; Shra=0; Not=0;
        Inc4=0; Add=0; Sub=0; Or=0; And=0; Ain=0; Cin=0; Cout=0; CONin=0; IRin=0; C1out=0; C2out=0;PCin=0; 
        PCout=0; MAin=0; MDout=0; MDbus=0; Read=0; Write=0; Wait=0; Ld=0; Decr=0; End=0; Goto6=0; Stop=0;
////////////////encoding every instruction in the isa///////////////        
        ////////////////fetch//////////////////////////////      
        if (T[0]) begin
            PCout = 1; MAin = 1; Inc4  = 1; Cin   = 1;  end                
        if (T[1]) begin
            Read  = 1; Wait = 1; Cout  = 1; PCin  = 1; end            
        if (T[2]) begin
            MDout  = 1; IRin  = 1; end   
        ////////////////ld/////////////////////////////////  
        if (T[3] && op[LD] == 1) begin
            Grb = 1 ;BAout = 1; Ain = 1; end
        if (T[4] && op[LD] == 1) begin
            C2out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[LD] == 1) begin
            Cout = 1; MAin = 1; end  
        if (T[6] && op[LD] == 1) begin
            Read = 1; Wait = 1; end  
        if (T[7] && op[LD] == 1) begin
            MDout = 1; Gra = 1; Rin = 1; End = 1; end 
        ///////////////ldr/////////////////////////////////
        if (T[3] && op[LDR] == 1) begin
            PCout = 1; Ain = 1; end
        if (T[4] && op[LDR] == 1) begin
            C1out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[LDR] == 1) begin
            Cout = 1; MAin = 1; end  
        if (T[6] && op[LDR] == 1) begin
            Read = 1; Wait = 1; end  
        if (T[7] && op[LDR] == 1) begin
            MDout = 1; Gra = 1; Rin = 1; End = 1; end  
        ////////////////st/////////////////////////////////
        if (T[3] && op[ST] == 1) begin
            Grb = 1 ;BAout = 1; Ain = 1; end
        if (T[4] && op[ST] == 1) begin
            C2out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[ST] == 1) begin
            Cout = 1; MAin = 1; end  
        if (T[6] && op[ST] == 1) begin
            Gra = 1; Rout = 1; MDbus = 1; end  
        if (T[7] && op[ST] == 1) begin
            Write = 1; Wait = 1; End = 1; end 
        ////////////////str/////////////////////////////////
        if (T[3] && op[STR] == 1) begin
            PCout = 1; Ain = 1; end
        if (T[4] && op[STR] == 1) begin
            C1out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[STR] == 1) begin
            Cout = 1; MAin = 1; end  
        if (T[6] && op[STR] == 1) begin
            Gra = 1; Rout = 1; MDbus = 1; end  
        if (T[7] && op[STR] == 1) begin
            Write = 1; Wait = 1; End = 1; end 
        ////////////////la////////////////////////////////        
        if (T[3] && op[LA] == 1) begin
            Grb = 1; BAout = 1; Ain = 1; end
        if (T[4] && op[LA] == 1) begin
            C2out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[LA] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end
        ////////////////lar////////////////////////////////        
        if (T[3] && op[LAR] == 1) begin
            PCout = 1; Ain = 1; end
        if (T[4] && op[LAR] == 1) begin
            C1out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[LAR] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end
        ///////////////br////////////////////////////////
        if (T[3] && op[BR] == 1) begin
            Grc = 1; Rout = 1; CONin = 1; end              
        if (T[4] && op[BR] == 1) begin
            if(con == 1) begin 
                Rout = 1; Grb = 1; PCin = 1; end
            End = 1; end 
        ///////////////brl////////////////////////////////
        if (T[3] && op[BRL] == 1) begin
            Grc = 1; Rout = 1; CONin = 1; end 
        if (T[4] && op[BRL] == 1) begin
            PCout = 1; Gra = 1; Rin = 1; end              
        if (T[5] && op[BRL] == 1) begin
            if(con == 1) begin 
                Rout = 1; Grb = 1; PCin = 1; end
            End = 1; end 
        ////////////////add////////////////////////////////        
        if (T[3] && op[ADD] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[ADD] == 1) begin
            Grc = 1; Rout = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[ADD] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end
        ////////////////addi////////////////////////////////        
        if (T[3] && op[ADDI] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[ADDI] == 1) begin
            C2out = 1; Add = 1; Cin = 1; end                
        if (T[5] && op[ADDI] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end
        ///////////////sub/////////////////////////////////
        if (T[3] && op[SUB] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[SUB] == 1) begin
            Grc = 1; Rout = 1; Sub = 1; Cin = 1; end                
        if (T[5] && op[SUB] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end
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
        ///////////////and/////////////////////////////////    
        if (T[3] && op[AND] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[AND] == 1) begin
            Grc = 1; Rout = 1; And = 1; Cin = 1; end                
        if (T[5] && op[AND] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end    
        ///////////////andi/////////////////////////////////    
        if (T[3] && op[ANDI] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[ANDI] == 1) begin
            C2out = 1; And = 1; Cin = 1; end                
        if (T[5] && op[ANDI] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end     
        ///////////////or/////////////////////////////////
        if (T[3] && op[OR] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[OR] == 1) begin
            Grc = 1; Rout = 1; Or = 1; Cin = 1; end                
        if (T[5] && op[OR] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end              
        ///////////////ori/////////////////////////////////
        if (T[3] && op[ORI] == 1) begin
            Grb = 1; Rout = 1; Ain = 1; end
        if (T[4] && op[ORI] == 1) begin
            C2out = 1; Or = 1; Cin = 1; end                
        if (T[5] && op[ORI] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end               
        ///////////////not/////////////////////////////////
        if (T[3] && op[NOT] == 1) begin
            Grc = 1; Rout = 1; Not = 1; Cin = 1; end                
        if (T[4] && op[NOT] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end       
        ///////////////shr/////////////////////////////////
        if (T[3] && op[SHR] == 1) begin
            C1out = 1; Ld = 1; end
        if (T[4] && op[SHR] == 1) begin
            if (n_is_zero == 1) begin
            Grc = 1; Rout = 1; Ld = 1; end 
            end               
        if (T[5] && op[SHR] == 1) begin
            Grb = 1; Rout = 1; BtoC = 1; Cin = 1; end  
        if (T[6] && op[SHR] == 1) begin
            if (n_is_zero != 1) begin 
            Cout = 1; Shr = 1; Cin = 1;  Decr = 1; Goto6 = 1; end  
            end
        if (T[7] && op[SHR] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end              
        ///////////////shra/////////////////////////////////
        if (T[3] && op[SHRA] == 1) begin
            C1out = 1; Ld = 1; end
        if (T[4] && op[SHRA] == 1) begin
            if (n_is_zero == 1) begin
            Grc = 1; Rout = 1; Ld = 1; end 
            end               
        if (T[5] && op[SHRA] == 1) begin
            Grb = 1; Rout = 1; BtoC = 1; Cin = 1; end  
        if (T[6] && op[SHRA] == 1) begin
            if (n_is_zero != 1) begin 
            Cout = 1; Shra = 1; Cin = 1;  Decr = 1; Goto6 = 1; end  
            end
        if (T[7] && op[SHRA] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end               
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
        ///////////////shc/////////////////////////////////
        if (T[3] && op[SHC] == 1) begin
            C1out = 1; Ld = 1; end
        if (T[4] && op[SHC] == 1) begin
            if (n_is_zero == 1) begin
            Grc = 1; Rout = 1; Ld = 1; end 
            end               
        if (T[5] && op[SHC] == 1) begin
            Grb = 1; Rout = 1; BtoC = 1; Cin = 1; end  
        if (T[6] && op[SHC] == 1) begin
            if (n_is_zero != 1) begin 
            Cout = 1; Shc = 1; Cin = 1;  Decr = 1; Goto6 = 1; end  
            end
        if (T[7] && op[SHC] == 1) begin
            Cout = 1; Gra = 1; Rin = 1; End = 1; end          
        ///////////////stop////////////////////////////////        
        if (T[3] && op[STOP] == 1) begin
            Stop = 1; end        
            
           
////////Generated Control Signals/////////////////////    
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

//////////control unit wraper//////////////////////////
module control_unit(
    input  logic       clk, rst, Done, strt, con, n_is_zero, //clock and signals
    input  logic[4:0]  opCode,                               //the opCode for instruction
    output logic[36:0] ctrl_signals         //the output signals from the control unit to all the units in the CPU
    );
    logic[3:0]   countIn;
    logic        read, write;
    logic        Enable, R, W;
    logic[3:0]   count;    //counts for steps
    logic[7:0]   T;        //step num
    logic[31:0]  op;       //op for the control unit to commit (from the ISA)
    
    
    clocking_logic  clk_logic(
        .clk(clk), .rst(rst), .read(ctrl_signals[29]), .write(ctrl_signals[30]), .Wait(ctrl_signals[31]),
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








