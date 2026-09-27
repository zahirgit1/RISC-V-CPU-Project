module data_memory(Write_Enable,Write_Data,A,Read_Data,clk,reset);

       input [31:0] Write_Data; // Data to write
       input [31:0] A; // Address for read/write
       input Write_Enable; // Write enable signal
       input clk, reset; // Clock and reset signals
       output reg [31:0] Read_Data; // Data output for read address
       reg [31:0] memory [1023:0]; // 1024 words of 32 bits each
       integer i;

       // Read on rising edge
       always @(posedge clk or posedge reset) begin
             if (!reset) begin
                 Read_Data <= 32'h00000000;
                 for (i = 0; i < 1024; i = i + 1) begin
                     memory[i] <= 32'h00000000;
                 end
             end else begin
                 Read_Data <= memory[A[11:2]];
             end
       end

       // Write on falling edge
       always @(negedge clk) begin
             if (reset && Write_Enable) begin
                 memory[A[11:2]] <= Write_Data;
             end
       end
endmodule