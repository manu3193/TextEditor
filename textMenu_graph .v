// Listing 14.7
module textMenu_graph 
   (
    input wire clk, reset,
    input wire [2:0] item_selector,
    input wire [9:0] pix_x, pix_y,
	 input wire window_selector,
    output wire graph_on,
    output reg [2:0] graph_rgb
   );

   // costant and signal declaration
   // x, y coordinates (0,0) to (639,479)
   localparam MAX_X = 640;
   localparam MAX_Y = 480;
   
	//Top menu text window sections
	localparam itemTextMenu1 = 4'd1;
	localparam itemTextMenu2 = 4'd2;
	localparam itemTextMenu3 = 4'd3;
	localparam itemTextMenu4 = 4'd4;
	localparam itemTextMenu5 = 4'd5;
	localparam itemTextMenu6 = 4'd6;
	
	//Main menu dialog sections
	localparam itemMainMenu1=1'b0;
	localparam itemMainMenu2=1'b1;
	
	//Menu main window vertical limits
	localparam topMenu_main_y_limit_top = 115;
	localparam topMenu_main_y_limit_bottom = 288;
	
	//Top menu text window vertical limits
	localparam topMenu_y_limit_top = 0;
	localparam topMenu_y_limit_bottom = 80;
	
	//Top menu text window horizontal limits
	localparam topMenu_x_limit_left=0;
	localparam topMenu_x_limit_right=640;
	
	//Top menu main window horizontal limits
	localparam topMenu_main_x_limit_left=190;
	localparam topMenu_main_x_limit_right=420;
	
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
   
	assign menu_mostrar=((topMenu_main_y_limit_top<=pix_y) && (pix_y <= topMenu_main_y_limit_top+1) &&
								(topMenu_main_x_limit_left<=pix_x) && (pix_x <= topMenu_main_x_limit_right)) ||
								((topMenu_main_y_limit_bottom-1<=pix_y) && (pix_y <= topMenu_main_y_limit_bottom) &&
								(topMenu_main_x_limit_left<=pix_x) && (pix_x <= topMenu_main_x_limit_right)) ||
								((topMenu_main_y_limit_top<=pix_y) && (pix_y <= topMenu_main_y_limit_bottom) &&
								(topMenu_main_x_limit_left<=pix_x) && (pix_x <= topMenu_main_x_limit_left+1)) ||
								((topMenu_main_y_limit_top<=pix_y) && (pix_y <= topMenu_main_y_limit_bottom) &&
								(topMenu_main_x_limit_right-1<=pix_x) && (pix_x <= topMenu_main_x_limit_right));


	
	reg[5:0] show_item_selector;
	reg [1:0] show_item_main_selector;
	
	reg [2:0] currentItemTextMenu;
	reg currentItemMainMenu;
	


always @ (*) begin
		
		currentItemTextMenu= item_selector;
	
		case(currentItemTextMenu) 
		
			itemTextMenu1: begin
							show_item_selector[0] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_right-1<=pix_x) && (pix_x <= topMenu_x_open_limit_right));
							end
			
			itemTextMenu2: begin
							show_item_selector[1] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_right-1<=pix_x) && (pix_x <= topMenu_x_save_limit_right));

							end
			
			itemTextMenu3: begin
							show_item_selector[2] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_exit_limit_left<=pix_x) && (pix_x <= topMenu_x_exit_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_exit_limit_left<=pix_x) && (pix_x <= topMenu_x_exit_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_exit_limit_left<=pix_x) && (pix_x <= topMenu_x_exit_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_exit_limit_right-1<=pix_x) && (pix_x <= topMenu_x_exit_limit_right));

							end
			
			itemTextMenu4: begin
							show_item_selector[3] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_caps_limit_left<=pix_x) && (pix_x <= topMenu_x_caps_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_caps_limit_left<=pix_x) && (pix_x <= topMenu_x_caps_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_caps_limit_left<=pix_x) && (pix_x <= topMenu_x_caps_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_caps_limit_right-1<=pix_x) && (pix_x <= topMenu_x_caps_limit_right));

							end
			
			itemTextMenu5: begin
							show_item_selector[4] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_color_limit_left<=pix_x) && (pix_x <= topMenu_x_color_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_color_limit_left<=pix_x) && (pix_x <= topMenu_x_color_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_color_limit_left<=pix_x) && (pix_x <= topMenu_x_color_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_color_limit_right-1<=pix_x) && (pix_x <= topMenu_x_color_limit_right));

							end
			
			itemTextMenu6: begin
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
	
	
	always @ (*) begin
		
		currentItemMainMenu =item_selector[1:0];
	
		case(currentItemMainMenu) 
		
			itemMainMenu1: begin
							show_item_main_selector[0] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_left<=pix_x) && (pix_x <= topMenu_x_open_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_open_limit_right-1<=pix_x) && (pix_x <= topMenu_x_open_limit_right));
							end
			
			itemMainMenu2: begin
							show_item_main_selector[1] = ((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_top_limit+1) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_right)) ||
															((topMenu_y_item_bottom_limit-1<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_right)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_left<=pix_x) && (pix_x <= topMenu_x_save_limit_left+1)) ||
															((topMenu_y_item_top_limit<=pix_y) && (pix_y <= topMenu_y_item_bottom_limit) &&
															(topMenu_x_save_limit_right-1<=pix_x) && (pix_x <= topMenu_x_save_limit_right));

							end
			default: 	begin
							show_item_main_selector= 2'b00;			
							end
		endcase
	end

   //--------------------------------------------
   // rgb multiplexing circuit
   //--------------------------------------------
   always @* begin
	graph_rgb = 3'b111;
		if(window_selector) begin
			if (menu_mostrar_separador)
				graph_rgb = 3'b000;
			else if (show_item_selector[0] || show_item_selector[1] || show_item_selector[2] ||
         		show_item_selector[3] || show_item_selector[4] || show_item_selector[5])
					graph_rgb = 3'b110;
			else
				graph_rgb = 3'b111; // black background
		end 
		else if (!window_selector) begin
			if(menu_mostrar)
				graph_rgb=3'b000;
			else if(show_item_main_selector[0] || show_item_main_selector[1])
				graph_rgb =3'b111;
			else
				graph_rgb = 3'b111; // black background
		end
	end
	
	assign graph_on=((show_item_selector[0] || show_item_selector[1] || show_item_selector[2] ||
						   show_item_selector[3] || show_item_selector[4] || show_item_selector[5] || menu_mostrar_separador) && window_selector) ||
						((show_item_main_selector[0]||show_item_main_selector[1]) && !window_selector);

endmodule 
