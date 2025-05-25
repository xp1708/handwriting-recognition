module conv2_layer_summary (
    input clk,
    input rst_n,
    input valid_in,
    input [11:0] max_value_1, max_value_2, max_value_3,
    output reg [11:0] conv2_out_1, conv2_out_2, conv2_out_3,
    output reg valid_out_conv2
);

    // === Bias Handling ===
    wire signed [11:0] ext_bias0 = 12'd0;
    wire signed [11:0] ext_bias1 = 12'd0;
    wire signed [11:0] ext_bias2 = 12'd0;

    // === Internal registers ===
    reg [4:0] counter;
    reg signed [13:0] sum1, sum2, sum3;
    reg valid_flag;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            sum1 <= 0;
            sum2 <= 0;
            sum3 <= 0;
            valid_out_conv2 <= 0;
        end else if (valid_in) begin
            // Simple accumulation as convolution placeholder (simplified)
            sum1 <= sum1 + max_value_1;
            sum2 <= sum2 + max_value_2;
            sum3 <= sum3 + max_value_3;
            counter <= counter + 1;

            if (counter == 24) begin // assuming 25 values for example
                conv2_out_1 <= sum1[12:1] + ext_bias0;
                conv2_out_2 <= sum2[12:1] + ext_bias1;
                conv2_out_3 <= sum3[12:1] + ext_bias2;
                valid_out_conv2 <= 1;
                sum1 <= 0;
                sum2 <= 0;
                sum3 <= 0;
                counter <= 0;
            end else begin
                valid_out_conv2 <= 0;
            end
        end else begin
            valid_out_conv2 <= 0;
        end
    end

endmodule