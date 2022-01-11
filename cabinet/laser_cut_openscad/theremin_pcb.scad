$fa = 1;
$fs = 0.2;
include <cabinet_params.scad>

module circle_grid(pitch=2.54, d=0.762, dx = 1, dy = 1) {
    for ( x = [0 : dx - 1] ) {
        for ( y = [0 : dy - 1] ) {
            translate([x * pitch, y * pitch, 0]) circle(d=d);
        }
    }
}

module pin_grid_drill(pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6) {
    for ( x = [0 : dx - 1] ) {
        for ( y = [0 : dy - 1] ) {
            translate([x * pitch, y * pitch, +pcb_thickness/2]) {
                cylinder(h=pcb_thickness+0.3, d=d, center=true);
            }
        }
    }
}

module pin_grid_copper(pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6) {
    for ( x = [0 : dx - 1] ) {
        for ( y = [0 : dy - 1] ) {
            translate([x * pitch, y * pitch, +pcb_thickness/2]) {
                cylinder(h=pcb_thickness+0.2, d=d*1.8, center=true);
            }
        }
    }
}

module pin_grid_pin(pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6) {
    for ( x = [0 : dx - 1] ) {
        for ( y = [0 : dy - 1] ) {
            translate([x * pitch, y * pitch, +pcb_thickness/2]) {
                cube([d*0.7,d*0.7,pcb_thickness + 1.2], center=true);
            }
        }
    }
}

module pin_grid_headerpin(pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6) {
    h = 11; // + 2.54 + 3.05;
    dh = h/2-(3.06-pcb_thickness);
    for ( x = [0 : dx - 1] ) {
        for ( y = [0 : dy - 1] ) {
            translate([x * pitch, y * pitch, +pcb_thickness/2-dh]) {
                cube([d*0.7,d*0.7,h], center=true);
            }
        }
    }
}

module pin_grid_pinsocket(pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6, socket_height=8.5) {
    translate([-pitch/2, -pitch/2, pcb_thickness]) cube([pitch*dx, pitch*dy, socket_height]);
}

module pin_grid_pinheader(pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6, socket_height=2.54) {
    translate([-pitch/2, -pitch/2, -socket_height]) cube([pitch*dx, pitch*dy, socket_height]);
}

module pin_grid(mode="drill", pitch=2.54, d=0.762, dx = 1, dy = 1, pcb_thickness=1.6, socket_height=8.5) {
    if (mode == "drill") {
        pin_grid_drill(pitch=pitch, d=d, dx = dx, dy = dy, pcb_thickness=pcb_thickness);
    }
    if (mode == "copper") {
        pin_grid_copper(pitch=pitch, d=d, dx = dx, dy = dy, pcb_thickness=pcb_thickness);
    }
    if (mode == "pin") {
        pin_grid_pin(pitch=pitch, d=d, dx = dx, dy = dy, pcb_thickness=pcb_thickness);
    }
    if (mode == "headerpin") {
        pin_grid_headerpin(pitch=pitch, d=d, dx = dx, dy = dy, pcb_thickness=pcb_thickness);
    }
    if (mode == "pinsocket") {
        pin_grid_pinsocket(pitch=pitch, d=d, dx = dx, dy = dy, pcb_thickness=pcb_thickness, socket_height=socket_height);
    }
    if (mode == "pinheader") {
        pin_grid_pinheader(pitch=pitch, d=d, dx = dx, dy = dy, pcb_thickness=pcb_thickness, socket_height=socket_height);
    }
}

// mode: "drill", "copper", "pin"
module pcb_components(mode = "drill", pcb_width=60.96, pcb_length=209.55, pcb_thickness=1.6) {
    mount_hole_r = 1.65;
    mount_hole_edge_offset = 2.54;
    halfw = pcb_width/2;
    halflen = pcb_length/2;
    dx1 = 40.64;
    dx2 = 55.88;
    
