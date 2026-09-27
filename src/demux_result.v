module demux_result ( ReadData, ALUResult,Imm_Ext,ResultSrc,PCplus4,Result);
    input [31:0] ReadData;
    input [31:0] ALUResult;
    input [31:0] PCplus4;
    input [31:0] Imm_Ext;
    input [1:0]ResultSrc;
    output [31:0] Result;
    assign Result = (ResultSrc == 2'b01) ? ReadData : //01 for load instruction, we take the data from memory
                    ResultSrc == 2'b00 ? ALUResult : //00 for R-type and I-type arithmetic instructions, we take the result from the ALU
                    ResultSrc == 2'b10 ? PCplus4 : //10 for JAL instruction, we take the PC+4 value
                    ResultSrc == 2'b11 ? Imm_Ext : //11 for LUI instruction, we take the immediate value
                    32'b0; // if ResultSrc is 1, we take the data from memory, otherwise we take the result from the ALU
    // this demux can be used for ALUISrc tpp
endmodule
module demux_Src (RD, imm, ALUSRC, Src);
    input [31:0] RD;
    input [31:0] imm;
    input ALUSRC;
    output [31:0] Src;
    assign Src = (ALUSRC == 1'b1) ? imm : RD;
endmodule