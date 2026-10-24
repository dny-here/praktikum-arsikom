module multiplexer2_to_1(
    input [31:0] A,
    input [31:0] B,
    input sel,
    output [31:0] D
);

assign D = (sel == 1'b0) ? A : B;

endmodule