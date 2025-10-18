`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2025 22:07:17
// Design Name: 
// Module Name: IR_tb
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

module tb_IR;

localparam   w = 32;
logic        clk = 0;
logic        rst = 0;
tri[w-1:0]   bus;
logic        c1, c2, IRin;
logic        to_control_unit;
logic        tb_drive_bus;
logic[w-1:0] tb_val_bus;

clocking cb @(posedge clk);
    default input #1step output #0;
    output c1, c2, IRin, rst; 
    input bus;
endclocking

always #5 clk = ~clk;

IR #(.w(w)) dut (
    .rst(rst),
    .clk(clk),
    .bus(bus),
    .c1(c1),
    .c2(c2),
    .IRin(IRin),
    .to_control_unit(to_control_unit)
    );
   
assign bus = tb_drive_bus ? tb_val_bus : 'bz;
     
initial begin 
    cb.c1        <= 0;
    cb.c2        <= 0;
    cb.IRin      <= 0;
    tb_drive_bus  = 0;
    tb_val_bus    = 32'b0;
    cb.rst       <= 1; @(cb);
    cb.rst       <= 0;
    
    tb_val_bus    = 32'b01010101010101010101010101010101;    
    tb_drive_bus  = 1; @(cb);
    $display("bus_in = %032b", tb_val_bus);
    cb.IRin      <= 1; @(cb);
    cb.IRin      <= 0;
    tb_drive_bus  = 0;
    
    cb.c1 <= 1; @(cb);
    $display("bus_c1 = %032b", bus); @(cb);
    cb.c1 <= 0;
    cb.c2 <= 1; @(cb);
    $display("bus_c2 = %032b", bus); @(cb);
    cb.c2 <= 0;   
       
       
    $finish;
end 
endmodule
