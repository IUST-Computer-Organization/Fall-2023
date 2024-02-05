`include "Defines.v"

module Arithmetic_Logic_Unit  
(
    input operation,
    input [7 : 0] operand_1,
    input [7 : 0] operand_2,
    output reg [17 : 0] result
);
    always @(*)
    begin
        case (operation)
            `OPERATION_ADD : result = operand_1 + operand_2;
            `OPERATION_SUB : result = operand_1 - operand_2;
            default        : result = 'bz;  
        endcase    
    end
endmodule