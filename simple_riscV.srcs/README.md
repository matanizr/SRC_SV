
#  Simple RISC-V Processor



Developed by Roei Sabag and Matan Izraeli  

Educational RISC-V based processor implemented in SystemVerilog and simulated using Vivado with a custom Python assembler.



---



##  Overview

This project implements a simple 32-bit RISC-V compatible processor, designed for learning and experimentation.  

It can be fully simulated in Vivado without requiring real FPGA hardware.  

The system loads instructions from a HEX file into memory unit and executes them step-by-step through a modular architecture.

note* - the memory module includes a parameter named initfile, which defines the path to the program file (in HEX format) this file is used to initialize the memory contents during simulation or synthesis.

Special thanks to Hanan Ribo for providing the cpu block diagram used in this project.


---



##  System Specifications   

| Parameter | Description |

|-------------|-------------|

| BUS Width   |  32 bits    |

| Memory Size | 1024 words  |

| Instruction Count | 22 supported instructions |

| Program Loading   | From `.hex` file into memory during simulation |



---


##  Project Structure

```
simple_riscV.srcs/
│
├── rtl
│   ├── SRC_top.sv
│   ├── ALU.sv
│   ├── IR.sv
│   ├── PC_u.sv
│   ├── alu_op.sv
│   ├── clocking_logic.sv
│   ├── con_u.sv
│   ├── control_u.sv
│   ├── memory.sv
│   ├── opCodesPkg.sv
│   ├── register_file.sv
│   └── shift_control.sv
│
├── tb
│   ├── imports/new/
│   └── new
│	     └── tb_SRC.sv
│
├── python_tools
│   └── assembler.py
│
├── program_init
│   └── program.hex
│
└── docs
    ├── cpu_block_diagram
    ├── RTL_Schematic
    ├── waveform_output
    ├── vivado_synthesis_report
    └── instruction_set_table
```




##  Architecture Overview  

This section provides a full visual documentation of the SRC RISC-V processor design —  
including the main CPU architecture, control logic, register files, and instruction reference.

---

###  CPU Block Diagram & Components

| Diagram | Description | Preview |
|----------|--------------|----------|
| **CPU_Macro_view.png** | High-level block diagram of the entire processor. | ![CPU Macro View](docs/cpu_block_diagram/CPU_Macro_view.png) |
| **Data_Path.png** | The datapath showing register connections, ALU, and memory buses. | ![Data Path](docs/cpu_block_diagram/Data_Path.png) |
| **Control_Unit.png** | Control unit logic responsible for instruction decoding and signal control. | ![Control Unit](docs/cpu_block_diagram/Control_Unit.png) |
| **Branching_in_the_Control_Unit.png** | Internal branching control mechanism. | ![Branching Control](docs/cpu_block_diagram/Branching_in_the_Control_Unit.png) |
| **Computation_of_the_Conditional_Value_CON.png** | Logic for computing branch condition signals. | ![Conditional Value Logic](docs/cpu_block_diagram/Computation_of_the_Conditional_Value_CON.png) |
| **Instruction_Register.png** | The IR (Instruction Register) that holds the current instruction being executed. | ![Instruction Register](docs/cpu_block_diagram/Instruction_Register.png) |
| **Register_File.png** | The register file containing all general-purpose registers. | ![Register File](docs/cpu_block_diagram/Register_File.png) |
| **ALU.png** | Arithmetic Logic Unit performing arithmetic and logic operations. | ![ALU](docs/cpu_block_diagram/ALU.png) |
| **Shift_Counter.png** | Shift and counter module used for instruction timing and shifting. | ![Shift Counter](docs/cpu_block_diagram/Shift_Counter.png) |
| **Memory_Adress_and_Memory_Data_Register.png** | Interface for memory address and data registers. | ![Memory Address and Data Register](docs/cpu_block_diagram/Memory_Adress_and_Memory_Data_Register.png) |
| **The_Clocking_Logic.png** | Clock generation and timing synchronization logic. | ![Clocking Logic](docs/cpu_block_diagram/The_Clocking_Logic.png) |

