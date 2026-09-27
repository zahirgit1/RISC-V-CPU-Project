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
        $display("Cycle | PC       | Fetched | Decoded | Executed | Memory | WriteBack");
        $display("------------------------------------------------------------");

        repeat (100) begin
            @(posedge clk);
            $display("%5d | %08h | %08h | %08h | %08h | %08h | %08h",
                     $time/10,
                     cpu_inst.PC,
                     cpu_inst.InstrF,
                     cpu_inst.InstrD,
                     cpu_inst.ALU_Result,
                     cpu_inst.ALUResultM,
                     cpu_inst.Write_Data_Reg);
        end

        $display("============================================================");
        $display("Final register snapshot:");
        $display("x1=%08h x2=%08h x3=%08h x4=%08h x5=%08h x6=%08h x7=%08h",
                 cpu_inst.reg_file.registers[1],
                 cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3],
                 cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[5],
                 cpu_inst.reg_file.registers[6],
                 cpu_inst.reg_file.registers[7]);
        $display("x8=%08h x9=%08h x10=%08h x11=%08h x12=%08h x13=%08h",
                 cpu_inst.reg_file.registers[8],
                 cpu_inst.reg_file.registers[9],
                 cpu_inst.reg_file.registers[10],
                 cpu_inst.reg_file.registers[11],
                 cpu_inst.reg_file.registers[12],
                 cpu_inst.reg_file.registers[13]);
        $display("============================================================");
        $finish;
    end

endmodule
