`timescale 1ns / 100ps

module top_tb;

    parameter CLK_PERIOD = 10;
    parameter IMG_SIZE = 784;

    reg clk;
    reg rst_n;
    reg [7:0] data_in;
    wire [3:0] decision;
    wire finish;

    reg [7:0] pixel_data [0:IMG_SIZE-1];
    integer i;
    reg [31:0] cycles_elapsed;

    // Instantiate DUT
    top dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .decision(decision),
        .finish(finish)
    );

    // Clock generation
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // Count cycles
    always @(posedge clk)
        cycles_elapsed <= cycles_elapsed + 1;

    // Main stimulus
    initial begin
        // Load image file
        $readmemh("E:/SOC/MNIST_Recognition/img3.txt", pixel_data);

        // Reset
        rst_n = 0;
        data_in = 0;
        cycles_elapsed = 0;

        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (5) @(posedge clk);

        // Feed pixels
        for (i = 0; i < IMG_SIZE; i = i + 1) begin
            @(posedge clk);
            data_in <= pixel_data[i];
        end

        // Wait for result
        @(posedge finish);
        $display("=== RESULT ===");
        $display("Time: %0t", $time);
        $display("Cycles: %0d", cycles_elapsed);
        $display("Predicted digit: %0d", decision);
        $display("================");

        #20;
        $stop;
    end

endmodule
