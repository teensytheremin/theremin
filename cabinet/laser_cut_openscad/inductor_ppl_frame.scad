include <rounded_rectangle.scad>

module inductor_ppl_frame(frame_len=62, frame_d=32, frame_internal_d=20, winding_len=45) {
    rotate([0,00,0])
    union() {
        color("gold") difference() {
            cylinder(h=winding_len, d=frame_d+0.2, center=true);
            cylinder(h=winding_len+2, d=frame_d-0.2, center=true);
        }
        color("white") difference() {
            cylinder(h=frame_len, d=frame_d, center=true);
            cylinder(h=frame_len+2, d=frame_internal_d, center=true);
        }   
    }
}

module ring_segment(inner_d=32, outer_d=35, angle1=30, angle2=-30) {
    difference() {
        circle(d=outer_d);
        circle(d=inner_d);
        rotate([0,0,angle1]) translate([-outer_d/2-1,0,0]) square([outer_d+2, outer_d/2+2]);
        rotate([0,0,180+angle2]) translate([-outer_d/2-1,0,0]) square([outer_d+2, outer_d/2+2]);
    }
}

module spring_holder(inner_d=32, outer_d=35, cabinet_height=44, angle=12) {
    // params
    spring_width = (outer_d-inner_d)/2;
    middle_d = (inner_d + outer_d) / 2;
    dx = sin(angle)*middle_d/2;
    dy = middle_d/2 - cos(angle)*middle_d/2;
    straight_len = cabinet_height/2-dx;
    
    ring_segment(inner_d=inner_d, outer_d=outer_d, angle1=angle+1, angle2=-angle-1);
    translate([middle_d-dy*2.0, dx*2,0]) ring_segment(inner_d=inner_d, outer_d=outer_d, angle1=-angle, angle2=angle);
    translate([middle_d-dy*2.0, -dx*2,0]) ring_segment(inner_d=inner_d, outer_d=outer_d, angle1=-angle, angle2=0);
    
    // top rounding
    translate([middle_d/2-dy,dx*3,0]) circle(d=spring_width);
    //translate([middle_d/2-dy,-dx*3,0]) circle(d=(outer_d-inner_d)/2);
    // straight bottom
    translate([inner_d/2-dy*2,-straight_len,0]) square([spring_width, straight_len-dx*2]);
    // wide bottom
    bottom_h = cabinet_height/2-dx*2;
    bottom_y = -cabinet_height/2+bottom_h;
    //bottom_x = cabinet_height/2+1;
    bottom_x = outer_d/2 + 0.6;
    bottom_cut_h = bottom_h - (cabinet_height/2-inner_d/2) - 1;
    difference() {
        translate([-1,-cabinet_height/2,0]) square([bottom_x, bottom_h]);
        // inductor frame
        circle(d=inner_d);
        // inner cut
        translate([inner_d/2-dy*2-0.5,bottom_y-bottom_cut_h+0.1,0]) square([0.5, bottom_cut_h+0.2]);
        translate([inner_d/2-dy*2-0.25,bottom_y-bottom_cut_h+0.1,0]) circle(d=0.5);
        // outer cut
        translate([outer_d/2-2*dy+0.5+0.25,bottom_y,0]) offset(0.25) polygon([[-0.5,0],[0,-bottom_cut_h+0.25 - 2],[0.5,0]]);
    }
}

module inductor_mount_flat(cabinet_height=44, sheet_thickness=5, ray_correction=0.1, spike_width = 20, spike_height = 9, edge_rounding=3, frame_d=32, spring_thickness=2.2, spring_angle=13) {
    w = cabinet_height; //frame_d + spring_thickness*4;
    h2 = cabinet_height * 0.27;
    
    // right clip
    spring_holder(inner_d=frame_d-ray_correction, outer_d=frame_d+spring_thickness*2, cabinet_height=cabinet_height, angle=spring_angle);
    // left clip
    rotate([0,180,0]) spring_holder(inner_d=frame_d-ray_correction, outer_d=frame_d+spring_thickness*2, cabinet_height=cabinet_height, angle=spring_angle);
    
    // middle spike
    translate([0, -cabinet_height/2-spike_height/2, 0]) rounded_spike_down(width=spike_width/2, height=spike_height, radius=edge_rounding);
    
}

module inductor_mount_side_flat(cabinet_height=40, sheet_thickness=5, ray_correction=0.1, spike_width = 20, spike_height = 9, edge_rounding=3, frame_d=32, spring_thickness=2.2, spring_angle=13) {
    //square([cabinet_height/2,frame_d/2-2]);
    h = cabinet_height*0.3;
    w = frame_d*0.7;
    translate([0, -cabinet_height/2+h/2, 0]) rounded_spike_up(width=w, height=h, radius=h/2-1);
    // middle spike
    translate([0, -cabinet_height/2-spike_height/2, 0]) rounded_spike_down(width=spike_width/2, height=spike_height, radius=edge_rounding);
}

module inductor_mount_side(cabinet_height=40, sheet_thickness=5, ray_correction=0.1, spike_width = 20, spike_height = 9, edge_rounding=3, frame_d=32, spring_thickness=2.2, spring_angle=13) {
    rotate([90,0,0]) translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness) inductor_mount_side_flat(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=frame_d, spring_thickness=spring_thickness, spring_angle=spring_angle);
}

module inductor_mount(cabinet_height=44, sheet_thickness=5, ray_correction=0.1, spike_width = 20, spike_height = 9, edge_rounding=3, frame_d=32, spring_thickness=2.2, spring_angle=13) {
    rotate([90,0,0]) translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness) inductor_mount_flat(cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height, edge_rounding=edge_rounding, frame_d=frame_d, spring_thickness=spring_thickness, spring_angle=spring_angle);
}

//inductor_mount_side();
//inductor_mount_flat();


//spring_holder();

//translate([-62/2+5/2,0,0]) rotate([0,90,0]) inductor_mount();
//translate([+62/2-5/2,0,0]) rotate([0,90,0]) inductor_mount();
//rotate([0,90,0]) inductor_ppl_frame();
