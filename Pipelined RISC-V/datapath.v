module datapath (
//global inputs
input wire clk,
input wire rst,
//instr memory inputs 
input wire [31:0] instrF,
//data memory inputs
input wire [31:0] read_dataM,
//CU inputs
input wire [1:0]  immsrcD,
input wire        ALUsrcD,
input wire [1:0]  ALUctrlD,
input wire [1:0]  resultsrcD,
input wire        regwrD,
input wire        jumpD,
input wire        jalrD,
input wire        branchD,
input wire        memwrD,
//hazard unit inputs
input wire [1:0] forwardAE,
input wire [1:0] forwardBE, 
input wire       stallF,
input wire       stallD,
input wire       flushE,
input wire       flushD,
//CU outputs
output wire [31:0] instrD,
//hazard unit outputs 
output wire [4:0] rs1E,
output wire [4:0] rs2E,
output wire [4:0] rdM,
output wire [4:0] rdW,
output wire       regwrM,
output wire       regwrW,
output wire [4:0] rs1D,
output wire [4:0] rs2D,
output wire [4:0] rdE,
output wire       resultsrcE0,
output wire       PCsrcE0,
//instr memory outputs
output wire [31:0] PCF,
//data memory outputs
output wire [31:0] ALUoutM,
output wire [31:0] write_dataM,
output wire        memwrM
);



wire [31:0] PCnext , PCplus4F , PCplus4D , PCplus4E , PCplus4M  , PCplus4W, PCtargetE , PCD, PCE ;
wire [31:0] resultW ;
wire [31:0] SrcA , SrcB ;
wire [31:0] immextD , immextE ;

wire [31:0] instrE ;
wire        jalrE ,branchE , jumpE,regwrE , memwrE , ALUsrcE ;
wire [31:0] rd1D, rd2D ,rd1E, rd2E ;        
wire [31:0] ALUoutE , ALUoutW;
wire [31:0] write_dataE ;
wire [1:0]  PCsrcE , ALUctrlE;
wire [1:0]  resultsrcE , resultsrcM , resultsrcW ;
wire [31:0] read_dataW ;
wire [4:0] rdD ;

wire zero ;
wire zero_new ;
assign zero_new = (instrE[12] && instrE[6:0] == 7'b1100011)? !zero : zero ;
assign PCsrcE = {jalrE, ((zero_new & branchE) | jumpE) } ;

assign resultsrcE0 = resultsrcE[0] ;
assign PCsrcE0 = PCsrcE[0] ;
assign rs1D = instrD[19:15] ;
assign rs2D = instrD[24:20] ;
assign rdD = instrD[11:7] ;

//flip flops between fetch and decode
flip_flop_en #(32) u_ff1(
.clk(clk),
.rst(flushD),
.en(~stallD),
.d(instrF), 
.q(instrD)  //
);

flip_flop_en #(32) u_ff2(
.clk(clk),
.rst(flushD),
.en(~stallD),
.d(PCF), 
.q(PCD) 
);

flip_flop_en #(32) u_ff3(
.clk(clk),
.rst(flushD),
.en(~stallD),
.d(PCplus4F), 
.q(PCplus4D) 
);

//flip flops between decode and excute
flip_flop_rst #(1) u_ff4(
.clk(clk),
.rst(flushE),
.d(regwrD), 
.q(regwrE) 
);

flip_flop_rst #(2) u_ff5(
.clk(clk),
.rst(flushE),
.d(resultsrcD), 
.q(resultsrcE) 
);

flip_flop_rst #(1) u_ff6(
.clk(clk),
.rst(flushE),
.d(memwrD), 
.q(memwrE) 
);

flip_flop_rst #(1) u_ff7(
.clk(clk),
.rst(flushE),
.d(jumpD), 
.q(jumpE) 
);

flip_flop_rst #(1) u_ff8(
.clk(clk),
.rst(flushE),
.d(jalrD), 
.q(jalrE) 
);

flip_flop_rst #(1) u_ff9(
.clk(clk),
.rst(flushE),
.d(branchD), 
.q(branchE) 
);

flip_flop_rst #(2) u_ff10(
.clk(clk),
.rst(flushE),
.d(ALUctrlD), 
.q(ALUctrlE) 
);


flip_flop_rst #(1) u_ff11(
.clk(clk),
.rst(flushE),
.d(ALUsrcD), 
.q(ALUsrcE) 
);

flip_flop_rst #(32) u_ff12(
.clk(clk),
.rst(flushE),
.d(rd1D), 
.q(rd1E) 
);

flip_flop_rst #(32) u_ff13(
.clk(clk),
.rst(flushE),
.d(rd2D), 
.q(rd2E) 
);

