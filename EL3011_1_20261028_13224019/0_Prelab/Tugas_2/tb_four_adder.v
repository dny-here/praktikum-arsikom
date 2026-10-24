module tb_four_adder;

reg     [31:0] PC_old;
wire    [31:0] PC_4_add;
integer i;
integer error;

four_adder u0 (
    .PC_old(PC_old),
    .PC_4_add(PC_4_add)
);

task init;
begin
    PC_old <= 0;
    error = 0;
end
endtask

task check;
begin
    if(PC_4_add !== PC_old + 4) begin
        $display("-----------------------------------");
        $display("T=%0t | Output tidak sesuai!", $time);
        $display("T=%0t | PC_old = %d | PC_4_add = %d", $time, PC_old, PC_4_add);
        error = error + 1;
    end else begin
        $display("-----------------------------------");
        $display("T=%0t | Output sesuai!", $time);
        $display("T=%0t | PC_old = %d | PC_4_add = %d", $time,  PC_old, PC_4_add);
    end
end
endtask

task testing;
begin
    for (i = 0; i < 10; i = i + 1) begin
        #10
        PC_old <= $random;
        check;
    end
end
endtask

initial begin
    // Dumpfile for gtkwave
    $dumpfile("four_adder.vcd");
    $dumpvars(0, tb_four_adder);

    // Testbench checking
    init;
    check;
    testing;

    // Finishing
    $display("Testbench ended with %d error", error);
    $finish;

end


endmodule