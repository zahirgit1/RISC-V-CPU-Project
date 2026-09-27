module Instruction_memory(Address,reset, ReadData);
    input [31:0]Address;
    output [31:0] ReadData;
    input reset;


    reg [31:0] memory [1023:0];
    assign ReadData = (!reset)? {32{1'b0}} : memory[Address[31:2]];

    initial begin
        for (integer i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'h00000033; // default to NOP
        end

       memory[0] = 32'h00c00093;   // ADDI x1, x0, 12      # x1 = 12 (address for store/load)
        memory[1] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[2] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[3] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[4] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[5] = 32'h00a00113;   // ADDI x2, x0, 10      # x2 = 10 (data to store)
        memory[6] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[7] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[8] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[9] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[10] = 32'h001123b3;   // SLT x7, x2, x1       # x7 = (x2<x1) = (10<12) = 1 (R-type)
        memory[11] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[12] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[13] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[14] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[15] = 32'h00500213;   // ADDI x4, x0, 5       # x4 = 5 (for logic operations)
        memory[16] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[17] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[18] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[19] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[20] = 32'h0abcd2b7;   // LUI x5, 0xABCD       # x5 = 0xABCD0000 (U-type immediate test)
        memory[21] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[22] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[23] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[24] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[25] = 32'h00208863;   // BEQ x1, x2, 16       # if x1==x2 branch (NOT taken, 12≠10)
        memory[26] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[27] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[28] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[29] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[30] = 32'h0220a823;   // SW x2, 48(x1)        # Store x2 at memory[x1]=12
        memory[31] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[32] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[33] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[34] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[35] = 32'h0000a183;   // LW x3, 0(x1)         # Load from memory[x1] into x3
        memory[36] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[37] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[38] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[39] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[40] = 32'h00208233;   // ADD x4, x1, x2       # x4 = 22 (R-type, 12+10)
        memory[41] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[42] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[43] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[44] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[45] = 32'h40208333;   // SUB x6, x1, x2       # x6 = 2 (R-type, 12-10)
        memory[46] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[47] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[48] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[49] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[50] = 32'h00727433;   // AND x8, x4, x7       # x8 = 22 & 1 = 0 (R-type)
        memory[51] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[52] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[53] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[54] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[55] = 32'h00726533;   // OR x10, x4, x7       # x10 = 22 | 1 = 23 (R-type)
        memory[56] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[57] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[58] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[59] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[60] = 32'h007265b3;   // OR x11, x4, x7       # x11 = 22 | 1 = 23 (R-type)
        memory[61] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[62] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[63] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[64] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[65] = 32'h03c004ef;   // JAL x9, skip         # jump over the next instruction block
        memory[66] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[67] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[68] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[69] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[70] = 32'h06300613;   // ADDI x12, x0, 99     # should be skipped
        memory[71] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[72] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[73] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[74] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[75] = 32'h05800693;   // ADDI x13, x0, 88     # should be skipped
        memory[76] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[77] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[78] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[79] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[80] = 32'h04700693;   // ADDI x13, x0, 71       # NOP
        memory[81] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[82] = 32'h00000033;   // ADD x0, x0, x0        # NOP
        memory[83] = 32'h00000033;   // ADD x0, x0, x0        # NOP

    end
endmodule