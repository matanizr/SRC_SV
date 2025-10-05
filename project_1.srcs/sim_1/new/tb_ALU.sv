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
localparam   w = 32;
logic        clk = 0, rst;
tri[w-1:0]   bus;
logic[3:0]   op;
logic        Ain, Cin, Cout;
logic[w-1:0] c_check, a_check;
logic        tb_drive_bus;
logic[w-1:0] tb_val_bus;
logic        zero = 0, negative = 0, overflow;

always #5 clk = ~clk;

assign bus = (tb_drive_bus) ? tb_val_bus : 'bz;

ALU #(.w(w)) dut(
    .clk(clk), .rst(rst), .bus(bus), .op(op), .Ain(Ain),
    .Cin(Cin), .Cout(Cout), .a_check(a_check), .c_check(c_check));

/*always @(op) begin
    @(posedge clk);
    case(op)
        4'b0000: $display("BtoC : b = %0d ; c = %0d", bus, c_check);
        4'b0001: $display("shr  : b = %0b ; c = %0b", bus, c_check);
        4'b0010: $display("shl  : b = %0b ; c = %0b", bus, c_check);
        4'b0011: $display("shc  : b = %0b ; c = %0b", bus, c_check);
        4'b0100: $display("shra : b = %0b ; c = %0b", bus, c_check);
        4'b0101: $display("not  : b = %0b ; c = %0b", bus, c_check);
        4'b0110: $display("inc4 : b = %0d ; c = %0d", bus, c_check);
        //4'b0111: $display("add  : %0d + %0d = %0d"  , a, bus, result);
        //4'b1000: $display("sub  : %0d - %0d = %0d"  , a, bus, result);
        //4'b1001: $display("or   : %0b OR %0b = %0b" , a, bus, result);    
        //4'b1010: $display("and  : %0b AND %0b = %0b", a, bus, result);       
    endcase
end */
/*initial begin 
    rst = 0; Ain = 0; Cout = 0; 
    tb_drive_bus = 1; tb_val_bus = '0; op = '0;
 end*/


initial begin
    rst = 1; Ain = 0; Cout = 0; 
    tb_drive_bus = 1; tb_val_bus = '0; op = '0;
    repeat(2) @(posedge clk); rst = 0;

    tb_drive_bus = 1;
    tb_val_bus   = 32'b10000000000000000000000000000001;
    Cin          = 1;
    Cout         = 0;
    
    op = 4'b0000; repeat(2) @(posedge clk);
    $display("BtoC : b = %032b ; c = %032b", bus, c_check);
    op = 4'b0001; repeat(2) @(posedge clk);
    $display("shr  : b = %032b ; c = %032b", bus, c_check);
    op = 4'b0010; repeat(2) @(posedge clk);
    $display("shl  : b = %032b ; c = %032b", bus, c_check);
    op = 4'b0011; repeat(2) @(posedge clk);
    $display("shc  : b = %032b ; c = %032b", bus, c_check);
    op = 4'b0100; repeat(2) @(posedge clk);
    $display("shra : b = %032b ; c = %032b", bus, c_check);
    op = 4'b0101; repeat(2) @(posedge clk);
    $display("not  : b = %032b ; c = %032b", bus, c_check);
    op = 4'b0110; repeat(2) @(posedge clk);
    $display("inc4 : b = %0d ; c = %0d", bus, c_check);
    
    @(posedge clk);
    Cin = 0;
    
    tb_val_bus   = 32'd6;
    Ain = 1; repeat(2) @(posedge clk); Ain = 0;
    tb_val_bus   = 32'd5;   
    op = 4'b0111; Cin = 1; repeat(2) @(posedge clk);
    $display("add  : %0d + %0d = %0d"  , a_check, bus, c_check);
    Cin = 0;
    
    tb_val_bus   = 32'd8;
    Ain = 1; repeat(2) @(posedge clk); Ain = 0;
    tb_val_bus   = 32'd5;   
    op = 4'b1000; Cin = 1; repeat(2) @(posedge clk);
    $display("sub  : %0d - %0d = %0d"  , a_check, bus, c_check);
    Cin = 0;
    
    tb_val_bus   = 32'b10000000000000000000000000000001;
    Ain = 1; repeat(2) @(posedge clk); Ain = 0;
    tb_val_bus   = 32'b00000000000000010000000000000000;   
    op = 4'b1001; Cin = 1; repeat(2) @(posedge clk);
    $display("or   : %032b OR %032b = %032b"  , a_check, bus, c_check);
    Cin = 0;
    
    tb_val_bus   = 32'b10000000000000000000000000000001;
    Ain = 1; repeat(2) @(posedge clk); Ain = 0;
    tb_val_bus   = 32'b00000000000000010000000000000000;   
    op = 4'b1010; Cin = 1; repeat(2) @(posedge clk);
    $display("and  : %032b AND %032b = %032b"  , a_check, bus, c_check);
    Cin = 0;
    
    //op = 4'b0111; #5;
    //op = 4'b1000; #5;
    //op = 4'b1001; #5;
    //op = 4'b1010; #5;
    $finish;
end 
endmodule



/*task automatic show;
    $display("a=%0d, b=%0d, op=%b => result=%0d \n zero=%b, overflow=%b, negative=%b", a, b, op, result, zero, overflow, negative);
endtask;*/