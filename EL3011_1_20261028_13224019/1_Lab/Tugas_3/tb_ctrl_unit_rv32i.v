// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File    : tb_ctrl_unit_rv32i.v
// Deskripsi    : Tesbench Control Unit, 3 port input (opcode, funct3, funct7),
//                16 port output/sinyal pengendali
module tb_ctrl_unit_rv32i;

 // Inputs (driven by testbench)
    reg  [6:0] opcode;
    reg  [2:0] funct3;
    reg  [6:0] funct7;

    // Outputs (driven by DUT)
    wire        cu_ALU1src;
    wire        cu_ALU2src;
    wire [2:0]  cu_immtype;
    wire [1:0]  cu_ALUtype;
    wire        cu_adtype;
    wire [1:0]  cu_gatype;
    wire [1:0]  cu_shiftype;
    wire        cu_slttype;
    wire [1:0]  cu_rdtype;
    wire        cu_rdwrite;
    wire [2:0]  cu_loadtype;
    wire        cu_store;
    wire [1:0]  cu_storetype;
    wire        cu_branch;
    wire [2:0]  cu_branchtype;
    wire        cu_jump;

    // Device under test
    ctrl_unit_rv32i u0 (
        .opcode        (opcode),
        .funct3        (funct3),
        .funct7        (funct7),

        .cu_ALU1src    (cu_ALU1src),
        .cu_ALU2src    (cu_ALU2src),
        .cu_immtype    (cu_immtype),
        .cu_ALUtype    (cu_ALUtype),
        .cu_adtype     (cu_adtype),
        .cu_gatype     (cu_gatype),
        .cu_shiftype   (cu_shiftype),
        .cu_slttype    (cu_slttype),
        .cu_rdtype     (cu_rdtype),
        .cu_rdwrite    (cu_rdwrite),
        .cu_loadtype   (cu_loadtype),
        .cu_store      (cu_store),
        .cu_storetype  (cu_storetype),
        .cu_branch     (cu_branch),
        .cu_branchtype (cu_branchtype),
        .cu_jump       (cu_jump)
    );

task init;
begin
    opcode = 0;
    funct3 = 0;
    funct7 = 0;
end
endtask

task show;
begin
    $display("-----------------------------------------------");
    $display("T=%0t | opcode=%b funct3=%b funct7=%b", $time, opcode, funct3, funct7);
    $display("ALU1src=%b  ALU2src=%b  immtype=%b", cu_ALU1src, cu_ALU2src, cu_immtype);
    $display("ALUtype=%b  adtype=%b  gatype=%b  shiftype=%b  slttype=%b",
              cu_ALUtype, cu_adtype, cu_gatype, cu_shiftype, cu_slttype);
    $display("rdtype=%b  rdwrite=%b  loadtype=%b", cu_rdtype, cu_rdwrite, cu_loadtype);
    $display("store=%b  storetype=%b", cu_store, cu_storetype);
    $display("branch=%b  branchtype=%b  jump=%b", cu_branch, cu_branchtype, cu_jump);
end
endtask

initial begin
    $dumpfile("ctrl_unit_rv32i.vcd");
    $dumpvars(0, tb_ctrl_unit_rv32i);

    #10;
    opcode = 7'b0110011;
    funct7 = 7'b0000000;
    funct3 = 3'b000;
    #5
    show;

    #10;
    opcode = 7'b0010011;
    funct3 = 3'b101;
    #5
    show;

    #10;
    opcode = 7'b0000011;
    funct3 = 3'b010;
    #5
    show;

    #10;
    opcode = 7'b0100011;
    funct3 = 3'b010;
    #5
    show;

    #10;
    opcode = 7'b1100011;
    funct3 = 3'b001;
    #5
    show;

    #5;
    $finish;
end

endmodule