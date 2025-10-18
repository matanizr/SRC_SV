`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.10.2025 19:14:45
// Design Name: 
// Module Name: memory_tb
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

module memory_tb;
    localparam   w = 32;
    logic clk,   rst, MDbus, MDout, MAin, Wait, read, write;
    tri[w-1:0]   bus;
    logic        tb_drive_bus;
    logic[w-1:0] tb_val_bus;
        
    memory dut(
        .clk(clk),
        .bus(bus),
        .rst(rst),
        .MDbus(MDbus),
        .MDout(MDout),
        .Wait(Wait),
        .read(read),
        .write(write),
        .MAin(MAin)        
    );

always #5 clk = ~clk;

clocking cb @(posedge clk);
    default input #1step output #0;
    output rst, MDbus, MDout, MAin, read, write;
    input bus;
endclocking

default clocking cb;

assign bus = (tb_drive_bus) ? tb_val_bus : 'bz;

    initial begin    
        clk = 0; cb.read <= 0; cb.write <= 0; Wait = 0;
        cb.MDbus <= 0; cb.MDout <= 0; cb.MAin <= 0;
        tb_drive_bus = 0; tb_val_bus = '0; rst = 1;
        
        cb.rst <= 1;
        ##1;
        cb.rst <= 0;
        rst = 0;
        ##1;
        tb_drive_bus = 1; tb_val_bus = 32'd1;       //write no.1   
        cb.MAin   <= 1;
        ##1;
        tb_val_bus = 32'd8; 
        cb.MAin   <= 0;            
        cb.MDbus  <= 1;
        ##1;
        cb.write  <= 1;   
        cb.MDbus  <= 0; 
        ##1;
        tb_val_bus = 32'd2;                         //write no.2   
        cb.MAin   <= 1;
        ##1;
        tb_val_bus = 32'd9; 
        cb.MAin   <= 0;            
        cb.MDbus  <= 1;
        ##1;
        cb.write  <= 1;   
        cb.MDbus  <= 0;
        ##1;
        tb_val_bus = 32'd1;        //read no.1
        cb.write  <= 0;
        cb.MAin   <= 1;
        ##1;
        cb.read   <= 1;
        ##1;
        tb_drive_bus = 0;
        cb.read   <= 0;
        cb.MDout  <= 1;
        cb.MAin   <= 0;
        ##1;
        tb_drive_bus = 1; tb_val_bus = 32'd2;        //read no.2     
        cb.MDout  <= 0;
        cb.MAin   <= 1;
        ##1;           
        cb.read   <= 1;
        ##1;  
        tb_drive_bus = 0; 
        cb.read   <= 0;
        cb.MAin   <= 0;    
        cb.MDout  <= 1; 
        ##1;
        cb.MDout  <= 0; 
        $finish;
    end
endmodule


/*      @(posedge clk);
            rst = 0;
        @(posedge clk);
            tb_drive_bus = 1; tb_val_bus = 32'd1;          
            MAin  = 1;
        @(posedge clk);
            tb_val_bus = 32'd8; 
            MAin  = 0;            
            MDbus = 1;
        @(posedge clk);
            write = 1;
        @(posedge clk);
            tb_drive_bus = 0;
            write = 0;
            read  = 1;
            MDout = 1;
        @(posedge clk);
            read  = 0;
        repeat(2) @(posedge clk);
            MDout = 0;*/