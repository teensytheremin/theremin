include <cabinet_bottom.scad>
include <cabinet_top.scad>
include <cabinet_side.scad>
include <cabinet_front.scad>
include <mic_stand_mount.scad>


pcb_width=60.96;
panel_thickness=1.5;
panel_extra_space=0.2;

cabinet_length=400;
cabinet_width=pcb_width + panel_thickness*2 + panel_extra_space*2;
cabinet_height=40;
sheet_thickness=5;
edge_extra=5;
edge_rounding=3;
ray_correction=-1;
panel_width=120;
panel_height=18;
panel_rounding=8;

module cabinet_assembled() {

    // bottom
    translate([0,0, -cabinet_height / 2 - sheet_thickness/2]) cabinet_bottom(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);

    // top
    translate([0,0, cabinet_height / 2 + sheet_thickness/2]) cabinet_top(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);

    // left side
    translate([-cabinet_length/2-sheet_thickness/2,0,   0]) rotate([90,0,-90]) cabinet_side_left(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);

    // right side
    translate([+cabinet_length/2+sheet_thickness/2,0,   0]) rotate([90,0,90]) cabinet_side_left(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);

    // front
    translate([0,-cabinet_width/2 - sheet_thickness/2, 0]) rotate([90,0,0]) cabinet_front(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding);

    // back
    translate([0,cabinet_width/2 + sheet_thickness/2, 0]) rotate([90,0,0]) cabinet_back(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height= cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, panel_width=panel_width, panel_height=panel_height, panel_rounding=panel_rounding);
}


cabinet_assembled();

color("silver") translate([0,0,-cabinet_height/2-sheet_thickness]) rotate([180,0,180]) mic_stand_mount();
