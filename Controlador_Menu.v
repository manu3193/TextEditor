`timescale 1ns / 1ps

module Controlador_Menu_Editor(
	
	clk, 
	reset,
	
	boton_arriba_in,
	boton_abajo_in,
	boton_izq_in,
	boton_der_in,
	boton_elige_in,
	//boton_arriba, boton_abajo, boton_izq, boton_der, boton_elige,
	
	text_red,
	text_green,
	text_blue,
	char_scale,
	es_mayuscula,
	
	nuevo,
	guardar,
	cerrar,
	
	where_fila,
	where_columna
   );
	
	input clk, reset;
	input boton_arriba_in, boton_abajo_in, boton_izq_in, boton_der_in, boton_elige_in;
	//input boton_arriba, boton_abajo, boton_izq, boton_der, boton_elige;
	
	wire boton_arriba, boton_abajo, boton_izq, boton_der, boton_elige;
	
	Navegador_PushButtons nav_pb(
		.clk_100Mhz (clk),
		
		.boton_arriba_in (boton_arriba_in), 
		.boton_abajo_in (boton_abajo_in), 
		.boton_izq_in (boton_izq_in), 
		.boton_der_in (boton_der_in),
		.boton_elige_in (boton_elige_in),
		
		.boton_arriba_out (boton_arriba),
		.boton_abajo_out (boton_abajo),
		.boton_izq_out (boton_izq),
		.boton_der_out (boton_der),
		.boton_elige_out (boton_elige)
	);
	
	output reg [2:0] where_fila; 
	output reg [2:0] where_columna;
	output reg [9:0] char_scale;	
	output reg text_red, text_green, text_blue, es_mayuscula;
	output reg nuevo, guardar, cerrar;

	initial begin
		where_fila <= 1;
		where_columna <= 1;
		
		char_scale <= 10'd2;
		text_red <= 1'b0;
		text_green <= 1'b0;
		text_blue <= 1'b1;
		es_mayuscula <= 1'b1;
		nuevo <= 1'b0;
		guardar <= 1'b0;
		cerrar <= 1'b0;
	end
	
	wire temp_clk;
	assign temp_clk = (boton_abajo || boton_izq || boton_arriba  || boton_der || boton_elige);
	
	reg [2:0] estado, sigEstado;
	
	parameter inicio = 0;
	parameter aumenta_fila = 1;
	parameter disminuye_fila = 2;
	parameter aumenta_columna = 3;
	parameter disminuye_columna = 4;
	parameter elige = 5;
	
	always @(posedge clk or posedge reset) begin
		if (reset) 
			estado <= inicio;
		else
			estado <= sigEstado;
	end
	
	always @(posedge temp_clk) begin
		case (estado)
			inicio:
				begin
				if (boton_arriba)
					sigEstado = disminuye_columna;
				else if (boton_abajo)
					sigEstado = aumenta_columna;
				else if (boton_izq)
					sigEstado = disminuye_fila;
				else if (boton_der)
					sigEstado = aumenta_fila;
				else if (boton_elige)
					sigEstado = elige;
				else 	
					sigEstado = inicio;
				end
				
			aumenta_fila:
				begin
					where_columna = 1;
					where_fila = (where_fila < 6)? where_fila + 1 : where_fila;
					sigEstado = inicio;
				end
				
			disminuye_fila:
				begin
					where_columna = 1;
					where_fila = (where_fila > 1)? where_fila - 1 : where_fila;
					sigEstado = inicio;
				end
				
			aumenta_columna:
				begin
					case (where_fila)
						4:
							where_columna = (where_columna < 2)?  where_columna + 1: where_columna;
						5:
							where_columna = (where_columna < 6)?  where_columna + 1: where_columna;
						6:
							where_columna = (where_columna < 3)?  where_columna + 1: where_columna;
					endcase
					sigEstado = inicio;
				end
				
			disminuye_columna:
				begin
					where_columna = (where_columna > 1)? where_columna - 1 : where_columna;
					sigEstado = inicio;
				end
			
			elige:
				begin
					case (where_fila)
						1:
							nuevo = 1;
						2:
							guardar = 1;
						3:
							cerrar = 1;
						4:
							begin
							case (where_columna)
								1:
									es_mayuscula = 1;
								2:
									es_mayuscula = 0;
							endcase
							end
						5:
							begin
							case (where_columna)
								1: 
									begin
									text_red = 0;
									text_green = 0;
									text_blue = 1;
									end
								2:
									begin
									text_red = 0;
									text_green = 1;
									text_blue = 0;
									end
								3:
									begin
									text_red = 0;
									text_green = 1;
									text_blue = 1;
									end
								4:
									begin
									text_red = 1;
									text_green = 0;
									text_blue = 0;
									end
								5:
									begin
									text_red = 1;
									text_green = 0;
									text_blue = 1;
									end
								6:
									begin
									text_red = 1;
									text_green = 1;
									text_blue = 0;
									end
							endcase
							end
						6:
							begin
							case (where_columna)
								1:
									char_scale = 10'd1;
								2:
									char_scale = 10'd2;
								3: 
									char_scale = 10'd3;
							endcase
							end
					endcase
					sigEstado = inicio;
				end
			
			default: sigEstado = inicio;
		endcase
	end
		
endmodule