flip_flop_rst #(32) u_ff14(
.clk(clk),
.rst(flushE),
.d(PCD), 
.q(PCE) 
);

flip_flop_rst #(5) u_ff15(
.clk(clk),
.rst(flushE),
.d(rs1D), 
.q(rs1E) 
);

flip_flop_rst #(5) u_ff16(
.clk(clk),
.rst(flushE),
.d(rs2D), 
.q(rs2E) 
);

flip_flop_rst #(5) u_ff17(
.clk(clk),
.rst(flushE),
.d(rdD), 
.q(rdE) 
);

flip_flop_rst #(32) u_ff18(
.clk(clk),
.rst(flushE),
.d(immextD), 
.q(immextE) 
);

flip_flop_rst #(32) u_ff19(
.clk(clk),
.rst(flushE),
.d(instrD), 
.q(instrE) 
);

flip_flop_rst #(32) u_ff20(
.clk(clk),
.rst(flushE),
.d(PCplus4D), 
.q(PCplus4E) 
);
//flip flops between excute and memory
flip_flop #(1) u_ff21(
.clk(clk),
.d(regwrE), 
.q(regwrM) 
);

flip_flop #(2) u_ff22(
.clk(clk),
.d(resultsrcE), 
.q(resultsrcM) 
);

flip_flop #(1) u_ff23(
.clk(clk),
.d(memwrE), 
.q(memwrM) 
);

flip_flop #(32) u_ff24(
.clk(clk),
.d(ALUoutE), 
.q(ALUoutM) 
);

flip_flop #(32) u_ff25(
.clk(clk),
.d(write_dataE), 
.q(write_dataM) 
);

flip_flop #(5) u_ff26(
.clk(clk),
.d(rdE), 
.q(rdM) 
);

flip_flop #(32) u_ff27(
.clk(clk),
.d(PCplus4E), 
.q(PCplus4M) 
);

//flip flops between memory and writeback 
flip_flop #(1) u_ff28(
.clk(clk),
.d(regwrM), 
.q(regwrW) 
);

flip_flop #(2) u_ff29(
.clk(clk),
.d(resultsrcM), 
.q(resultsrcW) 
);

flip_flop #(32) u_ff30(
.clk(clk),
.d(ALUoutM), 
.q(ALUoutW) 
);

flip_flop #(32) u_ff31(
.clk(clk),
.d(read_dataM), 
.q(read_dataW) 
);

flip_flop #(5) u_ff32(
.clk(clk),
.d(rdM), 
.q(rdW) 
);

flip_flop #(32) u_ff33(
.clk(clk),
.d(PCplus4M), 
.q(PCplus4W) 
);



flip_flop_en #(32) u_ff(
.clk(clk),
.rst(rst),
.en(~stallF),
.d(PCnext), 
.q(PCF) 
);

mux3x1 #(32) u_pcmux (
.sel(PCsrcE)   ,
.in0(PCplus4F) , 
.in1(PCtargetE) , 
.in2( {ALUoutE[31:1],1'b0} ), 
.out(PCnext) 
);

Reg_file u_regf (
.clk(clk),
.Addr1(rs1D),
.Addr2(rs2D),
.Addr3(rdW),
.wd3(resultW), 
.we3(regwrW),
.rd1(rd1D), 
.rd2(rd2D)
);

Sign_ext u_signext(
.in(instrD[31:7]),
.opcode(immsrcD),
.out(immextD) 
);

mux3x1 #(32) u_forwardAEmux (
.sel(forwardAE)   ,
.in0(rd1E) , 
.in1(resultW) , 
.in2(ALUoutM),
.out(SrcA)
);

mux3x1 #(32) u_forwardBEmux (
.sel(forwardBE)   ,
.in0(rd2E) , 
.in1(resultW) , 
.in2(ALUoutM),
.out(write_dataE)
);

mux2x1 #(32) u_alumux (
.sel(ALUsrcE)   ,
.in0(write_dataE) , 
.in1(immextE) , 
.out(SrcB) 
);

adder u_adderplus4 (
.in1(PCF), 
.in2(32'd4),
.out(PCplus4F) 
);

adder u_addertarget (
.in1(PCE), 
.in2(immextE), 
.out(PCtargetE) 
);

Alu u_ALU (
.ALUctrl(ALUctrlE) ,  
.A(SrcA) , 
.B(SrcB) , 
.ALUout(ALUoutE) ,
.zero(zero)
);

mux3x1 #(32) u_resultmux (
.sel(resultsrcW)   ,
.in0(ALUoutW) , 
.in1(read_dataW) , 
.in2(PCplus4W),
.out(resultW)
);

endmodule 


