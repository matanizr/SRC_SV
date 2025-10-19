`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.10.2025 18:18:18
// Design Name: 
// Module Name: tb_PC
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

module      tb_PC;

localparam   w = 32;
logic        clk, rst;
logic        PCin, PCout;
logic[w-1:0] val_bus;
logic        drive_bus;
tri[w-1:0]   bus;

always #5 clk = ~clk;

assign bus = drive_bus ? val_bus : 'bz;

PC_u #(.w(w)) dut (
    .clk(clk),
    .rst(rst),
    .bus(bus),
    .PCin(PCin),
    .PCout(PCout) );

clocking cb @(posedge clk);
    output val_bus, drive_bus;    
endclocking

initial begin
    clk           = 0;
    PCin          = 0;
    PCout         = 0;    
    cb.val_bus   <='0;
    cb.drive_bus <= 0;
    rst           = 1; @(cb);
    rst           = 0;
    
    cb.val_bus   <= 32'hF;
    cb.drive_bus <= 1;
    PCin          = 1; @(cb);
    cb.drive_bus <= 0;
    PCin          = 0;
        
    cb.drive_bus <= 1;
    cb.val_bus   <= 32'b0;  
    PCout     = 1; @(cb);
    cb.drive_bus <= 0;
    PCout     = 0; @(cb);
    
    $finish;
end
endmodule
