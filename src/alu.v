module alu(A,B,ALUControl,Result,Zero,Overflow,Negative,CarryOUT);
    input  [31:0]A,B;
    input [3:0] ALUControl;
    output  [31:0] Result;
    output  Zero,Overflow,Negative,CarryOUT;

    // relevant wires for operations
    wire [31:0] a_and_b;
    wire [31:0] a_or_b;
    wire [31:0] not_b;
    wire overflow_wire;
    wire [31:0] result_mux;

    // slt result
    wire slt_result;
    wire [31:0] slt;

    // B or not b multiplexer
    wire [31:0] b_mux;

    // adder result and carry out
    wire [31:0] sum;
    wire c_out;

    // logic operations
    assign a_and_b = A & B;
    assign a_or_b = A | B;
    assign not_b = ~B;

    // b or not b mux
    assign b_mux = (ALUControl[0]) ? not_b : B;
    
    // adder
    assign {c_out, sum} = A + b_mux + ALUControl[0];// ALUControl[0] is the carry in for subtraction



    // alu flags carry out and overflow
    assign CarryOUT = c_out &(~ALUControl[1]); // Carry out is only relevant for ADD/SUB
    assign overflow_wire = (~ALUControl[1]) & (~(A[31] ^ B[31] ^ ALUControl[0])) & (A[31] ^ sum[31]);


    assign slt_result = sum[31] ^ overflow_wire; // SLT is true if the result of A-B is negative (sum[31] == 1) or if there is an overflow in a negative direction
    assign slt = {31'b0, slt_result}; // SLT result is 1 if A < B, otherwise 0

    assign result_mux = (ALUControl == 3'b000) ? sum :        // ADD
        (ALUControl == 3'b001) ? sum :        // SUB
        (ALUControl == 3'b010) ? a_and_b :    // AND
        (ALUControl == 3'b011) ? a_or_b :     // OR
        (ALUControl == 3'b101) ? slt :        // SLT
        32'b0;        // Default
    
    //final result and flags    
    assign Result = result_mux;    
    assign Zero = &(~result_mux);  // Zero flag is set if Result is zero
    assign Negative = result_mux[31];
    assign Overflow = overflow_wire; // Overflow flag is set if there is an overflow in the operation

endmodule
