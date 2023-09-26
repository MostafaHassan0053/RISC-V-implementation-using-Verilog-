module hazard_unit (
//fowarding inputs
input wire       rst,
input wire [4:0] rs1E,
input wire [4:0] rs2E,
input wire [4:0] rdM,
input wire [4:0] rdW,
input wire       regwrM,
input wire       regwrW,
//stalling inputs
input wire [4:0] rs1D,
input wire [4:0] rs2D,
input wire [4:0] rdE,
input wire       resultsrcE0,
//flushing inputs
input wire       PCsrcE0,
//forwarding outputs
output reg [1:0] forwardAE,
output reg [1:0] forwardBE,
//stalling outputs 
output reg       stallF ,
output reg       stallD,
output reg       flushE,
//flushing outputs 
output reg       flushD
);



always@(*)
begin
     if( (rs1E == rdM) && regwrM && rs1E != 0 )
      begin
        forwardAE = 2'b10 ;
      end
    else if( (rs1E == rdW) && regwrW && rs1E != 0 )
      begin
        forwardAE = 2'b01 ;
      end
    else
      begin
        forwardAE <= 2'b00 ;
      end
      
    if( (rs2E == rdM) && regwrM && rs2E != 0 )
      begin
        forwardBE = 2'b10 ;
      end
    else if( (rs2E == rdW) && regwrW && rs2E != 0 )
      begin
        forwardBE = 2'b01 ;
      end
    else
      begin
         forwardBE = 2'b00 ;
      end 
               
end 

always@(*)
begin
  if(rst)
    begin
      stallF = 1'b0 ;
      stallD = 1'b0 ; 
    end
  else if(( (rdE == rs1D) || (rdE == rs2D) ) && resultsrcE0 ) 
    begin
      stallF = 1'b1 ;
      stallD = 1'b1 ;
    end
  else
    begin
      stallF = 1'b0 ;
      stallD = 1'b0 ;
    end
end

always@(*)
begin
  if(rst)
    begin
      flushD = 1'b0 ;
    end  
  else if(PCsrcE0)
    begin
      flushD = 1'b1  ;
    end
  else
    begin 
      flushD = 1'b0 ;
    end 
    
    
  if(rst)
    begin
      flushE = 1'b0 ;
    end
  else if((( (rdE == rs1D) || (rdE == rs2D) ) && resultsrcE0 ) || PCsrcE0)
    begin
      flushE = 1'b1 ;
    end 
  else
    begin
      flushE = 1'b0 ; 
    end

end 

endmodule

