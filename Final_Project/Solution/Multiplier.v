`include "Defines.v"

module Multiplier
(
    input enable,

    input [31 : 0] operand_1,
    input [31 : 0] operand_2,

    output reg [31 : 0] product
);

    always @(*)
    begin
        if (enable)
            product <= operand_1 * operand_2;
        else
            product <= 'bz;
    end
endmodule