---

###  Instruction Set Reference

| File | Description | Preview |
|-------|--------------|----------|
| **SRC_Instructions_Table.png** | Full summary of all supported assembly instructions and opcodes. | ![Instruction Table](docs/instruction_set_table/SRC%20Instructions%20%E2%80%93%20Assembly%20Language%20Format.png) |

[Open full instruction table](docs/instruction_set_table/SRC%20Instructions%20%E2%80%93%20Assembly%20Language%20Format.png)

---
##  RTL Schematic Overview

This section contains the **RTL-level schematics** of the processor,  
showing the internal structure of each module after synthesis and elaboration in Vivado.

---

###  Top-Level & Core Modules

| Diagram | Description | Preview |
|----------|--------------|----------|
| **SRC-top.png** | Top-level RTL schematic connecting all processor modules (CPU core, memory, control unit). | ![SRC Top](docs/RTL_Schematic/SRC-top.png) |
| **ALU.png** | RTL schematic of the Arithmetic Logic Unit — responsible for arithmetic and logic operations. | ![ALU](docs/RTL_Schematic/ALU.png) |
| **Condition-Unit.png** | RTL view of the condition evaluation block — computes flags for branching. | ![Condition Unit](docs/RTL_Schematic/Condition-Unit.png) |
| **General-Purpose-Register-File.png** | Register file schematic showing 32-bit registers and control signals. | ![Register File](docs/RTL_Schematic/General-Purpose-Register-File.png) |
| **IR.png** | Instruction Register schematic — holds the current instruction being decoded. | ![IR](docs/RTL_Schematic/IR.png) |
| **Memory-Unit.png** | RTL representation of the memory interface and data paths. | ![Memory Unit](docs/RTL_Schematic/Memory-Unit.png) |
| **Program-Counter.png** | Schematic of the Program Counter — responsible for sequential instruction flow. | ![Program Counter](docs/RTL_Schematic/Program-Counter.png) |
| **Shift-Control-Unit.png** | Shift and control logic for timing and instruction step sequencing. | ![Shift Control Unit](docs/RTL_Schematic/Shift-Control-Unit.png) |

---

###  Control Unit Internals

Located inside:  
`docs/RTL_Schematic/Control-Unit/`

| Diagram | Description | Preview |
|----------|--------------|----------|
| **Control-Unit-Wrapper.png** | Top-level wrapper of the control unit connecting submodules. | ![Control Unit Wrapper](docs/RTL_Schematic/Control-Unit/Control-Unit-Wrapper.png) |
| **Control-Signal-Encoder.png** | Logic for encoding control signals and managing instruction flow. | ![Control Signal Encoder](docs/RTL_Schematic/Control-Unit/Control-Signal-Encoder.png) |
| **Clock-Logic.png** | RTL schematic of the clock generation and synchronization logic. | ![Clock Logic](docs/RTL_Schematic/Control-Unit/Clock-Logic.png) |
| **Step-Counter.png** | Counter module used for sequencing control steps and instruction cycles. | ![Step Counter](docs/RTL_Schematic/Control-Unit/Step-Counter.png) |

---

###  Direct Access Links

- [Open SRC Top Schematic](docs/RTL_Schematic/SRC-top.png)
- [Open Control Unit Wrapper](docs/RTL_Schematic/Control-Unit/Control-Unit-Wrapper.png)
- [Open ALU Module](docs/RTL_Schematic/ALU.png)
- [Open Register File](docs/RTL_Schematic/General-Purpose-Register-File.png)

---

##  Python Assembler



A custom Python script is included to convert assembly code (TXT format)  

into machine code (HEX format) for memory initialization.



###  How it works

The assembler reads a `.txt` file that contains your assembly program  

and generates a `.hex` file ready to be loaded into the processor's memory.





