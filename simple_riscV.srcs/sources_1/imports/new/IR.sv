`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : the instruction register
// Module Name : IR
// Description : the register that holds the next instruction in every step
//////////////////////////////////////////////////////////////////////////////////

////////////////the instruction regisater////////////////////
module IR #(parameter w = 32) (
    //inout  logic[w-1:0]  bus,             //just for tb
    input  logic         clk, rst,
    input  logic         c1, c2, IRin,
    output logic[4:0]    to_control_unit,   //the IR sends the opCode directly to the controller
    output logic[2:0]    IR_to_condition_unit,  //define the condition to check for the condition_unit
    
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out,
    output logic[w-1:0]   IR_for_reg       //chose whitch registers will be ra,rb,rc
    );
    logic[w-1:0]         out_bus;
    logic[w-1:0]         inst;            //the instruction that the IR holds
    
    assign IR_for_reg = inst;             //send the unstruction to the registers unit
    assign IR_to_condition_unit = inst[2:0]; //send the unstruction to the condition unit
    
    always_ff @(posedge clk) begin
        if      (rst)  inst <= '0;
        else if (IRin) inst <= bus_in;        //update the instruction from the bus
    end
    
    always_comb begin
        out_bus = '0;
        unique case (1'b1)
            c1: out_bus = {{10{inst[21]}}, inst[21:0]};    //signed extension of the value in C1 to the bus width
            c2: out_bus = {{15{inst[16]}}, inst[16:0]};    //signed extension of the value in C2 to the bus width
            default : out_bus = '0;
        endcase
    end
    
    assign to_control_unit = inst[31:27];    //send the unstruction to the control unit (the bits he needs)
    
    assign bus_out = (c1 | c2) ? out_bus : 'bz;    //send to the bus the value in C1 or C2 (depands the instruction)  
endmodule
