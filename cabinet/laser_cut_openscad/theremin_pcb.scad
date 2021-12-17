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
    color("gray") teensy41_pcb_components(mode = "pinheader", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness, socket_height=2.54);
}

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
    color("gray") audio_pcb_components(mode = "pinheader", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness, socket_height=2.54);
}

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
    color("gray") fpga_pcb_components(mode = "pinheader", pcb_width=pcb_width, pcb_length=pcb_length, pcb_thickness=pcb_thickness, socket_height=2.54);
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
    
    translate([13.97,-pcb_width/2+1.27,8.5+2.54]) teensy41_pcb();
    translate([-16.51,-pcb_width/2+2.54,8.5+2.54]) audio_pcb();
    translate([-pcb_length/2+3.81,pcb_width/2-6.35,8.5+2.54]) rotate([0,0,-90]) fpga_pcb();
    translate([pcb_length/2-3.81,-pcb_width/2+6.35,8.5+2.54]) rotate([0,0,90]) fpga_pcb();
}

module sensor_pcb_components(mode = "drill", pcb_width=25.4, pcb_length=35.56, pcb_thickness=1.6, socket_height=2.54) {

    translate([-6.35,5.8,0]) pin_grid(mode=mode, dy=2, dx=6, socket_height=socket_height); 
    //translate([17.78,0,0]) pin_grid(mode=mode, dy=20, socket_height=socket_height); 
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
}

//sensor_pcb();

//theremin_pcb();
