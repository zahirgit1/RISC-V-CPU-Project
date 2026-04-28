`timescale 1ns / 1ps

module alu_tb;
    // Testbench signals
    reg [31:0] A, B;
    reg [3:0] ALUControl;
    wire [31:0] Result;
    wire Zero, Overflow, Negative, CarryOUT;
    
    // Instantiate ALU module
    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero),
        .Overflow(Overflow),
        .Negative(Negative),
        .CarryOUT(CarryOUT)
    );
    
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
        
        // Test 1: ADD (ALUControl = 0000)
        A = 32'd10;
        B = 32'd20;
        ALUControl = 4'b0000;
        #10;
        $display("ADD: A=%d, B=%d, Result=%d, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        // Test 2: SUB (ALUControl = 0001)
        A = 32'd50;
        B = 32'd20;
        ALUControl = 4'b0001;
        #10;
        $display("SUB: A=%d, B=%d, Result=%d, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        // Test 3: AND (ALUControl = 0010)
        A = 32'hFFFF0000;
        B = 32'h00FF00FF;
        ALUControl = 4'b0010;
        #10;
        $display("AND: A=%h, B=%h, Result=%h, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        // Test 4: OR (ALUControl = 0011)
        A = 32'hFFFF0000;
        B = 32'h0000FFFF;
        ALUControl = 4'b0011;
        #10;
        $display("OR: A=%h, B=%h, Result=%h, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        // Test 5: SLT (ALUControl = 0101)
        A = 32'd10;
        B = 32'd20;
        ALUControl = 4'b0101;
        #10;
        $display("SLT: A=%d, B=%d, Result=%d, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        // Test 6: SLT (A >= B)
        A = 32'd30;
        B = 32'd20;
        ALUControl = 4'b0101;
        #10;
        $display("SLT: A=%d, B=%d, Result=%d, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        // Test 7: ADD with Zero result
        A = 32'd100;
        B = 32'hFFFFFF9C; // -100 in 2's complement
        ALUControl = 4'b0000;
        #10;
        $display("ADD (Zero): A=%d, B=%h, Result=%d, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
       
        // Test 8: ADD with Overflow result
        A = 32'd100;
        B = 32'h7FFFFFFF; // Max positive value in 2's complement
        ALUControl = 4'b0000;
        #10;
        $display("ADD (Overflow): A=%d, B=%h, Result=%d, Zero=%b, Overflow=%b, Negative=%b, CarryOUT=%b", 
                 A, B, Result, Zero, Overflow, Negative, CarryOUT);
        
        $finish;
    end
endmodule
