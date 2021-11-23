// input deserializer 1->8
module sensor_iddr(
	input CLK,       // slow parallel clock
	input CLKX2,     // faster x2 of CLK clock, phase aligned
	input CLKX4,     // fast DDR clock, x4 of CLK, phase aligned
	input RESET, // reset active 1
	input IN,    // serial input
	output [7:0] OUT // parallel output, OUT[0] is most recent bit, OUT[7] is oldest bit
);

wire [1:0] ddr_out;

reg [1:0] stage1_half;
always @(negedge CLKX2) stage1_half <= ddr_out;
reg [3:0] stage1;
always @(posedge CLKX2) stage1 <= {stage1_half, ddr_out};

reg [3:0] stage2_half;
always @(negedge CLK) stage2_half <= stage1;
reg [7:0] stage2;
always @(posedge CLK) stage2 <= {stage2_half, stage1};


assign OUT = stage2;

IDDRXE iddrxe_inst (
	.SCLK(CLKX4),
	.RST(RESET),
	.D(IN),
	.Q0(ddr_out[0]),   // posedge
	.Q1(ddr_out[1])    // negedge
);



/*
IDDRX4B iddrx4b_inst (
	.ECLK(ECLK),
    .SCLK(SCLK),
    .RST(RESET),
    .ALIGNWD(1'b0),
	.Q0(OUT[0]),
	.Q1(OUT[1]),
	.Q2(OUT[2]),
	.Q3(OUT[3]),
	.Q4(OUT[4]),
	.Q5(OUT[5]),
	.Q6(OUT[6]),
	.Q7(OUT[7]),
	.D(IN)
);

*/

endmodule
