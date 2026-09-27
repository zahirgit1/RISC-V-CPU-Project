
module Top_cpu (clk, reset);
    input clk, reset;
    // program counter wires

    // Fetch stage wires


    wire [31:0] PC; // Current program counter
    wire [31:0] PCF; // Next program counter value
    wire [31:0] PCPlus4F; // PC + 4 for sequential execution
    wire [31:0] PC_Next_Branch; // PC + immediate for branch instructions
    wire [31:0] InstrF; // Instruction fetched from instruction memory


    // Decode stage wires


    wire [31:0] PCD; // Instruction in decode stage
    wire [31:0] PCPlus4D; // PC + 4 for decode
    wire [31:0] InstrD; // Instruction in decode stage
   // Control signals 
    wire [6:0] Op;
    wire [2:0] Funct3;
    wire [6:0] Funct7;
    wire [4:0] RS1;//goes to A1 of register file
    wire [4:0] RS2;//goes to A2 of register file
    wire [4:0] RdD;//goes to A3 of register file
    wire [31:0] Imm;

    wire [1:0] ResultSrcD; // Control signal to select between ALU result and memory data for writing back to register
    wire MemWriteD; // Memory write enable signal
    wire ALUSrcD; // Control signal to select between register data and immediate for ALU operand B
    wire RegWriteD; // Register write enable signal
    wire [2:0] ALUControlD;
    wire JumpD,BranchD; // Control signal to indicate a jump instruction
    wire [2:0] ImmSrcD; // Control signal to select the type of immediate
    wire [31:0] ImmExtD; // multiplexed immediate value after sign extension
    wire [31:0] RD1D, RD2D; // Register data read from register file

    // Execute stage wires
    wire [31:0] PCE; // Program counter in execute stage
    wire [31:0] PCPlus4E; // PC + 4 in execute stage
    wire [31:0] RD1E, RD2E; // Register data in execute stage
    wire [4:0] RdE; // Destination register in execute stage
    wire [31:0] ImmExtE; // Immediate value in execute stage
    wire [2:0] ALUControlE; // ALU control signal in execute stage
    wire ALUSrcE; // ALU source control signal in execute stage
    wire RegWriteE, MemWriteE, BranchE, JumpE; // Control signals
    wire [31:0] ALUResultE; // ALU result in execute stage
    wire [31:0] WriteDataE; // Data to be written to memory in execute stage
    wire [1:0] ResultSrcE; // Control signal to select between ALU result and memory data for writing back to register in execute stage
    assign WriteDataE = RD2E; // Data to be written to memory is the second register data in execute stage
    // Alu Flags

    wire ZeroE; 
    wire Overflow;
    wire Negative;
    wire CarryOUT;
    wire PcSrcE; // Control signal to select between PC+4 and branch target for next PC
    // file register outputs 


    // ALU inputs and outputs
    wire [31:0] ALU_B;
    wire [31:0] ALU_Result;


    
    // Memory stage wires
    wire [31:0] ALUResultM, WriteDataM; // ALU result and write data in memory stage
    wire [4:0] RdM; // Destination register in memory stage
    wire [31:0] Read_Data_Mem; // Data read from memory
    wire [31:0] PCPlus4M; // PC + 4 in memory stage
    wire [31:0] ImmExtM; // Immediate value in memory stage
    wire [1:0] ResultSrcM; // Control signal to select between ALU result and memory data for writing back to register in memory stage
    wire RegWriteM, MemWriteM; // Control signals in memory stage

    // Write Back stage wires
    wire [31:0] ALUResultW; // ALU result in write back stage
    wire [31:0] ReadDataW; // Data read from memory in write back stage
    wire [31:0] PCPlus4W; // PC + 4 in write back stage
    wire [31:0] ImmExtW; // Immediate value in write back stage
    wire [4:0] RdW; // Destination register in write back stage
    wire [1:0] ResultSrcW; // Control signal to select between ALU result and memory data for writing back to register in write back stage
    wire RegWriteW; // Register write enable signal in write back stage

    wire [31:0] Write_Data_Reg;
    // Control unit assigns control signals based on opcode and function fields
    assign Op = InstrD[6:0];
    assign Funct3 = InstrD[14:12];
    assign Funct7 = InstrD[31:25];
    assign RS1 = InstrD[19:15];
    assign RS2 = InstrD[24:20];
    assign RdD = InstrD[11:7];
    assign Imm = InstrD[31:0];// immediate value taken (takes all the cases in considiration)

    
    // Fetch stage: PC, instruction memory, and PC incrementer
    PC pc_reg (
        .PC(PCF),
        .PC_Next(PC),
        .clk(clk),
        .reset(reset)
    );
    
    Pc_incrementer pc_add (
        .PC(PCF),
        .imm_ext(32'd4),
        .PC_Inc(PCPlus4F)
    );
    
    Instruction_memory instr_mem (
        .Address(PCF),
        .reset(reset),
        .ReadData(InstrF)
    );
    // Fetch Pipeline Register
    // This register holds the instruction fetched from memory and the PC+4 value for the next
    fetch_instruction fetch_pip_reg  (
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .Instruction_F(InstrF),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .Instruction_D(InstrD),
        .clk(clk),
        .reset(reset)
    );

    //Decode stage: Control unit, register file, sign extend, and demux for ALU source
    Control_unit control (
        .Op(Op),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .Jump(JumpD),
        .Branch(BranchD),
        .ResultSrc(ResultSrcD),
        .MemWrite(MemWriteD),
        .ALUControl(ALUControlD),
        .ALUSrc(ALUSrcD),
        .RegWrite(RegWriteD),
        .ImmSrc(ImmSrcD)
    );
    
    register_files reg_file (
        .A1(RS1),
        .A2(RS2),
        .A3(RdW),
        .Write_Data3(Write_Data_Reg),// modify when i get to WB stage
        .Write_Enable3(RegWriteW),
        .clk(clk),
        .reset(reset),
        .Read_Data1(RD1D),
        .Read_Data2(RD2D)
    );
    
    Sign_Extend sign_ext (
        .In(InstrD),
        .Imm_Ext(ImmExtD),
        .ImmSrc(ImmSrcD)
    );
    
    // Decode Pipeline Register
    decode_instruction decode_pipeline_reg  (
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .ALUControlD(ALUControlD),
        .AluSrcD(ALUSrcD),
        .ResultSrcD(ResultSrcD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .PCD(PCD),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .ALUControlE(ALUControlE),
        .AluSrcE(ALUSrcE),
        .ResultSrcE(ResultSrcE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .RdE(RdE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .clk(clk),
        .reset(reset)
    );

    // Execute stage: ALU, data memory, and demux for result source
    demux_Src alu_src_mux (
        .RD(RD2E),
        .imm(ImmExtE),
        .ALUSRC(ALUSrcE),
        .Src(ALU_B)
    );
    
    alu alu_unit (
        .A(RD1E),
        .B(ALU_B),
        .ALUControl({1'b0, ALUControlE}),
        .Result(ALU_Result),
        .Zero(ZeroE),
        .Overflow(Overflow),
        .Negative(Negative),
        .CarryOUT(CarryOUT)
    );

    Pc_incrementer branch_calc (
        .PC(PCE),
        .imm_ext(ImmExtE),
        .PC_Inc(PC_Next_Branch)
    );
    
    // Execute Pipeline Register
    execute_instruction execute_pip_reg (
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .ALUResultE(ALU_Result),
        .WriteDataE(WriteDataE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .ImmExtE(ImmExtE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .ALUResultM(ALUResultM ),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .ImmExtM(ImmExtM),
        .clk(clk),
        .reset(reset)
    );
    // Memory stage: Data memory and demux for result source
    data_memory data_mem (
        .Write_Enable(MemWriteM),
        .Write_Data(WriteDataM),
        .A(ALUResultM),
        .Read_Data(Read_Data_Mem),
        .clk(clk),
        .reset(reset)
    );
    // Memory Pipeline Register
    WriteBack_instruction memory_pip_reg  (
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .ReadDataM(Read_Data_Mem),
        .AluResultM(ALUResultM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .ImmExtM(ImmExtM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ReadDataW(ReadDataW),
        .AluResultW(ALUResultW),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W),
        .ImmExtW(ImmExtW), 
        .clk(clk),
        .reset(reset)
    ); 
    // Write Back stage: Demux for result source
    demux_result result_mux (
        .ReadData(ReadDataW),
        .PCplus4(PCPlus4W),
        .ALUResult(ALUResultW),
        .ResultSrc(ResultSrcW),
        .Imm_Ext(ImmExtW),
        .Result(Write_Data_Reg)
    );
    

    assign PcSrcE = (BranchE & ZeroE) | JumpE; // Control signal to select between PC+4 and branch target for next PC
    assign PC = (PcSrcE) ? PC_Next_Branch : PCPlus4F;

endmodule
