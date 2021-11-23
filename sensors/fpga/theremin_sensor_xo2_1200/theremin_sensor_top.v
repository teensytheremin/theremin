`timescale 1 ns / 1 ps

module theremin_sensor_top (
	
	/* Sensor AFE Sense input signal, differential */
   input pin1 /* synthesis IO_TYPE="LVCMOS33D" */,               
//  inout pin2, /* NEG complementary pin for pin1 */
	
//	inout pin3_sn,
//  inout pin4_mosi,
//    inout pin5 /* synthesis IO_TYPE="LVCMOS33" */ ,
  
  /* MCLK, 12.288MHz, PLL input frequency source */
	input pin6 /* synthesis IO_TYPE="LVCMOS33" */,               
  
//  inout pin7_done,	
  
//  inout pin8_pgmn,
//  inout pin9_jtgnb,

//  inout pin10_sda,

/* Sensor AFE Drive signal, differential */
output pin11_scl /* synthesis IO_TYPE="LVCMOS33D" */,     

//output pin12_tdo,
  //inout pin13_tdi,
  //inout pin14_tck,
  //inout pin15_tms,
  
//  inout pin16,
//  inout pin17,
//  inout pin18_cs,
//  inout pin19_sclk,
//  inout pin20_miso,
  
  /* Sensor AFE Ref input signal, differential */
	input pin21 /* synthesis IO_TYPE="LVCMOS33D" */
//  ,inout pin22
);

wire pll_lock;
//               abs max     / grade  -6       -5       -4
// DDR clock:    786.432MHz      761.856  638.976  516.096
wire clk_400; // 393.216MHz      380.928  319.488  258.048
wire clk_200; // 196.608MHz      190.464  159.744  129.024
wire clk_100; //  98.304MHz       95.232   79.872   64.512





//wire clk_in;

// PLL: generate DDR, DDR/2, DDR/4 frequencies from MCLK=12.288MHz
sensor_clock_pll sensor_clock_pll_inst (
	.CLKI(pin6), 	
	.CLKOP(clk_400), 
	.CLKOS(clk_200), 
	.CLKOS2(clk_100), 
	.LOCK(pll_lock)
);

wire [7:0] drive_out_parallel;
wire [7:0] ref_in_parallel;
wire [7:0] sense_in_parallel;

wire reset;

assign reset = 1'b0;

/*
wire eclk1; // eclk for output DDR
wire sclk1;
wire eclk2; // eclk for input DDRs
wire sclk2;

ECLKSYNCA eclksync_inst_1 (
	.ECLKI(clk_400),
	.STOP(clk_100),
	.ECLKO(eclk1)
);
CLKDIVC #(.DIV(4)) clkdiv_inst_1  (
	.CLKI(eclk1),
	.RST(RESET),
	.ALIGNWD(1'b0),
	.CDIV1(),
	.CDIVX(sclk1)
);
ECLKSYNCA eclksync_inst_2 (
	.ECLKI(clk_400),
	.STOP(clk_100),
	.ECLKO(eclk2)
);
CLKDIVC #(.DIV(4)) clkdiv_inst_2  (
	.CLKI(eclk2),
	.RST(RESET),
	.ALIGNWD(1'b0),
	.CDIV1(),
	.CDIVX(sclk2)
);
*/


sensor_oddr sensor_oddr_inst (
	.CLK(clk_100),     // slow parallel clock
	.CLKX2(clk_200),   // CLK x2
	.CLKX4(clk_400),   // CLK x4 for DDR
	.RESET(reset),    // RESET active 1
	.IN(drive_out_parallel), // parallel input
	.OUT(pin11_scl)      // serial output
);

sensor_iddr sensor_iddr_ref_inst (
	.CLK(clk_100),     // slow parallel clock
	.CLKX2(clk_200),   // CLK x2
	.CLKX4(clk_400),   // CLK x4 for DDR
	.RESET(reset), // reset active 1
	.IN(pin21),    // serial input
	.OUT(ref_in_parallel) // parallel output
);

sensor_iddr sensor_iddr_sense_inst (
	.CLK(clk_100),     // slow parallel clock
	.CLKX2(clk_200),   // CLK x2
	.CLKX4(clk_400),   // CLK x4 for DDR
	.RESET(reset), // reset active 1
	.IN(pin1),    // serial input
	.OUT(sense_in_parallel) // parallel output
);

// for testing, to avoid optimization
assign drive_out_parallel = sense_in_parallel ^ ref_in_parallel;

  // left side of board
//  assign pin1 = 1'bz;
//  assign pin2 = 1'bz;
//  assign pin3_sn = 1'bz;
//  assign pin4_mosi = 1'bz;
//  assign pin5 = 1'bz;
//  assign pin6 = 1'bz;
//  assign pin7_done = 1'bz;
//  assign pin8_pgmn = 1'bz;
//  assign pin9_jtgnb = 1'bz;
  
//  assign pin10_sda = 1'bz;
//  assign pin11_scl = 1'bz;
  
  // right side of board
  //assign pin12_tdo = 1'bz;
  //assign pin13_tdi = 1'bz;
  //assign pin14_tck = 1'bz;
  //assign pin15_tms = 1'bz;
//  assign pin16 = 1'bz;
//  assign pin17 = 1'bz;
//  assign pin18_cs = 1'bz;
//  assign pin19_sclk = 1'bz;
//  assign pin20_miso = 1'bz;
  //assign pin21 = 1'bz;
  //assign pin22 = 1'bz;

endmodule
