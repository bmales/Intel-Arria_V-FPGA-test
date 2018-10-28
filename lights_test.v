`timescale 1ns / 1ps
module lights_test;

	// Inputs
	reg clk;
	reg start;

	// Outputs
	wire [2:0] main_road_lights;
	wire [2:0] side_road_lights;

	// Instantiate the Unit Under Test (UUT)
	traffic_light uut (
		.main_road_lights(main_road_lights), 
		.side_road_lights(side_road_lights), 
		.clk(clk), 
		.start(start)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		start = 1;
		#40 start = 0;	//start traffic lights
		#1 start = 1;	
		// Wait 100 ns for global reset to finish
		#500 $stop;
	end
	always #4 clk=~clk;
      
endmodule

