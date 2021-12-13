$fa = 1;
$fs = 0.2;

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

module volume_antenna(length=500, diameter=10, big_rounding=70, small_rounding=40) {
    // L = 2*PI*r
    big_round_length=big_rounding*PI;
    small_round_length=small_rounding*PI;
    straight_length=length - big_round_length - small_round_length;
    
    end_length_diff = 20; // ending straight segment is longer
    
    end_length = (straight_length - small_rounding*2) / 2 + end_length_diff/2;
    start_length = straight_length - end_length;
    
    
    mount_delta = (big_rounding - small_rounding) * 2;
    
    rotate([0,0,90])
    color("silver") {
        // start straight
        tube(length=start_length);
        // big rounding
        translate([0,start_length,0]) round_tube(angle=180, diameter=diameter, rounding=big_rounding  );
        // small rounding
        translate([-big_rounding*2,start_length,0]) rotate([0,0,180]) round_tube(angle=90, diameter=diameter, rounding=small_rounding  );
        translate([-big_rounding*2+small_rounding,start_length-small_rounding,0]) rotate([0,180,-90]) round_tube(angle=90, diameter=diameter, rounding=small_rounding  );
        // end straight
        translate([-mount_delta,-end_length_diff,0]) tube(length=end_length);
    }
}


//round_tube();
//tube();
//volume_antenna();
