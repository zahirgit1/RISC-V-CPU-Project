module Instruction_memory(Address,reset, ReadData);
    input [31:0]Address;
    output [31:0] ReadData;
    input reset;

    reg [31:0] memory [1023:0];
    assign ReadData = (!reset)? {32{1'b0}} : memory[Address[31:2]];

    initial begin
        memory[0] = 32'h04000093;   // ADDI x1, x0, 64
        memory[1] = 32'h00700113;   // ADDI x2, x0, 7
        memory[2] = 32'h00500193;   // ADDI x3, x0, 5
        memory[3] = 32'h00000893;   // ADDI x17, x0, 0
        memory[4] = 32'h00000a13;   // ADDI x20, x0, 0
        memory[5] = 32'h00310233;   // ADD x4, x2, x3
        memory[6] = 32'h003202b3;   // ADD x5, x4, x3
        memory[7] = 32'h40228333;   // SUB x6, x5, x2
        memory[8] = 32'h0042f3b3;   // AND x7, x5, x4
        memory[9] = 32'h0042e433;   // OR x8, x5, x4
        memory[10] = 32'h005324b3;   // SLT x9, x6, x5
        memory[11] = 32'h02a00513;   // ADDI x10, x0, 42
        memory[12] = 32'h00a0a023;   // SW x10, 0(x1)
        memory[13] = 32'h0000a583;   // LW x11, 0(x1)
        memory[14] = 32'h00258633;   // ADD x12, x11, x2
        memory[15] = 32'h03100693;   // ADDI x13, x0, 49
        memory[16] = 32'h00d60463;   // BEQ x12, x13, taken_branch
        memory[17] = 32'h06f00713;   // ADDI x14, x0, 111
        memory[18] = 32'h00e00713;   // ADDI x14, x0, 14
        memory[19] = 32'h00310863;   // BEQ x2, x3, branch_bad
        memory[20] = 32'h00f00793;   // ADDI x15, x0, 15
        memory[21] = 32'h00c0086f;   // JAL x16, after_jal
        memory[22] = 32'h07500893;   // ADDI x17, x0, 117
        memory[23] = 32'h06300a13;   // ADDI x20, x0, 99
        memory[24] = 32'h00080933;   // ADD x18, x16, x0
        memory[25] = 32'h06300013;   // ADDI x0, x0, 99
        memory[26] = 32'h00100993;   // ADDI x19, x0, 1
        memory[27] = 32'h0000006f;   // JAL x0, done
    end
endmodule
