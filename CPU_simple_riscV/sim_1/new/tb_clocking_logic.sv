`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.10.2025 02:07:55
// Design Name: 
// Module Name: tb_clocking_logic
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

module tb_clocking_logic;

logic clk = 1, rst = 0;
logic read = 0, write = 0, Wait = 0, Done = 0, strt = 0, stop = 0;
logic Enable, R, W;

clocking_logic dut (
    .clk(clk),
    .rst(rst),
    .read(read),
    .write(write),
    .Wait(Wait),
    .Done(Done),
    .strt(strt),
    .stop(stop),
    .Enable(Enable),
    .R(R),
    .W(W) );

always #5 clk = ~clk; 

clocking cb @(negedge clk);
    default input #1step output #0;
    output rst, read, write, Wait, Done, strt, stop;
    input Enable, R, W;
endclocking   

initial begin
    @(cb);
    cb.rst   <= 1; @(cb);
    cb.rst   <= 0;    
        
    cb.strt  <= 1; @(cb);
    cb.strt  <= 0;
    
    cb.read  <= 1;
    cb.write <= 1;
    cb.Wait  <= 1; @(cb);
    
    cb.Done  <= 1; @(cb);
    
    cb.stop  <= 1; @(cb);
        
    $finish;
end

endmodule

