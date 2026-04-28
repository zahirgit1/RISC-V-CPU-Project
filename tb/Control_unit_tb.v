`timescale 1ns / 1ps

module Control_unit_tb();
    // Test signals
    reg [6:0] Op;
    reg [2:0] Funct3;
    reg [6:0] Funct7;
    reg Zero;
    
    // Output signals
    wire PcSrc, ResultSrc, MemWrite, ALUSrc, RegWrite;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;
    
    // Instantiate the Control_unit module
    Control_unit dut (
        .Op(Op),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .Zero(Zero),
        .PcSrc(PcSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );
    
    initial begin
        $display("=== Control Unit Testbench ===");
        $display("Time | Op       | Func3 | Func7    | Zero | PcSrc | ResultSrc | MemWrite | ALUSrc | ImmSrc | RegWrite | ALUControl");
        $display("-----|----------|-------|----------|------|-------|-----------|----------|--------|--------|----------|------------");
        
        // Test 1: LW instruction (0000011)
        Op = 7'b0000011;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 2: SW instruction (0100011)
        Op = 7'b0100011;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 3: BEQ instruction (1100011) with Zero = 0
        Op = 7'b1100011;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 4: BEQ instruction (1100011) with Zero = 1 (branch taken)
        Op = 7'b1100011;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        Zero = 1;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 5: R-type ADD (0110011, Funct3=000, Funct7=0000000)
        Op = 7'b0110011;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 6: R-type SUB (0110011, Funct3=000, Funct7=0100000)
        Op = 7'b0110011;
        Funct3 = 3'b000;
        Funct7 = 7'b0100000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 7: R-type AND (0110011, Funct3=111)
        Op = 7'b0110011;
        Funct3 = 3'b111;
        Funct7 = 7'b0000000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        // Test 8: R-type OR (0110011, Funct3=110)
        Op = 7'b0110011;
        Funct3 = 3'b110;
        Funct7 = 7'b0000000;
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
        
        $display("=== Test Complete ===");
        $finish;

        // Test 9: I-type ADDI (0010011, Funct3=000)
        Op = 7'b0010011;
        Funct3 = 3'b000;
        Funct7 = 7'b0000000; // don't care for I-type
        Zero = 0;
        #10;
        $display("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b", 
                 $time, Op, Funct3, Funct7, Zero, PcSrc, ResultSrc, MemWrite, ALUSrc, ImmSrc, RegWrite, ALUControl);
    end
endmodule
