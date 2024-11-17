module reciever(
input clk,
input rx,
input rst,
output [7:0] do,
output busy,
output done
);
reg [3:0] cnt;
reg [1:0] idle=0 , rec =1 , fin =1;
reg [7:0] stored;
reg [1:0] st, ns;

always@(posedge clk or posedge rst) begin 
if(rst)
begin 
st<=idle;
busy<=0;
done<=0;
do<=0;
cnt<=0;
stored<=0;
end
else begin
st<=ns;
if(st==rec)begin 
cnt<=cnt+1;
stored<={rx,stored[7:1]};
end
end


always@(*) begin 
case (st)  begin 
idle: begin
busy=0;
done=0;
ns= rx ? idle : rec;

 end

rec: begin 
busy=1;
if(cnt==8)
 ns=fin;
 else
 ns=rec;

end
fin:  begin
do=stored;
done=1;
busy=0;
ns=idle;
cnt=0;
end
 
 
endcase
end



end
endmodule
