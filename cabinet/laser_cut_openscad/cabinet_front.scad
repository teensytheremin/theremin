include <rounded_rectangle.scad>

module cabinet_face_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, panel_width=120, panel_height=18, panel_rounding=8, spike_width = 20, spike_height = 9) {

    // full dimensions
    w = cabinet_length + sheet_thickness*2 + edge_extra*2;
    h = cabinet_width + sheet_thickness*2 + edge_extra*2;

    long_side_spike_count = 4;
    tablet_mount_offset = cabinet_length/long_side_spike_count/2;
    difference() {
        union() {
            difference() {
                // main shape
                square([cabinet_length, cabinet_height], center=true);
                rounded_rectangle(panel_width, panel_height, panel_rounding);
                // test spike positions
                //square([cabinet_length-1, cabinet_height-1], center=true);
            }
            for (i = [0 : long_side_spike_count-1]) {
                index = i - (long_side_spike_count-1) / 2;
                // top spike
                translate([cabinet_length/long_side_spike_count*index, cabinet_height/2 +spike_height / 2, 0]) rounded_spike_up(spike_width, spike_height, edge_rounding);
                // bottom spike
                translate([cabinet_length/long_side_spike_count*index, -cabinet_height/2 - spike_height/2, 0]) rounded_spike_down(spike_width, spike_height, edge_rounding);
            }
            // left edge spike
            translate([-cabinet_length/2-spike_height/2, 0, 0]) rounded_spike_left(width=spike_width, height=spike_height, radius=edge_rounding);
            // right edge spike
            translate([cabinet_length/2+spike_height/2, 0, 0]) rounded_spike_right(width=spike_width, height=spike_height, radius=edge_rounding);
        }
        // tablet mount - holes
        translate([-tablet_mount_offset, cabinet_height/2 +sheet_thickness+edge_extra/2 + 1, 0]) square([sheet_thickness-ray_correction*2, edge_extra+2-ray_correction*2], center=true);
        translate([tablet_mount_offset, cabinet_height/2 +sheet_thickness+edge_extra/2 + 1, 0]) square([sheet_thickness-ray_correction*2, edge_extra+2-ray_correction*2], center=true);
    }
}

module cabinet_front(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1, panel_width=120, panel_height=18, panel_rounding=8, spike_width = 20, spike_height = 9) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_face_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding, spike_width=spike_width, spike_height=spike_height);
}

module cabinet_back(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1, panel_width=120, panel_height=18, panel_rounding=8, spike_width = 20, spike_height = 9) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_face_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding, spike_width=spike_width, spike_height=spike_height);
}

//cabinet_face_flat();

//cabinet_front();
//translate([0, 100, 0]) cabinet_back();
