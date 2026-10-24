module program_counter(
    input       [31:0]  PC_in,
    input               clk,
    input               reset,
    output  reg [31:0]  PC_out
);

always @(posedge clk or posedge reset) begin
    if(!reset) begin
        PC_out <= PC_in;
    end else begin
        PC_out <= 32'h0;
    end
end

endmodule