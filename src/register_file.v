module register_files(A1,A2,A3,Write_Data3,Write_Enable3,clk,reset,Read_Data1,Read_Data2);

      input [4:0] A1, A2, A3; // Addresses for read and write
      input [31:0] Write_Data3; // Data to write
      input Write_Enable3; // Write enable signal
      input clk, reset; // Clock and reset signals
      output  [31:0] Read_Data1, Read_Data2; // Data outputs for read addresses

        reg [31:0] registers [31:0]; // 32 registers of 32 bits each
        assign Read_Data1 = (!reset)? 32'h00000000 : registers[A1]; // Read data from register A1
        assign Read_Data2 = (!reset)? 32'h00000000 : registers[A2]; // Read data from register A2

        always @(posedge clk) begin
            
            if(Write_Enable3) begin
            registers[A3] <= Write_Data3; // Write data to register A3 if write enable is high
            end
        
             
        end 
        initial begin
            registers[0] = 32'h00000000; // Initialize register 0 to zero
        end

endmodule