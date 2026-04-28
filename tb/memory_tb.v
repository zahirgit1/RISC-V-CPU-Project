`timescale 1ns / 1ps

module memory_tb();

    reg [31:0] Write_Data;
    reg [31:0] A;
    reg Write_Enable;
    reg clk, reset;
    wire [31:0] Read_Data;

    data_memory dut (
        .Write_Data(Write_Data),
        .A(A),
        .Write_Enable(Write_Enable),
        .clk(clk),
        .reset(reset),
        .Read_Data(Read_Data)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Test sequence
        reset = 1;
        Write_Enable = 0;
        Write_Data = 32'h00000000;
        A = 32'h00000000;
        #10;
        
        // Release reset
        reset = 0;
        #10;
        
        // Test 1: Write to memory
        reset = 1;
        Write_Enable = 1;
        A = 32'h00000000;
        Write_Data = 32'hDEADBEEF;
        #10;
        
        // Test 2: Write to another address
        A = 32'h00000004;
        Write_Data = 32'hCAFEBABE;
        #10;
        
        // Test 3: Read from first address
        Write_Enable = 0;
        A = 32'h00000000;
        #10;
        $display("Read from address 0x00000000: 0x%08h (Expected: 0xDEADBEEF)", Read_Data);
        
        // Test 4: Read from second address
        A = 32'h00000004;
        #10;
        $display("Read from address 0x00000004: 0x%08h (Expected: 0xCAFEBABE)", Read_Data);
        
        // Test 5: Write and read from different address
        Write_Enable = 1;
        A = 32'h00000008;
        Write_Data = 32'h12345678;
        #10;
        
        Write_Enable = 0;
        #10;
        $display("Read from address 0x00000008: 0x%08h (Expected: 0x12345678)", Read_Data);
        
        #20;
        $finish;
    end

endmodule
