`include "Defines.v"

module Divider
(
    input enable,

    input [7 : 0] operand_1,
    input [7 : 0] operand_2,

    output reg [17 : 0] result
);

    always @(*)
    begin
        case (enable)
            `ENABLE : result = operand_1 / operand_2;
            default : result = 'bz;
        endcase
    end
endmodule