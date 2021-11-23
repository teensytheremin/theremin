// output serializer 8->1
module sensor_oddr(
	input CLK,       // slow parallel clock
	input CLKX2,     // faster x2 of CLK clock, phase aligned
	input CLKX4,     // fast DDR clock, x4 of CLK, phase aligned
	input RESET,     // RESET active 1
	input [7:0] IN,  // parallel input
	output OUT       // serial output
);

reg [7:0] stage0;
always @(posedge CLK) stage0 <= IN;
	
reg [3:0] stage1;
always @(posedge CLKX2) stage1 <= CLK ? stage0[7:4] : stage0[3:0];
	
reg [1:0] stage2;
always @(posedge CLKX4) stage2 <= CLKX2 ? stage1[3:2] : stage0[1:0];


ODDRXE oddr_inst (
	.SCLK(CLKX4),
	.RST(RESET),
	.D0(stage2[0]), // out first
	.D1(stage2[1]), // out last
	.Q(OUT)
);

/*
ODDRX4B oddrx4b_inst (
	.ECLK(ECLK),
	.SCLK(SCLK),
	.RST(RESET),
	.D0(IN[0]),
	.D1(IN[1]),
	.D2(IN[2]),
	.D3(IN[3]),
	.D4(IN[4]),
	.D5(IN[5]),
	.D6(IN[6]),
	.D7(IN[7]),
	.Q(OUT)
);
*/

endmodule
