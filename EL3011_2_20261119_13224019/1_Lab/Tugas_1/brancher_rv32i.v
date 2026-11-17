// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : <isi>
// Nama (NIM) 1 : <isi>
// Nama (NIM) 2 : <isi>
// Nama File : brancher_rv32i.v
// Deskripsi : Brancher, logika untuk mendukung instruksi branching/tipe B

module brancher_rv32i(
    input wire [31:0] PC_new, // PC+4 seperti biasa dari 4-adder
    input wire [31:0] PC_branch, // PC+imm dari ALU
    input wire signed [31:0] in1, // Nilai di rs1
    input wire signed [31:0] in2, // Nilai di rs2
    input wire cu_branch, // Enable branch
    input wire [2:0] cu_branchtype, // BEQ = 3'b000, BNE = 3'b001,
                                    // BLT = 3'b010, BGE = 3'b011,
                                    // BLTU = 3'b100, BGEU = 3'b101
    output reg [31:0] PC_in
);

always @ (*)
begin
    if (cu_branch)
    begin
    case (cu_branchtype)
        3'b000: // BEQ
        PC_in = (in1 == in2) ? PC_branch : PC_new;
        3'b001: // BNE
        PC_in = (in1 != in2) ? PC_branch : PC_new;
        3'b010: // BLT
        PC_in = (in1 < in2) ? PC_branch : PC_new;
        3'b011: // BGE
        PC_in = (in1 >= in2) ? PC_branch : PC_new;
        3'b100: // BLTU
        PC_in = ($unsigned(in1) < $unsigned(in2)) ? PC_branch : PC_new;
        3'b101: // BGEU
        PC_in = ($unsigned(in1) >= $unsigned(in2)) ? PC_branch : PC_new;
        default:
        PC_in = PC_new;
    endcase
    end
    else
        PC_in = PC_new;
end
endmodule