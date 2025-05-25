module maxpool_relu_simple #(
    parameter CONV_BIT = 12
)(
    input clk,
    input rst_n,
    input valid_in,
    input signed [CONV_BIT-1:0] conv_out_1,
    input signed [CONV_BIT-1:0] conv_out_2,
    input signed [CONV_BIT-1:0] conv_out_3,
    output reg [CONV_BIT-1:0] max_value_1,
    output reg [CONV_BIT-1:0] max_value_2,
    output reg [CONV_BIT-1:0] max_value_3,
    output reg valid_out_relu
);

    // --- Max selection (MUX21 x3 logic)
    wire signed [CONV_BIT-1:0] max1 = (conv_out_1 > conv_out_2) ? conv_out_1 : conv_out_2;
    wire signed [CONV_BIT-1:0] max2 = (conv_out_2 > conv_out_3) ? conv_out_2 : conv_out_3;
    wire signed [CONV_BIT-1:0] max3 = (conv_out_3 > conv_out_1) ? conv_out_3 : conv_out_1;

    // --- ReLU x3 (LessThan0 + MUX21 logic)
    wire signed [CONV_BIT-1:0] relu1 = (max1 > 0) ? max1 : 0;
    wire signed [CONV_BIT-1:0] relu2 = (max2 > 0) ? max2 : 0;
    wire signed [CONV_BIT-1:0] relu3 = (max3 > 0) ? max3 : 0;

    // --- Flip-Flop x3 + valid register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            max_value_1 <= 0;
            max_value_2 <= 0;
            max_value_3 <= 0;
            valid_out_relu <= 0;
        end else if (valid_in) begin
            max_value_1 <= relu1;
            max_value_2 <= relu2;
            max_value_3 <= relu3;
            valid_out_relu <= 1;
        end else begin
            valid_out_relu <= 0;
        end
    end

endmodule
