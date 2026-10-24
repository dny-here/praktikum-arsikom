module four_adder(
    input   [31:0] PC_old,
    output  [31:0] PC_4_add
);

assign PC_4_add = PC_old + 4;

endmodule