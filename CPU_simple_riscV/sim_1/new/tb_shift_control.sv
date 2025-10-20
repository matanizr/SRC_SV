`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2025 22:58:41
// Design Name: 
// Module Name: tb_shift_control
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

module tb_shift_control;

localparam   w = 32;
tri[w-1:0]   bus;
logic        clk = 0, clk_tb = 0, rst;
logic        ld, decr;
logic        n;
logic        drive_bus = 0;
logic[w-1:0] val_bus;
logic[4:0]   tb_shifts;

always #5 clk = ~clk;

always begin
     #(5-1ps) clk_tb = ~clk_tb;
     #1ps; end

assign bus = drive_bus ? val_bus : 'bz;

clocking cb @(posedge clk_tb);
    output drive_bus, val_bus, rst, decr, ld;
endclocking

shift_control #(.w(w)) dut (
    .bus(bus),
    .clk(clk),
    .rst(rst),
    .ld(ld),
    .decr(decr),
    .n(n),
    .tb_shifts(tb_shifts)
);

initial begin 
    cb.decr      <= 0;
    cb.rst       <= 1; @(cb);
    cb.rst       <= 0;
    
    cb.val_bus   <= 32'd5;
    cb.drive_bus <= 1;
    cb.ld        <= 1; repeat(1) @(cb);
    cb.ld        <= 0;
    cb.drive_bus <= 0;
    
    cb.decr      <= 1; repeat(5) @(cb); 
    $finish;   
end
endmodule

