$fa = 1;
$fs = 0.2;
//include <libraries/BOLTS/bolts.scad>
//include <libraries/threads-scad/threads.scad>
include <mounts_and_fittings.scad>


module pitch_antenna(length=500, diameter=10) {

    color("silver" )
    translate([0,0,length/2])
    difference () {
        cylinder(h=length,r=diameter/2,center=true);
        cylinder(h=length+2,r=diameter/2-1,center=true);
    }
}

module pitch_antenna_assembled(length=500, diameter=10, sheet_thickness=5,big_thread_d=20.7, big_thread_wall=2, big_thread_len=14, hex_len=12, small_thread_d=16.5, pipe_d=17, pipe1_len=20, pipe2_len=55) {
    translate([-big_thread_len+sheet_thickness,0,0]) {
        // fitting
        rotate([180,-90,0]) L082m_fitting(big_thread_d=big_thread_d, big_thread_wall=big_thread_wall, big_thread_len=big_thread_len, hex_len=hex_len, small_thread_d=small_thread_d, pipe_d=pipe_d, pipe1_len=pipe1_len, pipe2_len=pipe2_len);
        // antenna
        translate([(big_thread_len+hex_len+pipe1_len-pipe_d/2),0,pipe2_len*2/3]) pitch_antenna();
    }
    // fitting mount
    rotate([0,90,0]) fitting_mount_hex();
}

//L082m_fitting();
//fitting_mount_hex();
//pitch_antenna_assembled();
//hexcap();

//RodStart();

//pitch_antenna();