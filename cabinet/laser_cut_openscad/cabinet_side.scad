include <rounded_rectangle.scad>

module cabinet_side_common(cabinet_length=400, cabinet_width=63, cabinet_height=40, front_extra=30, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, spike_width = 20, spike_height = 9, mic_stand_mount_height = 18.288) {

    w = cabinet_width + sheet_thickness*2 + edge_extra*2;
    wtop = w  + edge_extra*6;
    legs_height = mic_stand_mount_height + sheet_thickness / 2;
    legs_width = cabinet_width/3; //spike_width * 2;
    h = cabinet_height + sheet_thickness + legs_height;
    //echo(spike_width=spike_width, spike_height=spike_height, edge_rounding=edge_rounding);
    front_rounding_dy = cabinet_height/2+sheet_thickness*2;
    front_rounding_dx = front_extra + edge_extra + sheet_thickness;
    front_rounding_r = 10;
    difference() {
        // main shape
        translate([front_extra/2,-(legs_height)/2,0]) rounded_rectangle(wtop+front_extra, h-sheet_thickness, edge_rounding);
        // front top rounding
        translate([wtop/2+front_extra-front_rounding_dx,cabinet_height/2-front_rounding_dy]) square([front_rounding_dx, front_rounding_dy]);
        // side spike holes
        translate([-cabinet_width/2-sheet_thickness/2,0,0]) square([sheet_thickness-ray_correction*2, spike_width-ray_correction*2], center=true);
        translate([+cabinet_width/2+sheet_thickness/2,0,0]) square([sheet_thickness-ray_correction*2, spike_width-ray_correction*2], center=true);
        // bottom spike holes
        translate([-w/2+spike_width/2,-(cabinet_height)/2 - sheet_thickness/2,0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        translate([w/2-spike_width/2,-(cabinet_height)/2 - sheet_thickness/2,0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        translate([0,-(cabinet_height)/2 - sheet_thickness/2,0]) square([spike_width-ray_correction*2, sheet_thickness-ray_correction*2], center=true);
        // legs internal
        translate([front_extra/2,-(cabinet_height+legs_height+sheet_thickness*2+edge_extra*3)/2,0]) rounded_rectangle(wtop-legs_width*2+front_extra, legs_height, edge_rounding);
        
        // test spike positions
        //square([cabinet_width-1, cabinet_height-1], center=true);
    }
    // front rounding
    hull() {
        translate([wtop/2+front_extra-front_rounding_dx, cabinet_height/2-front_rounding_r]) circle(front_rounding_r);
        translate([wtop/2+front_extra-front_rounding_r, cabinet_height/2-front_rounding_dy]) circle(front_rounding_r);
        translate([wtop/2+front_extra-front_rounding_dx, cabinet_height/2-front_rounding_dy]) circle(front_rounding_r);
    }
    // legs
    translate([-wtop/2+legs_width/2, -cabinet_height/2 - legs_height, 0]) rounded_spike_down(width=legs_width, height=legs_height/2, radius=edge_rounding);
    translate([wtop/2-legs_width/2+front_extra, -cabinet_height/2 - legs_height, 0]) rounded_spike_down(width=legs_width, height=legs_height/2, radius=edge_rounding);
    // top spikes
    translate([-cabinet_width/2+spike_width/2, cabinet_height/2 + spike_height/2, 0]) rounded_spike_up(width=spike_width, height=spike_height, radius=edge_rounding);
    translate([cabinet_width/2-spike_width/2, cabinet_height/2 + spike_height/2, 0]) rounded_spike_up(width=spike_width, height=spike_height, radius=edge_rounding);

}

module cabinet_side_left_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, front_extra=30, volume_antenna_mount_delta=87, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, spike_width = 20, spike_height = 9, mic_stand_mount_height = 18.288) {
    
    antenna_d = 10; // 1/2 inch water pipe thread diameter
    antenna_mount_d = 22; // 1/2 inch water pipe thread diameter
    volume_ant_mnt_dist = volume_antenna_mount_delta;
    volume_ant_angle = 10;
    
    difference() {
        cabinet_side_common(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, front_extra=front_extra, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, mic_stand_mount_height = mic_stand_mount_height);
        // antenna mount hole
        translate([-cabinet_width/5, 0, 0]) {
            circle(d = antenna_mount_d);
            rotate([0, 0, -volume_ant_angle]) translate([volume_ant_mnt_dist, 0, 0]) circle(d = antenna_d);
        }
    }
}

module cabinet_side_right_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, front_extra=30, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, spike_width = 20, spike_height = 9, mic_stand_mount_height = 18.288) {
    difference() {
        antenna_d = 10; // 1/2 inch water pipe thread diameter
        antenna_mount_d = 22; // 1/2 inch water pipe thread diameter
        volume_ant_mnt_dist = 60;
        cabinet_side_common(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, front_extra=front_extra, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, mic_stand_mount_height = mic_stand_mount_height);
        translate([-cabinet_width/5, 0, 0]) {
            circle(d = antenna_mount_d);
        }
    }
}

module cabinet_side_left(cabinet_length=400, cabinet_width=63, cabinet_height=40, volume_antenna_mount_delta=87, front_extra=  30, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1, spike_width = 20, spike_height = 9, mic_stand_mount_height = 18.288) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_side_left_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, front_extra=front_extra, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, mic_stand_mount_height = mic_stand_mount_height);
}

module cabinet_side_right(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, front_extra=30, edge_extra=5, edge_rounding=4, ray_correction=0.1, spike_width = 20, spike_height = 9, mic_stand_mount_height = 18.288) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        rotate([0,180,0]) cabinet_side_right_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, front_extra=front_extra, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, mic_stand_mount_height = mic_stand_mount_height);
}

//cabinet_side_left(front_extra=30);
//translate([0,-90,0]) cabinet_side_right(front_extra=30);

//translate([0,100,0]) cabinet_side_right();
