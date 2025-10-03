`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2025 15:14:35
// Design Name: 
// Module Name: tb_ALU
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

module tb_alu;
localparam width = 8;
logic [width-1:0] a, b, result;
logic [2:0] op;
logic zero = 0, negative = 0, overflow;

ALU #(.width(width)) dut(
    .a(a), .b(b), .result(result), .op(op),
    .zero(zero), .negative(negative), .overflow(overflow));

task automatic show;
    $display("a=%0d, b=%0d, op=%b => result=%0d \n zero=%b, overflow=%b, negative=%b", a, b, op, result, zero, overflow, negative);
endtask;

initial begin
    a = 8'd5; b = 8'd2;
    op = 3'b000; #5; show();
    op = 3'b001; #5; show();
    op = 3'b010; #5; show();
    op = 3'b011; #5; show();
    op = 3'b100; #5; show();
    op = 3'b101; #5; show();
    op = 3'b110; #5; show();
    op = 3'b111; #5; show();
    $finish;
end 
endmodule

