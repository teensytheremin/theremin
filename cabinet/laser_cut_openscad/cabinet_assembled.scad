include <cabinet_bottom.scad>
include <cabinet_top.scad>
include <cabinet_side.scad>
include <cabinet_front.scad>
include <cabinet_tablet_mount.scad>
include <pitch_antenna.scad>
include <volume_antenna.scad>
include <mic_stand_mount.scad>
include <cabinet_params.scad>
include <inductor_ppl_frame.scad>
include <theremin_pcb.scad>

module tablet_landscape(w=204,h=137.4,t=14.2) {
    translate([0,h/2,0]) linear_extrude(t)
    rounded_rectangle(w,h,5);
}

module tablet_portrait(w=204,h=137.4,t=14.2) {
    translate([0,w/2,0]) linear_extrude(t)
    rounded_rectangle(h,w,5);
}

module pcb_mounts(pcb_mount_offset=0) {
        mount_hole_r = 1.65;
        mount_hole_edge_offset = 2.54;
        dx1 = 40.64;
        dx2 = 55.88;
    // front
    translate([-dx2,-pcb_width/2+pcb_mount_offset,-cabinet_height/2]) pcb_mount(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
    translate([dx1,-pcb_width/2+pcb_mount_offset,-cabinet_height/2]) pcb_mount(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
    // rear
    translate([dx2,pcb_width/2-pcb_mount_offset,-cabinet_height/2]) rotate([0,0,180]) pcb_mount(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
    translate([-dx1,pcb_width/2-pcb_mount_offset,-cabinet_height/2]) rotate([0,0,180]) pcb_mount(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
    // left
    translate([-pcb_length/2,0,-cabinet_height/2]) rotate([0,0,-90]) pcb_mount(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
    // right
    translate([pcb_length/2,0,-cabinet_height/2]) rotate([0,0,90]) pcb_mount(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
}

module cabinet_assembled() {

    // bottom
    color("#c0c020") translate([0,0, -cabinet_height / 2 - sheet_thickness/2]) cabinet_bottom(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height,  volume_inductor_offset=volume_inductor_offset, inductor_mount_wall_dist = inductor_mount_wall_dist, pitch_inductor_offset = pitch_inductor_offset,
pitch_inductor_length = pitch_inductor_length, pitch_inductor_side_offset=pitch_inductor_side_offset, pcb_length=pcb_length);

    // top
    translate([0,0, cabinet_height / 2 + sheet_thickness/2]) cabinet_top(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // left side
    translate([-cabinet_length/2-sheet_thickness/2,0,   0]) rotate([90,0,-90]) cabinet_side_left(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // right side
    translate([+cabinet_length/2+sheet_thickness/2,0,0]) rotate([90,0,90]) cabinet_side_right(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height);

    // front
     translate([0,-cabinet_width/2 - sheet_thickness/2, 0]) rotate([90,0,0]) cabinet_front(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding,
    panel_offset_y = front_panel_offset_y,
    spike_width=spike_width, spike_height=spike_height);

    // back
    translate([0,cabinet_width/2 + sheet_thickness/2, 0]) rotate([90,0,0]) cabinet_back(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height= cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding, panel_offset_y = rear_panel_offset_y,
spike_width=spike_width, spike_height=spike_height);
    
    
    // tablet holders
    long_side_spike_count = 4;
    tablet_mount_offset = cabinet_length/long_side_spike_count/2;
    // left holder
    translate([-tablet_mount_offset,0,cabinet_height/2+sheet_thickness/2]) rotate([90,0,-90]) cabinet_tablet_mount(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, angle=holder_angle, spike_width = spike_width, spike_height = spike_height);
    
    // right holder
    translate([tablet_mount_offset,0,cabinet_height/2+sheet_thickness/2]) rotate([90,0,-90]) cabinet_tablet_mount(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, angle=holder_angle, spike_width = spike_width, spike_height = spike_height);

    
    // volume inductor mount
    translate([-cabinet_length/2+volume_inductor_offset, cabinet_width/2-sheet_thickness/2-inductor_mount_wall_dist,0]) inductor_mount(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=inductor_frame_d, spring_thickness=inductor_mount_spring_thickness, spring_angle=inductor_mount_spring_angle);
    
    translate([-cabinet_length/2+volume_inductor_offset, -(cabinet_width/2-sheet_thickness/2)+inductor_mount_wall_dist,0]) inductor_mount(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=inductor_frame_d, spring_thickness=inductor_mount_spring_thickness, spring_angle=inductor_mount_spring_angle);

    // pitch inductor mount
         translate([cabinet_length/2-sheet_thickness/2-inductor_mount_wall_dist-pitch_inductor_side_offset, -cabinet_width/2+pitch_inductor_offset,0]) rotate([0,0,90]) {
        inductor_mount(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=inductor_frame_d, spring_thickness=inductor_mount_spring_thickness, spring_angle=inductor_mount_spring_angle);
        translate([0,-sheet_thickness,0]) inductor_mount_side(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=inductor_frame_d, spring_thickness=inductor_mount_spring_thickness, spring_angle=inductor_mount_spring_angle);
    }
    translate([cabinet_length/2+sheet_thickness/2-inductor_mount_wall_dist - pitch_inductor_length-pitch_inductor_side_offset, -cabinet_width/2+pitch_inductor_offset,0]) rotate([0,0,90]) {
        inductor_mount(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=inductor_frame_d, spring_thickness=inductor_mount_spring_thickness, spring_angle=inductor_mount_spring_angle);
        translate([0,sheet_thickness,0]) inductor_mount_side(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=inductor_frame_d, spring_thickness=inductor_mount_spring_thickness, spring_angle=inductor_mount_spring_angle);
    }
}


module antennas() {
    pitch_ant_mount_dist_y = cabinet_width/5;
    volume_ant_angle = 10;
    // pitch antenna
    color("silver") translate([cabinet_length/2,pitch_ant_mount_dist_y,0]) pitch_antenna_assembled(length=500, diameter=10);
    // volume antenna
    color("silver") translate([-cabinet_length/2,pitch_ant_mount_dist_y,0]) rotate([volume_ant_angle,0,0]) volume_antenna_assembled(length=500, diameter=10);
}

module inductors() {
    // volume inductor
    translate([-cabinet_length/2+volume_inductor_offset,0,0]) rotate([0,90,90]) inductor_ppl_frame(frame_len=cabinet_width-0.5, frame_d=inductor_frame_d, frame_internal_d=inductor_frame_internal_d, winding_len=volume_inductor_winding_len);
    // pitch inductor
    translate([cabinet_length/2-pitch_inductor_length/2-0.25-pitch_inductor_side_offset,-cabinet_width/2+pitch_inductor_offset,0]) rotate([0,90,0]) inductor_ppl_frame(frame_len=pitch_inductor_length, frame_d=inductor_frame_d, frame_internal_d=inductor_frame_internal_d, winding_len=pitch_inductor_winding_len);
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

module theremin_pcbs() {
    translate([0,0,pcb_dy]) theremin_pcb();
    translate([-pcb_length/2-0.5,-pcb_width/2+sensor_pcb_width/2,pcb_dy]) rotate([0,0,90]) sensor_pcb(pcb_length=sensor_pcb_length, pcb_width=sensor_pcb_width);
    translate([pcb_length/2+0.5,pcb_width/2-sensor_pcb_width/2,pcb_dy]) rotate([0,0,-90]) sensor_pcb(pcb_length=sensor_pcb_length, pcb_width=sensor_pcb_width);
}

module panels() {
    translate([0,-pcb_width/2,0])
    front_panel(panel_width=panel_width+20, panel_height=cabinet_height, panel_thickness=panel_thickness, pcb_dy=pcb_dy);
    translate([0,pcb_width/2,0])
    rotate([0,0,180])
    rear_panel(panel_width=panel_width+20, panel_height=cabinet_height, panel_thickness=panel_thickness, pcb_dy=pcb_dy);
}

cabinet_assembled();
pcb_mounts();
inductors();
theremin_pcbs();
color("white") panels();
stand_mount();

antennas();
tablet_standing();
