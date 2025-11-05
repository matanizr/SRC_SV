`timescale 1ns / 1ps

module tb_shift_control;

localparam   w = 32;
tri[w-1:0]   bus;
logic        clk = 1, rst = 0;
logic        ld = 0, decr = 0;
logic        n;
logic        drive_bus = 0; 
logic[w-1:0] val_bus;
logic[4:0]   tb_shifts;

always #5 clk = ~clk;

assign bus = drive_bus ? val_bus : 'bz;

clocking cb @(negedge clk);
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
    cb.rst       <= 1; repeat(2) @(cb);
    cb.rst       <= 0;
    
    cb.val_bus   <= 32'd5;
    cb.drive_bus <= 1;
    cb.ld        <= 1; @(cb);
    cb.ld        <= 0;
    cb.drive_bus <= 0;
    
    cb.decr      <= 1; repeat(5) @(cb); 
    $finish;   
end
endmodule

