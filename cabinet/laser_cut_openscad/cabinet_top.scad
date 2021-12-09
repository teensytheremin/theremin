include <rounded_rectangle.scad>

module cabinet_top_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1) {
    w = cabinet_length + sheet_thickness*2 + edge_extra*2;
    h = cabinet_width + sheet_thickness*2 + edge_extra*2;
    spike_width = sheet_thickness * 3; // + ray_correction*2;
    spike_height = sheet_thickness + edge_extra;
    //echo(spike_width=spike_width, spike_height=spike_height, edge_rounding=edge_rounding);
    long_side_spike_count = 4;
    tablet_mount_offset = cabinet_length / long_side_spike_count / 2;
    difference() {
        // main shape
        rounded_rectangle(w, h, edge_rounding);
        //square([cabinet_length, h], center=true);
        //rounded_rectangle(w, h, edge_rounding);
        // top and bottom edge holes
        for (i = [0 : long_side_spike_count-1]) {
            index = i - (long_side_spike_count-1) / 2;
            // bottom hole
            translate([cabinet_length/long_side_spike_count*index, -cabinet_width/2-sheet_thickness/2, 0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
            translate([cabinet_length/long_side_spike_count*index, cabinet_width/2+sheet_thickness/2, 0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        }
        // left edge holes
        translate([-cabinet_length/2-sheet_thickness/2, -h/2 + spike_width/2 + edge_extra + sheet_thickness, 0]) square([sheet_thickness-ray_correction*2, spike_width-ray_correction*2], center=true);
        translate([-cabinet_length/2-sheet_thickness/2, +h/2 - spike_width/2 - edge_extra - sheet_thickness, 0]) square([sheet_thickness-ray_correction*2, spike_width-ray_correction*2], center=true);
        // right edge holes
        translate([cabinet_length/2+sheet_thickness/2, -h/2 + spike_width/2 + edge_extra + sheet_thickness, 0]) square([sheet_thickness-ray_correction*2, spike_width-ray_correction*2], center=true);
        translate([cabinet_length/2+sheet_thickness/2, +h/2 - spike_width/2 - edge_extra - sheet_thickness, 0]) square([sheet_thickness-ray_correction*2, spike_width-ray_correction*2], center=true);
 
         // tablet mount - top holes
        translate([-tablet_mount_offset, cabinet_width/2+sheet_thickness+edge_extra/2 + 1, 0]) square([sheet_thickness-ray_correction*2, edge_extra+2-ray_correction*2], center=true);
        translate([tablet_mount_offset, cabinet_width/2 +sheet_thickness+edge_extra/2 + 1, 0]) square([sheet_thickness-ray_correction*2, edge_extra+2-ray_correction*2], center=true);
         // tablet mount - bottom holes
        translate([-tablet_mount_offset, -cabinet_width/2-sheet_thickness-edge_extra/2 - 1, 0]) square([sheet_thickness-ray_correction*2, edge_extra+2-ray_correction*2], center=true);
        translate([tablet_mount_offset, -cabinet_width/2-sheet_thickness-edge_extra/2 - 1, 0]) square([sheet_thickness-ray_correction*2, edge_extra+2-ray_correction*2], center=true);

        // test spike positions
        //square([cabinet_length-1, cabinet_width-1], center=true);
    }

}

module cabinet_top(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_top_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);
}
//cabinet_top();
