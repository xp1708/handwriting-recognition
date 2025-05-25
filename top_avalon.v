module top_avalon (
    input              iClk,
    input              iReset_n,
    input              iChipSelect_n,
    input              iWrite_n,
    input              iRead_n,
    input       [1:0]  iAddress,
    input       [31:0] iData,
    output reg  [31:0] oData
);

    // Internal wires
    reg [7:0] pixel_data;
    reg       valid_write;
    wire [3:0] decision;
    wire       finish;

    // CNN module instance
    top top_inst (
        .clk(iClk),
        .rst_n(iReset_n),
        .data_in(pixel_data),
        .decision(decision),
        .finish(finish)
    );

    // Input logic: latch data when write
    always @(posedge iClk or negedge iReset_n) begin
        if (!iReset_n) begin
            pixel_data <= 8'd0;
            valid_write <= 1'b0;
        end else if (!iChipSelect_n && !iWrite_n && iAddress == 2'd0) begin
            pixel_data <= iData[7:0];
            valid_write <= 1'b1;
        end else begin
            valid_write <= 1'b0;
        end
    end

    // Output logic
    always @(posedge iClk or negedge iReset_n) begin
        if (!iReset_n) begin
            oData <= 32'd0;
        end else if (!iChipSelect_n && !iRead_n) begin
            case (iAddress)
                2'd0: oData <= {28'd0, decision};  // Return decision
                2'd1: oData <= {31'd0, finish};    // Return finish flag
                default: oData <= 32'd0;
            endcase
        end
    end

endmodule
