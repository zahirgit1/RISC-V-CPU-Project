module PC(PC,PC_Next,clk,reset);
    input [31:0] PC_Next;
    input clk, reset;
    output reg [31:0] PC;

    always @(posedge clk) begin
        if (!reset) begin
            PC <= 32'h00000000; // Reset PC to 0
        end else begin
            PC <= PC_Next; // Update PC with the next value
        end
    end

endmodule
module Pc_incrementer(PC,PC_Inc,imm_ext);// used for the +4 too
    input [31:0] PC;
    input [31:0] imm_ext;
    output [31:0] PC_Inc;

    assign PC_Inc = PC + imm_ext; // Increment PC by the immediate value       
endmodule