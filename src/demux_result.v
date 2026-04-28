module demux_result ( ReadData, ALUResult,ResultSrc,Result);
    input [31:0] ReadData;
    input [31:0] ALUResult;
    input ResultSrc;
    output [31:0] Result;
    assign Result = (ResultSrc == 1'b1) ? ReadData : ALUResult; // if ResultSrc is 1, we take the data from memory, otherwise we take the result from the ALU
    // this demux can be used for ALUISrc tpp
endmodule
module demux_Src (RD, imm, ALUSRC, Src);
    input [31:0] RD;
    input [31:0] imm;
    input ALUSRC;
    output [31:0] Src;
    assign Src = (ALUSRC == 1'b1) ? imm : RD;
endmodule