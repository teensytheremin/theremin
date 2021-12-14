$fa = 1;
$fs = 0.2;
include <mounts_and_fittings.scad>

module tube(length=500, diameter=10) {
    rotate([-90,0,0])
    translate([0,0,length/2])
    difference () {
        cylinder(h=length,r=diameter/2,center=true);
        cylinder(h=length+2,r=diameter/2-1,center=true);
    }
}

module round_tube(angle=90, diameter=10, rounding=100) {
    translate([-rounding,0,0])
    rotate_extrude(angle=angle)
    translate([rounding,0,0])
    difference() {
        circle(r=diameter/2);
        circle(r=diameter/2-2);
    }
}

module round_tube_s(diameter=10, rounding=100, dx=90) {
    a = acos((rounding-dx/2)/rounding);
    dy2 = sin(a)*rounding;
    // l = 2*PI*r*(a/360)
    l = 2*PI*rounding*(a/360);
    echo(a=a,dx=dx,l=l);
    round_tube(angle=a, diameter=diameter, rounding=rounding);
    translate([-dx/2,dy2,0]) rotate([180,0,180+a]) round_tube(angle=a, diameter=diameter, rounding=rounding);
}

module volume_antenna(length=500, diameter=10, big_rounding=60, mount_delta=60) {
    // L = 2*PI*r
    big_round_length=big_rounding*PI;
    
    small_dx = big_rounding*2 - mount_delta;
    // small rounding calculation
    a = acos((big_rounding-small_dx/2)/big_rounding);
    small_round_length = 2*PI*big_rounding*(a/360);
    small_dy = sin(a)*big_rounding*2;
    
    
    //small_round_length=small_rounding*PI;
    straight_length=length - big_round_length - small_round_length;
    
    end_length_diff = 20; // ending straight segment is longer
    
    start_length_mandatory = small_dy;
    end_length_mandatory = end_length_diff;
    
    available_length = straight_length - start_length_mandatory - end_length_mandatory;

    middle_length = available_length * 0.45;
    
    end_length = end_length_mandatory + available_length * 0.05;
    start_length = start_length_mandatory + available_length * 0.5;
            
    rotate([0,0,90])
    color("silver") {
        // start straight
        tube(length=start_length);
        // big rounding
        translate([0,start_length,0]) round_tube(angle=180, diameter=diameter, rounding=big_rounding  );
        // middle straight
        translate([-big_rounding*2,start_length,0]) rotate([0,0,180]) tube(length=middle_length);
        // small rounding
        translate([-big_rounding*2,start_length-middle_length,0]) rotate([0,0,180]) round_tube_s(diameter=diameter, rounding=big_rounding, dx=small_dx);
        //round_tube(angle=90, diameter=diameter, rounding=small_rounding  );
        // end straight
        //translate([-big_rounding*2+small_rounding,start_length-small_rounding,0]) rotate([0,180,-90]) round_tube(angle=90, diameter=diameter, rounding=small_rounding  );
        // end straight
        translate([-mount_delta,-end_length_diff,0]) tube(length=end_length);
    }
}

module volume_antenna_assembled(length=500, diameter=10, big_rounding=70, mount_delta=60, sheet_thickness=5,big_thread_d=20.7, big_thread_wall=2, big_thread_len=14, hex_len=12, small_thread_d=16.5, pipe1_len=20) {
    translate([-sheet_thickness,0,0]) {
        // fitting
        translate([big_thread_len,0,0]) rotate([180,90,0]) KSM1002_fitting(big_thread_d=big_thread_d, big_thread_wall=big_thread_wall, big_thread_len=big_thread_len, hex_len=hex_len, small_thread_d=small_thread_d, pipe1_len=pipe1_len);
        // antenna
        translate([-15,0,0]) volume_antenna(length=length, diameter=diameter, big_rounding=big_rounding, mount_delta=mount_delta);
        // fitting mount
        translate([sheet_thickness,0,0]) rotate([0,-90,0]) fitting_mount_hex();
    }
}

//volume_antenna_assembled();

//round_tube();
//tube();
//round_tube_s();
//volume_antenna();
  