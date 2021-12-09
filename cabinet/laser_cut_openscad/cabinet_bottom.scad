include <rounded_rectangle.scad>

module cabinet_bottom_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1) {
    w = cabinet_length + sheet_thickness*2 + edge_extra*2;
    h = cabinet_width + sheet_thickness*2 + edge_extra*2;
    spike_width = sheet_thickness * 3; // + ray_correction*2;
    spike_height = sheet_thickness + edge_extra;
    //echo(spike_width=spike_width, spike_height=spike_height, edge_rounding=edge_rounding);
    long_side_spike_count = 4;
    difference() {
        // main shape
        square([cabinet_length, h], center=true);
        //rounded_rectangle(w, h, edge_rounding);
        // top and bottom edge holes
        for (i = [0 : long_side_spike_count-1]) {
            index = i - (long_side_spike_count-1) / 2;
            // bottom hole
            translate([cabinet_length/long_side_spike_count*index, -cabinet_width/2-sheet_thickness/2, 0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
            translate([cabinet_length/long_side_spike_count*index, cabinet_width/2+sheet_thickness/2, 0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        }
        // Atlas Sound AD-11B mic stand flange adapter mounting holes
        mounting_r = 31.75 / 2; // 1.25" / 2
        mounting_hole_r = 4.318 / 2; // 0.17" / 2
        rotate([0, 0, 0]) translate([0, -mounting_r, 0]) circle(r = mounting_hole_r);
        rotate([0, 0, 120]) translate([0, -mounting_r, 0]) circle(r = mounting_hole_r);
        rotate([0, 0, -120]) translate([0, -mounting_r, 0]) circle(r = mounting_hole_r);
        // test spike positions
        //square([cabinet_length-1, cabinet_width-1], center=true);
    }
    // left edge spikes
    translate([-cabinet_length/2-spike_height/2, -h/2 + spike_width/2, 0]) rounded_spike_left(width=spike_width, height=spike_height, radius=edge_rounding);
    translate([-cabinet_length/2-spike_height/2, h/2 - spike_width/2, 0]) rounded_spike_left(width=spike_width, height=spike_height, radius=edge_rounding);
    translate([-cabinet_length/2-spike_height/2, 0, 0]) rounded_spike_left(width=spike_width, height=spike_height, radius=edge_rounding);
    // right edge spikes
    translate([cabinet_length/2+spike_height/2, -h/2 + spike_width/2, 0]) rounded_spike_right(width=spike_width, height=spike_height, radius=edge_rounding);
    translate([cabinet_length/2+spike_height/2, h/2 - spike_width/2, 0]) rounded_spike_right(width=spike_width, height=spike_height, radius=edge_rounding);
    translate([cabinet_length/2+spike_height/2, 0, 0]) rounded_spike_right(width=spike_width, height=spike_height, radius=edge_rounding);
}

module cabinet_bottom(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_bottom_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);
}
//cabinet_bottom();
