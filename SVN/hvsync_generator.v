`timescale 1ns / 1ps

module hvsync_generator(
input wire clk,
input wire reset,
output reg vga_h_sync,
output reg vga_v_sync,
output reg [10:0] CounterX,
output reg [10:0] CounterY,
output reg inDisplayArea
    );


parameter TotalHorizontalPixels = 11'd800;
parameter HorizontalSyncWidth = 11'd96;
parameter VerticalSyncWidth = 11'd2;

parameter TotalVerticalLines = 11'd525;
parameter HorizontalBackPorchTime = 11'd144 ;
parameter HorizontalFrontPorchTime = 11'd784 ;
parameter VerticalBackPorchTime = 11'd12 ;
parameter VerticalFrontPorchTime = 11'd492;

reg VerticalSyncEnable;

reg [10:0] HorizontalCounter;
reg [10:0] VerticalCounter;

//Counter for the horizontal sync signal
always @(posedge clk or posedge reset)
begin
	if(reset == 1)
		HorizontalCounter <= 0;
	else
		begin
			if(HorizontalCounter == TotalHorizontalPixels - 1)
				begin //the counter has hreached the end of a horizontal line
					HorizontalCounter<=0;
					VerticalSyncEnable <= 1;
				end
			else
				begin 
					HorizontalCounter<=HorizontalCounter+1; 
					VerticalSyncEnable <=0;
				end
		end
end

//Generate the vga_h_sync pulse
//Horizontal Sync is low when HorizontalCounter is 0-127

always @(*)
begin
	if((HorizontalCounter<HorizontalSyncWidth))
		vga_h_sync = 1;
	else
		vga_h_sync = 0;
end

//Counter for the vertical sync

always @(posedge clk or posedge reset)
begin
	if(reset == 1)
		VerticalCounter<=0;
	else
	begin
		if(VerticalSyncEnable == 1)
			begin
				if(VerticalCounter==TotalVerticalLines-1)
					VerticalCounter<=0;
				else
					VerticalCounter<=VerticalCounter+1;
			end
	end
end

//generate the vga_v_sync pulse
always @(*)
begin
	if(VerticalCounter < VerticalSyncWidth)
		vga_v_sync = 1;
	else
		vga_v_sync = 0;
end

always @(posedge clk)
begin
	if((HorizontalCounter<HorizontalFrontPorchTime) && (HorizontalCounter>HorizontalBackPorchTime) && (VerticalCounter<VerticalFrontPorchTime) && (VerticalCounter>VerticalBackPorchTime))
		begin
			inDisplayArea <= 1;
			CounterX<= HorizontalCounter - HorizontalBackPorchTime;
			CounterY<= VerticalCounter - VerticalBackPorchTime;
		end
	else
		begin
			inDisplayArea <= 0;
			CounterX<=0;
			CounterY<=0;
		end
end

endmodule