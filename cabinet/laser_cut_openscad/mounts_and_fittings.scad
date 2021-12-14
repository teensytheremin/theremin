// mounts_and_fittings
module hexgon(d=25, h=12) {
    //hull()
    l = d / cos(30);
    t = sqrt(l*l + h*h);
    intersection() {
        translate([0,0,-h/2]) linear_extrude(h)
        difference() {
            circle(d=d*1.12);
            for (i = [0:5] ) {
                rotate([0,0,30+60*i]) color("red") translate([0,d,0]) square([d,d], center=true);
            }
        }
        
        sphere(r=t/2*0.94);
        //translate([0,0,-h*0.001]) sphere(r=t/2);
        //translate([0,0, h*0.001]) sphere(r=t/2);
        //rotate([0,0,30]) cube([d-d/k, d/2-d/k, h], center=true);
        //rotate([0,0,150]) cube([d-d/k, d/2-d/k, h], center=true);
        //rotate([0,0,270]) cube([d-d/k, d/2-d/k, h], center=true);
        //rotate([0,0,30]) cube([d, d/2, h-d/k], center=true);
        //rotate([0,0,150]) cube([d, d/2, h-d/k], center=true);
        //rotate([0,0,270]) cube([d, d/2, h-d/k], center=true);
    }
}

module hexcap(d=20, h=25) {
    difference() {
        intersection() {
            translate([0,0,0]) hexgon(d=d, h=h);
            translate([0,0,-d/2]) sphere(d=d*1.2);
        }
        translate([0,0,d/2]) cube([d*2,d*2,d], center=true);
        cylinder(h=h*2, d=10, center=true);
    }
}

module L082m_fitting(big_thread_d=20.7, big_thread_wall=2, big_thread_len=14, hex_len=12, small_thread_d=16.5, pipe_d=17, pipe1_len=20, pipe2_len=55) {
    
    difference() {
        union() {
            // big thread
            cylinder(h=big_thread_len, r=big_thread_d/2);
            // big thread hex
            translate([0,0,big_thread_len+hex_len/2]) hexgon();

            // pipes L angle
            // pipe1 + pipe2 connection
            intersection() {
                translate([0,0,big_thread_len+hex_len]) cylinder(h=pipe1_len, r=pipe_d/2);
                translate([-pipe_d/2,0,big_thread_len+hex_len+pipe1_len-pipe_d/2]) rotate([0,90,0]) cylinder(h=pipe2_len, r=pipe_d/2);
            }
            // pipe 1
            translate([0,0,big_thread_len+hex_len]) cylinder(h=pipe1_len-pipe_d/2, r=pipe_d/2);
            // pipe 2
            translate([0,0,big_thread_len+hex_len+pipe1_len-pipe_d/2]) rotate([0,90,0]) cylinder(h=pipe2_len-pipe_d/2, r=pipe_d/2);
            // 10mm connection pipe
            translate([pipe2_len,0,big_thread_len+hex_len+pipe1_len-pipe_d/2]) rotate([0,90,0]) hexcap();
        }
        // big thread hole
        translate([0,0,-1]) cylinder(h=big_thread_len+2, r=big_thread_d/2-big_thread_wall);
        // small thread hole
        //translate([pipe2_len,0,big_thread_len+hex_len+pipe1_len+pipe_d/2]) rotate([0,90,0]) cylinder(h=pipe2_len*10, d=10);
    }
}

module KSM1002_fitting(big_thread_d=20.7, big_thread_wall=2, big_thread_len=20, hex_len=10, small_thread_d=16.5, pipe1_len=20) {
    difference() {
        union() {
            // big thread
            cylinder(h=big_thread_len, r=big_thread_d/2);
            // big thread hex
            translate([0,0,big_thread_len+hex_len/2]) hexgon(h=hex_len, d=big_thread_d*1.2);

            // pipe 1
            translate([0,0,big_thread_len+hex_len]) cylinder(h=pipe1_len-small_thread_d/2, r=small_thread_d/2);
            // 10mm connection pipe
            translate([0,0,big_thread_len+hex_len+pipe1_len]) hexcap();
        }
        // big thread hole
        translate([0,0,-1]) cylinder(h=big_thread_len+2, r=big_thread_d/2-big_thread_wall);
        // small thread hole
        translate([0,0,big_thread_len+hex_len]) cylinder(h=pipe1_len, d=10);
    }
}

module fitting_mount_hex(big_thread_d=20.7, hex_h=4) {
    clearance_h = big_thread_d/10;
    clearance_d = big_thread_d*1.7;
    difference() {
        union() {
            translate([0,0,-clearance_h]) cylinder(h=clearance_h, d=clearance_d);
            translate([0,0,-clearance_h-hex_h/2]) hexgon(d=25, h=hex_h);
        }
        cylinder(h=(clearance_h+hex_h)*3, d=big_thread_d, center=true);
    }
}



//KSM1002_fitting();
//hexcap();
//hexgon(d=25, h=10);
