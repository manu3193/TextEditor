// Listing 14.4
module text_screen_gen
   (
    input wire clk, reset,
    input wire [2:0] btn,
    input wire [6:0] sw,
    input wire [9:0] pixel_x, pixel_y,
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

	//labels
	wire open_label_on, save_label_on, exit_label_on, caps_label_on, color_label_on, size_label_on, center_label_on;
	wire [2:0]  bit_addr_open_label, bit_addr_save_label,bit_addr_exit_label,bit_addr_center_label;
	wire [2:0] bit_addr_caps_label, bit_addr_color_label, bit_addr_size_label;
   wire [3:0] row_addr_open_label, row_addr_save_label, row_addr_exit_label, row_addr_center_label;
   wire [3:0] row_addr_caps_label, row_addr_color_label, row_addr_size_label;
	reg [6:0]  char_addr_open_label, char_addr_save_label,char_addr_exit_label, char_addr_center_label;
	reg [6:0] char_addr_caps_label, char_addr_color_label, char_addr_size_label;

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
	/*
	assign caps_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<19 &&(pixel_x[9:3]>14));
   assign row_addr_save_label = pixel_y[4:0];
   assign bit_addr_save_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'hF: char_addr_save_label = 7'h53; // S
         4'h10: char_addr_save_label = 7'h61; // a
         4'h11: char_addr_save_label = 7'h76; // v
			4'h12: char_addr_save_label = 7'h65;// e
			
      endcase
		
	assign color_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<19 &&(pixel_x[9:3]>14));
   assign row_addr_save_label = pixel_y[4:0];
   assign bit_addr_save_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'hF: char_addr_save_label = 7'h53; // S
         4'h10: char_addr_save_label = 7'h61; // a
         4'h11: char_addr_save_label = 7'h76; // v
			4'h12: char_addr_save_label = 7'h65;// e
			
      endcase
		
	assign size_label_on = (pixel_y[9:4]==2) && (pixel_x[9:3]<19 &&(pixel_x[9:3]>14));
   assign row_addr_save_label = pixel_y[4:0];
   assign bit_addr_save_label = pixel_x[3:0];
   always @*
      case (pixel_x[6:3])
         4'hF: char_addr_save_label = 7'h53; // S
         4'h10: char_addr_save_label = 7'h61; // a
         4'h11: char_addr_save_label = 7'h76; // v
			4'h12: char_addr_save_label = 7'h65;// e
			
      endcase
		
	*/

   //-------------------------------------------
   // mux for font ROM addresses and rgb
   //-------------------------------------------
   always @*
   begin
      text_rgb = 3'b111;  // background, white
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
               text_rgb = 3'b000;
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
	
	 assign text_on = open_label_on||save_label_on||exit_label_on||center_label_on||caps_label_on||color_label_on||size_label_on;
   //-------------------------------------------
   // font rom interface
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr};
   assign font_bit = font_word[~bit_addr];
endmodule

