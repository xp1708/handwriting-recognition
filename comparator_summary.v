module comparator_summary (
    input clk,
    input rst_n,
    input valid_in,
    input [11:0] data_in,
    output reg [3:0] decision,
    output reg valid_out
);

    reg [3:0] idx;
    reg [11:0] max_val;
    reg [3:0] max_idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            idx <= 0;
            max_val <= 0;
            max_idx <= 0;
            decision <= 0;
            valid_out <= 0;
        end else if (valid_in) begin
            if (data_in > max_val) begin
                max_val <= data_in;
                max_idx <= idx;
            end
            idx <= idx + 1;
            valid_out <= 0;

            if (idx == 9) begin
                decision <= max_idx;
                valid_out <= 1;
                idx <= 0;
                max_val <= 0;
                max_idx <= 0;
            end
        end else begin
            valid_out <= 0;
        end
    end

endmodule
