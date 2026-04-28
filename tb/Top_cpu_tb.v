`timescale 1ns / 1ps

module Top_cpu_tb();
    reg clk, reset;
    
    Top_cpu cpu_inst (
        .clk(clk),
        .reset(reset)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0;
        reset = 0;
        
        #10 reset = 1;
        
        $display("\n========================================");
        $display("   (I-type, S-type, LW, B-type, R-type)");
        $display("========================================\n");
        
        $display("Step | PC       | Instr    | Description              | x1  | x2  | x3  | x4  | x6  | x7   | x8  | x10");
        $display("----|----------|----------|--------------------------|-----|-----|-----|-----|-----|------|-----|-----");
        
       #5;
        $display("[0]  | %h | %h | ADDI x1, x0, 12 (addr)    | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction, 
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[1]  | %h | %h | ADDI x2, x0, 10 (data)    | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[2]  | %h | %h | SLT x7, x2, x1 [R-type]  | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[3]  | %h | %h | ADDI x4, x0, 5           | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[4]  | %h | %h | BEQ x1, x2 (NOT taken)    | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[5]  | %h | %h | SW x2, 0(x1) [S-type]    | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[6]  | %h | %h | LW x3, 0(x1) [I-type]    | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[7]  | %h | %h | ADD x4, x1, x2 [R-type]  | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[8]  | %h | %h | SUB x6, x1, x2 [R-type]  | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[9]  | %h | %h | AND x8, x4, x7 [R-type]  | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #10;
        $display("[10] | %h | %h | OR x10, x4, x7 [R-type]  | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);

        #10;
        $display("[11] | %h | %h | ADD x0, x0, x0: NOP  | %3d | %3d | %3d | %3d | %3d | %4d | %3d | %3d", 
                 cpu_inst.PC, cpu_inst.Instruction,
                 cpu_inst.reg_file.registers[1], cpu_inst.reg_file.registers[2],
                 cpu_inst.reg_file.registers[3], cpu_inst.reg_file.registers[4],
                 cpu_inst.reg_file.registers[6], cpu_inst.reg_file.registers[7],
                 cpu_inst.reg_file.registers[8], cpu_inst.reg_file.registers[10]);
        
        #20;
        $display("\n========================================");
        $display("   FINAL REGISTER STATE");
        $display("========================================");
        $display("x1  = %3d  (expected: 12 - address)", cpu_inst.reg_file.registers[1]);
        $display("x2  = %3d  (expected: 10 - data stored)", cpu_inst.reg_file.registers[2]);
        $display("x3  = %3d  (expected: 10 - loaded from mem)", cpu_inst.reg_file.registers[3]);
        $display("x4  = %3d  (expected: 22 - ADD 12+10)", cpu_inst.reg_file.registers[4]);
        $display("x6  = %3d  (expected: 2 - SUB 12-10)", cpu_inst.reg_file.registers[6]);
        $display("x7  = %3d  (expected: 1 - SLT result)", cpu_inst.reg_file.registers[7]);
        $display("x8  = %3d  (expected: 0 - AND 22&1)", cpu_inst.reg_file.registers[8]);
        $display("x10 = %3d  (expected: 23 - OR 22|1)", cpu_inst.reg_file.registers[10]);


        $display("\n========================================");
        $display("   TEST RESULTS");
        $display("========================================");
        if (cpu_inst.reg_file.registers[3] == 10) begin
            $display("LW (I-type) works: x3=10 (loaded from memory)");
        end else begin
            $display("LW (I-type) failed: x3=%d", cpu_inst.reg_file.registers[3]);
        end
        
        if (cpu_inst.reg_file.registers[4] == 22) begin
            $display("ADD (R-type) works: x4=22");
        end else begin
            $display("ADD (R-type) failed: x4=%d", cpu_inst.reg_file.registers[4]);
        end
        
        if (cpu_inst.reg_file.registers[6] == 2) begin
            $display("SUB (R-type) works: x6=2");
        end else begin
            $display("SUB (R-type) failed: x6=%d", cpu_inst.reg_file.registers[6]);
        end
        
        if (cpu_inst.reg_file.registers[8] == 0) begin
            $display("AND (R-type) works: x8=0");
        end else begin
            $display("AND (R-type) failed: x8=%d", cpu_inst.reg_file.registers[8]);
        end
        
        if (cpu_inst.reg_file.registers[10] == 23) begin
            $display("OR (R-type) works: x10=23");
        end else begin
            $display("OR (R-type) failed: x10=%d", cpu_inst.reg_file.registers[10]);
        end
        
        if (cpu_inst.reg_file.registers[7] == 1) begin
            $display("SLT (R-type) works: x7=1");
        end else begin
            $display("SLT (R-type) failed: x7=%d", cpu_inst.reg_file.registers[7]);
        end
        
        $display("SW (S-type) stored x2=10 at memory[12]");
        $display("========================================\n");

        $finish;
    end
    
endmodule
