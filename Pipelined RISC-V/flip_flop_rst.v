module flip_flop_rst #(parameter n = 32) (
input wire clk,
input wire rst,
input wire [n-1:0] d,
output reg [n-1:0] q
);

always@(posedge clk)
begin
  if(rst)
    begin
      q <= 0 ;
    end
  else
    begin
      q <= d ; 
    end
end

endmodule

    

