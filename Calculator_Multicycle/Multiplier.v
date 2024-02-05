`include "Defines.v"

module Multiplier
(
    input enable,

    input [7 : 0] operand_1,
    input [7 : 0] operand_2,

    output reg [17 : 0] product
);

    always @(*)
    begin
        case (enable)
            `ENABLE : product = operand_1 * operand_2;
            default : product = 'bz;
        endcase
    end
endmodule