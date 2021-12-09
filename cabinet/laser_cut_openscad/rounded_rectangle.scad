$fa = 1;
$fs = 0.2;

module rounded_rectangle(width, height, radius) {
    offset(r=radius) square([width-radius*2, height-radius*2], center=true);
}

module rounded_spike(width, height, radius) {
    union() {
        rounded_rectangle(width=width, height=height, radius=radius);
        translate([0, -radius/2, 0]) square([width, height-radius], center=true);
    }
}

module rounded_spike_up(width, height, radius) {
    rotate([0, 0, 0]) rounded_spike(width=width, height=height, radius=radius);
}

module rounded_spike_down(width, height, radius) {
    rotate([0, 0, 180]) rounded_spike(width=width, height=height, radius=radius);
}

module rounded_spike_left(width, height, radius) {
    rotate([0, 0, 90]) rounded_spike(width=width, height=height, radius=radius);
}

module rounded_spike_right(width, height, radius) {
    rotate([0, 0, -90]) rounded_spike(width=width, height=height, radius=radius);
}

//rounded_rectangle(width=10, height=15, radius=4.9);
//rounded_spike(width=10, height=15, radius=3);
//translate([0, -15,0]) rounded_spike_left(width=10, height=10, radius=4.9);
//translate([0, 15,0]) rounded_spike_right(width=10, height=20, radius=3);
//translate([20, -15,0]) rounded_spike_down(width=10, height=20, radius=3);
//translate([20,  15,0]) rounded_spike_up(width=10, height=20, radius=3);
