i guess this is the start of my cpu risc-v implementation.

# RISC-V 32I

## CORE Component :

### ALU : 
does simple operation add sub slt and or with different flags zero overflow carryout and Negative .
Validated with the test bench

### Register File :
module containing all the 32 proc registres , write and read logic.

### sign_extender :
Takes the imidiate from the instruction binary and extends it to 32 bits .
### Pc : 
logic d'incrementation du Program counter pc +4 ou pc + immediat pour les branchement.
### memory
1 Cycle access memory for the instruction and data (merged afterwards when i implement the pipeline and caches)
### Multiplexers :
we always need multiplexers .
### control Unit : 
Main_Decoder, Aludecoder : use the op and functions bits to decide what command signals to output for the component controls.(for now i only have 3 instructions, lw, sw , beq).
* the testbench tests the logic of the decoders, going to expand as we go on (same logic for the otehr testbenchs so they stay relevant whenever i add some hardware modifications)
### Top :
where we assemble everything.
* in the testbench i am trying to do a combinasion of codes and programs to nich out bugs for now but it seems to be working good for the instructions that i implemented so far
* For the simulation : cd vcd_files : iverilog -o test ../tb/Top_cpu_tb.v ../src/*
                                     gtkwave 


