pcb_width=60.96;
pcb_length=210.82;
pcb_thickness=1.6;

cabinet_length=420;
cabinet_height=44;

panel_width=120;
panel_height=cabinet_height*0.65;
panel_rounding=panel_height/2-1;
panel_thickness=1;
panel_extra_space=0.3;
front_panel_offset_y = -2;
rear_panel_offset_y = -2;

cabinet_width=pcb_width + panel_thickness*2 + panel_extra_space*2;

sheet_thickness=4;
edge_extra=5;
edge_rounding=3;

ray_correction=-0.2;

// laser cut parts mounting spikes dimensions
spike_width = 16;
spike_height = sheet_thickness + edge_rounding + 0.5;


pcb_dy = -12;
pcb_mount_h = cabinet_height/2 + pcb_dy; // - pcb_thickness;
pcb_mount_offset = panel_thickness + panel_extra_space;
pcb_mount_width = spike_width + 10;


holder_angle=60;


inductor_mount_wall_dist = 0.5;

inductor_frame_d = 32;
inductor_frame_internal_d = 20;
inductor_mount_spring_thickness = 2.2;
inductor_mount_spring_angle = 13;

volume_inductor_offset = 44;
volume_inductor_winding_len=45;

pitch_inductor_offset = inductor_frame_d/2 + inductor_mount_spring_thickness*2; //cabinet_height/2 + 1;
pitch_inductor_side_offset = 25-sheet_thickness;

pitch_inductor_length = 51;
pitch_inductor_winding_len=35;



sensor_pcb_length=35.56 - 2.54*2 + 2.54;
//sensor_pcb_length=33.02;
//sensor_pcb_width=25.4;
//sensor_pcb_width=22.86;
sensor_pcb_width=20.32;

