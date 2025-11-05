`timescale 1ns / 1ps

module tb_SRC;

logic[31:0]   memory[0:1023];
logic clk = 1, rst = 0, strt = 0;


always #5 clk = ~clk;

SRC_top dut (
    .rst(rst),
    .clk(clk),
    .strt(strt) );

    
initial begin     
    rst  = 1;            @(posedge clk);
    rst  = 0;  
    strt = 1;            @(posedge clk);
    strt = 0;            repeat(3000) @(posedge clk); 
    $display("finish");  
    $finish;
end
endmodule
