module conv1_layer_summary (
    input clk,
    input rst_n,
    input [7:0] data_in,
    output reg [11:0] conv_out_1, conv_out_2, conv_out_3,
    output reg valid_out_conv
);

    // === Internal registers ===
    reg [4:0] counter;
    reg signed [13:0] sum1, sum2, sum3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            sum1 <= 0;
            sum2 <= 0;
            sum3 <= 0;
            valid_out_conv <= 0;
        end else begin
            // Simple placeholder: treat input as shared for 3 conv outputs
            sum1 <= sum1 + data_in;
            sum2 <= sum2 + data_in;
            sum3 <= sum3 + data_in;
            counter <= counter + 1;

            if (counter == 24) begin // assume 25 pixels accumulated
                conv_out_1 <= sum1[12:1];
                conv_out_2 <= sum2[12:1];
                conv_out_3 <= sum3[12:1];
                valid_out_conv <= 1;
                counter <= 0;
                sum1 <= 0;
                sum2 <= 0;
                sum3 <= 0;
            end else begin
                valid_out_conv <= 0;
            end
        end
    end

endmodule
