module freq-div(
input clk ,// input clk =100 Mhz
input rst, // async reset
output clkdiv // desired freq (9.6 Khz)
);

parameter div=10417 // =100M/9.6K
reg [13:0] cnt; //2^14 =16k > 10k

always@(posedge clk or posedge rst) begin 

if(rst) begin
cnt<=0;
clkdiv<=0;

end
// the idea is to count the specific number of periods that we calculated by dividing the input freq and the desired feq (10417) 
// every 10417/2  periods we toggle the clkdiv , which is half the period , in order to get half period on '1' and the other hald on '0' 
else begin 
if(cnt==div/2-1) begin 
clkdiv<=~clkdiv;
cnt<=0;

else
cnt<=cnt+1;
end

end
end
endmodule