    if (mode != "pinsocket") {
        // sensor connector pins
        translate([-halflen+10.16,-halfw+3.81,0]) pin_grid(mode=mode, dx=2, dy=6); 
        translate([halflen-10.16-2.54,halfw-3.81-2.54*5,0]) pin_grid(mode=mode, dx=2, dy=6); 
        // sensor power jumpers
        // volume side
        translate([-halflen+25.4,-halfw+2.54,0]) pin_grid(mode=mode, dx=2, dy=3); 
        translate([-halflen+25.4,-halfw+2.54+2.54*4,0]) pin_grid(mode=mode, dx=2, dy=2); 
        translate([-halflen+25.4,-halfw+2.54+2.54*7,0]) pin_grid(mode=mode, dx=2, dy=3); 
        
        // sensor power jumpers
        // pitch side
        translate([halflen-25.4-2.54, halfw-2.54-2.54*2,0]) pin_grid(mode=mode, dx=2, dy=3); 
        translate([halflen-25.4-2.54, halfw-2.54-2.54*5,0]) pin_grid(mode=mode, dx=2, dy=2); 
        translate([halflen-25.4-2.54, halfw-2.54-2.54*9,0]) pin_grid(mode=mode, dx=2, dy=3); 
    }
    // boards
    // teensy
    translate([13.97,-halfw+1.27,0]) pin_grid(mode=mode, dy=24); 
    translate([29.21,-halfw+1.27,0]) pin_grid(mode=mode, dy=24); 
    translate([13.97+2.54,-halfw+1.27+45.72,0]) pin_grid(mode=mode, dx=5); 
    // audio board
    translate([-16.51,-halfw+2.54,0]) pin_grid(mode=mode, dy=14); 
    translate([-1.27,-halfw+2.54,0]) pin_grid(mode=mode, dy=14); 
    translate([-22.86,-halfw+13.97,0]) pin_grid(mode=mode, dx=2, dy=5); 
    // volume fpga
    translate([-halflen+3.81,halfw-6.35,0]) pin_grid(mode=mode, dx=20); 
    translate([-halflen+3.81,halfw-24.13,0]) pin_grid(mode=mode, dx=20); 
    // pitch fpga
    translate([halflen-52.07,-halfw+6.35,0]) pin_grid(mode=mode, dx=20); 
    translate([halflen-52.07,-halfw+24.13,0]) pin_grid(mode=mode, dx=20); 
}

module teensy41_pcb_components(mode = "drill", pcb_width=17.78, pcb_length=60.96, pcb_thickness=1.6, socket_height=2.54) {

    pin_grid(mode=mode, dy=24, socket_height=socket_height); 
    translate([15.24,0,0]) pin_grid(mode=mode, dy=24, socket_height=socket_height); 
    translate([2.54,45.72,0]) pin_grid(mode=mode, dx=5, socket_height=socket_height); 
}

module audio_pcb_components(mode = "drill", pcb_width=35.56, pcb_length=36.83, pcb_thickness=1.6, socket_height=2.54) {

    pin_grid(mode=mode, dy=14, socket_height=socket_height); 
    translate([15.24,0,0]) pin_grid(mode=mode, dy=14, socket_height=socket_height); 
    translate([-6.35,11.43,0]) pin_grid(mode=mode, dx=2, dy=5, socket_height=socket_height); 
}

module fpga_pcb_components(mode = "drill", pcb_width=35.56, pcb_length=36.83, pcb_thickness=1.6, socket_height=2.54) {

    pin_grid(mode=mode, dy=20, socket_height=socket_height); 
    translate([17.78,0,0]) pin_grid(mode=mode, dy=20, socket_height=socket_height); 
}

