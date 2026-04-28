module main_decoder(op,Branch,ResultSrc,MemWrite,ALUSrc,ImmSrc,RegWrite,ALUOp);
    input [6:0] op;
    output reg Branch,ResultSrc,MemWrite,ALUSrc,RegWrite;
    output reg [1:0] ImmSrc,ALUOp;
    
    always @(*) begin
        case(op)
            7'b0000011: begin //lw
                Branch = 0;
                ResultSrc = 1;
                MemWrite = 0;
                ALUSrc = 1;
                ImmSrc = 2'b00; //I-type
                RegWrite = 1;
                ALUOp = 2'b00; //add
            end
            7'b0100011: begin //sw
                Branch = 0;
                ResultSrc = 0; //don't care about this signal for sw
                MemWrite = 1;
                ALUSrc = 1;
                ImmSrc = 2'b01; //S-type
                RegWrite = 0;
                ALUOp = 2'b00; //add
            end
            7'b1100011: begin //beq
                Branch = 1;
                ResultSrc = 0; //don't care about this signal for beq
                MemWrite = 0;
                ALUSrc = 0;
                ImmSrc = 2'b10; //B-type
                RegWrite = 0;
                ALUOp = 2'b01; //subtract
            end
            7'b0110011: begin //R-type
                Branch = 0;     
                ResultSrc = 0; 
                MemWrite = 0;
                ALUSrc = 0;
                ImmSrc = 2'b00; //don't care for R-type
                RegWrite = 1;
                ALUOp = 2'b10; //R-type
            end
            7'b0010011: begin //I-type arithmetic instructions
                Branch = 0;     
                ResultSrc = 0; 
                MemWrite = 0;
                ALUSrc = 1;
                ImmSrc = 2'b00; //I-type
                RegWrite = 1;
                ALUOp = 2'b11; //I-type arithmetic (distinguish from R-type)
            end
            default: begin //default case for unsupported instructions
                Branch = 0;
                ResultSrc = 0;
                MemWrite = 0;
                ALUSrc = 0;
                ImmSrc = 2'b00;
                RegWrite = 0;
                ALUOp = 2'b00;
            end
        endcase
    end
endmodule

module alu_decoder(ALUOp,Funct3,Funct7,ALUControl);
    input [1:0] ALUOp;
    input [2:0] Funct3;
    input [6:0] Funct7;
    output reg [2:0] ALUControl;
    
    always @(*) begin 
        case(ALUOp)
            2'b00: ALUControl = 3'b000; //add for lw and sw
            2'b01: ALUControl = 3'b001; //subtract for beq
            2'b10: begin //R-type arithmetic instructions (check Funct7 and Funct3)
                case (Funct3)
                    3'b000: ALUControl = (Funct7 == 7'b0000000) ? 3'b000 : 3'b001; // ADD (Funct7=0) or SUB (Funct7=32)
                    3'b111: ALUControl = 3'b010; //AND
                    3'b110: ALUControl = 3'b011; //OR
                    default: ALUControl = 3'b000; //default to add
                endcase
            end
            2'b11: begin //I-type arithmetic instructions (don't check Funct7, always use Funct3)
                case (Funct3)
                    3'b000: ALUControl = 3'b000; //ADD for ADDI
                    3'b111: ALUControl = 3'b010; //AND for ANDI
                    3'b110: ALUControl = 3'b011; //OR for ORI
                    default: ALUControl = 3'b000; //default to add
                endcase
            end
            default: ALUControl = 3'b000; //default to add
        endcase
    end
endmodule


module Control_unit (Op, Funct3, Funct7,Zero,PcSrc,ResultSrc,MemWrite,ALUControl,ALUSrc,ImmSrc,RegWrite);
    input [6:0] Op;
    input [2:0] Funct3;
    input [6:0] Funct7;
    input Zero;
    output  PcSrc,ResultSrc,MemWrite,ALUSrc,RegWrite;
    output  [1:0] ImmSrc;
    output  [2:0] ALUControl;
    //wires to connect the main decoder and alu decoder
    wire [1:0] ALUOp;
    wire branch;
    main_decoder main_dec (
        .op(Op),
        .Branch(branch),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );
    alu_decoder alu_dec (
        .ALUOp(ALUOp),
        .Funct3(Funct3),
        .Funct7(Funct7),
        .ALUControl(ALUControl)
    );
    //PcSrc is the branch signal ANDed with the zero flag
    assign PcSrc = branch & Zero;

endmodule

