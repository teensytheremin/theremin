include <rounded_rectangle.scad>

module cabinet_tablet_mount_flat(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=3, ray_correction=0.1, angle=50) {
    w = cabinet_length + sheet_thickness*2 + edge_extra*2;
    h = cabinet_width + sheet_thickness*2 + edge_extra*2;
    spike_width = sheet_thickness * 3; // + ray_correction*2;
    spike_height = sheet_thickness + edge_extra;
    //echo(spike_width=spike_width, spike_height=spike_height, edge_rounding=edge_rounding);
    long_side_spike_count = 4;
    tablet_mount_offset = cabinet_length/long_side_spike_count/2;
    
    side_width = edge_extra + sheet_thickness;
    bottom_width = cabinet_width + 2*sheet_thickness + 2*side_width;
    bottom_height = 30;
    translate([0,bottom_height/2,0]) rounded_rectangle(width=bottom_width,height=bottom_height, radius=edge_rounding);
    
    translate([0, -spike_height/2, 0]) rounded_spike_down(width=spike_width, height=spike_height, radius=edge_rounding);
    // left edge spike
    translate([-bottom_width/2+side_width/2, 0, 0]) rounded_spike_down(width=side_width, height=spike_height*2, radius=edge_rounding);
    // right edge spike
    translate([bottom_width/2-side_width/2, 0, 0]) rounded_spike_down(width=side_width, height=spike_height*2, radius=edge_rounding);
    
    holder_length = 150;
    holder_width = side_width*1.5;
    
    //translate([0,bottom_width/2,0])
    //color("blue") 
    translate([0,0,0]) 
    //rotate([0,0,-angle]) 
    {
        translate([-(holder_length-holder_width)/2,0,0]) rounded_rectangle(width=holder_length,height=holder_width, radius=edge_rounding);
        //rotate([0,0,-90])
        union() {
            color("blue") translate([-(holder_width)/2,0,0]) rounded_rectangle(width=holder_width+10,height=holder_width, radius=edge_rounding);
            color("red") translate([-(holder_width/2+5/2),-5,0]) circle(r=5);
        }
    }
}


module cabinet_tablet_mount(cabinet_length=400, cabinet_width=63, cabinet_height=40, sheet_thickness=5, edge_extra=5, edge_rounding=4, ray_correction=0.1) {
    translate([0,0,-sheet_thickness/2]) linear_extrude(sheet_thickness)
        cabinet_tablet_mount_flat(cabinet_length=cabinet_length, cabinet_width=cabinet_width, cabinet_height=cabinet_height, sheet_thickness=sheet_thickness, edge_extra=edge_extra, edge_rounding=edge_rounding, ray_correction=ray_correction);
}

cabinet_tablet_mount_flat();