// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File : data_mem_rv32i.v
// Deskripsi : Testbench Data Memory 256 x 32-bit

module tb_data_mem_rv32i;

reg clock;
reg cu_store;
reg [1:0] cu_storetype;
reg [31:0] dmem_addr;
reg [31:0] rs2;
wire [31:0] dmem_out;
integer i;


data_mem_rv32i u0 (
    .clock(clock),
    .cu_store(cu_store),
    .cu_storetype(cu_storetype),
    .dmem_addr(dmem_addr),
    .rs2(rs2),
    .dmem_out(dmem_out)
);

always #10 clock = ~clock;

task init;
begin
    clock = 0;
    cu_store = 0;
    cu_storetype = 0;
    dmem_addr = 0;
    rs2 = 0;
end
endtask

task testing;
begin
    @(posedge clock);
    cu_store <= 1;

    for(i = 0; i < 10; i = i + 1) begin
        @(posedge clock);
        rs2 <= $random;
        dmem_addr <= {22'd0, ($random & 32'h000003FF)};
        cu_storetype <= {$random} % 4;
        @(posedge clock);
        case(cu_storetype)
        // SB (Store-Byte)
        2'b00:
        case(dmem_addr[1:0])
            2'b00: 
            if (dmem_out[7:0] == rs2[7:0]) 
                $display("PASS");
            else 
                $display("FAIL");

            2'b01: 
            if (dmem_out[15:8] == rs2[7:0]) 
                $display("PASS");
            else 
                $display("FAIL");
            
            2'b10:
            if (dmem_out[23:16] == rs2[7:0]) 
                $display("PASS");
            else 
                $display("FAIL");

            2'b11:
            if (dmem_out[31:24] == rs2[7:0]) 
                $display("PASS");
            else 
                $display("FAIL");
        endcase

        // SH (Store Halfword)
        2'b01:
        case(dmem_addr[1])
            1'b0:
            if (dmem_out[15:0] == rs2[15:0]) 
                $display("PASS");
            else 
                $display("FAIL");

            1'b1:
            if (dmem_out[31:16] == rs2[15:0]) 
                $display("PASS");
            else 
                $display("FAIL");
        endcase

        // SW (Store Word)
        2'b10:
        if (dmem_out[31:0] == rs2[31:0]) 
                $display("PASS");
            else 
                $display("FAIL");
        endcase
    end
end
endtask

initial begin
    $dumpfile("data_mem_rv32i.vcd");
    $dumpvars(0, tb_data_mem_rv32i);

    init;
    testing;

    #10
    $finish;
end


endmodule