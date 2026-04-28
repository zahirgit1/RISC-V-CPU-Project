module Instruction_memory(Address,reset, ReadData);
    input [31:0]Address;
    output [31:0] ReadData;
    input reset;


    reg [31:0] memory [1023:0];
    assign ReadData = (!reset)? {32{1'b0}} : memory[Address[31:2]];

    initial begin
        memory[0] = 32'h00C00093;   // ADDI x1, x0, 12: x1 = 12 (address for store/load)
        memory[1] = 32'h00A00113;   // ADDI x2, x0, 10: x2 = 10 (data to store)
        memory[2] = 32'h001123B3;   // SLT x7, x2, x1: x7 = (x2<x1) = (10<12) = 1 (R-type)
        memory[3] = 32'h00500213;   // ADDI x4, x0, 5: x4 = 5 (for logic operations)
        memory[4] = 32'h01008263;   // BEQ x1, x2, +16: if x1==x2 branch (NOT taken, 12≠10)
        memory[5] = 32'h00212023;   // SW x2, 0(x1): Store x2 at memory[x1]=12
        memory[6] = 32'h00012183;   // LW x3, 0(x1): Load from memory[x1] into x3
        memory[7] = 32'h00208233;   // ADD x4, x1, x2: x4 = 22 (R-type, 12+10)
        memory[8] = 32'h40208333;   // SUB x6, x1, x2: x6 = 2 (R-type, 12-10)
        memory[9] = 32'h00727433;   // AND x8, x4, x7: x8 = 22 & 1 = 0 (R-type)
        memory[10] = 32'h00726533;  // OR x10, x4, x7: x10 = 22 | 1 = 23 (R-type)
        memory[11] = 32'h00000033;  // ADD x0, x0, x0: NOP
        memory[12] = 32'h00000000;
        memory[13] = 32'h00000000;
        memory[14] = 32'h00000000;
        memory[15] = 32'h00000000;
    end
endmodule