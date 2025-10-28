`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2025 18:52:05
// Design Name: 
// Module Name: SRC_top
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


module SRC_top(
    input  logic clk, rst, strt,
    input  logic[32:0]   memory[1023:0]
    );
    localparam            bus_width = 32;
    localparam            mem_size  = 1024;
    
    logic[bus_width-1:0]  bus;
    logic                 Done;
    logic                 n_is_zero;
    logic                 con;
    logic[4:0]            opCode;
    logic[36:0]           ctrl_signals;
    logic[4:0]            opCode; 
    
    logic[bus_width-1:0]  IR_to_bus;
    logic[bus_width-1:0]  PC_to_bus;
    logic[bus_width-1:0]  MD_to_bus;
    logic[bus_width-1:0]  ALU_to_bus;
    logic[bus_width-1:0]  RegFile_to_bus;
    
    logic  Rout, BAout, Cout, C1out, C2out, PCout, MDout;
    
    assign Rout  = ctrl_signals[4];
    assign BAout = ctrl_signals[5];
    assign Cout  = ctrl_signals[19];
    assign C1out = ctrl_signals[22];
    assign C2out = ctrl_signals[23];
    assign PCout = ctrl_signals[25];
    assign MDout = ctrl_signals[27];
    
    assign Done = '0;
    
    always_comb begin
        bus = '0;
        if      (Rout)  bus = RegFile_to_bus;
        else if (BAout) bus = RegFile_to_bus;
        else if (Cout)  bus = ALU_to_bus;
        else if (C1out) bus = IR_to_bus;
        else if (C2out) bus = IR_to_bus;
        else if (PCout) bus = PC_to_bus;
        else if (MDout) bus = MD_to_bus;
    end
    
    control_unit  SRC_Control_U (
        .clk(clk),
        .rst(rst),
        .strt(strt),
        .Done(Done), 
        .opCode(opCode),
        .ctrl_signals(ctrl_signals),
        .con(con),
        .n_is_zero(n_is_zero)
         );     
    
    IR #(.w(bus_width)) SRC_IR(
        .clk(clk),
        .rst(rst),
        .bus_in(bus),
        .bus_out(IR_to_bus),
        .c1(ctrl_signals[22]),
        .c2(ctrl_signals[23]),
        .IRin(ctrl_signals[21]),
        .to_control_unit(opCode) );
        
    memory #(.w(bus_width), .mem_size(mem_size)) SRC_memory(
        .bus_in(bus),
        .bus_out(MD_to_bus),
        .rst(rst),
        .clk(clk),
        .read(ctrl_signals[29]),
        .write(ctrl_signals[30]),
        .Wait(ctrl_signals[31]),
        .MAin(ctrl_signals[26]),
        .MDout(ctrl_signals[27]),
        .MDbus(ctrl_signals[28]),
        .memory(memory) );
        
    PC_u #(.w(bus_width)) SRC_PC (
        .clk(clk),
        .rst(rst),
        .bus_in(bus),
        .bus_out(PC_to_bus),
        .PCin(ctrl_signals[24]),
        .PCout(ctrl_signals[25]) );
        
    ALU #(.w(bus_width)) SRC_ALU (
        .clk(clk),
        .rst(rst),
        .bus_in(bus),
        .bus_out(ALU_to_bus),
        .Ain(ctrl_signals[17]),
        .Cin(ctrl_signals[18]),
        .Cout(ctrl_signals[19]),
        .BtoC(ctrl_signals[6]),
        .Shr(ctrl_signals[7]),
        .Shl(ctrl_signals[8]), 
        .Shc(ctrl_signals[9]), 
        .Shra(ctrl_signals[10]), 
        .Not(ctrl_signals[11]), 
        .Inc4(ctrl_signals[12]), 
        .Add(ctrl_signals[13]), 
        .Sub(ctrl_signals[14]), 
        .Or(ctrl_signals[15]), 
        .And(ctrl_signals[16]) );
        
    regfile #(.w(bus_width)) SRC_regfile(
        .clk(clk),
        .Gra(ctrl_signals[0]),
        .Grb(ctrl_signals[1]),
        .Grc(ctrl_signals[2]),
        .Rin(ctrl_signals[3]),
        .Rout(ctrl_signals[4]),
        .BAout(ctrl_signals[5]),
        .bus_in(bus),
        .bus_out(IR_to_bus) );  
        
    con_u #(.w(bus_width)) SRC_con_u (
        .clk(clk),
        .rst(rst),
        .con_in(ctrl_signals[20]),
        .con_out(con),
        .bus_in(bus)
    );
    
    shift_control #(.w(bus_width)) (
        .clk(clk),
        .rst(rst),
        .ld(ctrl_signals[32]),
        .decr(ctrl_signals[33]),       
        .n_is_zero(n_is_zero),
        .bus_in(bus_in) );    
    
endmodule   
    
    

        



