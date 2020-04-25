include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/screws.scad>
include <common_consts.scad>

use <y_motor_assembly.scad>
use <electronics_assembly.scad>

module ele_bracket_stl() {
    stl("ele_bracket");

    box_footprint = [114, 94];
    x_dim = box_footprint[0] + 4;

    translate([0, 0, ew / 2 - 3])
    difference() {
        union() {
            translate([-x_dim/2, 0, 0])
            cube([x_dim, box_footprint[1], 8]);

            translate([0, 0, -ew + 3])
            rotate([90, 0, 90])
            translate([0, 0, -x_dim/2])
            linear_extrude(x_dim)
            polygon([[0, 0], [0, ew - 3], [box_footprint[1], ew - 3], [20, 0]]);
        }

        translate([-box_footprint[0]/2, 0, 3])
        cube([box_footprint[0], box_footprint[1], 15]);

        translate([-x_dim/2 + 10, 5, -ew + 3])
        cube([x_dim - 20, box_footprint[1], ew - 3]);

        translate([30, 0, -(ew - 3) / 2])
        rotate([90, 0, 0])
        cylinder(r=screw_clearance_radius(M4_cap_screw), h=10, center=true);

        translate([-30, 0, -(ew - 3) / 2])
        rotate([90, 0, 0])
        cylinder(r=screw_clearance_radius(M4_cap_screw), h=10, center=true);

        translate([25, box_footprint[1] / 2 + 15, 0])
        cylinder(r=screw_clearance_radius(M3_cap_screw), h=10, center = true);

        translate([25, box_footprint[1] / 2 - 10, 0])
        cylinder(r=screw_clearance_radius(M3_cap_screw), h=10, center = true);
    }
}

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

    translate([0, 62, 0]) {
        translate([0, 0, 15])
        electronics_assembly();

        color(printed_part_color)
        translate([0, -47, 0])
        ele_bracket_stl();
    }
}

if ($preview) {
    back_assembly();
}