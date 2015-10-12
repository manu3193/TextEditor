`timescale 1ns / 1ps


module Simulacion_Controlador_menu;

	// Inputs
	reg boton_arriba;
	reg boton_abajo;
	reg boton_izq;
	reg boton_der;
	reg boton_elige;

	// Outputs
	wire text_red;
	wire text_green;
	wire text_blue;
	wire char_scale;
	wire es_mayuscula;
	wire nuevo;
	wire guardar;
	wire cerrar;
	wire wf;
	wire wc;

	// Instantiate the Unit Under Test (UUT)
	Controlador_Menu_Editor uut (
		.boton_arriba(boton_arriba), 
		.boton_abajo(boton_abajo), 
		.boton_izq(boton_izq), 
		.boton_der(boton_der), 
		.boton_elige(boton_elige), 
		.text_red(text_red), 
		.text_green(text_green), 
		.text_blue(text_blue), 
		.char_scale(char_scale), 
		.es_mayuscula(es_mayuscula), 
		.nuevo(nuevo), 
		.guardar(guardar), 
		.cerrar(cerrar),
		.where_fila (wf),
		.where_columna (wc)
	);

	initial begin
		// Initialize Inputs
		boton_arriba = 0;
		boton_abajo = 0;
		boton_izq = 0;
		boton_der = 0;
		boton_elige = 0;

		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 1;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 0;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 1;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 0;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 1;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 0;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 1;
			boton_izq = 0;
			boton_der = 0;
			boton_elige = 0;
		
		#10;
			boton_arriba = 0;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 0;
			boton_elige = 0;

	end
      
endmodule

