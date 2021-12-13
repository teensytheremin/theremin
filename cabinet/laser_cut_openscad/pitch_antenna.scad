
module pitch_antenna(length=500, diameter=10) {

    color("silver" )
    translate([0,0,length/2])
    difference () {
        cylinder(h=length,r=diameter/2,center=true);
        cylinder(h=length+2,r=diameter/2-1,center=true);
    }
}

//pitch_antenna();