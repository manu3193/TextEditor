`timescale 1ns / 1ps

module Button_Filter(
   input clk, button_in, 
	output hold, filtered
	);
	
	reg [24:0] holdtime_c;
	reg hold, filtered;
	
	initial begin
		hold = 1'bx;
		filtered = 1'bx;
	end
	
	always @(posedge clk) begin
		if (button_in != hold) begin
			hold = button_in;
			holdtime_c = 0;
		end
		else if (holdtime_c == 25'b1111111111111111111111111)
			filtered = hold;
		else 
			holdtime_c = holdtime_c + 1;
	end
	
endmodule
