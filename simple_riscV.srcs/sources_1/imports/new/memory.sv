`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.10.2025 14:40:53
// Design Name: 
// Module Name: memory
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

module memory #(
    parameter w = 32,
    parameter mem_size = 1024,
    parameter string initfile = "C:\\Users\\matan\\OneDrive\\Desktop\\simple_riscV\\program_init\\temp_test.hex"
    )(    
    //inout  logic[w-1:0]   bus,   //just for tb
    input  logic          clk,
    input  logic          rst,
    input  logic          read, write, Wait,
    input  logic          MAin,
    input  logic          MDout, MDbus,    
    input  logic[w-1:0]   bus_in,
    output logic[w-1:0]   bus_out  
    
    );        
    logic[w-1:0]          memory[0:mem_size-1];
    localparam            addr_bits = $clog2(mem_size);
    
    initial $display("initfile resolved to: '%s'", initfile);

    initial begin   
        //$display("[%0t] loading program from %s", $time, initfile);
        $readmemh (initfile, memory);
        
        end

    
    logic[w-1:0]          MD;
    logic[addr_bits-1:0]  MA;    
    
    logic                 strobe;
    assign                strobe = ~Wait;

    always_ff @(posedge clk) begin
        if      (rst)   MA <= '0;
        else if (MAin)  MA <= bus_in[addr_bits-1:0];
    end
    
    always_ff @(posedge clk) begin
        if      (rst)             MD           <= '0;
        else if (MDbus)           MD           <= bus_in;
        else if (read  & strobe)  MD           <= memory[MA];   
        else if (write & strobe)  memory[MA]   <= MD;            
    end
    
    assign bus_out = (MDout) ? MD : 'bz;
endmodule


//////test for branch - (Ra = x, Rb =  br, Rc = indicator) -  if(con=1)  Rc = 1;/////    
    /*memory[0] = 32'b00010000010000000000000000000000;
    memory[1] = 32'b00000000000000000000000000000001;
    memory[2] = 32'b00010000100000000000000000000000;
    memory[3] = 32'b00000000000000000000000000001001;    
    memory[4] = 32'b00010000110000000000000000000000;
    memory[5] = 32'b00000000000000000000000000000001;
    memory[6] = 32'b01000000000001000001000000000100;
    memory[7] = 32'b00010000110000000000000000000000;    
    memory[8] = 32'b00000000000000000000000000000000;    
    memory[9] = 32'b11111000000000000000000000000000;*/

    /*
    //////test for shifter - ( shift ra rb times and save in rc)
    memory[0] = 8'b00010000;
    memory[1] = 8'b01000000;
    memory[2] = 8'b00000000;
    memory[3] = 8'b00000000;
    memory[4] = 8'b00000000;
    memory[5] = 8'b00000000;
    memory[6] = 8'b00000000;
    memory[7] = 8'b00000001;
    memory[8] = 8'b00010000;
    memory[9] = 8'b10000000;
    memory[10] = 8'b00000000;
    memory[11] = 8'b00000000;
    memory[12] = 8'b00000000;
    memory[13] = 8'b00000000;
    memory[14] = 8'b00000000;
    memory[15] = 8'b00001001;  
    memory[16] = 8'b11100000;
    memory[17] = 8'b11000010;
    memory[18] = 8'b00100000;
    memory[19] = 8'b00000000;  
    memory[20] = 8'b11111000;
    memory[21] = 8'b00000000;
    memory[22] = 8'b00000000;
    memory[23] = 8'b00000000;  
    */
     //////from Hnan test
    /*
    memory[0] = 32'b00101000000000000000000100000000;    //  la r0, 64
    memory[4] = 32'b00101000010000000000010000000000;    //  la r1, 4096
    memory[8] = 32'b00101000100000000000000000010100;    //  la r2, Loop(20)
    memory[12] = 32'b00101000110000000000000000101100;    //  la r3, Case(44) 
    memory[16] = 32'b00101001000000000000000000110000;    //  la r4, Next(48)  
    memory[20] = 32'b00001010000000100000000000000000;    //  ld r8, 0(r1)
    memory[24] = 32'b00001010010000100001000000000000;    //  ld r9, 4096(r1)
    memory[28] = 32'b01110010100100101000000000000000;    //  sub r10, r9, r8
    memory[32] = 32'b01000000110101000000000000000010;    //  brmi r3, r10
    memory[36] = 32'b00011010010000100010000000000000;    //  st r9, 8192(r1)
    memory[40] = 32'b01000001000000000000000000000011;   //  br r4
    memory[44] = 32'b00011010000000100010000000000000;   //  st r8, 8192(r1)
    memory[48] = 32'b01101000010000100000000000000100;   //  addi r1, r1, 4
    memory[52] = 32'b01101000000000011111111111111111;   //  addi r0, r0, -1
    memory[56] = 32'b01000000100000000000000000000001;   //  brnz r2, r0
    memory[60] = 32'b11111000000000000000000000000000;   //  stop
    */ 


