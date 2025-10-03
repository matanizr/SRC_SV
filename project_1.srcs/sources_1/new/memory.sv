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
    mem_size = 1024,
    addr_bits = $clog2(mem_size)
    )(
    inout  logic[w-1:0]   bus,
    input  logic          clk,
    input  logic          rst,
    input  logic          read, write, Wait,
    input  logic          MAin,
    input  logic          MDout, MDbus
    );
    logic[w-1:0]          memory[0:mem_size-1];
    
    logic[w-1:0]          MD;
    logic[addr_bits-1:0]  MA;
    
    logic                 strobe;
    assign                strobe = ~Wait;

    always_ff @(posedge clk) begin
        if      (rst)   MA <= '0;
        else if (MAin)  MA <= bus[addr_bits-1:0];
    end

    always_ff @(posedge clk) begin
        if      (rst)             MD         <= '0;
        else if (MDbus)           MD         <= bus;
        else if (read  && strobe) MD         <= memory[MA];
        else if (write && strobe) memory[MA] <= MD;
    end

    assign bus = (MDout) ? MD : 'bz;
endmodule



/*module memory_block #(
    parameter w = 32,
    mem_size = 1024,
    addr_bits = $clog2(mem_size)
    )(
    inout  logic[w-1:0]  bus,
    input  logic         clk,
    input  logic         rst,
    input  logic         read, write, Wait,
    input  logic         MAin,
    input  logic         MDout, MDbus,
    input  logic[w-1:0]  address,
    inout  logic[w-1:0]  data  
    );  
    logic[w-1:0]         memory[0:mem_size-1];
    logic                strobe;
    assign               strobe = ~Wait;
    
    always_ff @(posedge clk) begin
        if (write && strobe) memory[address[addr_bits-1:0]] <= data;
        if (read  && strobe) data <= memory[address[addr_bits-1:0]];
    end 
    
MA #(.w(w)) u_ma(
    .MAin(MAin),
    .clk(clk),
    .rst(rst),
    .bus(bus),
    .address(address)
    );
MD #(.w(w)) u_md(
    .bus(bus),
    .clk(clk),
    .strobe(strobe),
    .rst(rst),    
    .MDout(MDout),
    .MDbus(MDbus),
    .data(data)
    );
endmodule 
    
module MA #(parameter w = 32)(
    inout  logic[w-1:0]  bus,
    input  logic         clk,
    input  logic         rst,
    input  logic         MAin,
    output logic[w-1:0]  address                    
    );  
    always_ff @(posedge clk) begin
        if      (rst)  address <= '0;
        else if (MAin) address <= bus;
    end  
endmodule

module MD #(parameter w = 32)(
    inout  logic[w-1:0]  bus,
    input  logic         clk,
    input  logic         rst,
    input  logic         strobe,
    input  logic         MDout, MDbus,
    inout logic[w-1:0]  data
    );    
    logic[w-1:0]         MDreg;
    assign               data = MDreg;
    
    always_ff @(posedge clk) begin
        if      (rst)   MDreg <= 0;   
        else if (MDbus) MDreg <= bus;         
    end    
    
    assign bus = (MDout && strobe) ? MDreg : 'bz; 
endmodule*/



/*module memory_block #(parameter w = 32, mem_size = 1024, addr_bits = $clog2(mem_size))(
    inout  logic[w-1:0]  bus,
    inout  logic[w-1:0]  memory_bus,
    input  logic         clk,
    input  logic         rst,
    input  logic         read, write, Wait,
    input  logic         MAin,
    input  logic         MDout, MDbus    
    );  
    logic[w-1:0]         memory[0:mem_size-1];
    logic[w-1:0]         MDreg;
    logic[w-1:0]         address;
    logic                strobe = ~Wait;
    
    always_ff @(posedge clk) begin
        if (write) memory[address[addr_bits-1:0]] <= memory_bus;
    end 
    
    assign memory_bus = read ? memory[address[addr_bits-1:0]] : 'bz;
    
MA #(.w(w)) u_ma(
    .MAin(MAin),
    .clk(clk),
    .rst(rst),
    .bus(bus),
    .address(address)
    );
MD #(.w(w)) u_md(
    .bus(bus),
    .memory_bus(memory_bus),
    .clk(clk),
    .rst(rst),
    .MDout(MDout),
    .MDbus(MDbus),
    .MDrd(read),
    .MDwr(write),
    .strobe(strobe),
    .MDreg(MDreg)
    );
endmodule 
    
module MA #(parameter w = 32)(
    inout  logic[w-1:0]  bus,
    input  logic         clk,
    input  logic         rst,
    input  logic         MAin,
    output logic[w-1:0]  address                    
    );  
    always_ff @(posedge clk) begin
        if      (rst)  address <= '0;
        else if (MAin) address <= bus;
    end  
endmodule

module MD #(parameter w = 32)(
    inout  logic[w-1:0]  bus,
    inout  logic[w-1:0]  memory_bus,
    input  logic         clk,
    input  logic         MDout, MDbus, MDrd, MDwr, strobe,  
    output logic[w-1:0]  MDreg,
    input  logic         rst

    );
    
    always_ff @(posedge clk) begin
        if      (rst)              MDreg <= '0;        
        else if (MDbus && strobe)  MDreg <= bus;
        else if (MDrd && strobe)   MDreg <= memory_bus;
        
    end
    
    assign bus        = (MDout) ? MDreg : 'bz;  
    assign memory_bus = (MDwr)  ? MDreg : 'bz; 
endmodule*/




