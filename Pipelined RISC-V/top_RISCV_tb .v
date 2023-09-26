`timescale 1ps/1fs 
module top_RISCV_tb #(parameter n = 10 , m = 32)();
reg clk ;
reg rst ; 
wire [31:0]  instrF ;
wire [n-1:0] addr; 
wire [m-1:0] write_dataM;
wire         memwrM ;
wire [31:0] read_dataM;
wire [31:0] PCF;
wire [31:0] instrD;

//instantiation
top_RISCV #(10,32) u_top (
.clk(clk),
.rst(rst), 
.instrF(instrF),
.addr(addr), 
.write_dataM(write_dataM),
.memwrM(memwrM),
.read_dataM(read_dataM),
.PCF(PCF),
.instrD(instrD)
);

instr_rom #(10,32) u_ins_rom (
.addr(PCF[9:0]),
.read_data(instrF)
);

data_ram #(10,32) u_data_ram (
.clk(clk),
.rst(rst),
.we(memwrM),
.addr(addr),
.write_data(write_dataM),
.read_data(read_dataM)
);

initial 
begin
  clk = 0 ;
  forever #250 clk = ~clk ; //clk with period 500ps 
end

initial 
begin 
  rst = 1'b1  ;
  #500 
  rst = 1'b0 ;
end

always@(negedge clk)
begin
  if(memwrM)
    begin
      if(write_dataM == 2 && addr == 96)
        begin
          $display("time = %0t , write_dataM = %4d ,  addr = %8d ,testcase1 passed (first sw)", $time , write_dataM , addr) ;
        end
      else if(write_dataM == 4 && addr == 92)
        begin
          $display("time = %0t , write_dataM = %4d ,  addr = %8d ,testcase2 passed (second sw)", $time , write_dataM , addr) ;
		      #1500
          $stop ;
        end
      else
        begin
          $display("time = %0t , write_dataM = %4d ,  addr = %8d ,testcase1,2 faild", $time , write_dataM , addr) ;
          $stop ;
        end
    end
end

endmodule
