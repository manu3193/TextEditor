`timescale 1ns / 1ps

module text_editor_top(
		MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS, 	
		ClkPort,              									
		BtnC,														
		PS2KeyboardData,										
		PS2KeyboardClk,											
		vga_h_sync,												
		vga_v_sync,													
		vga_r,														
		vga_g,													
		vga_b,														
		boton_arriba_in,
		boton_abajo_in,
		boton_izq_in,
		boton_der_in,
		boton_elige_in,
		
		where_fila,
		where_columna,
		selector_menu
	  );
	  
	input boton_arriba_in,
			boton_abajo_in,
			boton_izq_in,
			boton_der_in,
			boton_elige_in;
			
	input selector_menu;
			
	wire boton_arriba,
			boton_abajo,
			boton_izq,
			boton_der,
			boton_elige;
			
	/************************************************************************
	 *                               INPUTS                                 *
	 ************************************************************************/
	input		ClkPort;	
	input		BtnC;
	
	/************************************************************************
	 *                           BIDIRECTIONALS                             *
	 ************************************************************************/
	inout		PS2KeyboardData, PS2KeyboardClk;
	
	
	/************************************************************************
	 *                               OUTPUTS                                *
	 ************************************************************************/
	output 	MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS;
	
	output 	vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;

	
	/************************************************************************
	 *                            LOCAL SIGNALS                             *
	 ************************************************************************/	
	wire			Reset, ClkPort;
	wire			board_clk, sys_clk, PS2_clk, VGA_clk, cursor_clk;
	wire [1:0] 	ssdscan_clk;
	reg  [26:0]	DIV_CLK;
	
	reg  [3:0]	SSD;
	wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	reg  [7:0]  SSD_CATHODES;
	
	wire [7:0]	KeyData;
	wire			KeyReleased;
	reg  [7:0]  CurrentKey;
	
	reg  [8:0]	document_pointer;
	reg  [8:0]  write_location;
	reg			write_to_RAM;
	wire [7:0]  RAM_data;
	wire [9:0]  read_address;
	
	reg vga_r, vga_g, vga_b;
	
	//assign { Ld7, Ld6, Ld5, Ld4, Ld3, Ld2, Ld1, Ld0	} = document_pointer[7:0];
	
	assign Reset = BtnC;
	
	// Disable the three memories so that they do not interfere with the rest of the design.
	assign {MemOE, MemWR, RamCS, FlashCS, QuadSpiFlashCS} = 5'b11111;
	
	
	/************************************************************************
	 *                            CLOCK DIVISION                            *
	 ************************************************************************/
	BUFGP BUFGP1 (board_clk, ClkPort); 	

	// Our clock is too fast (100MHz) for SSD scanning
	// create a series of slower "divided" clocks
	// each successive bit is 1/2 frequency
	always @(posedge board_clk, posedge Reset) begin							
		if (Reset)
			DIV_CLK <= 0;
		else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	 
	assign	sys_clk    = board_clk;		// 100 MHz
	assign	PS2_clk    = DIV_CLK[0];	//  50 MHz
	assign   VGA_clk    = DIV_CLK[1];	//  25 MHz
	assign   cursor_clk = DIV_CLK[26];	// .75  Hz
	 
	 
	/************************************************************************
	 *                             VGA Control                              *
	 ************************************************************************/	
	parameter RAM_size     = 10'd512;				// Size of the RAM
	parameter write_area   = RAM_size - 10'd2;	// Allowable write area in the RAM (last location used as a null location)
	parameter char_dim     = 10'd16;					// Dimension of a character (16x16 bits)
	parameter char_scale_i = 10'd2;					// Initial character scale
	parameter row_length_i = 10'd18;					// Initial length of a row (number of columns)
	parameter col_length_i = 10'd29;					// Initial length of a column (number of rows)
	
	wire text_red, text_green, text_blue;
	wire text_red_temp, text_green_temp, text_blue_temp;
	
	wire [9:0] char_scale;
	wire [9:0] char_scale_temp;
	
	wire es_mayuscula, nuevo, guardar, cerrar;
	wire es_mayuscula_temp;
	
	output wire [2:0] where_fila;
	output wire [2:0]where_columna;
	
	//reg [9:0] char_scale;
	reg [9:0] row_length;
	reg [9:0] col_length;
	reg [9:0] scroll;
	
	//reg text_red;
	//reg text_green;
	//reg text_blue;
	wire [2:0] textMenu_rgb, text_rgb;
	
	wire textMenu_graph_on, text_on;
	
	wire inDisplayArea;
	wire [9:0] CounterX;
	wire [9:0] CounterY;
	
	wire [9:0] CounterXDiv;
	wire [9:0] CounterYDiv; 
	assign CounterXDiv = CounterX / char_scale;
	assign CounterYDiv = CounterY / char_scale;
	
	wire shouldDraw;
	assign shouldDraw = CounterXDiv < char_dim * row_length && CounterYDiv < char_dim * col_length;
	
	wire [0:255] relativePixel;
	assign relativePixel = CounterXDiv % char_dim + CounterYDiv % char_dim * char_dim;
	
	wire drawCursor;
	assign drawCursor = read_address == document_pointer && Cursor[relativePixel] && cursor_clk;
	
	assign read_address = (CounterXDiv / char_dim + CounterYDiv / char_dim * row_length + scroll * row_length) < RAM_size - 1'b1 ? 
															(CounterXDiv / char_dim + CounterYDiv / char_dim * row_length + scroll * row_length) :
															RAM_size - 1'b1;
															
	/************************************************************************
	 *                             VGA Control MENU                         *
	 ************************************************************************/
	hvsync_generator vgaSyncGen(
		// Inputs
		.clk(VGA_clk),
		.reset(Reset),
		
		// Outputs
		.vga_h_sync(vga_h_sync),
		.vga_v_sync(vga_v_sync),
		.inDisplayArea(inDisplayArea),
		.CounterX(CounterX),
		.CounterY(CounterY)
	);
	
	//assign temp=1'b1;
	
	 // instantiate text module
   text_screen_gen text_unit(
		.clk(sys_clk),
		.pixel_x(CounterX), 
		.pixel_y(CounterY),
      .text_rgb(text_rgb), 
		.color_selector({text_blue_temp,text_green_temp,text_red_temp}),
		.size_selector(char_scale_temp),
		.caps_on(es_mayuscula_temp),
		.text_on(text_on), 
		.window_selector(selector_menu)
	);
   // instantiate graph module
   textMenu_graph graph_unit( 
		.clk(sys_clk), 
		.reset(Reset), 
		.item_selector(where_fila),
      .pix_x(CounterX), 
		.pix_y(CounterY),
      .graph_on(textMenu_graph_on), 
		.graph_rgb(textMenu_rgb), 
		.window_selector(selector_menu)
	);
	
	
	always @(posedge VGA_clk) begin
		if(inDisplayArea) begin
			if(text_on) begin
				vga_r<=text_rgb[0];
				vga_g<=text_rgb[1];
				vga_b<=text_rgb[2];
			end
			else if (textMenu_graph_on) begin
				vga_r<=textMenu_rgb[0];
				vga_g<=textMenu_rgb[1];
				vga_b<=textMenu_rgb[2];			
			end
			else begin
				vga_r <= Red;
				vga_g <= Green;
				vga_b <= Blue;
			end
		end
		else begin
			vga_r <= 1'b0;
			vga_g <= 1'b0;
			vga_b <= 1'b0;
		end
	end
	
	wire Red   = !(shouldDraw && ((~drawCursor && text_red   && toDraw[relativePixel]) || (drawCursor && !text_red) || (drawCursor && text_red && text_green && text_blue)));
	wire Blue  = !(shouldDraw && ((~drawCursor && text_blue  && toDraw[relativePixel]) || (drawCursor && !text_blue)));
	wire Green = !(shouldDraw && ((~drawCursor && text_green && toDraw[relativePixel]) || (drawCursor && !text_green)));
	
	wire [0:255] toDraw;
	assign toDraw = 	RAM_data == 8'h70 ? Block :
							RAM_data == 8'h49 ? Period :
							RAM_data == 8'h41 ? Comma :
							RAM_data == 8'h52 ? Apost :
							//mayusculas
							(RAM_data == 8'h1C && es_mayuscula)? A :
							(RAM_data == 8'h32 && es_mayuscula)? B :
							(RAM_data == 8'h21 && es_mayuscula)? C :
							(RAM_data == 8'h23 && es_mayuscula)? D :
							(RAM_data == 8'h24 && es_mayuscula)? E :
							(RAM_data == 8'h2B && es_mayuscula)? F :
							(RAM_data == 8'h34 && es_mayuscula)? G :
							(RAM_data == 8'h33 && es_mayuscula)? H :
							(RAM_data == 8'h43 && es_mayuscula)? I :
							(RAM_data == 8'h3B && es_mayuscula)? J :
							(RAM_data == 8'h42 && es_mayuscula)? K :
							(RAM_data == 8'h4B && es_mayuscula)? L :
							(RAM_data == 8'h3A && es_mayuscula)? M :
							(RAM_data == 8'h31 && es_mayuscula)? N :
							(RAM_data == 8'h44 && es_mayuscula)? O :
							(RAM_data == 8'h4D && es_mayuscula)? P :
							(RAM_data == 8'h15 && es_mayuscula)? Q :
							(RAM_data == 8'h2D && es_mayuscula)? R :
							(RAM_data == 8'h1B && es_mayuscula)? S :
							(RAM_data == 8'h2C && es_mayuscula)? T :
							(RAM_data == 8'h3C && es_mayuscula)? U :
							(RAM_data == 8'h2A && es_mayuscula)? V :
							(RAM_data == 8'h1D && es_mayuscula)? W :
							(RAM_data == 8'h22 && es_mayuscula)? X :
							(RAM_data == 8'h35 && es_mayuscula)? Y :
							(RAM_data == 8'h1A && es_mayuscula)? Z :
							//minusculas
							(RAM_data == 8'h1C && !es_mayuscula)? a :
							(RAM_data == 8'h32 && !es_mayuscula)? b :
							(RAM_data == 8'h21 && !es_mayuscula)? c :
							(RAM_data == 8'h23 && !es_mayuscula)? d :
							(RAM_data == 8'h24 && !es_mayuscula)? e :
							(RAM_data == 8'h2B && !es_mayuscula)? f :
							(RAM_data == 8'h34 && !es_mayuscula)? g :
							(RAM_data == 8'h33 && !es_mayuscula)? h :
							(RAM_data == 8'h43 && !es_mayuscula)? i :
							(RAM_data == 8'h3B && !es_mayuscula)? j :
							(RAM_data == 8'h42 && !es_mayuscula)? k :
							(RAM_data == 8'h4B && !es_mayuscula)? l :
							(RAM_data == 8'h3A && !es_mayuscula)? m :
							(RAM_data == 8'h31 && !es_mayuscula)? n :
							(RAM_data == 8'h44 && !es_mayuscula)? o :
							(RAM_data == 8'h4D && !es_mayuscula)? p :
							(RAM_data == 8'h15 && !es_mayuscula)? q :
							(RAM_data == 8'h2D && !es_mayuscula)? r :
							(RAM_data == 8'h1B && !es_mayuscula)? s :
							(RAM_data == 8'h2C && !es_mayuscula)? t :
							(RAM_data == 8'h3C && !es_mayuscula)? u :
							(RAM_data == 8'h2A && !es_mayuscula)? v :
							(RAM_data == 8'h1D && !es_mayuscula)? w :
							(RAM_data == 8'h22 && !es_mayuscula)? x :
							(RAM_data == 8'h35 && !es_mayuscula)? y :
							(RAM_data == 8'h1A && !es_mayuscula)? z :
							//numeros
							RAM_data == 8'h16 ? num1 :
							RAM_data == 8'h1E ? num2 :
							RAM_data == 8'h26 ? num3 :
							RAM_data == 8'h25 ? num4 :
							RAM_data == 8'h2E ? num5 :
							RAM_data == 8'h36 ? num6 :
							RAM_data == 8'h3D ? num7 :
							RAM_data == 8'h3E ? num8 :
							RAM_data == 8'h46 ? num9 :
							RAM_data == 8'h45 ? num0 :
							256'd0;
	
	parameter [0:255] Cursor = 256'hC000C000C000C000C000C000C000C000C000C000C000C000C000C000C000C000;
	parameter [0:255] Block  = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
	parameter [0:255] Period = 256'h0000000000000000000000000000000000000000000000000000E000E000E000;
	parameter [0:255] Comma  = 256'h000000000000000000000000000000000000000000000000000070007000E000;
	parameter [0:255] Apost  = 256'h070007000E000000000000000000000000000000000000000000000000000000;
	parameter [0:255] ExlPnt = 256'hF000F000F000F000F000F000F000F000F000F000F00000000000F000F000F000;
	parameter [0:255] A      = 256'h00001FE03870387070387038E01CE01CE01CFFFCFFFCE01CE01CE01CE01CE01C;
	parameter [0:255] B      = 256'h0000FFC0FFF0F078F03CF03CF038FFE0FFE0F038F03CF03CF03CF07CFFF8FFE0;
	parameter [0:255] C      = 256'h00001FF07FFCF81EF01EE000E000E000E000E000E000E000E01EF01E7FFC1FF0;
	parameter [0:255] D      = 256'h0000FFE0FFF8F03CF01CF00EF00EF00EF00EF00EF00EF00EF01CF03CFFF8FFE0;
	parameter [0:255] E      = 256'h0000FFFEFFFEE000E000E000E000FFFEFFFEE000E000E000E000E000FFFEFFFE;
	parameter [0:255] F      = 256'h0000FFFEFFFEF000F000F000F000FFFEFFFEF000F000F000F000F000F000F000;
	parameter [0:255] G      = 256'h00003FF07FF8F01EE00EC000C000C000C000C07EC07EC00EC00EF01E7FF83FF0;
	parameter [0:255] H      = 256'h0000E00EE00EE00EE00EE00EE00EFFFEFFFEE00EE00EE00EE00EE00EE00EE00E;
	parameter [0:255] I      = 256'h0000FFFCFFFC07800780078007800780078007800780078007800780FFFCFFFC;
	parameter [0:255] J      = 256'h00003FFC3FFC001C001C001C001C001C001C001CE01CE01CE01CF03C7FF83FF0;
	parameter [0:255] K      = 256'h0000E00EE00EE01CE038E070E0E0FFC0FFC0E0E0E070E038E01CE00EE00EE00E;
	parameter [0:255] L      = 256'h0000E000E000E000E000E000E000E000E000E000E000E000E000E000FFFCFFFC;
	parameter [0:255] M      = 256'h0000F87CFCFCFCFCECDCEFDCE79CE31CE01CE01CE01CE01CE01CE01CE01CE01C;
	parameter [0:255] N      = 256'h0000F81CF81CEC1CEC1CE61CE61CE31CE31CE31CE19CE19CE0DCE0DCE07CE07C;
	parameter [0:255] O      = 256'h00003FF07878E01CE01CE01CE01CE01CE01CE01CE01CE01CE01CF03C78783FF0;
	parameter [0:255] P      = 256'h0000FFC0FFF8F07CF03CF03CF03CF07CFFF8FFC0F000F000F000F000F000F000;
	parameter [0:255] Q      = 256'h00003FF07878E01CE01CE01CE01CE01CE01CE01CE01CE01CE01CF03C787C0FDE;
	parameter [0:255] R      = 256'h0000FFF0FFFCF01EF01EF01EF01EFFF0FFC0F0F0F078F03CF03CF01EF01EF01E;
	parameter [0:255] S      = 256'h00000FF03FFCE01EE00EE00EF0007FF01FFC001EE00EE00EF00E781E3FFC07F8;
	parameter [0:255] T      = 256'h0000FFFEFFFE0380038003800380038003800380038003800380038003800380;
	parameter [0:255] U      = 256'h0000E00EE00EE00EE00EE00EE00EE00EE00EE00EE00EE00EE00EE00E783C1FF0;
	parameter [0:255] V      = 256'h0000E00EF01EF01E783C783C3C783C783C781EF01EF00FE00FE007C003800100;
	parameter [0:255] W      = 256'h0000E01CE01CE01CE01CE01CE01CE01CE01CE31CE79CEFDCECDCFCFCFCFCF87C;
	parameter [0:255] X      = 256'h0000F01EF01E78783CF03CF01FE00FC007800FC01FE03CF03CF07878F03CF03C;
	parameter [0:255] Y      = 256'h0000E00EE00E701C781C3C780FE007C003800380038003800380038003800380;
	parameter [0:255] Z      = 256'h0000FFFEFFFE001E003C007800F001E003C00F001E003C007800F000FFFEFFFE;
	
	parameter [0:255] num1   = 256'h0000003C00FC01DC039C071C001C001C001C001C001C001C001C001C001C001C;
	parameter [0:255] num2   = 256'h00000FF01FF8381C001C001C001C0038007000E001C0038007001C003FFC3FFC;
	parameter [0:255] num3   = 256'h00003FFC3FFC000C00180060018003C000E0003000380038003800383FF03FC0;
	parameter [0:255] num4   = 256'h0000007C00DC019C031C061C0C1C181C301C3FFC001C001C001C001C001C001C;
	parameter [0:255] num5   = 256'h00003FFC3FFC3000300030003FC001E00070003000380038007000E03FC03F00;
	parameter [0:255] num6   = 256'h000000E003800E0018003800380038003FE03FF03C18381838181C181FF00FE0;
	parameter [0:255] num7   = 256'h00003FFC3FFC000C000C000C00180030006000C00180030006000C0018003000;
	parameter [0:255] num8   = 256'h00001FF83FFC381C381C381C3FFC3FFC381C381C381C381C381C381C3FFC1FF8;
	parameter [0:255] num9   = 256'h00001FFC3FFC381C300C300C381C1FFC0FFC000C000C000C000C000C007C007C;
	parameter [0:255] num0   = 256'h00001FF83FFC381C381C381C381C381C381C381C381C381C381C381C3FFC1FF8;
	//minusculas
	parameter [0:255] a      = 256'h00000000000000000000000007F007F80018000C03FC0FFC0C0C0C0C0FFC07FC;
	parameter [0:255] b      = 256'h0000E000E000E000E000E000FFF8FFFCE01CE01CE01CE01CE01CE01CFFFCFFFC;
	parameter [0:255] c      = 256'h000000000000000000001FF07FFCF81EF01EE000E000E000E01EF01E7FFC1FF0;
	parameter [0:255] d      = 256'h0000000E000E000E000E000E000E1FFE7FFE781E700E700E701E383E1FFE0FCE;
	parameter [0:255] e      = 256'h000000000000000000001FF03FF8701CE01CE01CFFFCFFFCE000E0007FFC3FFC;
	parameter [0:255] f      = 256'h0000000000003FFE7FFE7000F000F000F000FFFEFFFEF000F000F000F000F000;
	parameter [0:255] g      = 256'h00000000000007E00FF01818380C300C300C1C0C0FFC001C001C381C1FFC0FF8;
	parameter [0:255] h      = 256'h0000E000E000E000E000E000E000FFFEFFFEE00EE00EE00EE00EE00EE00EE00E;
	parameter [0:255] i      = 256'h0000000000000000078007800780000000000780078007800780078007800780;
	parameter [0:255] j      = 256'h000000000000001C001C001C00000000001C001CE01CE01CE01CF03C7FF83FF0;
	parameter [0:255] k      = 256'h0000000000000000E00EE00EE01CE038E070E0E0FFC0FFE0E070E070E070E070;
	parameter [0:255] l      = 256'h0000038003800380038003800380038003800380038003800380038003800380;
	parameter [0:255] m      = 256'h00000000000000000000000000000000FCFCFCDCEFDCE79CE31CE01CE01CE01C;
	parameter [0:255] n      = 256'h00000000000000000000000000000000E7F8FFFCF01CE01CE01CE01CE01CE01C;
	parameter [0:255] o      = 256'h00000000000000000000000000003FF07878E01CE01CE01CE01CF03C78783FF0;
	parameter [0:255] p      = 256'h0000000000000000FFC0FFF8F07CF03CF03CF03CF07CFFF8FFC0F000F000F000;
	parameter [0:255] q      = 256'h000000000000000003FF1FFF3E0F3C0F3C0F3C0F3E0F1FFF03FF000F000F000F;
	parameter [0:255] r      = 256'h0000000000000000000000000000F3FCF7FCFE00FC00F800F000F000F000F000;
	parameter [0:255] s      = 256'h0000000000000000000000000FF03FFCE01EF0007FF01FFC000E781E3FFC07F8;
	parameter [0:255] t      = 256'h00000380038003800380FFFEFFFE038003800380038003800380038003800380;
	parameter [0:255] u      = 256'h00000000000000000000000000000000E00EE00EE00EE00EE00EE00E783C1FF0;
	parameter [0:255] v      = 256'h0000000000000000000000003C783C783C781EF01EF00FE00FE007C003800100;
	parameter [0:255] w      = 256'h0000000000000000000000000000E01CE01CE31CE79CEFDCECDCFCFCFCFCF87C;
	parameter [0:255] x      = 256'h00000000000000000000000000003CF03CF01FE00FC007800FC01FE03CF03CF0;
	parameter [0:255] y      = 256'h000000000000000000000000E00F701E781C3C780FE007C007800F001E003C00;
	parameter [0:255] z      = 256'h000000000000000000000000FFFEFFFE001E007801E007801E007800FFFEFFFE;
	
	/************************************************************************
	 *                             PS2 KEYBOARD                             *
	 ************************************************************************/	
	text_editor_keyboard_controller KeyBoard(
		// Inputs
		.sys_Clk(sys_clk),
		.PS2_Clk(PS2_clk),
		.Reset(Reset),
	 
		// Bidirectionals
		.PS2KeyboardData(PS2KeyboardData),
		.PS2KeyboardClk(PS2KeyboardClk),
	 
		// Outputs
		.KeyData(KeyData),
		.KeyReleased(KeyReleased)
    );
	 
	 
	/************************************************************************
	 *                            TEXT RAM                                  *
	 ************************************************************************/
	 text_editor_RAM RAM(
		// Inputs
		.clk(sys_clk),
		.Reset(Reset),
		.write(write_to_RAM),
		.write_address(write_location),
		.write_data(CurrentKey),
		.read_address(read_address[8:0]),
	 
		// Outputs
		.read_data(RAM_data)
	 );
	 
	 /************************************************************************
	 *                           PUSHBUTTONS                                 *
	 ************************************************************************/
	 	 
	 Controlador_Menu_Editor(
		.clk (sys_clk), 
		.reset (Reset),
		.boton_arriba_in(boton_arriba_in),
		.boton_abajo_in(boton_abajo_in),
		.boton_izq_in(boton_izq_in),
		.boton_der_in(boton_der_in),
		.boton_elige_in(boton_elige_in),
		
		.text_red(text_red),
		.text_green(text_green),
		.text_blue(text_blue),
		.char_scale(char_scale),
		.es_mayuscula(es_mayuscula),
		
		.text_red_temp(text_red_temp),
		.text_green_temp(text_green_temp),
		.text_blue_temp(text_blue_temp),
		.char_scale_temp(char_scale_temp),
		.es_mayuscula_temp(es_mayuscula_temp),
		
		.nuevo(nuevo),
		.guardar(guardar),
		.cerrar(cerrar),
		
		.where_fila(where_fila),
		.where_columna(where_columna)
   );
	 
	
	/************************************************************************
	 *                          STATE MACHINE                               *
	 ************************************************************************/	
	reg  [1:0]  state;		
	localparam 	
		INI    = 2'b00,
		GETKEY = 2'b01,
		EDIT   = 2'b10,
		WRITE  = 2'b11,
		UNK    = 2'bXX;
	
	always @ (posedge sys_clk, posedge Reset) begin: STATE_MACHINE
		if (Reset || !selector_menu || nuevo ) begin
			CurrentKey <= 8'hXX;
			document_pointer <= 9'bXXXXXXXXX;
			write_location <= 9'bXXXXXXXXX;
			write_to_RAM <= 1'bX;
			//char_scale <= 10'bXXXXXXXXXX;
			row_length <= 10'bXXXXXXXXXX;
			col_length <= 10'bXXXXXXXXXX;
			scroll <= 10'bXXXXXXXXXX;
			//text_red <= 1'bX;
			//text_green <= 1'bX;
			//text_blue <= 1'bX;
			
			state <= INI;
		end else begin			
			case (state)
				INI: begin
					state <= GETKEY;
					
					CurrentKey <= 8'h29; // SPACE
					write_to_RAM <= 1'b0;
					document_pointer <= 10'd0;
					write_location <= 10'd0;
					//char_scale <= char_scale_i;
					row_length <= row_length_i;
					col_length <= col_length_i;
					scroll <= 10'd0;
					//text_red <= 1'b0;
					//text_green <= 1'b1;
					//text_blue <= 1'b0;
				end
				
				GETKEY: begin
					if (KeyReleased) begin
						state <= EDIT;
					end
					
					CurrentKey <= KeyData;
					
					case(char_scale)
						2'd1: begin row_length <= 10'd36; col_length <= 10'd15; end
						2'd2: begin row_length <= 10'd18; col_length <= 10'd29; end
						2'd3: begin row_length <= 10'd12; col_length <= 10'd43; end
						default: begin row_length <= 10'd18; col_length <= 10'd29; end
					endcase
				end
				
				EDIT: begin
					state <= WRITE;
					write_to_RAM <= 1'b1;
					write_location <= document_pointer;
					
					case (CurrentKey)
						8'h66: begin // BACKSPACE
							if (document_pointer > 10'd0) begin
								document_pointer <= document_pointer - 1'b1;
								write_location <= document_pointer - 1'b1;
							end
							
							CurrentKey <= 8'h29; // SPACE
						end
						
						8'h6B: begin // LEFT ARROW
							write_to_RAM <= 1'b0;
							if (document_pointer > 10'd0) begin
								document_pointer <= document_pointer - 1'b1;
							end
						end
						
						8'h74: begin // RIGHT ARROW
							write_to_RAM <= 1'b0;
							if (document_pointer < write_area) begin
								document_pointer <= document_pointer + 1'b1;
							end
						end
						
						8'h75: begin // UP ARROW
							write_to_RAM <= 1'b0;
							if (document_pointer >= row_length) begin
								document_pointer <= document_pointer - row_length;
							end
						end
						
						8'h72: begin // DOWN ARROW
							write_to_RAM <= 1'b0;
							if (document_pointer <= write_area - row_length) begin
								document_pointer <= document_pointer + row_length;
							end
						end
						//------------cambia tamanio de letra----------------------
						/*
						8'h79: begin // + KEYPAD
							write_to_RAM <= 1'b0;
							if (char_scale < 10'd3) begin
								char_scale <= char_scale + 1'b1;
							end
						end
						
						8'h7B: begin // - KEYPAD
							write_to_RAM <= 1'b0;
							if (char_scale > 10'd1) begin
								char_scale <= char_scale - 1'b1;
							end
						end
						*/
						//--------------------------------------------------------
						8'h7D: begin // PG UP
							write_to_RAM <= 1'b0;
							if (scroll < col_length - 2'd2) begin
								scroll <= scroll + 1'b1;
							end
						end
						
						8'h7A: begin // PG DOWN
							write_to_RAM <= 1'b0;
							if (scroll > 10'd0) begin
								scroll <= scroll - 1'b1;
							end
						end
						//------------------------cambia color de la letra------------------------------
						/*
						8'h05: begin // F1 (Red color)
							write_to_RAM <= 1'b0;
							text_red <= ~text_red;
							if (text_red && !text_blue) begin
								text_green <= 1'b1;
							end
						end
						
						8'h06: begin // F2 (Green color)
							write_to_RAM <= 1'b0;
							text_green <= ~text_green;
							if (text_green && !text_blue && !text_red) begin
								text_green <= 1'b1;
							end
						end
						
						8'h04: begin // F3 (Blue color)
							write_to_RAM <= 1'b0;
							text_blue <= ~text_blue;
							if (text_blue && !text_red) begin
								text_green <= 1'b1;
							end
						end
						*/
						//----------------------------------------------------------------------------
						8'h71: begin // DELETE KEY						
							CurrentKey <= 8'h29; // SPACE
						end
						
						default: begin
							if (document_pointer < write_area) begin
								document_pointer <= document_pointer + 1'b1;
							end
						end
					endcase
				end
				
				WRITE: begin
					state <= GETKEY;
					write_to_RAM <= 1'b0;
				end
				
				default: begin
					state <= UNK;
				end
			endcase
		end
	
	end
	
	
	//-------------------------MENU EDITOR TEXTO---------------------------------------
	
	//---------------------------------------------------------------------------------

endmodule
