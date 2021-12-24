include <rounded_rectangle.scad>

module cabinet_bottom_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, spike_width = 15, spike_height = 9, volume_inductor_offset=32, inductor_mount_wall_dist = 0.1, pitch_inductor_offset = 24,
pitch_inductor_length = 50,     pitch_inductor_side_offset=12, pcb_width=60.96, pcb_length=210.82) {
    
    // full dimensions
    w = cabinet_length + sheet_thickness*2 + edge_extra*2;
    h = cabinet_width + sheet_thickness*2 + edge_extra*2;
    
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
        // volume inductor mount holes
        translate([-cabinet_length/2+volume_inductor_offset, -cabinet_width/2+sheet_thickness/2+inductor_mount_wall_dist, 0]) square([spike_width/2-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        translate([-cabinet_length/2+volume_inductor_offset, +cabinet_width/2-sheet_thickness/2-inductor_mount_wall_dist, 0]) square([spike_width/2-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        // pitch inductor mount holes
        translate([cabinet_length/2-inductor_mount_wall_dist+sheet_thickness*0-pitch_inductor_side_offset, -cabinet_width/2+pitch_inductor_offset, 0]) square([sheet_thickness*2-ray_correction*2, spike_width/2-ray_correction*2], center=true);
        translate([cabinet_length/2-inductor_mount_wall_dist+sheet_thickness*0-pitch_inductor_length-pitch_inductor_side_offset, -cabinet_width/2+pitch_inductor_offset, 0]) square([sheet_thickness*2-ray_correction*2, spike_width/2-ray_correction*2], center=true);
        
        // Atlas Sound AD-11B mic stand flange adapter mounting holes
        mounting_r = 31.75 / 2; // 1.25" / 2
        mounting_hole_r = 4.318 / 2; // 0.17" / 2
        rotate([0, 0, 0]) translate([0, -mounting_r, 0]) circle(r = mounting_hole_r);
        rotate([0, 0, 120]) translate([0, -mounting_r, 0]) circle(r = mounting_hole_r);
        rotate([0, 0, -120]) translate([0, -mounting_r, 0]) circle(r = mounting_hole_r);

        // PCB mount
        mount_hole_r = 1.65;
        mount_hole_edge_offset = 2.54;
        dx1 = 40.64;
        dx2 = 55.88;
        // front pcb mount holes
        translate([-dx2-spike_width/4+ray_correction, -pcb_width/2+ray_correction, 0]) square([spike_width/2-ray_correction*2, sheet_thickness*2-ray_correction*2]); 
        translate([dx1-spike_width/4+ray_correction, -pcb_width/2+ray_correction, 0])square([spike_width/2-ray_correction*2, sheet_thickness*2-ray_correction*2]); 
        // rear pcb mount holes
        translate([dx2-spike_width/4+ray_correction, pcb_width/2-sheet_thickness*2+ray_correction, 0])square([spike_width/2-ray_correction*2, sheet_thickness*2-ray_correction*2]); 
        translate([-dx1-spike_width/4+ray_correction, pcb_width/2-sheet_thickness*2+ray_correction, 0])square([spike_width/2-ray_correction*2, sheet_thickness*2-ray_correction*2]); 
        // left pcb mount hole
        translate([-pcb_length/2+ray_correction, -spike_width/4+ray_correction, 0])square([sheet_thickness*2-ray_correction*2, spike_width/2-ray_correction*2]); 
        // right pcb mount hole
        translate([pcb_length/2-sheet_thickness*2+ray_correction, -spike_width/4+ray_correction, 0]) square([sheet_thickness*2-ray_correction*2, spike_width/2-ray_correction*2]); 

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

//cabinet_bottom_flat();

module cabinet_bottom(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1, spike_width = 16, spike_height = 9, volume_inductor_offset=32, inductor_mount_wall_dist = 0.1, pitch_inductor_offset = 24,
pitch_inductor_length = 50, pitch_inductor_side_offset=12, pcb_width=60.96, pcb_length=210.82) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_bottom_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, volume_inductor_offset=volume_inductor_offset, inductor_mount_wall_dist = inductor_mount_wall_dist, pitch_inductor_offset = pitch_inductor_offset,
pitch_inductor_length = pitch_inductor_length,  pitch_inductor_side_offset=pitch_inductor_side_offset, pcb_width=pcb_width, pcb_length=pcb_length);
}

module pcb_mount_flat(pcb_mount_h=40/2-8, sheet_thickness=5, pcb_mount_width=25, spike_width = 16, spike_height = 9, edge_rounding=4) {
    
    polygon([[-pcb_mount_width/2,0], 
    [-pcb_mount_width/2,pcb_mount_h/3], 
    [-pcb_mount_width/4,pcb_mount_h], [pcb_mount_width/4,pcb_mount_h], 
    [pcb_mount_width/2,pcb_mount_h/3], 
    [pcb_mount_width/2,0]]);
    
    //translate([-pcb_mount_width/2,0,0]) square([pcb_mount_width, pcb_mount_h]);
    translate([0,-spike_height/2,0]) rounded_spike_down(width=spike_width/2, height=spike_height, radius=edge_rounding/2);
}

//pcb_mount_flat();

module pcb_mount(pcb_mount_h=40/2-8, sheet_thickness=5, pcb_mount_width=20, spike_width = 16, spike_height = 9, edge_rounding=4) {
    difference() {
        rotate([-90,180,0]) {
            linear_extrude(sheet_thickness)
            pcb_mount_flat(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
            translate([0,0,sheet_thickness+0.1]) linear_extrude(sheet_thickness)
            pcb_mount_flat(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
        }
        translate([0,2.54,pcb_mount_h+0.1-8]) cylinder(h=8, d=2);
    }
}

//pcb_mount();

//cabinet_bottom();
