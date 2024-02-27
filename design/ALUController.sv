`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [1:0] ALUOp,  // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

  assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b110)) ||  // R\I-or
      ((ALUOp == 2'b10) && (Funct3 == 3'b100)) ||  // R\I-xor
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // R\I-srli
      ((ALUOp == 2'b10) && (Funct3 == 3'b000) & (Funct7 == 7'b0100000))  || //R\I - sub
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||  // R\I-srai
      ((ALUOp == 2'b01) && (Funct3 == 3'b001)); // Branch - bne

  assign Operation[1] = (ALUOp == 2'b00) ||  // LW\SW
      ((ALUOp == 2'b10) && (Funct3 == 3'b000)) ||  // R\I-add/addi
      ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) || //R\I - sub
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // R\I-srai
      (ALUOp == 2'b11) ||  //LUI
      ((ALUOp == 2'b01) && (Funct3 == 3'b101));    // Branch - bge

  assign Operation[2] =  ((ALUOp==2'b10) && (Funct3==3'b101) && (Funct7==7'b0000000)) || // R\I-srli
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||  // R\I-srai
      ((ALUOp == 2'b10) && (Funct3 == 3'b001)) ||  // R\I-slli
      ((ALUOp == 2'b10) && (Funct3 == 3'b010)) ||  // R\I-slt/slti
      ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||  // Branch - bne
      ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||  // Branch - blt
      ((ALUOp == 2'b01) && (Funct3 == 3'b101));    // Branch - bge

  assign Operation[3] = (ALUOp == 2'b01) ||  // Branch - beq/bne/blt/bge
      ((ALUOp == 2'b10) && (Funct3 == 3'b100)) ||  // R\I-xor
      ((ALUOp == 2'b10) && (Funct3 == 3'b010)) ||  // R\I-slt/slti
      (ALUOp == 2'b11);  //LUI
endmodule
