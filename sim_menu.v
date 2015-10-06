`timescale 1ns / 1ps


module sim_menu;

	// Inputs
	reg clk;
	reg reset;
	reg boton_arriba;
	reg boton_abajo;
	reg boton_izq;
	reg boton_der;
	reg boton_elige;

	// Outputs
	wire text_red;
	wire text_green;
	wire text_blue;
	wire [9:0] char_scale;
	wire es_mayuscula;
	wire nuevo;
	wire guardar;
	wire cerrar;
	wire [2:0] where_fila;
	wire [2:0] where_columna;

	// Instantiate the Unit Under Test (UUT)
	Controlador_Menu_Editor uut (
		.clk(clk), 
		.reset(reset), 
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
		.where_fila(where_fila), 
		.where_columna(where_columna)
	);
	always 
		#10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
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
		
		#10;
			boton_arriba = 1;
			boton_abajo = 0;
			boton_izq = 0;
			boton_der = 0;
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

