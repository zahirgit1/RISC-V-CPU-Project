module hazard_unit (Rs1E,Rs2E,Rs1D,Rs2D,RdE,RdM,RdW,
                    PCSrcE,ResultSrcE0,RegWriteM,RegWriteW,
                    StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE);
  input [4:0] Rs1E;
  input [4:0] Rs2E;
  input [4:0] Rs1D;
  input [4:0] Rs2D;
  input [4:0] RdE;
  input [4:0] RdM;
  input [4:0] RdW;
  input PCSrcE;
  input ResultSrcE0;
  input RegWriteM;
  input RegWriteW;
  output StallF;
  output StallD;
  output FlushD;
  output FlushE;
  output [1:0] ForwardAE;
  output [1:0] ForwardBE;
  wire  lwStall;

    assign ForwardAE = (RegWriteM && (RdM != 0) && (RdM == Rs1E)) ? 2'b10 : // Forward from MEM stage
            (RegWriteW && (RdW != 0) && (RdW == Rs1E)) ? 2'b01 : // Forward from WB stage
                    2'b00; // No forwarding

    assign ForwardBE = (RegWriteM && (RdM != 0) && (RdM == Rs2E)) ? 2'b10 : // Forward from MEM stage
            (RegWriteW && (RdW != 0) && (RdW == Rs2E)) ? 2'b01 : // Forward from WB stage
                    2'b00; // No forwarding
        assign lwStall = ResultSrcE0 && (RdE != 0) &&
                                         ((RdE == Rs1D) || (RdE == Rs2D));
    assign StallF = lwStall; // Stall the fetch stage if there's a load-use hazard
    assign StallD = lwStall; // Stall the decode stage if there's a load-use hazard
    assign FlushD = PCSrcE; // Flush the fetched instruction after a taken branch or jump
    assign FlushE = lwStall || PCSrcE; // Insert a bubble for load-use or taken control flow
endmodule
