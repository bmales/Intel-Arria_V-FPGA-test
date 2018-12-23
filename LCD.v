module LCD(clk, data,rs,rw,enb);
	//inputs
	input clk;
	//input clock with 50ms delay
	//outputs
	output reg[7:0] data;
	output reg rs;
	output reg rw;
	output reg enb=0;
	//internal registers
	reg[3:0] state = 4'b0000;
	reg[3:0] print = 4'b0000;
	reg[25:0] del_counter = 26'd0;
	reg[25:0] en_counter = 26'd0;
	reg[4:0] i = 0;
	reg end_print = 0;
	reg cmd_data= 0;
	////////////////These State are For LCD Commands////////////////
	always @ (posedge clk) begin
		enb = 1'b0; //Logic is Sending High(1) then uses clocks Delay then Low(0) of Next state..
		case(state)
			4'b0000:begin
			//wait for 30ms until Vdd raises to 2.7 V
				del_counter = del_counter + 1;
					if(del_counter > 2200000) begin
					state = 4'b0001;
					del_counter = 26'd0;
				end
			end
			4'b0001:begin    //wait 40ms until Vdd raises to 4.5V ,after that use LCD Command 0X38(00111000)
				del_counter = del_counter + 1;
				if(del_counter > 1800000) begin
					rs=1'b0;
					rw=1'b0;
					data=8'b00111000;
					enb = 1'b1;
					state = 4'b0010;
					del_counter = 26'd0;
				end
			end      
			4'b0010:begin   //Using LCD Command 0X0E(00001110)
				del_counter  = del_counter +1'b1;
				if(del_counter >2200) begin
					rs=1'b0;
					rw=1'b0;
					data=8'b00001110;   
					enb=1'b1; //Logic is Sending High(1) then uses clocks Delay then Low(0) of Next state..
					state=4'b0011;
					del_counter = 1'b0;
				end
			end
			4'b0011:begin   //Using LCD Command 0X01(00000001)
			del_counter  = del_counter +1'b1;
			if(del_counter >2200) begin
				rs=1'b0;
				rw=1'b0;
				if(cmd_data==1'b1)begin
					data=8'b00000010; //return home after string print
					state = 4'b0101;
				end
				else
					data=8'b00000001;
					//or clear display in initialization
					enb=1'b1; //Logic is Sending High(1) then uses clocks Delay then Low(0) of Next state..
					state=4'b0100;
					del_counter = 1'b0;
				end
			end

			4'b0100:begin   //Using LCD Command 0X06(00000110)
				del_counter  = del_counter +1'b1;
				if(del_counter >2200) begin
					rs=1'b0;
					rw=1'b0;
					data=8'b00000110;
					enb=1'b1; //Logic is Sending High(1) then uses clocks Delay then Low(0) of Next state..
					state = 4'b0101;
					cmd_data=1;
					del_counter = 1'b0;
				end 
			end
			4'b0101:begin
				del_counter  = del_counter +1'b1;
				if(del_counter >10000) begin
					rs=1'b1;
					rw=1'b0;
					case(i)
						5'b00000:begin
							data=8'b01000001;// "A" letter
							i =5'b00001;
							enb=1'b1;
						end
						5'b00001:begin
							data=8'b01010010;// "R" 
							i = 5'b00010;
							enb=1'b1;
						end
						5'b00010:begin
							data=8'b01010010;// "R" 
							i = 5'b00011;
							enb=1'b1;
						end
						5'b00011:begin
							data=8'b01001001;// "I" 
							i = 5'b00100;
							enb=1'b1;
						end
						5'b00100:begin
							data=8'b01000001;// "A" 
							i =5'b00101;
							enb=1'b1;
						end
						5'b00101:begin
							data=8'b00100000;// "space"
							i =5'b00110;
							enb=1'b1;
						end
						5'b00110:begin
							data=8'b01010110;// "V" 
							i =5'b00111;
							enb=1'b1;
						end
						5'b00111:begin
							data=8'b00100000;// "space"
							i =5'b01000;
							enb=1'b1;
						end
						5'b01000:begin
							data=8'b01000111;// "G" 
							i =5'b01001;
							enb=1'b1;
						end
						5'b01001:begin
							data=8'b01010100;// "T"
							i =5'b01010;
							enb=1'b1;
						end
						5'b01010:begin
							state = 4'b0011;
							cmd_data=1;
							i=5'b00000;
						end
						endcase
							del_counter = 1'b0;
						end
					end
			endcase 
	end
endmodule
