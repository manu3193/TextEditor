// Listing 14.4
module text_screen_gen
   (
    input wire clk, reset,
	 input wire caps_on,
	 input wire [2:0] color_selector,
	 input wire [1:0] size_selector,
    input wire [9:0] pixel_x, pixel_y,
	 input wire window_selector,
    output reg [2:0] text_rgb,
	 output wire text_on
   );

   // signal declaration
   // font ROM
   wire [10:0] rom_addr;
   reg [6:0] char_addr;
   reg [3:0] row_addr;
   reg [2:0] bit_addr;
   wire [7:0] font_word;
   wire font_bit;

	//labels, text editor window
	wire open_label_on, save_label_on, exit_label_on, caps_label_on, color_label_on, size_label_on, center_label_on;
	wire [2:0]  bit_addr_open_label, bit_addr_save_label,bit_addr_exit_label,bit_addr_center_label;
	wire [2:0] bit_addr_caps_label, bit_addr_color_label, bit_addr_size_label;
   wire [3:0] row_addr_open_label, row_addr_save_label, row_addr_exit_label, row_addr_center_label;
   wire [3:0] row_addr_caps_label, row_addr_color_label, row_addr_size_label;
	reg [6:0]  char_addr_open_label, char_addr_save_label,char_addr_exit_label, char_addr_center_label;
	reg [6:0] char_addr_caps_label, char_addr_color_label, char_addr_size_label;
	
	//labels, init dialog
	
	wire new_label_on, open_label_on_1, center_label_1_on;
	wire [2:0]  bit_addr_open_1_label, bit_addr_new_label, bit_addr_center_1_label;
	wire [3:0] row_addr_open_1_label, row_addr_new_label, row_addr_center_1_label;
	reg [6:0]  char_addr_open_1_label, char_addr_center_1_label, char_addr_new_label;
	
	
	// instantiate font ROM
   font_rom font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));
   

	assign open_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<=6 &&(pixel_x[9:3]>=4));
   assign row_addr_open_label = pixel_y[4:0];
   assign bit_addr_open_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd4: char_addr_open_label = 7'h4e; // N
         4'd5: char_addr_open_label = 7'h65; // e
         4'd6: char_addr_open_label = 7'h77; // w
      endcase
		
	assign save_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<=15 &&(pixel_x[9:3]>=12));
   assign row_addr_save_label = pixel_y[4:0];
   assign bit_addr_save_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd12: char_addr_save_label = 7'h53; // S
         4'd13: char_addr_save_label = 7'h61; // a
         4'd14: char_addr_save_label = 7'h76; // v
			4'd15: char_addr_save_label = 7'h65;// e
			
      endcase
		
	assign exit_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<=23 &&(pixel_x[9:3]>=20));
   assign row_addr_exit_label = pixel_y[4:0];
   assign bit_addr_exit_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd20: char_addr_exit_label = 7'h45; // E
         4'd21: char_addr_exit_label = 7'h78; // x
         4'd22: char_addr_exit_label = 7'h69; // i
			4'd23: char_addr_exit_label = 7'h74;// t
			
      endcase
	
	assign center_label_on = (pixel_y[9:5]==1) && (pixel_x[9:4]<=23 &&(pixel_x[9:4]>=15));
   assign row_addr_center_label = pixel_y[4:1];
   assign bit_addr_center_label = pixel_x[4:1];
   always @*
      case (pixel_x[7:4])
         4'd15: char_addr_center_label = 7'h44; // D
         4'd16: char_addr_center_label = 7'h45; // E
         4'd17: char_addr_center_label = 7'h4d; // M
			4'd18: char_addr_center_label = 7'h4f;// O
			4'd19: char_addr_center_label = 7'h20; // 
         4'd20: char_addr_center_label = 7'h57; // W
         4'd21: char_addr_center_label = 7'h4f; // O
			4'd22: char_addr_center_label = 7'h52;// R
			4'd23: char_addr_center_label = 7'h44;// D
			
      endcase
	
	assign caps_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<=57 &&(pixel_x[9:3]>=56));
   assign row_addr_caps_label = pixel_y[4:0];
   assign bit_addr_caps_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd56: 
				begin
				if (caps_on)
					char_addr_caps_label = 7'h41; // A
				else if (!caps_on) 
					char_addr_caps_label = 7'h61; // a
				end
         4'd57: 
				begin
				if (caps_on)
					char_addr_caps_label = 7'h61; // a
				else if (!caps_on) 
					char_addr_caps_label = 7'h41; // A
				end
      endcase
		
	assign color_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<=68 &&(pixel_x[9:3]>=64));
   assign row_addr_color_label = pixel_y[4:0];
   assign bit_addr_color_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd64: char_addr_color_label = 7'h43; //  C
         4'd65: char_addr_color_label = 7'h6f; // o
         4'd66: char_addr_color_label = 7'h6c; // l
			4'd67: char_addr_color_label = 7'h6f;//  o
			4'd68: char_addr_color_label = 7'h72;//  r
			
      endcase
		
	assign size_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<=78 &&(pixel_x[9:3]>=71));
   assign row_addr_size_label = pixel_y[4:0];
   assign bit_addr_size_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd71: char_addr_size_label = 7'h53; // S
         4'd72: char_addr_size_label = 7'h69; // i
         4'd73: char_addr_size_label = 7'h7a; // z
			4'd74: char_addr_size_label = 7'h65;// e
			4'd75: char_addr_size_label = 7'h3a; //  :
         4'd76: char_addr_size_label = 7'h20; // 
			4'd77: char_addr_size_label = 7'h31; // 1
			4'd78:
				begin
					if(size_selector==10'd1)
						char_addr_size_label = 7'h30; // 0
					else if (size_selector==10'd2) 
						char_addr_size_label = 7'h32;// 2
					else if(size_selector==10'd3) 
						char_addr_size_label = 7'h34;// 4
				end			
      endcase

	assign center_1_label_on = (pixel_y[9:5]==4) && (pixel_x[9:4]<=23 &&(pixel_x[9:4]>=15));
   assign row_addr_center_1_label = pixel_y[4:1];
   assign bit_addr_center_1_label = pixel_x[4:1];
   always @*
      case (pixel_x[7:4])
         4'd15: char_addr_center_1_label = 7'h44; // D
         4'd16: char_addr_center_1_label = 7'h45; // E
         4'd17: char_addr_center_1_label = 7'h4d; // M
			4'd18: char_addr_center_1_label = 7'h4f;// O
			4'd19: char_addr_center_1_label = 7'h20; // 
         4'd20: char_addr_center_1_label = 7'h57; // W
         4'd21: char_addr_center_1_label = 7'h4f; // O
			4'd22: char_addr_center_1_label = 7'h52;// R
			4'd23: char_addr_center_1_label = 7'h44;// D
			
      endcase
		
		
	assign new_label_on = (pixel_y[9:4]==15) && (pixel_x[9:3]<=26 &&(pixel_x[9:3]>=24));
   assign row_addr_new_label = pixel_y[4:0];
   assign bit_addr_new_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd24: char_addr_new_label = 7'h4e; // N
         4'd25: char_addr_new_label = 7'h65; // e
         4'd26: char_addr_new_label = 7'h77; // w
      endcase
		
	assign open_1_label_on = (pixel_y[9:4]==10) && (pixel_x[9:3]<=27 &&(pixel_x[9:3]>=24));
   assign row_addr_open_1_label = pixel_y[4:0];
   assign bit_addr_open_1_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'd24: char_addr_open_1_label = 7'h4f; // O
         4'd25: char_addr_open_1_label = 7'h70; // p
         4'd26: char_addr_open_1_label = 7'h65; // e
			4'd27: char_addr_open_1_label = 7'h6e; // n
      endcase
   //-------------------------------------------
   // mux for font ROM addresses and rgb
   //-------------------------------------------
   always @*
   begin
      text_rgb = 3'b111;  // background, white
		if(window_selector) begin
			if (open_label_on)
				begin
					char_addr = char_addr_open_label;
					row_addr = row_addr_open_label;
					bit_addr = bit_addr_open_label;
					if (font_bit)
						text_rgb = 3'b000;
				end
			else if (save_label_on)
				begin
					char_addr = char_addr_save_label;
					row_addr = row_addr_save_label;
					bit_addr = bit_addr_save_label;
					if (font_bit)
						text_rgb = 3'b000;
				end
			else if (exit_label_on)
				begin
					char_addr = char_addr_exit_label;
					row_addr = row_addr_exit_label;
					bit_addr = bit_addr_exit_label;
					if (font_bit)
						text_rgb = 3'b000;
				end
			else if (center_label_on)
				begin
					char_addr = char_addr_center_label;
					row_addr = row_addr_center_label;
					bit_addr = bit_addr_center_label;
					if (font_bit)
						text_rgb = 3'b000;
				end
			else if (caps_label_on)
				begin
					char_addr = char_addr_caps_label;
					row_addr = row_addr_caps_label;
					bit_addr = bit_addr_caps_label;
					if (font_bit)
						text_rgb = 3'b000;
				end
			else if (color_label_on)
				begin
					char_addr = char_addr_color_label;
					row_addr = row_addr_color_label;
					bit_addr = bit_addr_color_label;
					if (font_bit)
						text_rgb = color_selector;
				end
			else if (size_label_on)
				begin
					char_addr = char_addr_size_label;
					row_addr = row_addr_size_label;
					bit_addr = bit_addr_size_label;
					if (font_bit)
						text_rgb = 3'b000;
				end
		end
		else if (!window_selector) begin
			if (open_1_label_on)
					begin
						char_addr = char_addr_open_1_label;
						row_addr = row_addr_open_1_label;
						bit_addr = bit_addr_open_1_label;
						if (font_bit)
							text_rgb = 3'b000;
					end
			else if (new_label_on)
					begin
						char_addr = char_addr_new_label;
						row_addr = row_addr_new_label;
						bit_addr = bit_addr_new_label;
						if (font_bit)
							text_rgb = 3'b000;
					end
			else if (center_1_label_on)
					begin
						char_addr = char_addr_center_1_label;
						row_addr = row_addr_center_1_label;
						bit_addr = bit_addr_center_1_label;
						if (font_bit)
							text_rgb = 3'b000;
					end
		end
	end
      
	
	 assign text_on = ((open_label_on||save_label_on||exit_label_on||center_label_on||caps_label_on||color_label_on||size_label_on) && window_selector) ||
	                  ((open_1_label_on||new_label_on||center_1_label_on)&& !window_selector);
   //-------------------------------------------
   // font rom interface
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr};
   assign font_bit = font_word[~bit_addr];
endmodule

