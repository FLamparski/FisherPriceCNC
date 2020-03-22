include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <common_consts.scad>

use <y_motor_assembly.scad>

//! This is the back side of the machine. Mount the stepper motor assemblies onto the 3030 profile
//! taking care to align the edges together.
module back_assembly()
assembly("back") {
    rotate([0, 90, 0])
    extrusion(extrusion_type, outer_width);

    translate([-inner_width / 2 - 16, 6, ew / 2 + NEMA_width(NEMA17S) / 2 + 2])
    rotate([0, -90, 0])
    y_motor_left_assembly();

    translate([inner_width / 2 + 16, 6, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, 90, 0])
    y_motor_right_assembly();
}

if ($preview) {
    back_assembly();
}