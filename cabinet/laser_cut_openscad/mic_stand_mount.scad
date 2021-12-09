$fa = 1;
$fs = 0.2;


// mic stand mount ~ Atlas Sound AD-11
module mic_stand_mount(height=0.72*25.4, flat_d=1.75*25.4, flat_h=0.16*25.4, tip_d=0.75*25.4, mount_hole_d=0.17*25.4, mount_hole_dist=1.25*25.4/2) {
    
    flat_rounding=2;
    difference() {
        union() {
            //color("red") 
            translate([0,0,0])
            cylinder(h=flat_h-flat_rounding, r1=flat_d/2, r2=flat_d/2, center=false);
            //color("blue") 
            translate([0,0,(flat_h-flat_rounding)])
            cylinder(h=flat_rounding, r1=flat_d/2, r2=flat_d/2-flat_rounding, center=false);
            //color("pink") 
            translate([0,0,0])
            translate([0, 0, 1]) cylinder(h=height-1, r1=tip_d/2*11/10, r2=tip_d/2, center=false);
        }
        rotate([0, 0, 0]) translate([0, -mount_hole_dist, 0]) cylinder(h=height, r1=mount_hole_d/2, r2=mount_hole_d/2, center=true);
        rotate([0, 0, 120]) translate([0, -mount_hole_dist, 0]) cylinder(h=height, r1=mount_hole_d/2, r2=mount_hole_d/2, center=true);
        rotate([0, 0, -120]) translate([0, -mount_hole_dist, 0]) cylinder(h=height, r1=mount_hole_d/2, r2=mount_hole_d/2, center=true);
        thread_r = 0.5*25.4/2;
        translate([0, 0, -1]) cylinder(h=height*2, r1=thread_r, r2=thread_r, center=false);
    }
    //color("yellow") cylinder(h=flat_h*2-flat_rounding, r1=flat_d/2-flat_rounding, r2=flat_d/2-flat_rounding, center=true);
}

//mic_stand_mount();
