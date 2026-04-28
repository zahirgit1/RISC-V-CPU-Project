module data_memory(Write_Enable,Write_Data,A,Read_Data,clk,reset);

       input [31:0] Write_Data; // Data to write
       input [31:0] A; // Address for read/write
       input Write_Enable; // Write enable signal
       input clk, reset; // Clock and reset signals
       output [31:0] Read_Data; // Data output for read address (asynchronous)
       reg [31:0] memory [1023:0]; // 1024 words of 32 bits each
       integer i;
       
       // Asynchronous read - data available immediately
       assign Read_Data = memory[A[11:2]];
       
       // Synchronous write on posedge clk
       always @(posedge clk or posedge reset) begin
             if (!reset) begin
                 // Reset memory to zero
                 for (i = 0; i < 1024; i = i + 1) begin
                     memory[i] <= 32'h00000000;
                 end
             end else if (Write_Enable) begin
                 // Write data to memory at address A
                 memory[A[11:2]] <= Write_Data;
             end
       end
endmodule