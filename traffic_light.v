/*
 When start is in low state, traffic lights are off (yellow blinking).
 If start is in high state, traffic lights are working normally.											  
*/

module traffic_light(main_road_lights,side_road_lights,clk,start);
	
	parameter[3:0] greenRed_delay = 15, //delay for every light pair
						yellowRed_delay = 4,
						redRed_delay = 2,
						redRedYellow_delay = 2;
						
	parameter [3:0] mainGreen_sideRed = 4'b0000, //states
						 mainYellow_sideRed = 4'b0001,
						 mainRed_sideRed_first = 4'b0010,
						 mainRed_sideRedYellow = 4'b0011,
						 mainRed_sideGreen = 4'b0100,
						 mainRed_sideYellow = 4'b0101,
						 mainRed_sideRed_second = 4'b0110,
						 mainRedYellow_sideRed = 4'b0111,
						 use_traffic_signs = 4'b1000; //blinking yellow on both lights
	 
	output reg[2:0] main_road_lights ,side_road_lights; //output to LED for main and side road 
	input clk,start; //clock from board 
	reg[5:0] counter = 1'b0; //timing counter
	reg blink =1'b1;
	reg[3:0] state = mainGreen_sideRed; //reg to store current state 
	reg turn_off = 1'b0;
	
	always @ (posedge clk or negedge start) begin
		if (start == 1'b0)
			turn_off = 1'b1;
	end
	
	always @ (posedge clk or negedge start) 
	begin
	if (turn_off)
		state = use_traffic_signs;
	else begin 
			case (state)
				mainGreen_sideRed:
				begin
					if(counter < greenRed_delay) begin
						state <= mainGreen_sideRed;
						counter <= counter + 1'b1;
					end
					else begin
						counter = 1'b0;
						state = mainYellow_sideRed;
					end
				end
				
				mainYellow_sideRed: 
					if(counter < yellowRed_delay) begin
						state <= mainYellow_sideRed;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainRed_sideRed_first;
						counter <= 1'b0;
					end
					
				mainRed_sideRed_first:
					if(counter < redRed_delay) begin
						state <= mainRed_sideRed_first;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainRed_sideRedYellow;
						counter <= 1'b0;
					end
					
				mainRed_sideRedYellow:
					if(counter < redRedYellow_delay) begin
						state <= mainRed_sideRedYellow;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainRed_sideGreen;
						counter <= 1'b0;
					end
				mainRed_sideGreen:
					if(counter < greenRed_delay) begin
						state <= mainRed_sideGreen;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainRed_sideYellow;
						counter <= 1'b0;
					end
				mainRed_sideYellow:
					if(counter < yellowRed_delay) begin
						state <= mainRed_sideYellow;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainRed_sideRed_second;
						counter <= 1'b0;
					end
				mainRed_sideRed_second:
					if(counter < redRed_delay) begin
						state <= mainRed_sideRed_second;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainRedYellow_sideRed;
						counter <= 1'b0;
					end
				mainRedYellow_sideRed:
					if(counter < redRedYellow_delay) begin
						state <= mainRedYellow_sideRed;
						counter <= counter + 1'b1;
					end
					else begin
						state <= mainGreen_sideRed;
						counter <= 1'b0;
					end
			endcase 
		end
	end

	always @(posedge clk) //block for changing lights
		begin
			case(state)
			mainGreen_sideRed: 
			begin 
				main_road_lights = 3'b110; //green
				side_road_lights = 3'b011; //red
			end
			mainYellow_sideRed: 
			begin 
				main_road_lights = 3'b101; //yellow
				side_road_lights = 3'b011; //red
			end 
			mainRed_sideRed_first: 
			begin 
				main_road_lights = 3'b011; //red
				side_road_lights = 3'b011; //red
			end 
			mainRed_sideRedYellow: 
			begin 
				main_road_lights = 3'b011; //red
				side_road_lights = 3'b001; //both red and yellow
			end 
			mainRed_sideGreen: 
			begin 
				main_road_lights = 3'b011; //red
				side_road_lights = 3'b110; //green
			end 
			mainRed_sideYellow: 
			begin 
				main_road_lights = 3'b011; //red
				side_road_lights = 3'b101; //yellow
			end 
			mainRed_sideRed_second: 
			begin 
				main_road_lights = 3'b011; //red
				side_road_lights = 3'b011; //red
			end 
			mainRedYellow_sideRed: 
			begin 
				main_road_lights = 3'b001; //both red and yellow
				side_road_lights = 3'b011; //red
			end
			use_traffic_signs: 
			begin
				blink = ~ blink;
				main_road_lights = {1'b1,blink,1'b1}; //blinking yellow
				side_road_lights = {1'b1,blink,1'b1};
			end
			endcase
		end
endmodule
