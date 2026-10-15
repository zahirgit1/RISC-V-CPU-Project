module fetch_instruction(PCF, PCPlus4F, Instruction_F,
                         PCD, PCPlus4D, Instruction_D,
                         clk, reset, EN, clr);
    input clk, reset, EN, clr;
    input [31:0] PCF, PCPlus4F, Instruction_F;
    output reg [31:0] PCD, PCPlus4D, Instruction_D;

    always @(posedge clk) begin
        if (!reset || clr) begin
            PCD <= 32'h00000000;
            PCPlus4D <= 32'h00000000;
            Instruction_D <= 32'h00000000;
        end else if (EN) begin
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
            Instruction_D <= Instruction_F;
        end
        // Otherwise, hold the current values.
    end
endmodule

module decode_instruction(RegWriteD, MemWriteD, BranchD, JumpD, ALUControlD, AluSrcD, ResultSrcD,
                          RD1D, RD2D, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D,
                          RegWriteE, MemWriteE, BranchE, JumpE, ALUControlE, AluSrcE, ResultSrcE,
                          RD1E, RD2E, PCE, Rs1E, Rs2E, RdE, ImmExtE, PCPlus4E,
                          clk, reset, clr);
    input clk, reset, clr;
    input RegWriteD, MemWriteD, BranchD, JumpD, AluSrcD;
    input [1:0] ResultSrcD;
    input [2:0] ALUControlD;
    input [31:0] RD1D, RD2D, PCD, ImmExtD, PCPlus4D;
    input [4:0] Rs1D, Rs2D, RdD;
    output reg RegWriteE, MemWriteE, BranchE, JumpE, AluSrcE;
    output reg [1:0] ResultSrcE;
    output reg [2:0] ALUControlE;
    output reg [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E;
    output reg [4:0] Rs1E, Rs2E, RdE;

    always @(posedge clk) begin
        if (!reset || clr) begin
            RegWriteE <= 0;
            MemWriteE <= 0;
            BranchE <= 0;
            JumpE <= 0;
            AluSrcE <= 0;
            ResultSrcE <= 2'b00;
            ALUControlE <= 3'b000;
            RD1E <= 32'h00000000;
            RD2E <= 32'h00000000;
            PCE <= 32'h00000000;
            Rs1E <= 5'b00000;
            Rs2E <= 5'b00000;
            RdE <= 5'b00000;
            ImmExtE <= 32'h00000000;
            PCPlus4E <= 32'h00000000;
        end else begin
            RegWriteE <= RegWriteD;
            MemWriteE <= MemWriteD;
            BranchE <= BranchD;
            JumpE <= JumpD;
            AluSrcE <= AluSrcD;
            ResultSrcE <= ResultSrcD;
            ALUControlE <= ALUControlD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;
        end
    end
endmodule

// ...existing code...

module execute_instruction(RegWriteE, MemWriteE,ResultSrcE
                          ,ALUResultE,WriteDataE,RdE,PCPlus4E,ImmExtE,
                          RegWriteM, MemWriteM, ResultSrcM,
                          ALUResultM,WriteDataM,RdM,PCPlus4M,ImmExtM,
                          clk,reset);
    input clk,reset;
    input RegWriteE, MemWriteE;
    input [1:0] ResultSrcE;
    input [31:0] ALUResultE,WriteDataE,PCPlus4E,ImmExtE;
    input [4:0] RdE;
    output reg RegWriteM, MemWriteM;
    output reg [1:0] ResultSrcM;
    output reg [31:0] ALUResultM,WriteDataM,PCPlus4M,ImmExtM;
    output reg [4:0] RdM;

    always @(posedge clk) begin
        if (!reset) begin
            RegWriteM <= 0;
            MemWriteM <= 0;
            ResultSrcM <= 2'b00;
            ALUResultM <= 32'h00000000;
            WriteDataM <= 32'h00000000;
            RdM <= 5'b00000;
            PCPlus4M <= 32'h00000000;
            ImmExtM <= 32'h00000000;
        end else begin
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            ResultSrcM <= ResultSrcE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            PCPlus4M <= PCPlus4E;
            ImmExtM <= ImmExtE;
        end
    end
endmodule

module WriteBack_instruction(RegWriteM, ResultSrcM, ReadDataM,RdM,PCPlus4M,ImmExtM,AluResultM,
                            RegWriteW, ResultSrcW,  ReadDataW,RdW,PCPlus4W,ImmExtW,AluResultW,
                            clk,reset);
    input clk,reset;
    input RegWriteM;
    input [1:0] ResultSrcM;
    input [31:0] ReadDataM, PCPlus4M, ImmExtM, AluResultM;
    input [4:0] RdM;
    output reg RegWriteW;
    output reg [1:0] ResultSrcW;
    output reg [31:0] ReadDataW, PCPlus4W, ImmExtW, AluResultW;
    output reg [4:0] RdW;   

    always @(posedge clk) begin
        if (!reset) begin
            RegWriteW <= 0;
            ResultSrcW <= 2'b00;
            ReadDataW <= 32'h00000000;
            AluResultW <= 32'h00000000;
            RdW <= 5'b00000;
            PCPlus4W <= 32'h00000000;
            ImmExtW <= 32'h00000000;
        end else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            ReadDataW <= ReadDataM;
            AluResultW <= AluResultM;
            RdW <= RdM;
            PCPlus4W <= PCPlus4M;
            ImmExtW <= ImmExtM;
        end
    end
endmodule