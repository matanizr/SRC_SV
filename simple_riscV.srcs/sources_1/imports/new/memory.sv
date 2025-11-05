`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: matan and roei labs
// Engineer: matan izraeli and roei sabag
// 
// Create Date : 26.10.2025 18:52:05
// Design Name : the memory unit of the CPU
// Module Name : memory
// Description : the memory unit, includes the memory data register (MD) and the memory address register (MA)
//////////////////////////////////////////////////////////////////////////////////

module memory #(
    parameter w = 32,
    parameter mem_size = 1024,
    parameter string initfile = "C:\\simple_riscV_project\\simple_riscV\\temp_test.hex"   //the file with the program
    )(    
    //inout  logic[w-1:0]   bus,   //just for tb
    input  logic          clk, rst,
    input  logic          read, write,          //read and write signals
    input  logic          MAin, MDout, MDbus,   //signals for the MA and the MD
    output logic          Done,                 //signal for finish read/write
    input  logic[w-1:0]   bus_in,               //input from the bus
    output logic[w-1:0]   bus_out               //output to the bus  
    );        
    logic[w-1:0]          memory[0:mem_size-1];           //the memory of the CPU (size - 1024 x 4 bytes)
    localparam            addr_bits = $clog2(mem_size);   //size for adrress (depand the memory size)
    
    initial begin  
        $readmemh (initfile, memory);     //  read the program from the file 
        end

    
    logic[w-1:0]          MD;            //memory data register
    logic[addr_bits-1:0]  MA;            //memory address register
    
    logic                 strobe;        //signal from the control unit to enable read\write (wired here to 1 const)
    assign                strobe = 1'b1;

    always_ff @(posedge clk) begin
        if      (rst)   MA <= '0;        //reset the MA
        else if (MAin)  MA <= bus_in[addr_bits-1:0];       //get address from the bus to the MA
    end
    
    always_ff @(posedge clk) begin
        Done <= 1'b0;   
        
        if      (rst)    MD         <= '0;           //reset the MD
        else if (MDbus)  MD         <= bus_in;       //get data from the bus to the MD
        else if (read  & strobe)  begin
                         MD         <= memory[MA];   //read to the MD from the address that in the MA 
                         Done       <= 1'b1; end     // send done when read has finished
        else if (write & strobe)  begin
                         memory[MA] <= MD;           //write to the address that in the MA the word that inside the MD
                         Done       <= 1'b1; end     // send done when write has finished      
    end
    
    assign bus_out = (MDout) ? MD : 'bz;             //send the MD to the bus when MDout=1
endmodule

