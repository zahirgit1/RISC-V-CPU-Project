`timescale 1ns/1ps

module sign_extend_tb;

    reg [31:0] In;
    reg [1:0] ImmSrc;
    wire [31:0] Imm_Ext;

    Sign_Extend dut (
        .In(In),
        .ImmSrc(ImmSrc),
        .Imm_Ext(Imm_Ext)
    );

    initial begin
        // Test case 1: I-type instruction (ImmSrc = 0)
        In = 32'h7FF00000;
        ImmSrc = 2'b00;
        #10;
        $display("Test 1 - I-type: In=%h, ImmSrc=%b, Imm_Ext=%h,", In, ImmSrc, Imm_Ext);

        // Test case 2: S-type instruction (ImmSrc = 1)
        In = 32'hFFFF0000;
        ImmSrc = 2'b01;
        #10;
        $display("Test 2 - S-type: In=%h, ImmSrc=%b, Imm_Ext=%h", In, ImmSrc, Imm_Ext);

        // Test case 3: I-type with negative immediate
        In = 32'hFFF00000;
        ImmSrc = 2'b00;
        #10;
        $display("Test 3 - I-type negative: In=%h, ImmSrc=%b, Imm_Ext=%h", In, ImmSrc, Imm_Ext);

        // Test case 4: S-type with positive immediate
        In = 32'h00F00000;
        ImmSrc = 2'b01;
        #10;
        $display("Test 4 - S-type positive: In=%h, ImmSrc=%b, Imm_Ext=%h", In, ImmSrc, Imm_Ext);

        // Test case 5: B-type instruction (ImmSrc = 2)
        In = 32'h00000000; // Example input for B-type
        ImmSrc = 2'b10;
        #10;
        $display("Test 5 - B-type: In=%h, ImmSrc=%b, Imm_Ext=%h", In, ImmSrc, Imm_Ext);

        $finish;
    end

endmodule
