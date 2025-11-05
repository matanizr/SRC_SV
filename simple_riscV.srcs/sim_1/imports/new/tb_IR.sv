`timescale 1ns / 1ps

module tb_IR;

localparam   w = 32;
logic        clk = 1;
logic        rst = 0;
tri[w-1:0]   bus;
logic        c1 = 0, c2 = 0, IRin = 0;
logic[4:0]   to_control_unit;
logic        tb_drive_bus = 0;
logic[w-1:0] tb_val_bus;

clocking cb @(negedge clk);
    default input #1step output #0;
    output c1, c2, IRin, rst, tb_drive_bus, tb_val_bus; 
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
    cb.rst       <= 1; repeat (2) @(cb);
    cb.rst       <= 0;
    
    cb.tb_val_bus   <= 32'b01010101010101010101010101010101;    
    cb.tb_drive_bus <= 1; @(cb);
    $display("bus_in = %032b", tb_val_bus);
    cb.IRin         <= 1; @(cb);
    cb.IRin         <= 0;
    cb.tb_drive_bus <= 0;
    
    cb.c1 <= 1; @(cb);
    $display("bus_c1 = %032b", bus); @(cb);
    cb.c1 <= 0;
    cb.c2 <= 1; @(cb);
    $display("bus_c2 = %032b", bus); @(cb);
    cb.c2 <= 0;   
       
       
    $finish;
end 
endmodule
