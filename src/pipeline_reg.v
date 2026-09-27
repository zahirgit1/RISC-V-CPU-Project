module fetch_instruction(PCF,PCplus4F,Instruction_F,
                        PCE,PCPlus4D,Instruction_D,
                        clk,reset);
    input clk,reset;
    input [31:0] PCF,PCplus4F,Instruction_F;
    output reg [31:0] PCE,PCPlus4D,Instruction_D;   

    always @(posedge clk) begin
        if (!reset) begin
            PCE <= 32'h00000000;
            PCPlus4D <= 32'h00000000;
            Instruction_D <= 32'h00000000;
        end else begin
            PCE <= PCF;
            PCPlus4D <= PCplus4F;
            Instruction_D <= Instruction_F;
        end
    end
endmodule

module decode_instruction(RegWriteD, MemWriteD, BranchD, JumpD,ALUControlD,AluSrcD,
                          RD1D, RD2D,PCD,RdD,ImmExtD,PCD,PCplus4D,
                          RegWriteE, MemWriteE, BranchE, JumpE,ALUControlE,AluSrcE,
                          RD1E, RD2E,PCE,RdE,ImmExtE,PCE,PCplus4E,
                          clk,reset);
    input clk,reset;
    input RegWriteD, MemWriteD, BranchD, JumpD,AluSrcD;
    input [2:0] ALUControlD;
    input [31:0] RD1D, RD2D,PCD,ImmExtD,PCplus4D;
    input [4:0] RdD;
    output reg RegWriteE, MemWriteE, BranchE, JumpE,AluSrcE;
    output reg [2:0] ALUControlE;
    output reg [31:0] RD1E, RD2E,PCE,ImmExtE,PCplus4E;
    output reg [4:0] RdE;   

    always @(posedge clk) begin
        if (!reset) begin
            RegWriteE <= 0;
            MemWriteE <= 0;
            BranchE <= 0;
            JumpE <= 0;
            AluSrcE <= 0;
            ALUControlE <= 3'b000;
            RD1E <= 32'h00000000;
            RD2E <= 32'h00000000;
            PCE <= 32'h00000000;
            RdE <= 5'b00000;
            ImmExtE <= 32'h00000000;
            PCplus4E <= 32'h00000000;
        end else begin
            RegWriteE <= RegWriteD;
            MemWriteE <= MemWriteD;
            BranchE <= BranchD;
            JumpE <= JumpD;
            AluSrcE <= AluSrcD;
            ALUControlE <= ALUControlD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            RdE <= RdD;
            ImmExtE <= ImmExtD;
            PCplus4E <= PCplus4D;
        end
    end

endmodule

module execute_instruction(RegWriteE, MemWriteE,ResultSrcE
                          ,ALUResultE,WriteDataE,RdE,PCPlus4E,
                          RegWriteM, MemWriteM, ResultSrcM,
                          ALUResultM,WriteDataM,RdM,PCPlus4M,
                          clk,reset);
    input clk,reset;
    input RegWriteE, MemWriteE;
    input [1:0] ResultSrcE;
    input [31:0] ALUResultE,WriteDataE,PCPlus4E;
    input [4:0] RdE;
    output reg RegWriteM, MemWriteM;
    output reg [1:0] ResultSrcM;
    output reg [31:0] ALUResultM,WriteDataM,PCPlus4M;
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
        end else begin
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            ResultSrcM <= ResultSrcE;
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            RdM <= RdE;
            PCPlus4M <= PCPlus4E;
        end
    end
endmodule

module WriteBack_instruction(RegWriteM, ResultSrcM, ReadDataM,RdM,PCplus4M,
                            RegWriteW, ResultSrcW,  ReadDataW,RdW,PCplus4W,
                            clk,reset);
    input clk,reset;
    input RegWriteM;
    input [1:0] ResultSrcM;
    input [31:0] ReadDataM, PCplus4M;
    input [4:0] RdM;
    output reg RegWriteW;
    output reg [1:0] ResultSrcW;
    output reg [31:0] ReadDataW, PCplus4W;
    output reg [4:0] RdW;   

    always @(posedge clk) begin
        if (!reset) begin
            RegWriteW <= 0;
            ResultSrcW <= 2'b00;
            ReadDataW <= 32'h00000000;
            RdW <= 5'b00000;
            PCplus4W <= 32'h00000000;
        end else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            ReadDataW <= ReadDataM;
            RdW <= RdM;
            PCplus4W <= PCplus4M;
        end
    end
endmodule