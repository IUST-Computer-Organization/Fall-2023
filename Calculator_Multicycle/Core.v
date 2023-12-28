`include "Defines.v"
`include "Arithmetic_Logic_Unit.v"
`include "Multiplier.v"
`include "Divider.v"

module Core 
#(
    parameter RESET_ADDRESS = 'b0
) 
(
    input reset,
    input clk,
    
    inout [17 : 0] memoryData,
    output reg memoryEnable,
    output reg memoryReadWrite,
    output reg [17 : 0] memoryAddress
);

    ////////////////
    // Controller //
    ////////////////

    reg [1 : 0] state;
    reg [1 : 0] nextState;

    reg pcWrite;
    reg irWrite;

    reg instructionOrData;

    reg aluOperation;
    reg aluSrc_1;
    reg aluSrc_2;

    reg opcode;
    reg funct;

    reg [7 : 0] A;
    reg [7 : 0] B;

    always @(posedge clk ) 
    begin
        if (reset) state <= `RESET;
        else state <= nextState;    
    end

    always @(*) 
    begin
        nextState = 'bz;

        memoryReadWrite = 'bz;
        pcWrite = 'bz;
        irWrite = 'bz;

        aluOperation = 'bz;
        aluSrc_1 = 'bz;
        aluSrc_2 = 'bz;

        multiplierEnable = 'bz;
        dividerEnable = 'bz;
        
        case (state)
            `RESET :
            begin
                nextState = `FETCH;
                memoryEnable = `DISABLE;
            end 

            `FETCH :
            begin
                instructionOrData = `INSTRUCTION;
                memoryReadWrite = `READ;
                memoryEnable = `ENABLE;
                irWrite = `ENABLE;

                aluSrc_1 = `PC;
                aluSrc_2 = `ONE;
                aluOperation = `OPERATION_ADD;
                pcWrite = `ENABLE;


                nextState = `DECODE;
            end
            
            `DECODE :
            begin
                memoryEnable <= `DISABLE;
                irWrite <= `DISABLE;

                opcode  = ir[17];
                funct   = ir[16];
                A       = ir[15 :  8];
                B       = ir[ 7 :  0]; 

                nextState = `EXECUTE; 
            end

            `EXECUTE : 
            begin
                case (opcode)
                    `ADDSUB :
                    begin
                        aluSrc_1 = `A;
                        aluSrc_2 = `B;

                        case (funct)
                            `ADD : aluOperation = `OPERATION_ADD;
                            `SUB : aluOperation = `OPERATION_SUB;
                        endcase
                    end 

                    `MULDIV :
                    begin
                        case (funct)
                            `MUL :
                            begin
                                mulOperand_1 = A;
                                mulOperand_2 = B;
                                multiplierEnable = `ENABLE;
                            end

                            `DIV :
                            begin
                                divOperand_1 = A;
                                divOperand_2 = B;
                                dividerEnable = `ENABLE;
                            end 
                        endcase
                    end
                endcase

                nextState = `FETCH;
            end
        endcase    
    end

    //////////////
    // Datapath //
    //////////////

    // ------------------------ //
    // Program Counter Register //
    // ------------------------ //
    reg [17 : 0] pc;

    always @(posedge clk) 
    begin
        if (reset) pc <= RESET_ADDRESS;    
        else if (pcWrite) pc <= aluResult;
    end

    // -------------------- //
    // Instruction Register //
    // -------------------- //
    reg [17 : 0] ir;

    always @(posedge clk) 
    begin
        if (reset)      ir <= 'bz;
        if (irWrite)    ir <= memoryData;
    end

    // ----------------------- //
    // Memory Address Register //
    // ----------------------- //   
    always @(*) 
    begin
        case (instructionOrData)
            `INSTRUCTION    : memoryAddress <= pc;
            `DATA           : memoryAddress <= aluResult; 
            default         : memoryAddress <= 'bz;
        endcase
    end

    // --------------------- //
    // Arithmetic Logic Unit //
    // --------------------- //

    reg  [ 7 : 0] aluOperand_1;
    reg  [ 7 : 0] aluOperand_2;
    wire [17 : 0] aluResult;

    always @(*) 
    begin
        case (aluSrc_1)
            `PC :       aluOperand_1 = pc;
            `A  :       aluOperand_1 = A; 
            default :   aluOperand_1 = 'bz;
        endcase

        case (aluSrc_2)
            `ONE :      aluOperand_2 = 'd1; 
            `B :        aluOperand_2 = B;
            default :   aluOperand_2 = 'bz;
        endcase
    end

    Arithmetic_Logic_Unit alu 
    (
        .operation(aluOperation),
        .operand_1(aluOperand_1),
        .operand_2(aluOperand_2),
        .result(aluResult)
    );

    // --------------- //
    // Multiplier Unit //
    // --------------- //  
    reg multiplierEnable;

    reg  [ 7 : 0] mulOperand_1;
    reg  [ 7 : 0] mulOperand_2;
    wire [17 : 0] multiplierResult;

    Multiplier multiplier
    (
        .enable(multiplierEnable),
        .operand_1(mulOperand_1),
        .operand_2(mulOperand_2),
        .product(multiplierResult)
    );

    // --------------- //
    // Divider Unit //
    // --------------- //  
    reg dividerEnable;

    reg  [ 7 : 0] divOperand_1;
    reg  [ 7 : 0] divOperand_2;
    wire [17 : 0] dividerResult;

    Divider divider
    (
        .enable(dividerEnable),
        .operand_1(divOperand_1),
        .operand_2(divOperand_2),
        .result(dividerResult)
    );
endmodule