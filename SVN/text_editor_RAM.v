`timescale 1ns / 1ps

module text_editor_RAM(
    input							clk,
	 input							Reset,
    input							write,
	 input  [ADDR_WIDTH-1:0] 	write_address,
	 input  [DATA_WIDTH-1:0] 	write_data,
	 input  [ADDR_WIDTH-1:0] 	read_address,
	 
	 output [DATA_WIDTH-1:0]	read_data
    );
	 
	 parameter DATA_WIDTH = 8;
	 parameter ADDR_WIDTH = 9;
	 parameter RAM_DEPTH  = 1 << ADDR_WIDTH;
	 
	 reg [DATA_WIDTH-1:0] data [0:RAM_DEPTH-1]; // Array to store 512 8-bit words (characters)
	 
	 always @ (posedge clk, posedge Reset) begin: RAM_logic
		if (Reset) begin: Reset
			integer i;
			for (i = 0; i < RAM_DEPTH; i = i + 1) begin
				data[i] <= 8'h29; // a "Space"
			end			
		end else if (write) begin
			data[write_address] <= write_data;
		end
	 end
	 
	 assign read_data = data[read_address];
 
endmodule
