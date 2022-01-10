//use  <cabinet_bottom.scad>
//use <cabinet_top.scad>
//use <cabinet_side.scad>
//use <cabinet_front.scad>
//use <cabinet_tablet_mount.scad>
//use <pitch_antenna.scad>
//use <volume_antenna.scad>
//use <mic_stand_mount.scad>
//use <inductor_ppl_frame.scad>
use <theremin_pcb.scad>
include <cabinet_params.scad>

module laser_cut_panels(spacing = 7) {
    translate([0,-cabinet_height/2-spacing,0])
    front_panel_flat(panel_width=panel_width+20, panel_height=cabinet_height, panel_thickness=panel_thickness, pcb_dy=pcb_dy);
    translate([0,cabinet_height/2,0])
    rear_panel_flat(panel_width=panel_width+20, panel_height=cabinet_height, panel_thickness=panel_thickness, pcb_dy=pcb_dy);
}

laser_cut_panels();
