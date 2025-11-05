`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : arithmetic logic unit
// Module Name : ALU
// Description : The ALU performs arithmetic and logical operations on 32-bit operands
//////////////////////////////////////////////////////////////////////////////////

module ALU #(parameter int w = 32)(
    input  logic          clk, rst,   //clock and reset signal
    input  logic          Ain, Cin, Cout,   //Ain for Areg <= bus, Cin for Creg <= ALU, and Cout for bus <= Creg
    input  logic          BtoC, Shr, Shl, Shc, Shra, Not, Inc4, Add, Sub, Or, And,   //signals for each opertaion in the ALU
    input  logic[w-1:0]   bus_in,               //input from the bus
    output logic[w-1:0]   bus_out               //output to the bus
    //input  alu_op_t      op,                  //just for tb
    //inout[w-1:0]         bus,                 //just for tb
    ); 
    logic[w-1:0] A, B, C;       // C and A are registers and B is hard-wired to the bus
    logic[w-1:0] result;        //the ALU result
    
    assign B       = bus_in;    //B is hard-wired to the bus
    
    always_ff @(posedge clk) begin
        if (rst) begin           // reset A and C registers
            A      <= '0;
            C      <= '0; end            
        else begin
            if (Ain) A <= bus_in;   //A-reg <= bus in posclk if Ain=1
            if (Cin) C <= result;   //C-reg <= ALU in posclk if Cin=1
        end
    end    
    
    //arithmetical operations 
    always_comb begin
        unique case(1'b1)
            BtoC : result = B;            //C <= B
            Shr  : result = B >> 1;        //shift right
            Shl  : result = B << 1;        //shift left
            Shc  : result = {B[w-2:0], B[w-1]};       //cyclic shift
            Shra : result = $signed(B) >>> 1;         //shift right arithmeticשlly
            Not  : result = ~B;            //not(B)
            Inc4 : result = B + 1;         //increase B by 1 for the PC
            Add  : result = A + B;         //          
            Sub  : result = A - B;         //
            Or   : result = A | B;         //
            And  : result = A & B;         //         
            default : result = '0;         //
        endcase 
    end
        
    assign bus_out = (Cout) ? C : 'bz;    // send the bus register C if Cout=1
endmodule
