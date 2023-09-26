module control_unit(
//instr memory inputs
input wire [6:0]  opD,
input wire [2:0]  funct3D,
input wire        funct7_5D,
//datapath outputs
output wire [1:0]  immsrcD,
output wire        ALUsrcD,
output wire [1:0]  ALUctrlD,
output wire [1:0]  resultsrcD,
output wire        regwrD,
output wire        jumpD,
output wire        jalrD,
output wire        branchD,
//data memory output
output wire       memwrD
);

wire [1:0] ALUopD ;


main_decoder u_md (
.op(opD),
.jump(jumpD),
.jalr(jalrD),
.branch(branchD),
.immsrc(immsrcD),
.ALUsrc(ALUsrcD),
.ALUop(ALUopD), //
.resultsrc(resultsrcD),
.regwr(regwrD),
.memwr(memwrD)
); 

Alu_decoder u_ad (
.ALUop(ALUopD),
.funct3(funct3D),
.funct7_5(funct7_5D),
.op_5(opD[5]),
.ALUctrl(ALUctrlD)
);



endmodule
