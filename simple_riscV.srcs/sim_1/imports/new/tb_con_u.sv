`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.10.2025 02:24:21
// Design Name: 
// Module Name: tb_con_u
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

module tb_con_u;

localparam   w = 32;
logic        rst = 0, clk = 1;
tri[w-1:0]   bus;
logic        con_in = 0, con_out = 0;
logic[w-1:0] IR;

logic signed[w-1:0] val_bus;//
logic        drive_bus = 0;

always #5 clk = ~clk;

assign bus = drive_bus ? val_bus : 'bz;

clocking cb @(negedge clk);
    output rst, con_out, IR, val_bus, drive_bus;
endclocking

con_u #(.w(w)) dut (
    .rst(rst),
    .clk(clk),
    .bus(bus),
    .IR(IR),
    .con_in(con_in),
    .con_out(con_out) );
    
initial begin
    cb.rst       <= 1; repeat(2) @(cb);
    cb.rst       <= 0;
    con_in       <= 1;
    cb.IR        <= 32'd0; @(cb);
    cb.IR        <= 32'd1; @(cb);
    
    cb.drive_bus <= 1;    
    cb.val_bus   <= 32'b0;        
    cb.IR        <= 32'd2; @(cb); 
    $display ("\n*value = %1d*", val_bus);
    $display ("=0  : %1b", con_out);  
    cb.IR        <= 32'd3; @(cb);
    $display ("!=0 : %1b", con_out); 
    cb.IR        <= 32'd4; @(cb);  
    $display (">=0 : %1b", con_out); 
    cb.IR        <= 32'd5; @(cb); 
    $display ("<0  : %1b", con_out); 
          
    cb.val_bus   <= 32'b1;        
    cb.IR        <= 32'd2; @(cb); 
    $display ("\n*value = %1d*", val_bus);
    $display ("=0  : %1b", con_out);  
    cb.IR        <= 32'd3; @(cb);
    $display ("!=0 : %1b", con_out); 
    cb.IR        <= 32'd4; @(cb);  
    $display (">=0 : %1b", con_out); 
    cb.IR        <= 32'd5; @(cb); 
    $display ("<0  : %1b", con_out); 
    
    cb.val_bus   <= 32'hFFFFFFFF;        
    cb.IR        <= 32'd2; @(cb); 
    $display ("\n*value = %1d*", val_bus);
    $display ("=0  : %1b", con_out);  
    cb.IR        <= 32'd3; @(cb);
    $display ("!=0 : %1b", con_out); 
    cb.IR        <= 32'd4; @(cb);  
    $display (">=0 : %1b", con_out); 
    cb.IR        <= 32'd5; @(cb); 
    $display ("<0  : %1b", con_out); 
    $finish;    
end

endmodule