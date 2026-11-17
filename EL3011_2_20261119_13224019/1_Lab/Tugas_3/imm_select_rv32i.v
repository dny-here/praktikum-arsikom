// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 2
// Percobaan : 2
// Tanggal : <isi>
// Nama (NIM) 1 : <isi>
// Nama (NIM) 2 : <isi>
// Nama File : imm_select_rv32i.v
// Deskripsi : Immediate Selector, memilih antara 5 tipe immediate yang ada

module imm_select_rv32i(
    input wire [31:7] trimmed_instr, // Trimmed instruction, 25 MSB from instr
    input wire [2:0] cu_immtype, // I-type = 3'b000, S-type = 3'b001,
    // B-type = 3'b010, U-type = 3'b011,
    // J-type = 3'b100
    output reg [31:0] imm // 32-bit immediate
);

always @ (*)
begin
    case (cu_immtype)
    3'b000: // I-type
        imm <= {{20{trimmed_instr[31]}}, trimmed_instr[31:20]};
    3'b001: // S-type
        imm <= {{20{trimmed_instr[31]}}, trimmed_instr[31:25], trimmed_instr[11:8], trimmed_instr[7]};
    3'b010: // B-type
        imm <= {{20{trimmed_instr[31]}}, trimmed_instr[7], trimmed_instr[30:25], trimmed_instr[11:8], 1'b0};
    3'b011: // U-type
        imm <= {trimmed_instr[31], trimmed_instr[30:20], trimmed_instr[19:12], 12'h000};
    3'b100: // J-type
        imm <= {{12{trimmed_instr[31]}}, trimmed_instr[19:12], trimmed_instr[20], trimmed_instr[30:25], trimmed_instr[24:21], 1'b0};
    default:
        imm <= 32'd0;
endcase
end
endmodule