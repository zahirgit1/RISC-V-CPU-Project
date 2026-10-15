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
        $display("x14=%08h x15=%08h x16=%08h x17=%08h x18=%08h x19=%08h x20=%08h",
                 cpu_inst.reg_file.registers[14],
                 cpu_inst.reg_file.registers[15],
                 cpu_inst.reg_file.registers[16],
                 cpu_inst.reg_file.registers[17],
                 cpu_inst.reg_file.registers[18],
                 cpu_inst.reg_file.registers[19],
                 cpu_inst.reg_file.registers[20]);
        if (cpu_inst.reg_file.registers[0]  === 0  &&
            cpu_inst.reg_file.registers[1]  === 64 &&
            cpu_inst.reg_file.registers[2]  === 7  &&
            cpu_inst.reg_file.registers[3]  === 5  &&
            cpu_inst.reg_file.registers[4]  === 12 &&
            cpu_inst.reg_file.registers[5]  === 17 &&
            cpu_inst.reg_file.registers[6]  === 10 &&
            cpu_inst.reg_file.registers[7]  === 0  &&
            cpu_inst.reg_file.registers[8]  === 29 &&
            cpu_inst.reg_file.registers[9]  === 1  &&
            cpu_inst.reg_file.registers[10] === 42 &&
            cpu_inst.reg_file.registers[11] === 42 &&
            cpu_inst.reg_file.registers[12] === 49 &&
            cpu_inst.reg_file.registers[13] === 49 &&
            cpu_inst.reg_file.registers[14] === 14 &&
            cpu_inst.reg_file.registers[15] === 15 &&
            cpu_inst.reg_file.registers[16] === 88 &&
            cpu_inst.reg_file.registers[17] === 0  &&
            cpu_inst.reg_file.registers[18] === 88 &&
            cpu_inst.reg_file.registers[19] === 1  &&
            cpu_inst.reg_file.registers[20] === 0  &&
            cpu_inst.data_mem.memory[16] === 42) begin
            $display("PIPELINE TEST: PASS");
        end else begin
            $display("PIPELINE TEST: FAIL");
        end
        $display("============================================================");
        $finish;
    end

endmodule
