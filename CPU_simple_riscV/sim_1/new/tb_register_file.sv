`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2025 22:39:33
// Design Name: 
// Module Name: tb_register_file
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

module tb_register_file;
localparam int  w = 32,  n = 32;
localparam int Ra_MSB = 16, Ra_LSB = 12;
localparam int Rb_MSB = 21, Rb_LSB = 17;
localparam int Rc_MSB = 26, Rc_LSB = 22;
logic           clk = 1;
logic           Gra = 0, Grb  = 0, Grc   = 0;
logic           Rin = 0, Rout = 0, BAout = 0;  
logic[w-1:0]    IR;        
tri[w-1:0]      bus;
//logic[w-1:0] Ra_check, Rb_check, Rc_check;

logic tb_drive_bus;
logic [w-1:0] tb_val_bus;

always #5 clk = ~clk;

regfile #(
    .w(w), .n(n), .Ra_MSB(Ra_MSB), .Ra_LSB(Ra_LSB),
    .Rb_MSB(Rb_MSB), .Rb_LSB(Rb_LSB),
    .Rc_MSB(Rc_MSB), .Rc_LSB(Rc_LSB)) dut (
    .clk  (clk),
    .bus  (bus),
    .IR   (IR),
    .Gra  (Gra),
    .Grb  (Grb),
    .Grc  (Grc),
    .Rin  (Rin),
    .Rout (Rout),
    .BAout(BAout)
//    ,.Ra_check(Ra_check),
//     .Rb_check(Rb_check),
//     .Rc_check(Rc_check)
);

clocking cb @(negedge clk);
    default input #1step output #0;
    output Gra, Grb, Grc, Rin, Rout, BAout, IR, tb_val_bus, tb_drive_bus; 
    input bus;
endclocking

assign bus = (tb_drive_bus) ? tb_val_bus : 'bz;

initial begin    
    @(cb);
    cb.IR <= 32'b00000000010001000011000000000000;
    
    //write
    cb.Gra          <= 1;
    cb.tb_drive_bus <= 1;
    cb.Rin          <= 1;
    cb.tb_val_bus   <= 32'd2; @(cb);
    cb.Rin          <= 0;
    cb.Gra          <= 0;
    
    cb.Grb          <= 1;
    cb.tb_drive_bus <= 1;
    cb.Rin          <= 1;
    cb.tb_val_bus   <= 32'd3; @(cb);
    cb.Rin          <= 0;
    cb.Grb          <= 0;
    
    cb.Grc          <= 1;
    cb.tb_drive_bus <= 1;
    cb.Rin          <= 1;
    cb.tb_val_bus   <= 32'd4; @(cb);
    cb.Rin          <= 0;
    cb.Grc          <= 0;
    
    //read
    cb.Gra          <= 1;
    cb.tb_drive_bus <= 0;
    cb.Rout         <= 1; @(cb);
    cb.Rout         <= 0;
    cb.Gra          <= 0;
    
    cb.Grb          <= 1;
    cb.tb_drive_bus <= 0;
    cb.Rout         <= 1; @(cb);
    cb.Rout         <= 0;
    cb.Grb          <= 0;
    
    cb.Grc          <= 1;
    cb.tb_drive_bus <= 0;
    cb.Rout         <= 1; @(cb);
    cb.Rout         <= 0;  
    cb.Grc          <= 0; 
    
    $finish;
end
endmodule



