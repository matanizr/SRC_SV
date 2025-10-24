`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2025 19:23:19
// Design Name: 
// Module Name: clocking_logic
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


module clocking_logic (
    input  clk, rst, read, write, Wait, Done, strt, stop,
    output Enable, R, W
    );
    logic Run, SDone;
    
jk_FF read_ff (
    .j(read),
    .k(SDone),
    .clk(clk),
    .rst(rst),
    .Q(R) );
    
jk_FF write_ff (
    .j(write),
    .k(SDone),
    .clk(clk),
    .rst(rst),
    .Q(W) );
    
jk_FF strt_ff (
    .j(strt),
    .k(stop),
    .clk(clk),
    .rst(rst),
    .Q(Run) );
    
d_FF done_ff (
    .D(Done),
    .clk(clk),
    .rst(rst),
    .Q(SDone) );

assign Enable = Run & (SDone | ~Wait | ~(R | W));    
    
endmodule

module jk_FF(
    input  logic clk, rst,
    input  logic j, k,
    output logic Q 
    );
always_ff @(posedge clk) begin
    if (rst) Q <= 1'b0;
    else begin
        unique case({j,k})
            2'b00: Q <= Q;
            2'b01: Q <= 1'b0;
            2'b10: Q <= 1'b1;
            2'b11: Q <= ~Q;
        endcase
    end
end
endmodule

module d_FF(
    input  logic rst, clk,
    input  logic D,
    output logic Q);
    
    always_ff @(posedge clk) begin
        if (rst) Q <= 1'b0;
        else     Q <= D;
    end    
endmodule
    
    
    
    
    
    
    