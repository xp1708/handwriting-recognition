module fully_connected_simple  (
    input clk,
    input rst_n,
    input valid_in,
    input signed [11:0] data_in_1, data_in_2, data_in_3,
    output reg [11:0] data_out,
    output reg valid_out_fc
);

    reg [5:0] counter;
    reg signed [19:0] acc;

    wire signed [13:0] ext_data1 = (data_in_1[11]) ? {2'b11, data_in_1} : {2'b00, data_in_1};
    wire signed [13:0] ext_data2 = (data_in_2[11]) ? {2'b11, data_in_2} : {2'b00, data_in_2};
    wire signed [13:0] ext_data3 = (data_in_3[11]) ? {2'b11, data_in_3} : {2'b00, data_in_3};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            acc <= 0;
            valid_out_fc <= 0;
            data_out <= 0;
        end else if (valid_in) begin
            acc <= acc + ext_data1 + ext_data2 + ext_data3;
            counter <= counter + 1;

            if (counter == 15) begin // giả định 16 lần tích lũy mỗi kênh
                data_out <= acc[18:7];
                valid_out_fc <= 1;
                acc <= 0;
                counter <= 0;
            end else begin
                valid_out_fc <= 0;
            end
        end else begin
            valid_out_fc <= 0;
        end
    end

endmodule