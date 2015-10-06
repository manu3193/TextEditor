`timescale 1ns / 1ps

module Navegador_PushButtons(

	input clk_100Mhz,
	
	input boton_arriba_in, 
	input boton_abajo_in, 
	input boton_izq_in, 
	input boton_der_in,
	input boton_elige_in,
	
	output boton_arriba_out,
	output boton_abajo_out,
	output boton_izq_out,
	output boton_der_out,
	output boton_elige_out
   );  
	
	Button_Filter filt_boton_arriba (
		.clk (clk_100Mhz),
		.button_in (boton_arriba_in),
		.hold(),
		.filtered (boton_arriba_out)
	);
	
	Button_Filter filt_boton_abajo (
		.clk (clk_100Mhz),
		.button_in (boton_abajo_in),
		.hold(),
		.filtered (boton_abajo_out)
	);
	
	Button_Filter filt_boton_izq (
		.clk (clk_100Mhz),
		.button_in (boton_izq_in),
		.hold(),
		.filtered (boton_izq_out)
	);
	
	Button_Filter filt_boton_der (
		.clk (clk_100Mhz),
		.button_in (boton_der_in),
		.hold(),
		.filtered (boton_der_out)
	);
	
	Button_Filter filt_boton_elige (
		.clk (clk_100Mhz),
		.button_in (boton_elige_in),
		.hold(),
		.filtered (boton_elige_out)
	);

endmodule
