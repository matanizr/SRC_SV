`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : shift control unit
// Module Name : shift_control
// Description : The shift control unit manages the number of shift operations and indicates when all required shifts have been completed
//////////////////////////////////////////////////////////////////////////////////


module shift_control #(parameter w = 32) (
    //inout  logic[w-1:0] bus,      //just for tb
    input  logic        clk, rst,   //clock and reset signals
    input  logic        ld, decr,   //control signals: load the number of shifts(ld) and decrement it by 1 each cycle(decr)
    output logic        n_is_zero,  //signal that is high when no more shifts remain  
    input  logic[4:0]   shifts_num  //number of shifts (loaded from the bus)
    );    
    logic[4:0] shifts;              //remaining shifts
    
    assign n_is_zero = ~(|shifts);  //n=1 for no more shifts
    
    always_ff @(posedge clk) begin
            if      (rst)                shifts <= '0;         //reset the "shifts"
            else if (ld)                 shifts <= shifts_num; //load the number of shifts
            else if (decr & !n_is_zero)  shifts <= shifts - 1; //decrement by 1 while n_is_zero != 1      
    end    
endmodule
