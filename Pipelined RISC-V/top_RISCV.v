module top_RISCV #(parameter n = 10 , m = 32)(
input wire clk,
input wire rst,
input wire  [31:0] instrF,
output wire [n-1:0] addr,
output wire [m-1:0] write_dataM,
output wire        memwrM,
output wire [31:0] read_dataM,
output wire [31:0] PCF,
output wire [31:0] instrD
);

wire [1:0]  PCsrc ;
wire [1:0]  immsrcD ;
wire        ALUsrcD ;
wire [1:0]  ALUctrlD ;
wire [1:0]  resultsrcD ;
wire        regwrD , regwrM , regwrW ;
wire [31:0] ALUoutM ;
wire [1:0]  forwardAE, forwardBE;
wire [4:0]  rs1E , rs2E ;
wire [4:0]  rdE ,rdM , rdW ;
wire [4:0]  rs1D , rs2D ;
wire        jumpD ,jalrD , branchD ;
wire        stallF , stallD, flushD , flushE ; 
wire        resultsrcE0 , PCsrcE0 ;
    


assign addr = ALUoutM[9:0] ;



datapath u_dp (
.clk(clk),
.rst(rst),
//instr memory inputs 
.instrF(instrF), 
//data memory inputs
.read_dataM(read_dataM), 
//CU inputs
.immsrcD(immsrcD),
.ALUsrcD(ALUsrcD),
.ALUctrlD(ALUctrlD),
.resultsrcD(resultsrcD),
.regwrD(regwrD),
.jumpD(jumpD),
.jalrD(jalrD),
.branchD(branchD),
.memwrD(memwrD),
//hazard unit inputs
.forwardAE(forwardAE),
.forwardBE(forwardBE), 
.stallF(stallF),
.stallD(stallD),
.flushE(flushE),
.flushD(flushD),
//CU outputs 
.instrD(instrD),
//hazard unit outputs 
.rs1E(rs1E),
.rs2E(rs2E),
.rdM(rdM),
.rdW(rdW),
.regwrM(regwrM),
.regwrW(regwrW),
.rs1D(rs1D),
.rs2D(rs2D),
.rdE(rdE),
.resultsrcE0(resultsrcE0),
.PCsrcE0(PCsrcE0),
//instr memory outputs
.PCF(PCF),
//data memory outputs
.ALUoutM(ALUoutM),
.write_dataM(write_dataM),
.memwrM(memwrM)
);

control_unit u_cu (
.opD(instrD[6:0]),
.funct3D(instrD[14:12]),
.funct7_5D(instrD[30]),
//datapath outputs
.immsrcD(immsrcD),
.ALUsrcD(ALUsrcD),
.ALUctrlD(ALUctrlD),
.resultsrcD(resultsrcD),
.regwrD(regwrD),
.jumpD(jumpD),
.jalrD(jalrD),
.branchD(branchD),
//data memory output
.memwrD(memwrD)
);

hazard_unit u_hu (
.rst(rst),
.rs1E(rs1E),
.rs2E(rs2E),
.rdM(rdM),
.rdW(rdW),
.regwrM(regwrM),
.regwrW(regwrW),
//stalling inputs
.rs1D(rs1D),
.rs2D(rs2D),
.rdE(rdE),
.resultsrcE0(resultsrcE0),
//flushing inputs
.PCsrcE0(PCsrcE0),
//forwarding outputs
.forwardAE(forwardAE),
.forwardBE(forwardBE),
//stalling outputs 
.stallF(stallF),
.stallD(stallD),
.flushE(flushE),
//flushing outputs 
.flushD(flushD)
);


endmodule