module theremin_pcb_flat(pcb_width=60.96, pcb_length=209.55, pcb_thickness=1.6) {
    mount_hole_r = 1.65;
    mount_hole_edge_offset = 2.54;
    halfw = pcb_width/2;
    halflen = pcb_length/2;
    dx1 = 40.64;
    dx2 = 55.88;
    difference() {
        // board
        square([pcb_length, pcb_width], center=true);
        // mounting holes
        // top mount
        translate([-dx1,halfw-mount_hole_edge_offset,0]) circle(r=mount_hole_r);
        translate([dx2,halfw-mount_hole_edge_offset,0]) circle(r=mount_hole_r);
        // bottom mount
        translate([dx1,-halfw+mount_hole_edge_offset,0]) circle(r=mount_hole_r);
        translate([-dx2,-halfw+mount_hole_edge_offset,0]) circle(r=mount_hole_r);
        // side mount holes
        translate([-halflen+mount_hole_edge_offset,0,0]) circle(r=mount_hole_r);
        translate([halflen-mount_hole_edge_offset,0,0]) circle(r=mount_hole_r);
    }
}

module teensy41_pcb(pcb_width=17.78, pcb_length=60.96, pcb_thickness=1.6) {
    difference() {
        union() {
            color("green") translate([-1.27, -1.27, 0]) linear_extrude(pcb_thickness)
            square([pcb_width, pcb_length]);
            color("gold") teensy41_pcb_components(mode = "copper", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
        }
        teensy41_pcb_components(mode = "drill", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    }
    color("gold") teensy41_pcb_components(mode = "headerpin", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    color("#404080") teensy41_pcb_components(mode = "pinheader", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness, socket_height=2.54);

    // MCU
    color("#304050")
    translate([1.27,8.5*2.54,pcb_thickness]) cube([5*2.54,5*2.54,1.2]);
        
    // usb connector
    translate([0,0,0])
    color ("silver") {
        translate([15.24/2-7.5/2,-1.27  ,pcb_thickness]) cube([7.5,5,2.5]);
        translate([15.24/2-8.06/2,-1.27-0.6,pcb_thickness-(3.07-2.5)/2]) difference() {
            cube([8.06,0.6,3.07]);
            translate([0.25,-0.26,0.25]) cube([8.06-0.5,0.6,3.07-0.5]);
        }
    }
    
    // SD card
        color("silver") {
        translate([1.27,18.5*2.54,pcb_thickness]) cube([2.54*5,2.54*4,1.5]);
        translate([1.27,22.5*2.54,pcb_thickness]) cube([2.54*0.5,2.54*0.8,1.5]);
        translate([1.27*10,22.5*2.54,pcb_thickness]) cube([2.54*0.5,2.54*0.8,1.5]);
    }
}

//teensy41_pcb();

module audio_jack_35_smd() {
    color("#303030") translate([-3,0,0]) cube([6,14.5,5]);
    translate([0,-1.25,2.5]) rotate([-90,0,0]) {    
        color("silver") difference() {
            cylinder(h=2.5, d=5, center=true); 
            cylinder(h=2.6, d=3.6, center=true); 
        }
    }
}

module audio_jack_635_sg008g04() {
    translate([0,-7.5,0]) {
        color("#304040") {
            translate([-10.6/2,0,(6.5+5.5-10.6)]) cube([10.6,26.5,10.6]);
            translate([-14/2,0,(6.5+5.5-10.6)-0.5]) cube([14,1.7,10.6+0.5]);
            // bottom stand
            color("blue") translate([10.6/2-1,7.5,0.7]) cube([2,2,1.5], center=true);    
            color("blue") translate([-10.6/2+1,7.5,0.7]) cube([2,2,1.5], center=true);    
            color("blue") translate([10.6/2-1,19,0.7]) cube([2,2,1.5], center=true);    
            color("blue") translate([-10.6/2+1,19,0.7]) cube([2,2,1.5], center=true);    
        }
        // pins
        color("gold")  {
            translate([0,7.5,-1.3]) cube([1,1.7,5.5], center=true);    
            translate([-2.5,22.5,-1.3]) cube([1,1.7,5.5], center=true);    
            translate([2.5,22.5,-1.3]) cube([1,1.7,5.5], center=true);    
        }
        
        translate([0,0,6.5]) rotate([90,0,0]) {
            difference() {
                union() {
                    color("gold") cylinder(d=10.4, h=9);
                    color("#304040") cylinder(d=10.6, h=8.9);
                }
                cylinder(d=6.43, h=9.1);
            }
        }
    }
}

module audio_jack_35_st_215n_04() {
    translate([0,-1.2,0]) {
        union() {
            color("#303030") translate([-3.2,0,0]) cube([8.2, 14.2, 12.3]);
            color("silver") difference() {
                translate([0,0,7]) rotate([90,0,0]) cylinder(d=6, h=4);
                translate([0,0,7]) rotate([90,0,0]) cylinder(d=3.6, h=4.1);
            }
        }
        color("gold") {
            translate([1,1.2,-3]) cube([1.5, 0.3, 3]);
            translate([-1,3.5,-3]) cube([1.5, 0.3, 3]);
            translate([-1,9,-3]) cube([1.5, 0.3, 3]);
        }
    }
}

module power_jack() {
    translate([0,0,6.5])
    rotate([90,0,180])
    union() {
        color("#303030") 
        difference() {
            union() {
                cylinder(d=9, h=14.2);
                translate([-4.5,-6.5,0]) cube([9,11,3]);
                translate([-4.5,-6.5,0]) cube([9,6.5,14.2]);
            }
            translate([0,0,-0.1]) cylinder(d=6.4, h=9.35);
        }
        color("gold") translate([0,0,1.5]) cylinder(d=2.5, h=6.9);
    }
    color("gold") translate([4.8,11,0]) cube([0.8,3,8], center=true);
    color("gold") translate([0,7.5,-2]) cube([3,0.8,4], center=true);
    color("gold") translate([0,13.5,-2]) cube([3.8,0.8,4], center=true);
}

module plt133t10w() {
    color("#303040") 
    difference() {
        translate([-9.7/2,0,0]) cube([9.7, 13.5, 10]);
        translate([-7.7/2,-0.1,4.35]) cube([7.7, 3, 4.65]);
        translate([-6/2,-0.1,1.1]) cube([6, 3, 3.35]);
    }
    // two thick pins
    color("gold") translate([-2.54,2.35+8.76-2.62,-3.85]) cylinder(h=3.85, d=0.65);
    color("gold") translate([2.54,2.35+8.76-2.62,-3.85]) cylinder(h=3.85, d=0.65);
    // 3 thin pins
    color("gold") translate([-2.54,2.35+8.76,-3.85]) cylinder(h=3.85, d=0.4);
    color("gold") translate([2.54,2.35+8.76,-3.85]) cylinder(h=3.85, d=0.4);
    color("gold") translate([0,2.35+8.76,-3.85]) cylinder(h=3.85, d=0.4);
}

module tactButton() {
    // front metal panel
    color("silver") translate([-7.5/2, 0, 1]) cube([7.5, 0.5, 6.1]);
    // side panels
    color("silver") translate([-7.5/2, 0.5, 2]) cube([0.5, 3.3, 3]);
    color("silver") translate([7.5/2-0.5, 0.5, 2]) cube([0.5, 3.3, 3]);
    color("silver") translate([-7.5/2, 2.5, 0]) cube([0.5, 3.5, 4]);
    color("silver") translate([7.5/2-0.5, 2.5, 0]) cube([0.5, 3.5, 4]);
    // mounting pins
    color("silver") translate([-7.5/2, 4.5, -3.9]) cube([0.5, 1, 3.9]);
    color("silver") translate([7.5/2-0.5, 4.5, -3.9]) cube([0.5, 1, 3.9]);
    // signal pins
    color("gold") translate([-4.5/2, 2.6, -3.9]) cube([0.3, 0.3, 4.9]);
    color("gold") translate([4.5/2-0.3, 2.6, -3.9]) cube([0.3, 0.3, 4.9]);
    // plastic body
    color("#404040") translate([-7.5/2, 0.5, 5]) cube([7.5, 2.8, 2.1]);
    color("#404040") translate([-6.5/2, 0.5, 1]) cube([6.5, 2.8, 4]);
    // button
    color("#303030") translate([0,0,4]) rotate([90,0,0]) cylinder(h = 1.7, d1=4, d2=3.4);
}

//tactButton();
    

//plt133t10w();
//power_jack();

//audio_jack_35_st_215n_04();
//audio_jack_635_sg008g04();
//audio_jack_35_smd();

module audio_pcb(pcb_width=35.56, pcb_length=36.83, pcb_thickness=1.6) {
    difference() {
        union() {
            color("green") translate([-8.89, -1.27, 0]) linear_extrude(pcb_thickness)
            square([pcb_length, pcb_width]);
            color("gold") audio_pcb_components(mode = "copper", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
        }
        audio_pcb_components(mode = "drill", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    }
    color("gold") audio_pcb_components(mode = "headerpin", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    color("#404080") audio_pcb_components(mode = "pinheader", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness, socket_height=2.54);
    
    // sgtl5000
    color("#304050")
    translate([1.27*5,3.2*2.54,pcb_thickness]) cube([1.7*2.54,1.7*2.54,1.2]);
    // SD card
    color("silver") {
        translate([1.27,8.5*2.54,pcb_thickness]) cube([2.54*5,2.54*4,1.5]);
        translate([1.27,12.5*2.54,pcb_thickness]) cube([2.54*0.5,2.54*0.8,1.5]);
        translate([1.27*10,12.5*2.54,pcb_thickness]) cube([2.54*0.5,2.54*0.8,1.5]);
    }
    
    translate([2.54*9,-1.27,pcb_thickness]) audio_jack_35_smd();
    
}

//audio_pcb();

module fpga_pcb(pcb_width=20.32, pcb_length=57.15, pcb_thickness=1.6) {
    difference() {
        union() {
            color("gray") translate([-2.54, -1.27, 0]) linear_extrude(pcb_thickness)
            square([pcb_width+2.54, pcb_length]);
            color("gold") fpga_pcb_components(mode = "copper", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
        }
        fpga_pcb_components(mode = "drill", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    }
    color("gold") fpga_pcb_components(mode = "headerpin", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    color("#404080") fpga_pcb_components(mode = "pinheader", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness, socket_height=2.54);
    
    color("silver") translate([2.54*2.5,pcb_length-2.54*3,pcb_thickness]) cube([2.5*2.54, 3*2.54, 3]);
    color("#303030") translate([2.54*2.5,2.54*10.5,pcb_thickness]) cube([2*2.54, 2*2.54, 0.7]);

    color("#303030") translate([2.54*2.75,pcb_length-2.54*6.5,pcb_thickness]) cube([2*2.54, 3*2.54, 0.7]);
}

//fpga_pcb();

module sensor_pcb_components(mode = "drill", pcb_width=25.4, pcb_length=35.56, pcb_thickness=1.6, socket_height=2.54) {

    translate([-6.35,3.81,0]) pin_grid(mode=mode, dy=2, dx=6, socket_height=socket_height); 
    //translate([17.78,0,0]) pin_grid(mode=mode, dy=20, socket_height=socket_height); 
}

module right_angle_pin_header(dy=6) {
    pin_below = 2.54;
    color("gold")
    for (y = [0:dy-1]) {
        x = - y * 2.54;
        // inner pin
        translate([x-0.32,-0.32+2.54,-pin_below+0.32]) cube([0.64, 0.64, pin_below + 1.8]);
        translate([x-0.32, -0.32+2.54,1.8-0.32]) cube([0.64, 1.5+2.54+6, 0.64]);
        // outer pin
        translate([x-0.32,-0.32,-pin_below+0.32]) cube([0.64, 0.64, pin_below + 1.8 + 2.54]);
        translate([x-0.32, -0.32, 1.8-0.32+2.54]) cube([0.64, 1.5+2.54+6+2.54, 0.64]);
    }
    color("black") translate([1.25-dy*2.54,2.54+1.5,0]) cube([dy*2.54, 2.54, 1.8*2+2.54]);
}

module right_angle_pin_socket(dy=6) {
    pin_below = 2.54;
    color("gold")
    for (y = [0:dy-1]) {
        x = - y * 2.54;
        // inner pin
        translate([x-0.32,-0.32+2.54,-pin_below+0.32]) cube([0.64, 0.64, pin_below + 1.8]);
        translate([x-0.32, -0.32+2.54,1.8-0.32]) cube([0.64, 1.5+2.54+6, 0.64]);
        // outer pin
        translate([x-0.32,-0.32,-pin_below+0.32]) cube([0.64, 0.64, pin_below + 1.8 + 2.54]);
        translate([x-0.32, -0.32, 1.8-0.32+2.54]) cube([0.64, 1.5+2.54+6+2.54, 0.64]);
    }
    color("#404040") translate([1.25-dy*2.54,2.54+1.5,0]) cube([dy*2.54, 8.5, 1.8*2+2.54]);
}


module sensor_pcb(pcb_width=25.4, pcb_length=35.56, pcb_thickness=1.6) {
    difference() {
        union() {
            color("#206020") linear_extrude(pcb_thickness)
            translate([-pcb_width/2,0,0]) square([pcb_width, pcb_length]);
            color("gold") sensor_pcb_components(mode = "copper", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
        }
        sensor_pcb_components(mode = "drill", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    }
    //color("gold") pcb_components(mode = "pin", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    //color("gray") pcb_components(mode = "pinsocket", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    
    translate([-2.54*2.5,3.81+2.54,pcb_thickness]) rotate([0,0,180]) right_angle_pin_header(dy=6); 
}

module theremin_pcb(pcb_width=60.96, pcb_length=210.82, pcb_thickness=1.6) {
    difference() {
        union() {
            color("#206020") linear_extrude(pcb_thickness)
            theremin_pcb_flat(pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
            color("gold") pcb_components(mode = "copper", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
        }
        pcb_components(mode = "drill", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    }
    color("gold") pcb_components(mode = "pin", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    color("gray") pcb_components(mode = "pinsocket", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness);
    
    boards_y = 8.5+2.54+pcb_thickness;
    
    translate([13.97,-pcb_width/2+1.27,boards_y]) teensy41_pcb();
    translate([-16.51,-pcb_width/2+2.54,boards_y]) audio_pcb();
    translate([-pcb_length/2+3.81,pcb_width/2-6.35,boards_y]) rotate([0,0,-90]) fpga_pcb();
    translate([pcb_length/2-3.81,-pcb_width/2+6.35,boards_y]) rotate([0,0,90]) fpga_pcb();
    
    // volume sensor connector
    translate([-pcb_length/2+10.16+2.54,-pcb_width/2+6.35+2.54*4,pcb_thickness]) rotate([0,0,90]) right_angle_pin_socket();
    // pitch sensor connector
    translate([pcb_length/2-10.16-2.54,pcb_width/2-6.35-2.54*4,pcb_thickness]) rotate([0,0,-90]) right_angle_pin_socket();
  
    line_out_dy = 15.748; //15.48;
   // line out 6.35mm audio jack
    translate([-33.02,-pcb_width/2+line_out_dy-1.27/2,pcb_thickness]) audio_jack_635_sg008g04();

    line_in_dy = 4.064;
    line_in_dx = 45.72; // 45.085
    // line in 3.5mm audio jack
    translate([-line_in_dx,-pcb_width/2+line_in_dy,pcb_thickness]) audio_jack_35_st_215n_04();

    expr_dx = 39.37;
    expr_dy = 15.748;
    // expression pedal 6.35mm audio jack
    translate([expr_dx,pcb_width/2-expr_dy,pcb_thickness]) rotate([0,0,180]) audio_jack_635_sg008g04();
    
    power_dx = 16.51;
    // power jack
    translate([-power_dx,pcb_width/2,pcb_thickness]) rotate([0,0,180]) power_jack();

    spdif_out_dx = -5.08;
    spdif_in_dx = 6.35;
    // plt133
    translate([spdif_out_dx,pcb_width/2,pcb_thickness]) rotate([0,0,180]) plt133t10w();
    translate([spdif_in_dx,pcb_width/2,pcb_thickness]) rotate([0,0,180]) plt133t10w();
    
    tact_button_dx = -28.895;
    // tact button
    translate([tact_button_dx,pcb_width/2,pcb_thickness]) rotate([0,0,180]) tactButton();
        
//    # color("white") {          
//        // front panel
//        translate([0,-pcb_width/2-0.5,12]) cube([pcb_length, 1, 30], center=true); 
//        // back panel
//        translate([0,pcb_width/2+0.5,12]) cube([pcb_length, 1, 30], center=true); 
//    }
}

//theremin_pcb();
    
module rear_panel_holes(pcb_thickness=1.6, pinheader_height=2.54+8.5) {
    
    // expression pedal 6.35mm audio jack
    translate([-39.37,6.5,0]) circle(d=11.6);

    // s/pdif IN
    translate([-6.35,(10)/2,0]) square([9.7-1.2, 10-1.2], center=true);
    // s/pdif OUT
    translate([5.08,(10)/2,0]) square([9.7-1.2, 10-1.2], center=true);
    
    // power in
    translate([16.51,6.5,0]) circle(d=6.5+4);
    
    tact_button_dx = 28.895;
    // tact button: program
    translate([tact_button_dx,4,0]) circle(d=4.2);
}

//rear_panel_holes();

module rear_bottom_holes() {
    mount_hole_r = 1.65;
    mount_hole_edge_offset = 2.54;
    dx1 = 40.64;
    dx2 = 55.88;
    pins_width = 2.7;
    // mount holes
    translate([-dx2,mount_hole_edge_offset,0]) circle(r=mount_hole_r);
    translate([dx1,mount_hole_edge_offset,0]) circle(r=mount_hole_r);
    // s/pdif pins cut
    translate([-6.35-2.54*1.5,2.54*2.5,0]) square([2.54*3,15]);
    translate([5.08-2.54*1.5,2.54*2.5,0]) square([2.54*3,15]);
    // power in
    translate([17.5-2.54*2,2.54*2.5,0]) square([2.54*4,15]);
    // fpga pins
    translate([50.8,2.54*1.7,0]) square([2.54*20,15]);
    // teensy pins cut
    translate([-13.97-pins_width/2,0.2,0]) square([pins_width,15]);
    translate([-29.21-pins_width/2,0.2,0]) square([pins_width,15]);    
}

module rear_panel_bottom(panel_width=120) {
    translate([0,0,-1-1.6])
    rotate([0,0,0])
    linear_extrude(1)
    difference() {
        translate([-panel_width/2,-1,0]) square([panel_width, 11]);
        rear_bottom_holes();
    }
}

//rear_panel_bottom();

module rear_panel_angle(panel_width=120, panel_height=30) {
    rotate([90,0,0])
    linear_extrude(1)
    difference() {
        translate([-panel_width/2,-1.6-1,0]) square([panel_width, panel_height]);
        rear_panel_holes();
    }
    rear_panel_bottom(panel_width=panel_width);
}

module rear_panel_flat(panel_width=120, panel_height=44, panel_thickness=1, pcb_dy=-11, pcb_thickness=1.6) {

    difference() {
        square([panel_width, panel_height], center=true);
        translate([0,pcb_dy+pcb_thickness,0])rear_panel_holes();
    }
}


module rear_panel(panel_width=120, panel_height=44, panel_thickness=1, pcb_dy=-11, pcb_thickness=1.6) {
    rotate([90,0,0])
    linear_extrude(panel_thickness)
    rear_panel_flat(panel_width=panel_width, panel_height=panel_height, panel_thickness=panel_thickness, pcb_dy=pcb_dy, pcb_thickness=pcb_thickness);
}

//rear_panel();

module front_panel_holes(pcb_thickness=1.6, pinheader_height=2.54+8.5) {
    
    
    boards_dy = 2.54+8.5+pcb_thickness;
    // phones out
    translate([6.985-0.54,boards_dy+2.5,0]) circle(d=6);
    // 21.59
    // teensy usb
    translate([21.59,boards_dy+1.2,0]) square([9, 4], center=true);
    
    // line out
    translate([-33.02,6.5,0]) circle(d=11.6);
    
    line_in_dx = 45.72; // 45.085
    // line in
    translate([-line_in_dx,7,0]) circle(d=7);
    
}



module front_bottom_holes() {
    mount_hole_r = 1.65;
    mount_hole_edge_offset = 2.54;
    dx1 = 40.64;
    dx2 = 55.88;
    pins_width = 2.7;
    // mount holes
    translate([-dx2,mount_hole_edge_offset,0]) circle(r=mount_hole_r);
    translate([dx1,mount_hole_edge_offset,0]) circle(r=mount_hole_r);
    // line in cut
    translate([-45.72,2.54,0]) square([5,15]);
    // audio board pins cut
    translate([-16.51-pins_width/2,1.27,0]) square([pins_width,15]);
    translate([-1.27-pins_width/2,1.27,0]) square([pins_width,15]);
    // fpga pins
    translate([50.8,2.54*1.7,0]) square([2.54*20,15]);
    // teensy pins cut
    translate([13.97-pins_width/2,0.2,0]) square([pins_width,15]);
    translate([29.21-pins_width/2,0.2,0]) square([pins_width,15]);    
}

module front_panel_bottom(panel_width=120) {
    translate([0,0,-1-1.6])
    rotate([0,0,0])
    linear_extrude(1)
    difference() {
        translate([-panel_width/2,-1,0]) square([panel_width, 11]);
        front_bottom_holes();
    }
}

//front_bottom_holes();
//front_panel_bottom();

module front_panel_angle(panel_width=120, panel_height=30) {
    rotate([90,0,0])
    linear_extrude(1)
    difference() {
        translate([-panel_width/2,-1.6-1,0]) square([panel_width, panel_height]);
        front_panel_holes();
    }
    front_panel_bottom(panel_width=panel_width);
}

module front_panel_flat(panel_width=120, panel_height=44, panel_thickness=1, pcb_dy=-11, pcb_thickness=1.6) {
    difference() {
        square([panel_width, panel_height], center=true);
        translate([0,pcb_dy+pcb_thickness,0]) front_panel_holes();
    }
}

module front_panel(panel_width=120, panel_height=44, panel_thickness=1, pcb_dy=-11, pcb_thickness=1.6) {
    rotate([90,0,0])
    linear_extrude(panel_thickness)
    front_panel_flat(panel_width=panel_width, panel_height=panel_height, panel_thickness=panel_thickness, pcb_dy=pcb_dy, pcb_thickness=pcb_thickness);
}

//front_panel();

//translate([-70,0,0]) rotate([-90,0,0]) audio_jack_35_st_215n_04();
//translate([-10,0,0])  rotate([-90,0,0])audio_jack_635_sg008g04();
//translate([-30,2.54+8.5+1.6,0])  rotate([-90,0,0])audio_jack_35_smd();



//front_panel_holes();


//right_angle_pin_header();
//right_angle_pin_socket();

//sensor_pcb();

//theremin_pcb();
//# translate([0,-pcb_width/2,1.6]) front_panel();
//# translate([0,pcb_width/2,1.6]) rotate([0,0,180]) rear_panel();
