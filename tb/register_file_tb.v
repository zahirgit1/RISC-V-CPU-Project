`timescale 1ns/1ps

module register_file_tb;
    
    // Testbench signals
    reg [4:0] A1, A2, A3;
    reg [31:0] Write_Data3;
    reg Write_Enable3;
    reg clk, reset;
    wire [31:0] Read_Data1, Read_Data2;
    
    // Instantiate the register file module
    register_files uut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .Write_Data3(Write_Data3),
        .Write_Enable3(Write_Enable3),
        .clk(clk),
        .reset(reset),
        .Read_Data1(Read_Data1),
        .Read_Data2(Read_Data2)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        A1 = 5'b0;
        A2 = 5'b0;
        A3 = 5'b0;
        Write_Data3 = 32'h0;
        Write_Enable3 = 1'b0;
        
        // Apply reset
        #10 reset = 1;
        
        // Test 1: Read from register 0 (should be 0)
        #10 A1 = 5'd0; A2 = 5'd0;
        #10 $display("Test 1 - Read from R0: Read_Data1=%h, Read_Data2=%h (Expected: 00000000)", Read_Data1, Read_Data2);
        
        // Test 2: Write to register 1
        #10 A3 = 5'd1; Write_Data3 = 32'hDEADBEEF; Write_Enable3 = 1'b1;
        #10 Write_Enable3 = 1'b0;
        
        // Test 3: Read from register 1
        #10 A1 = 5'd1; A2 = 5'd0;
        #10 $display("Test 3 - Read from R1: Read_Data1=%h, Read_Data2=%h (Expected: DEADBEEF, 00000000)", Read_Data1, Read_Data2);
        
        // Test 4: Write to multiple registers
        #10 A3 = 5'd2; Write_Data3 = 32'hCAFECAFE; Write_Enable3 = 1'b1;
        #10 A3 = 5'd3; Write_Data3 = 32'hBABEFACE; Write_Enable3 = 1'b1;
        #10 Write_Enable3 = 1'b0;
        
        // Test 5: Read from registers 2 and 3
        #10 A1 = 5'd2; A2 = 5'd3;
        #10 $display("Test 5 - Read from R2,R3: Read_Data1=%h, Read_Data2=%h (Expected: CAFECAFE, BABEFACE)", Read_Data1, Read_Data2);
        
        // Test 6: Reset and verify read is 0
        #10 reset = 0;
        #10 $display("Test 6 - After reset: Read_Data1=%h, Read_Data2=%h (Expected: 00000000, 00000000)", Read_Data1, Read_Data2);
        
        // Test 7: Reset release and read again
        #10 reset = 1;
        #10 A1 = 5'd1; A2 = 5'd2;
        #10 $display("Test 7 - After reset release: Read_Data1=%h, Read_Data2=%h (Expected: DEADBEEF, CAFECAFE)", Read_Data1, Read_Data2);
        
        #20 $finish;
    end
    
    initial begin
        $monitor("Time=%0t | A1=%d, A2=%d, A3=%d | Write_Data3=%h | WE=%b | Read_Data1=%h, Read_Data2=%h | reset=%b", 
                 $time, A1, A2, A3, Write_Data3, Write_Enable3, Read_Data1, Read_Data2, reset);
    end

endmodule
