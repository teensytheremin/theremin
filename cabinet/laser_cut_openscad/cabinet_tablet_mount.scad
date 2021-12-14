include <rounded_rectangle.scad>

module cabinet_tablet_mount_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, angle=60, spike_width = 20, spike_height = 9) {
    w = cabinet_length + sheet_thickness*2 + edge_extra*2;
    h = cabinet_width + sheet_thickness*2 + edge_extra*2;
    //echo(spike_width=spike_width, spike_height=spike_height, edge_rounding=edge_rounding);
    long_side_spike_count = 4;
    tablet_mount_offset = cabinet_length/long_side_spike_count/2;
    
    side_width = edge_extra + sheet_thickness;
    bottom_width = cabinet_width + 2*sheet_thickness + 2*side_width;
    bottom_height = side_width;

    holder_length = 150;
    holder_width = side_width*1.2;
    holder_tip_width = side_width*1.2+edge_rounding;
    holder_tip_length = 14+edge_rounding*2;

    holder_rotate_pos_x = cabinet_width/2+sheet_thickness+side_width/2;
    holder_rotate_pos_y = bottom_height/2;
    
    holder_leg_position = bottom_width/2 * 5/6;
    
    
    union () {
        // bottom body
        translate([0,bottom_height/2,0]) rounded_rectangle(width=bottom_width,height=bottom_height, radius=edge_rounding*1.5);
        
        translate([0, -spike_height/2, 0]) rounded_spike_down(width=spike_width, height=spike_height, radius=edge_rounding);
        // left edge spike
        translate([-bottom_width/2+side_width/2, -(spike_height + bottom_height/2)/2 + bottom_height/2, 0]) rounded_spike_down(width=side_width, height=spike_height + bottom_height/2, radius=edge_rounding);
        // right edge spike
        translate([bottom_width/2-side_width/2, -(spike_height + bottom_height/2)/2 + bottom_height/2, 0]) rounded_spike_down(width=side_width, height=spike_height + bottom_height/2, radius=edge_rounding);
    //    translate([bottom_width/2-side_width/2, 0, 0]) rounded_spike_down(width=side_width, height=spike_height*2, radius=edge_rounding);
        
        
        
        difference() {
            translate([-holder_leg_position,bottom_height/2,0]) rotate([0,0,-angle/8]) square([holder_width, holder_length]);

            translate([holder_rotate_pos_x,holder_rotate_pos_y,0]) rotate([0,0,-angle]) {
                translate([-holder_length/2+edge_rounding-holder_tip_width+edge_rounding*2-holder_width,+edge_rounding*2 + holder_length/2,0]) rounded_rectangle(holder_length, holder_length, edge_rounding);
            }
        }
        
        translate([holder_rotate_pos_x,holder_rotate_pos_y,0]) rotate([0,0,-angle]) {
            translate([-holder_tip_width+edge_rounding,+edge_rounding*2,0])
            // rounded holder tip
            difference() {
                union () {
                    // main body boxes
                    translate([edge_rounding,-holder_width,0]) square([holder_tip_width-edge_rounding*2, holder_width+holder_tip_length]);
                    translate([edge_rounding,-holder_width+edge_rounding*2,0]) square([holder_tip_width, holder_width+holder_tip_length-edge_rounding*4]);
                    translate([edge_rounding,holder_tip_length-edge_rounding,0]) circle(edge_rounding);
                    translate([holder_tip_width-edge_rounding,holder_tip_length-edge_rounding*2,0]) circle(edge_rounding*2);

                    // bottom - rounded connection between tip and main part
                    translate([holder_tip_width-edge_rounding,-holder_width+edge_rounding*2,0]) circle(edge_rounding*2);
                }
                translate([0,(holder_tip_length-2*edge_rounding)/2,0]) rounded_rectangle(edge_rounding*4, holder_tip_length-2*edge_rounding, 3);
            }
      
    //            difference() {
    //                translate([edge_rounding,0,0]) square([holder_tip_width-edge_rounding*2,holder_tip_length]);
    //                translate([0,(holder_tip_length-2*edge_rounding)/2,0]) rounded_rectangle(edge_rounding*4, holder_tip_length-2*edge_rounding, 3);;
    //                //square([10,10]);
    //            }
            // long holder part
            translate([-holder_length/2+edge_rounding-holder_tip_width+edge_rounding*2,-holder_width/2+edge_rounding*2,0]) rounded_rectangle(holder_length, holder_width, edge_rounding);
        }
    }
    
    
    //color("red") translate([holder_rotate_pos_x, holder_rotate_pos_y, 0]) circle(3);
}


module cabinet_tablet_mount(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, angle=60, spike_width = 20, spike_height = 9) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_tablet_mount_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction, spike_width = spike_width, spike_height = spike_height);
}

//cabinet_tablet_mount_flat();
