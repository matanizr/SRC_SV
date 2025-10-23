`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2025 15:14:35
// Design Name: 
// Module Name: tb_ALU
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

module tb_alu;
localparam            w = 32;
logic                 clk = 1, rst = 0;
tri[w-1:0]            bus;
logic[3:0]            op;
logic                 Ain = 0, Cin = 0, Cout = 0;
logic signed [w-1:0]  c_check, a_check;    // just for TB
logic                 tb_drive_bus = 0;
logic[w-1:0]          tb_val_bus;
logic                 zero, negative, overflow, carry;

always #5 clk = ~clk;

clocking cb @(negedge clk);
    default input #1step output #0;
    output op, Cin, Cout, Ain, tb_val_bus, tb_drive_bus, rst; 
    input c_check, a_check, bus;
endclocking

default clocking cb;

assign bus = (tb_drive_bus) ? tb_val_bus : 'bz;

ALU #(.w(w)) dut(
    .clk(clk), .rst(rst), .bus(bus), .op(op), .Ain(Ain),
    .Cin(Cin), .Cout(Cout), .a_check(a_check), .c_check(c_check),
    .Zf(zero), .Nf(negative), .Vf(overflow), .Cf(carry));

initial begin
    
//////////////////// flag check ////////////////////////////////////////////
    $display("-------- flags ---------");
    cb.tb_drive_bus   <=  1; @(cb)
    
    //zero flag
    cb.tb_val_bus <= 32'b00000000000000000000000000000001;   
    cb.Ain        <= 1'b1; @(cb)
    cb.Ain        <= 1'b0;
    cb.tb_val_bus <= 32'b00000000000000000000000000000001;   
    cb.op         <= 4'b1000;
    cb.Cin        <= 1'b1; @(cb)
    cb.Cin        <= 1'b0; @(cb)
    $display("sub : %0d - %0d = %0d", a_check, cb.bus, c_check);   
    
    //negative flag
    cb.tb_val_bus <= 32'b11111111111111111111111111111111;   
    cb.Ain        <= 1'b1; @(cb)
    cb.Ain        <= 1'b0;
    cb.tb_val_bus <= 32'b00000000000000000000000000000001;   
    cb.op         <= 4'b1000;
    cb.Cin        <= 1'b1; @(cb)
    cb.Cin        <= 1'b0; @(cb)
    $display("sub : %0d - %0d = %0d", a_check, cb.bus, c_check);
    
    //carry flag
    cb.tb_val_bus <= 32'b11111111111111111111111111111111;                        
    cb.Ain        <= 1'b1; @(cb)
    cb.Ain        <= 1'b0;
    cb.tb_val_bus <= 32'b00000000000000000000000000000010;   
    cb.op         <= 4'b0111;
    cb.Cin        <= 1'b1; @(cb)
    cb.Cin        <= 1'b0; @(cb)
    $display("add : %032b + %032b = %032b", a_check, cb.bus, c_check);
    
    //overflow flag
    cb.tb_val_bus <= 32'b10000000000000000000000000000000;                        
    cb.Ain        <= 1'b1; @(cb)
    cb.Ain        <= 1'b0;
    cb.tb_val_bus <= 32'b00000000000000000000000000000001;   
    cb.op         <= 4'b1000;
    cb.Cin        <= 1'b1; @(cb)
    cb.Cin        <= 1'b0; @(cb)
    $display("sub : %032b - %032b = %032b", a_check, cb.bus, c_check); @(cb);
    

//////////////////// Op check //////////////////////////////////////////// 
    $display("-------- OP ------------");   
    @(cb);
    cb.tb_val_bus    <= 32'h80000001;
    cb.tb_drive_bus  <= 1;
    cb.Cin           <= 1;
      
    cb.op <= 4'b0000; @(cb);
    $display("BtoC : b = %032b ; c = %032b", bus, c_check);
    cb.op <= 4'b0001; @(cb);
    $display("shr  : b = %032b ; c = %032b", bus, c_check); 
    cb.op <= 4'b0010; @(cb);
    $display("shl  : b = %032b ; c = %032b", bus, c_check);
    cb.op <= 4'b0011; @(cb);
    $display("shc  : b = %032b ; c = %032b", bus, c_check);
    cb.op <= 4'b0100; @(cb);
    $display("shra : b = %032b ; c = %032b", bus, c_check);
    cb.op <= 4'b0101; @(cb);
    $display("not  : b = %032b ; c = %032b", bus, c_check);
    cb.op <= 4'b0110; @(cb);
    $display("inc4 : b = %0d ; c = %0d", bus, c_check);
    
    @(cb);
    cb.Cin <= 0;
    
    cb.tb_val_bus <= 32'd6;
    cb.Ain        <= 1; @(cb);
    cb.Ain        <= 0;
    cb.tb_val_bus <= 32'd5;   
    cb.op         <= 4'b0111;
    cb.Cin        <= 1; @(cb);    
    $display("add  : %0d + %0d = %0d"  , a_check, bus, c_check);
    cb.Cin        <= 0;
    
    cb.tb_val_bus <= 32'd8;
    cb.Ain        <= 1; @(cb); 
    cb.Ain        <= 0;
    cb.tb_val_bus <= 32'd5;   
    cb.op         <= 4'b1000; 
    cb.Cin        <= 1; @(cb);
    $display("sub  : %0d - %0d = %0d"  , a_check, bus, c_check);
    cb.Cin        <= 0;
    
    cb.tb_val_bus <= 32'b10000000000000000000000000000001;
    cb.Ain        <= 1; @(cb);
    cb.Ain        <= 0;
    cb.tb_val_bus <= 32'b00000000000000010000000000000000;   
    cb.op         <= 4'b1001;
    cb.Cin        <= 1; @(cb);
    $display("or   : %032b OR %032b = %032b"  , a_check, bus, c_check);
    cb.Cin        <= 0;
    
    cb.tb_val_bus <= 32'b10000000000000000000000000000001;
    cb.Ain        <= 1; @(cb);
    cb.Ain        <= 0;
    cb.tb_val_bus <= 32'b00000000000000010000000000000000;   
    cb.op         <= 4'b1010;
    cb.Cin        <= 1; @(cb);
    $display("and  : %032b AND %032b = %032b"  , a_check, bus, c_check);
    cb.Cin        <= 0;  
    
    
    $finish;
end 
endmodule



