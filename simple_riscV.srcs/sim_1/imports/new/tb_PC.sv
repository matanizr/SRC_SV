`timescale 1ns / 1ps

module      tb_PC;

localparam   w = 32;
logic        clk = 1, rst = 0;
logic        PCin = 0, PCout = 0;
logic[w-1:0] val_bus;
logic        drive_bus = 0;
tri[w-1:0]   bus;

always #5 clk = ~clk;

assign bus = drive_bus ? val_bus : 'bz;

PC_u #(.w(w)) dut (
    .clk(clk),
    .rst(rst),
    .bus(bus),
    .PCin(PCin),
    .PCout(PCout) );
    
clocking cb @(negedge clk);
    default input #1step output #0; 
    output rst, PCin, PCout, drive_bus, val_bus; 
endclocking

initial begin
    cb.rst       <= 1; repeat(2) @(cb);
    cb.rst       <= 0;
    
    cb.val_bus   <= 'hF;
    cb.drive_bus <= 1;        
    cb.PCin      <= 1; @(cb);
    cb.PCin      <= 0;

    cb.val_bus   <= 'b0; @(cb);
    
    cb.drive_bus <= 0;
    cb.PCout     <= 1; @(cb);
    cb.PCout     <= 0; @(cb);
    
    $finish;
end
endmodule

