`include "Defines.v"

module Arithmetic_Logic_Unit
(
    input [2 : 0] operation,

    input [31 : 0] operand_1,
    input [31 : 0] operand_2,

    output reg [31 : 0] result,
    output reg zero
);

    // Start Your Design Here
    // ...


    always @(*) 
    begin
        if (result == 32'b0)
            zero <= `ENABLE;
        else
            zero <= `DISABLE;    
    end
endmodule