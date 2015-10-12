// Listing 14.7
module textMenu_graph 
   (
    input wire clk, reset,
    input wire [2:0] item_selector,
    input wire [9:0] pix_x, pix_y,
    output wire graph_on,
    output reg [2:0] graph_rgb
   );

   // costant and signal declaration
   // x, y coordinates (0,0) to (639,479)
   localparam MAX_X = 640;
   localparam MAX_Y = 480;
   
	//Top menu sections
	localparam item1 = 4'd1;
	localparam item2 = 4'd2;
	localparam item3 = 4'd3;
	localparam item4 = 4'd4;
	localparam item5 = 4'd5;
	localparam item6 = 4'd6;
	
	//Top menu vertical limits
	localparam topMenu_y_limit_top = 0;
	localparam topMenu_y_limit_bottom = 80;
	
	//Top menu horizontal limits
	localparam topMenu_x_limit_left=0;
	localparam topMenu_x_limit_right=640;
	
	//Top menu items sections horizontal each region
	localparam topMenu_x_open_limit_left=10;
	localparam topMenu_x_open_limit_right=topMenu_x_open_limit_left+60;
	localparam topMenu_x_save_limit_left=topMenu_x_open_limit_right+10;
	localparam topMenu_x_save_limit_right=topMenu_x_save_limit_left+60;
	localparam topMenu_x_exit_limit_left=topMenu_x_save_limit_right+10;
	localparam topMenu_x_exit_limit_right=topMenu_x_exit_limit_left+60;
	localparam topMenu_x_center_width=topMenu_x_exit_limit_right+210;
	localparam topMenu_x_caps_limit_left=topMenu_x_center_width+10;
	localparam topMenu_x_caps_limit_right=topMenu_x_caps_limit_left+60;
	localparam topMenu_x_color_limit_left=topMenu_x_caps_limit_right+10;
	localparam topMenu_x_color_limit_right=topMenu_x_color_limit_left+60;
	localparam topMenu_x_size_limit_left=topMenu_x_color_limit_right+10;
	localparam topMenu_x_size_limit_right=topMenu_x_size_limit_left+60;
	
	//Top menu items vertical limits
	localparam topMenu_y_item_top_limit=topMenu_y_limit_top+17;
	localparam topMenu_y_item_bottom_limit=topMenu_y_item_top_limit+45; 
	
	wire menu_mostrar_separador;
	wire menu_mostrar;
	
	assign menu_mostrar_separador = (topMenu_x_limit_left<=pix_x) && (pix_x <= topMenu_x_limit_right) &&
							    (topMenu_y_limit_bottom-2<=pix_y) && (pix_y <= topMenu_y_limit_bottom);
								 
	
						
   //						
	reg[5:0] show_item_selector;
	reg [2:0] currentItem;
	

	always @ (*) begin
		
		currentItem= item_selector;
	
		case(currentItem) 
		
			item1: begin
							show_item_selector[0] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_right-1<=pix_x) && (pix_x <= topMenu_x_open_limit_right));
							end
			
			item2: begin
							show_item_selector[1] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_right-1<=pix_x) && (pix_x <= topMenu_x_save_limit_right));

							end
			
			item3: begin
							show_item_selector[2] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_exit_limit_left<=pix_x) && (pix_x <= topMenu_x_exit_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_exit_limit_left<=pix_x) && (pix_x <= topMenu_x_exit_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_exit_limit_left<=pix_x) && (pix_x <= topMenu_x_exit_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_exit_limit_right-1<=pix_x) && (pix_x <= topMenu_x_exit_limit_right));

							end
			
			item4: begin
							show_item_selector[3] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_caps_limit_left<=pix_x) && (pix_x <= topMenu_x_caps_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_caps_limit_left<=pix_x) && (pix_x <= topMenu_x_caps_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_caps_limit_left<=pix_x) && (pix_x <= topMenu_x_caps_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_caps_limit_right-1<=pix_x) && (pix_x <= topMenu_x_caps_limit_right));

							end
			
			item5: begin
							show_item_selector[4] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_color_limit_left<=pix_x) && (pix_x <= topMenu_x_color_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_color_limit_left<=pix_x) && (pix_x <= topMenu_x_color_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_color_limit_left<=pix_x) && (pix_x <= topMenu_x_color_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_color_limit_right-1<=pix_x) && (pix_x <= topMenu_x_color_limit_right));

							end
			
			item6: begin
							show_item_selector[5] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_size_limit_left<=pix_x) && (pix_x <= topMenu_x_size_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_size_limit_left<=pix_x) && (pix_x <= topMenu_x_size_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_size_limit_left<=pix_x) && (pix_x <= topMenu_x_size_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_size_limit_right-1<=pix_x) && (pix_x <= topMenu_x_size_limit_right));

							end
			default: 	begin
							show_item_selector= 3'b000;			
							end
		endcase
	end

   //--------------------------------------------
   // rgb multiplexing circuit
   //--------------------------------------------
   always @* begin
			if (menu_mostrar_separador)
				graph_rgb = 3'b000;
			else if (show_item_selector[0] || show_item_selector[1] || show_item_selector[2] ||
						show_item_selector[3] || show_item_selector[4] || show_item_selector[5])
							graph_rgb = 3'b100;
	end
	
	assign graph_on=show_item_selector[0] || show_item_selector[1] || show_item_selector[2] ||
						show_item_selector[3] || show_item_selector[4] || show_item_selector[5] || menu_mostrar_separador;
		
endmodule 
