// Praktikum EL3011 Arsitektur Sistem Komputer
// Modul : 1
// Percobaan : 1
// Tanggal : 28 Oktober 2026
// Nama (NIM) 1 : Danny Rahmat Pratama (13224019)
// Nama (NIM) 2 : Aziiz Adityatama (13224070)
// Nama File    : ctrl_unit_rv32i.v
// Deskripsi    : Control Unit, 3 port input (opcode, funct3, funct7),
//                16 port output/sinyal pengendali
module ctrl_unit_rv32i (
    // Opcode: R = 7'h33, I = 7'h13, Load = 7'h03, S = 7'h23, B = 7'h63,
    //         JAL = 7'h6F, JALR = 7'h67, LUI = 7'h37, AUIPC = 7'h17
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
 
    output reg        cu_ALU1src,     // rs1 = 1'b0, PC = 1'b1
    output reg        cu_ALU2src,     // rs2 = 1'b0, imm = 1'b1
    output reg  [2:0] cu_immtype,     // I = 3'b000, S = 3'b001, B = 3'b010,
                                      // U = 3'b011, J = 3'b100
    output reg  [1:0] cu_ALUtype,     // ADD/SUB = 2'b00, GATE = 2'b01,
                                      // SHIFT = 2'b10, SLT = 2'b11
    output reg        cu_adtype,      // ADD = 1'b0, SUB = 1'b1
    output reg  [1:0] cu_gatype,      // XOR = 2'b00, OR = 2'b01, AND = 2'b10
    output reg  [1:0] cu_shiftype,    // SLL = 2'b00, SRL = 2'b01, SRA = 2'b10
    output reg        cu_slttype,     // Signed = 1'b0, Unsigned = 1'b1
    output reg  [1:0] cu_rdtype,      // ALU = 2'b00, memory = 2'b01,
                                      // PC+4 = 2'b10, immediate = 2'b11
    output reg        cu_rdwrite,     // Enable write to rd = 1'b1
    output reg  [2:0] cu_loadtype,    // LB = 3'b000, LH = 3'b001, LW = 3'b010,
                                      // LBU = 3'b011, LHU = 3'b100
    output reg        cu_store,       // Store to memory = 1'b1
    output reg  [1:0] cu_storetype,   // SB = 2'b00, SH = 2'b01, SW = 2'b10
    output reg        cu_branch,      // Enable branching = 1'b1
    output reg  [2:0] cu_branchtype,  // BEQ = 3'b000, BNE = 3'b001,
                                      // BLT = 3'b010, BGE = 3'b011,
                                      // BLTU = 3'b100, BGEU = 3'b101
    output reg        cu_jump         // Enable jumping = 1'b1
);
 
    always @(*) begin
        // ---------------- Default values ----------------
        cu_ALU1src    = 1'b0;
        cu_ALU2src    = 1'b0;
        cu_immtype    = 3'b000;
        cu_ALUtype    = 2'b00;
        cu_adtype     = 1'b0;
        cu_gatype     = 2'b00;
        cu_shiftype   = 2'b00;
        cu_slttype    = 1'b0;
        cu_rdtype     = 2'b00;
        cu_rdwrite    = 1'b0;
        cu_loadtype   = 3'b000;
        cu_store      = 1'b0;
        cu_storetype  = 2'b00;
        cu_branch     = 1'b0;
        cu_branchtype = 3'b000;
        cu_jump       = 1'b0;
 
        case (opcode)
            // ---------------- R-type ----------------
            7'h33: begin
                cu_rdwrite = 1'b1;
                case (funct3)
                    3'h0: if (funct7 == 7'h20) cu_adtype = 1'b1;   // ADD/SUB
                    3'h1: cu_ALUtype = 2'b10;                      // SLL
                    3'h2: cu_ALUtype = 2'b11;                      // SLT
                    3'h3: begin                                    // SLTU
                        cu_ALUtype = 2'b11;
                        cu_slttype = 1'b1;
                    end
                    3'h4: cu_ALUtype = 2'b01;                      // XOR
                    3'h5: begin                                    // SRL/SRA
                        cu_ALUtype = 2'b10;
                        if (funct7 == 7'h00) cu_shiftype = 2'b01;  // SRL
                        if (funct7 == 7'h20) cu_shiftype = 2'b10;  // SRA
                    end
                    3'h6: begin                                    // OR
                        cu_ALUtype = 2'b01;
                        cu_gatype  = 2'b01;
                    end
                    3'h7: begin                                    // AND
                        cu_ALUtype = 2'b01;
                        cu_gatype  = 2'b10;
                    end
                endcase
            end
 
            // ---------------- I-type (ADDI by default) ----------------
            7'h13: begin
                cu_ALU2src = 1'b1;
                cu_rdwrite = 1'b1;
                case (funct3)
                    3'h0: ;                                        // ADDI (defaults)
                    3'h1: cu_ALUtype = 2'b10;                      // SLLI (shiftype = 00)
                    3'h2: cu_ALUtype = 2'b11;                      // SLTI
                    3'h3: begin                                    // SLTIU
                        cu_ALUtype = 2'b11;
                        cu_slttype = 1'b1;
                    end
                    3'h4: cu_ALUtype = 2'b01;                      // XORI (gatype = 00)
                    3'h5: begin                                    // SRLI/SRAI
                        cu_ALUtype = 2'b10;
                        if (funct7 == 7'h00) cu_shiftype = 2'b01;  // SRLI
                        if (funct7 == 7'h20) cu_shiftype = 2'b10;  // SRAI
                    end
                    3'h6: begin                                    // ORI
                        cu_ALUtype = 2'b01;
                        cu_gatype  = 2'b01;
                    end
                    3'h7: begin                                    // ANDI
                        cu_ALUtype = 2'b01;
                        cu_gatype  = 2'b10;
                    end
                endcase
            end
 
            // ---------------- Load ----------------
            7'h03: begin
                cu_ALU2src = 1'b1;
                cu_rdtype  = 2'b01;                                // from memory
                cu_rdwrite = 1'b1;
                case (funct3)
                    3'h0: cu_loadtype = 3'b000;                    // LB
                    3'h1: cu_loadtype = 3'b001;                    // LH
                    3'h2: cu_loadtype = 3'b010;                    // LW
                    3'h4: cu_loadtype = 3'b011;                    // LBU
                    3'h5: cu_loadtype = 3'b100;                    // LHU
                endcase
            end
 
            // ---------------- S-type ----------------
            7'h23: begin
                cu_ALU2src = 1'b1;
                cu_immtype = 3'b001;
                cu_store   = 1'b1;
                case (funct3)
                    3'h0: cu_storetype = 2'b00;                    // SB
                    3'h1: cu_storetype = 2'b01;                    // SH
                    3'h2: cu_storetype = 2'b10;                    // SW
                endcase
            end
 
            // ---------------- B-type ----------------
            7'h63: begin
                cu_ALU1src = 1'b1;                                 // PC
                cu_ALU2src = 1'b1;                                 // imm
                cu_immtype = 3'b010;
                cu_branch  = 1'b1;
                case (funct3)
                    3'h0: cu_branchtype = 3'b000;                  // BEQ
                    3'h1: cu_branchtype = 3'b001;                  // BNE
                    3'h4: cu_branchtype = 3'b010;                  // BLT
                    3'h5: cu_branchtype = 3'b011;                  // BGE
                    3'h6: cu_branchtype = 3'b100;                  // BLTU
                    3'h7: cu_branchtype = 3'b101;                  // BGEU
                endcase
            end
 
            // ---------------- AUIPC ----------------
            7'h17: begin
                cu_ALU1src = 1'b1;                                 // PC
                cu_ALU2src = 1'b1;                                 // imm
                cu_immtype = 3'b011;
                cu_rdwrite = 1'b1;                                 // rdtype = ALU
            end
 
            // ---------------- LUI ----------------
            7'h37: begin
                cu_ALU2src = 1'b1;
                cu_immtype = 3'b011;
                cu_rdtype  = 2'b11;                                // from immediate
                cu_rdwrite = 1'b1;
            end
 
            // ---------------- J-type (JAL) ----------------
            7'h6F: begin
                cu_ALU1src = 1'b1;                                 // PC
                cu_ALU2src = 1'b1;                                 // imm
                cu_immtype = 3'b100;
                cu_rdtype  = 2'b10;                                // PC+4
                cu_rdwrite = 1'b1;
                cu_jump    = 1'b1;
            end
 
            // ---------------- JALR ----------------
            7'h67: begin
                cu_ALU2src = 1'b1;                                 // rs1 + imm
                cu_rdtype  = 2'b10;                                // PC+4
                cu_rdwrite = 1'b1;
                cu_jump    = 1'b1;
            end
        endcase
    end
 
endmodule