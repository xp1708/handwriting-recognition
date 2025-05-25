module conv1_layer_simple #(
    parameter WIDTH = 28,
    parameter HEIGHT = 28,
    parameter DATA_BITS = 8,
    parameter KERNEL_SIZE = 5,
    parameter NUM_OUTPUTS = 3
) (
    input clk,
    input rst_n,
    input [DATA_BITS-1:0] data_in,
    output [11:0] conv_out [0:NUM_OUTPUTS-1],
    output valid_out_conv
);

    localparam WINDOW_SIZE = KERNEL_SIZE * KERNEL_SIZE; // 5x5 kernel = 25 pixels
    wire [DATA_BITS-1:0] data_out [0:WINDOW_SIZE-1];
    wire valid_out_buf;

    // Convolution Buffer
    conv1_buf #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .DATA_BITS(DATA_BITS)
    ) conv1_buf (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_out(data_out),
        .valid_out_buf(valid_out_buf)
    );

    // Convolution Calculation
    conv1_calc conv1_calc (
        .valid_out_buf(valid_out_buf),
        .data_out(data_out),
        .conv_out(conv_out),
        .valid_out_calc(valid_out_conv)
    );

endmodule