module flip_flop #(parameter n = 32) (
input wire clk,
input wire [n-1:0] d,
output reg [n-1:0] q
);

always@(posedge clk)
begin
  q <= d ; 
end

endmodule

