// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 21 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : tb_multiplexer2_to_1.v
// Deskripsi : Testbench untuk Multiplexer 2:1 berukuran 32 bit dalam Verilog
module tb_multiplexer2_to_1;

// Variable for testing
reg [31:0]  A; // Driving the A input 
reg [31:0]  B; // Driving the B input
reg         sel; // Driving the  selector input
wire [31:0]  D; // Drving the D output
integer     error; // Integer for detecting errors
integer     i; // Integer for testing loop

// Initiate the DUT from the multiplexer module
multiplexer2_to_1 u0 (
    .A(A),
    .B(B),
    .sel(sel),
    .D(D)
);

// Initialization for variables to zero
task init;
begin
    A <= 0;
    B <= 0;
    sel <= 0;
    error <= 0;
end
endtask

// Checking for each test
task check;
begin 
    if ((sel == 1'b0) && (D !== A)) begin
        $display("---------------------------------------------------------");
        $display("T= %0t | Output tidak sesuai dengan selektor yang dipilih", $time);
        $display("T= %0t | A = %d | B = %d | sel = %b | D = %d ", $time, A, B, sel, D);
        error = error + 1;
    end else if ((sel == 1'b1) && (D != B)) begin
        $display("---------------------------------------------------------");
        $display("T= %0t | Output tidak sesuai dengan selektor yang dipilih", $time);
        $display("T= %0t | A = %d | B = %d | sel = %b | D = %d ", $time, A, B, sel, D);
        error = error + 1;
    end else begin
        $display("---------------------------------------------------------");
        $display("T= %0t | Output sesuai dengan selektor yang dipilih", $time);
        $display("T= %0t | A = %d | B = %d | sel = %b | D = %d ", $time, A, B, sel, D);
    end
end
endtask

// Testing for random inputs
task testing;
begin
    for(i = 0; i < 10; i = i + 1) begin
        #10
        A <= $random;
        B <= $random;
        sel <= $random;
        check;
    end
end
endtask

initial begin
    // Dumping variables for GTKWave
    $dumpfile("multiplexer2_to_1.vcd");
    $dumpvars(0, tb_multiplexer2_to_1);

    // Testbenches
    init;
    check; // Initial checking for zeros
    testing; // Testing the mux

    // Results
    $display("Testing ended with %d erros", error);
    $finish;
end

endmodule