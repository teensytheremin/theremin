include <cabinet_bottom.scad>
include <cabinet_top.scad>
include <cabinet_side.scad>
include <cabinet_front.scad>
include <cabinet_tablet_mount.scad>
include <pitch_antenna.scad>
include <volume_antenna.scad>
include <mic_stand_mount.scad>
include <cabinet_params.scad>

module tablet_landscape(w=204,h=137.4,t=14.2) {
    translate([0,h/2,0]) linear_extrude(t)
    rounded_rectangle(w,h,5);
}

module tablet_portrait(w=204,h=137.4,t=14.2) {
    translate([0,w/2,0]) linear_extrude(t)
    rounded_rectangle(h,w,5);
}

module cabinet_assembled() {

    // bottom
    translate([0,0, -cabinet_height / 2 - sheet_thickness/2]) cabinet_bottom(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // top
//#      translate([0,0, cabinet_height / 2 + sheet_thickness/2]) cabinet_top(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // left side
    translate([-cabinet_length/2-sheet_thickness/2,0,   0]) rotate([90,0,-90]) cabinet_side_left(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // right side
    translate([+cabinet_length/2+sheet_thickness/2,0,0]) rotate([90,0,90]) cabinet_side_right(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // front
    translate([0,-cabinet_width/2 - sheet_thickness/2, 0]) rotate([90,0,0]) cabinet_front(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding, spike_width=spike_width, spike_height=spike_height);

    // back
    translate([0,cabinet_width/2 + sheet_thickness/2, 0]) rotate([90,0,0]) cabinet_back(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height= cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding, spike_width=spike_width, spike_height=spike_height);
    
    
    // tablet holders
    long_side_spike_count = 4;
    tablet_mount_offset = cabinet_length/long_side_spike_count/2;
    // left holder
    translate([-tablet_mount_offset,0,cabinet_height/2+sheet_thickness/2]) rotate([90,0,-90])
    cabinet_tablet_mount(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, angle=holder_angle, spike_width = spike_width, spike_height = spike_height);
    // right holder
    translate([tablet_mount_offset,0,cabinet_height/2+sheet_thickness/2]) rotate([90,0,-90])
    cabinet_tablet_mount(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, angle=holder_angle, spike_width = spike_width, spike_height = spike_height);

}

module antennas() {
    pitch_ant_mount_dist_y = cabinet_width/5;
    volume_ant_angle = 10;
    // pitch antenna
    color("silver") translate([cabinet_length/2,pitch_ant_mount_dist_y,0]) pitch_antenna_assembled(length=500, diameter=10);
    // volume antenna
    color("silver") translate([-cabinet_length/2,pitch_ant_mount_dist_y,0]) rotate([volume_ant_angle,0,0]) volume_antenna_assembled(length=500, diameter=10);
}

module stand_mount() {
// mic stand mount
    color("silver") translate([0,0,-cabinet_height/2-sheet_thickness]) rotate([180,0,180]) mic_stand_mount();
}

module tablet_standing() {
    side_width = edge_extra + sheet_thickness;
    bottom_height = side_width;
    holder_rotate_pos_x = cabinet_width/2+sheet_thickness+side_width/2;
    holder_rotate_pos_y = bottom_height/2;
    holder_width = side_width*1.2;
    holder_tip_width = side_width*1.2+edge_rounding;
    # translate([0,-holder_rotate_pos_x,holder_rotate_pos_y+cabinet_height/2]) rotate([holder_angle,0,0]) translate([0,holder_tip_width/2+edge_rounding/2, holder_width/2+edge_rounding/2]) tablet_portrait();
}

cabinet_assembled();
stand_mount();
antennas();
tablet_standing();
