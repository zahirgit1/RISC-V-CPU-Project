`timescale 1ns / 1ps

module compare_tb();
    reg clk;
    reg reset;
    integer i;

    Top_cpu cpu_inst (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;

        #10;
        reset = 1;

        $display("============================================================");
        $display("Cycle | PC         | Instruction     | Registers x0..x31");
        $display("------------------------------------------------------------");

        repeat (20) begin
            @(posedge clk);
            $write("%5d | %08h | %08h |",
                   $time/10,
                   cpu_inst.PC,
                   cpu_inst.Instruction);

            for (i = 0; i < 32; i = i + 1) begin
                if (i % 8 == 0)
                    $write("\n       ");
                $write(" x%0d=%0d", i, cpu_inst.reg_file.registers[i]);
            end

            $display("\n");
        end

        $display("============================================================");
        $finish;
    end

endmodule
