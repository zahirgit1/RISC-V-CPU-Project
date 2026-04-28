
module Top_cpu (clk, reset);
    input clk, reset;
    // program counter wires
    wire [31:0] PC; // Current program counter
    wire [31:0] PC_Next; // Next program counter value
    wire [31:0] PC_Inc; // PC + 4 for sequential execution
    wire [31:0] PC_Next_Branch; // PC + immediate for branch instructions
   
    wire [31:0] Instruction;

   // Control signals 
    wire [6:0] Op;
    wire [2:0] Funct3;
    wire [6:0] Funct7;
    wire [4:0] RS1;//goes to A1 of register file
    wire [4:0] RS2;//goes to A2 of register file
    wire [4:0] RD;//goes to A3 of register file
    wire [31:0] Imm;//immediate value extended from instruction
    
    wire Branch; // Branch control signal
    wire ResultSrc; // Control signal to select between ALU result and memory data for writing back to register
    wire MemWrite; // Memory write enable signal
    wire ALUSrc; // Control signal to select between register data and immediate for ALU operand B
    wire RegWrite; // Register write enable signal
    wire [2:0] ALUOp; 
    wire [2:0] ALUControl;
    wire PcSrc; // Control signal to select between PC+4 and branch target for next PC
    wire [1:0] ImmSrc; // Control signal to select the type of immediate

    // Alu Flags
    wire Zero; 
    wire Overflow;
    wire Negative;
    wire CarryOUT;
    
    // file register outputs 
    wire [31:0] Read_Data1;
    wire [31:0] Read_Data2;

    // ALU inputs and outputs
    wire [31:0] ALU_B;
    wire [31:0] ALU_Result;
    wire [31:0] Read_Data_Mem;
    wire [31:0] Write_Data_Reg;
    wire [31:0] Imm_Ext; // multiplexed immediate value after sign extension
    

    // Control unit assigns control signals based on opcode and function fields
    assign Op = Instruction[6:0];
    assign Funct3 = Instruction[14:12];
    assign Funct7 = Instruction[31:25];
    assign RS1 = Instruction[19:15];
    assign RS2 = Instruction[24:20];
    assign RD = Instruction[11:7];
    assign Imm = Instruction[31:0];// immediate value taken (takes all the cases in considiration)
    
    PC pc_reg (
        .PC(PC),
        .PC_Next(PC_Next),
        .clk(clk),
        .reset(reset)
    );
    
    Pc_incrementer pc_add (
        .PC(PC),
        .imm_ext(32'd4),
        .PC_Inc(PC_Inc)
    );
    
    Instruction_memory instr_mem (
        .Address(PC),
        .reset(reset),
        .ReadData(Instruction)
    );
    
    Control_unit control (
        .Op(Op),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .Zero(Zero),
        .PcSrc(PcSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc)
    );
    
    register_files reg_file (
        .A1(RS1),
        .A2(RS2),
        .A3(RD),
        .Write_Data3(Write_Data_Reg),
        .Write_Enable3(RegWrite),
        .clk(clk),
        .reset(reset),
        .Read_Data1(Read_Data1),
        .Read_Data2(Read_Data2)
    );
    
    Sign_Extend sign_ext (
        .In(Imm),
        .Imm_Ext(Imm_Ext),
        .ImmSrc(ImmSrc)
    );
    
    demux_Src alu_src_mux (
        .RD(Read_Data2),
        .imm(Imm_Ext),
        .ALUSRC(ALUSrc),
        .Src(ALU_B)
    );
    
    alu alu_unit (
        .A(Read_Data1),
        .B(ALU_B),
        .ALUControl({1'b0, ALUControl}),
        .Result(ALU_Result),
        .Zero(Zero),
        .Overflow(Overflow),
        .Negative(Negative),
        .CarryOUT(CarryOUT)
    );
    
    data_memory data_mem (
        .Write_Enable(MemWrite),
        .Write_Data(Read_Data2),
        .A(ALU_Result),
        .Read_Data(Read_Data_Mem),
        .clk(clk),
        .reset(reset)
    );
    
    demux_result result_mux (
        .ReadData(Read_Data_Mem),
        .ALUResult(ALU_Result),
        .ResultSrc(ResultSrc),
        .Result(Write_Data_Reg)
    );
    
    Pc_incrementer branch_calc (
        .PC(PC),
        .imm_ext(Imm_Ext),
        .PC_Inc(PC_Next_Branch)
    );
    
    assign PC_Next = (PcSrc) ? PC_Next_Branch : PC_Inc;

endmodule
