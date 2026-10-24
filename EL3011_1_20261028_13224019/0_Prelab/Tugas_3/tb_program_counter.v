module tb_program_counter;

reg     [31:0]  PC_in;
reg             reset;
reg             clk;
wire    [31:0]  PC_out;
integer i;
integer error;
reg     [2:0]   delay;

// Clock generation
always #10 clk = ~clk;

program_counter u0 (
    .PC_in(PC_in),
    .clk(clk),
    .reset(reset),
    .PC_out(PC_out)
);

task init;
begin
    PC_in <= 0;
    reset <= 0;
    clk <= 0;
    error = 0;
end
endtask

task testing;
begin
    for(i = 0; i < 10; i = i + 1) begin
        delay = $random;
        #(delay) 
        PC_in <= $random;
        reset <= $random;
    end
end
endtask

initial begin
    $dumpfile("program_counter.vcd");
    $dumpvars(0, tb_program_counter);

    init;
    testing;

    #10
    $display("Program selesai dengan %d error", error);
    $finish;
end

initial begin
    $monitor("-------------------------------------------- \n T=%0t | Terdapat Perubahan Input! \n T=%0t | clk = %d | PC_in = %d | reset = %d | PC_out %d", $time, $time, clk, PC_in, reset, PC_out);
end

always @(posedge clk or posedge reset) begin
    #1
    if(reset) begin
        if(PC_out !== 32'h0) begin
            $display("--------------------------------------------");
            $display("T=%0t | Output tidak sesuai!", $time);
            $display("T=%0t | clk = %d | PC_in = %d | reset = %d | PC_out %d", $time,clk, PC_in, reset, PC_out);
            error = error + 1;
        end else begin
            $display("--------------------------------------------");
            $display("T=%0t | Output sesuai!", $time);
            $display("T=%0t | clk = %d | PC_in = %d | reset = %d | PC_out %d", $time,clk, PC_in, reset, PC_out);
        end
    end else begin
        if(PC_out !== PC_in) begin
            $display("--------------------------------------------");
            $display("T=%0t | Output tidak sesuai!", $time);
            $display("T=%0t | clk = %d | PC_in = %d | reset = %d | PC_out %d", $time,clk, PC_in, reset, PC_out);
            error = error + 1;
        end else begin
            $display("--------------------------------------------");
            $display("T=%0t | Output sesuai!", $time);
            $display("T=%0t | clk = %d | PC_in = %d | reset = %d | PC_out %d", $time,clk, PC_in, reset, PC_out);
        end
    end
end

endmodule