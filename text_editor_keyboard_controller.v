`timescale 1ns / 1ps

module text_editor_keyboard_controller(
    input sys_Clk,
	 input PS2_Clk,
    input Reset,
    inout PS2KeyboardData,
    inout PS2KeyboardClk,
    output reg [7:0] KeyData,
    output reg KeyReleased
    );	
	 
	
	/************************************************************************
	 *                            LOCAL SIGNALS                             *
	 ************************************************************************/
	reg  [1:0]  state;		
	localparam 	
		I    = 2'b00,
		BAT  = 2'b01,
		DATA = 2'b10,
		UNK  = 2'bXX;
	
	wire [7:0]	received_data;
	wire			received_data_en;
	reg  [7:0]  previous_word;
	
	reg         send_command;
	reg  [7:0]  the_command;
	wire        command_sent;
	
	
	/************************************************************************
	 *                             PS2 KEYBOARD                             *
	 ************************************************************************/	
	PS2_Controller PS2_Keyboard_Controller(
		// Inputs
		.CLOCK_50(PS2_Clk),
		.reset(Reset),
		.the_command(the_command),
		.send_command(send_command),

		// Bidirectionals
		.PS2_CLK(PS2KeyboardClk),				// PS2 Clock
		.PS2_DAT(PS2KeyboardData),				// PS2 Data

		// Outputs
		.command_was_sent(command_sent),
		.error_communication_timed_out( ),
		.received_data(received_data),
		.received_data_en(received_data_en)	// If 1 - new data has been received
	);
	
	/************************************************************************
	 *                          STATE MACHINE                               *
	 ************************************************************************/	
	always @ (posedge sys_Clk, posedge Reset) begin: STATE_MACHINE
		if(Reset) begin
				state <= I;
				previous_word <= 8'hXX;
				send_command <= 1'bX;
				the_command <= 8'hXX;
				KeyData <= 8'hXX;
		end else
			case(state)	
					I: begin
						state <= BAT;
						
						KeyData <= 8'h00;
						previous_word <= 8'h00;
						KeyReleased <= 1'b0;
						send_command <= 1'b1;
						the_command <= 8'hFF;	// RESET KEYBOARD
					end
					
					BAT: begin
						if (command_sent) begin
							send_command <= 1'b0;
						end
						case (received_data)
							8'hAA: begin			// SUCCESSFUL POST
								state <= DATA;
							end
							
							8'hFC: begin
								send_command <= 1'b1;	// TRY TO POST AGAIN
							end
							
							default: begin
								
							end
						endcase
					end
					
					DATA: begin
						if (command_sent) begin
							send_command <= 1'b0;
						end
						
						if (KeyReleased) begin
							KeyReleased <= 1'b0;
						end
						
						if (received_data_en) begin
							previous_word <= received_data;
							
							case(received_data)
								8'hF0: begin
									// Key Released
								end
								
								8'hFA: begin
									// Acknowledge
								end
								
								8'hAA: begin
									// Self Test Passed
								end
								
								8'hEE: begin
									// Echo Response
								end
								
								8'hFE: begin
									// Resend Request
								end
								
								8'h00: begin
									// Error
								end
								
								8'hFF: begin
									// Error
								end
								
								8'h12: begin
									// Shift
								end
								
								8'h59: begin
									// Shift
								end
								
								8'h58: begin
									// Caps
								end
								
								8'h0D: begin
									// Tab
								end
								
								8'h14: begin
									// Ctrl
								end
								
								8'h11: begin
									// Alt
								end
								
								8'hE0: begin
									// Extra
								end
								
								8'h5A: begin
									// Enter
								end
								
								default: begin
									if (previous_word == 8'hF0) begin // IF PREV WORD WAS KEY RELEASED SCAN CODE
										KeyData <= received_data;
										KeyReleased <= 1'b1;
									end
								end
							endcase
						end
					end
					
					default:
						state <= UNK;
			endcase
	end
endmodule

