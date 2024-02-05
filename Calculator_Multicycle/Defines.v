`ifndef OPCODES
    `define ADDSUB   1'b0
    `define MULDIV   1'b1
`endif /*OPCODES*/

`ifndef FUNCTIONS
    `define ADD   1'b0
    `define SUB   1'b1
    `define MUL   1'b0
    `define DIV   1'b1
`endif /*FUNCTIONS*/

`ifndef ALU_OPERATIONS
    `define OPERATION_ADD   1'b0
    `define OPERATION_SUB   1'b1
`endif /*ALU_OPERATIONS*/

`ifndef ALU_SRC_SELECT
    `define PC          1'b0
    `define A           1'b1

    `define ONE         1'b0
    `define B           1'b1
`endif /*ALU_SRC_SELECT*/

`ifndef CONTROL_SIGNALS
    `define INSTRUCTION     1'b0
    `define DATA            1'b1

    `define READ            1'b0
    `define WRITE           1'b1

    `define DISABLE         1'b0
    `define ENABLE          1'b1
`endif /*CONTROL_SIGNALS*/

`ifndef CONTROLLER_STATES
    `define RESET            0
    `define FETCH            1    
    `define DECODE           2
    `define EXECUTE          3
`endif /*CONTROLLER_STATES*/