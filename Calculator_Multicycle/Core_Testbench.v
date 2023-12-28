`timescale 1 ns / 1 ns

`include "Defines.v"
`include "Core.v"

module Core_Testbench;
    
    //////////////////////
    // Clock Generation //
    //////////////////////
    parameter CLK_PERIOD = 4;
    reg clk = 1'b1;
    initial begin forever #(CLK_PERIOD/2) clk = ~clk; end
    initial #(1000 * CLK_PERIOD) $finish;
    reg reset = `ENABLE;  

    //////////////////////////////
    // Memory Interface Signals //
    //////////////////////////////
    wire [17 : 0] memoryData;
    reg  [17 : 0] memoryData_reg;
    assign memoryData = memoryData_reg;

    wire memoryEnable;
    wire memoryReadWrite;
    wire [17 : 0] memoryAddress;

    Core
    #(
        .RESET_ADDRESS('b0)
    )
    uut
    (
        .clk(clk),
        .reset(reset),

        .memoryData(memoryData),
        .memoryEnable(memoryEnable),
        .memoryReadWrite(memoryReadWrite),
        .memoryAddress(memoryAddress)
    );

    initial 
    begin
        $dumpfile("Core.vcd");    
        $dumpvars(0, Core_Testbench);
        repeat (5) @(posedge clk);
        reset <= `DISABLE;
    end

    ////////////
    // Memory //
    ////////////

    reg [17 : 0] Memory [0 : 1024 - 1];
    initial $readmemb("Memory.txt", Memory);

    // Memory Interface Behaviour
    always @(*)
    begin
        if (!memoryEnable)
            memoryData_reg <= 'bz;

        else if (memoryEnable)
        begin
            if (memoryReadWrite == `WRITE)
                Memory[memoryAddress] <= memoryData;
            if (memoryReadWrite == `READ)
                memoryData_reg <= Memory[memoryAddress];
        end
    end
endmodule