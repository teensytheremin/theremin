include <cabinet_bottom.scad>
include <cabinet_top.scad>
include <cabinet_side.scad>
include <cabinet_front.scad>
include <cabinet_tablet_mount.scad>
include <pitch_antenna.scad>
include <volume_antenna.scad>
include <mic_stand_mount.scad>
include <inductor_ppl_frame.scad>
include <cabinet_params.scad>

module laser_cut_inductor_mounts(spacing=7) {
    w = cabinet_height - 4 + spacing;
    w2 = 30;
    translate([0,35]) {
        for ( y = [0 : 1] )
            for ( i = [0 : 1] ) {
                translate([w/2 + w*i,-y*45]) inductor_mount_flat();
            }
        for ( i = [0 : 1] ) {
            translate([w2/2 + w*2,w/2 - i*(20 + spacing)]) inductor_mount_side_flat();
        }
    }
    
    mw = 30;
    for ( y = [0 : 2] )
    for ( i = [0 : 3] ) {
        translate([20 + mw*i,-65 - y*25]) pcb_mount_flat(pcb_mount_h=pcb_mount_h, sheet_thickness=sheet_thickness, pcb_mount_width=pcb_mount_width, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding);
    }
}

module laser_cut_cabinet_main(spacing=7) {
    
    full_len = cabinet_length + spike_height*2;
    full_width = cabinet_width + sheet_thickness*2 + edge_extra*2;
    legs_height = mic_stand_mount_height + sheet_thickness / 2;
    full_height = cabinet_height + sheet_thickness*0 + edge_extra*0 + legs_height;
    side_width = full_width + sheet_thickness*4 + edge_extra*4;
    
    // bottom
    translate([0,0,0]) cabinet_bottom_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height,  volume_inductor_offset=volume_inductor_offset, inductor_mount_wall_dist = inductor_mount_wall_dist, pitch_inductor_offset = pitch_inductor_offset,
pitch_inductor_length = pitch_inductor_length, pitch_inductor_side_offset=pitch_inductor_side_offset, pcb_length=pcb_length);
    
    // top
    translate([0,full_width+spacing,0]) cabinet_top_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height); 

    side_y = -full_width/2-spacing-full_height/2;
    side_x = -full_len/2 + side_width/2;
    // left side
    translate([side_x,side_y,0]) cabinet_side_left_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, mic_stand_mount_height = mic_stand_mount_height);

    // right side
    translate([side_x + side_width + spacing + 25,side_y ,0]) cabinet_side_right_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width,   cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width=spike_width, spike_height=spike_height, mic_stand_mount_height = mic_stand_mount_height);

    // front
     translate([0,full_width + spacing + full_width/2 + spacing/2 + full_height/2, 0]) cabinet_face_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding,
    panel_offset_y = front_panel_offset_y,
    spike_width=spike_width, spike_height=spike_height);

    // back
    translate([0,full_width + spacing + full_width/2 + spacing/2 + full_height*1.5, 0]) cabinet_face_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height= cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding, panel_offset_y = rear_panel_offset_y,
spike_width=spike_width, spike_height=spike_height);


    y2 = -210;  
    // left holder
    translate([-full_len + 270,y2]) cabinet_tablet_mount_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, angle=holder_angle, spike_width = spike_width, spike_height = spike_height, front_extra=holder_front_extra);
    // right holder
    translate([-full_len + 420, y2+60]) rotate([0,0,180]) cabinet_tablet_mount_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, angle=holder_angle, spike_width = spike_width, spike_height = spike_height, front_extra=holder_front_extra);

}

module laser_cut_layout() {
    laser_cut_cabinet_main();
    translate([80,-100]) laser_cut_inductor_mounts();    
}



//projection() translate([0,0,-1]) linear_extrude(2) 
laser_cut_layout();
//laser_cut_cabinet_main();
//laser_cut_inductor_mounts();