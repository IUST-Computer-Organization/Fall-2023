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
        begin
            // Change this logic to use your own multiplier
            product <= operand_1 * operand_2;
        end
        else
            product <= 'bz;
    end


    // Start your 8-bit multiplier design here
endmodule