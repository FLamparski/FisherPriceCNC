include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <common_consts.scad>

use <y_axis_holder_assembly.scad>
use <y_limit_switch_assembly.scad>
use <y_carriage_base_assembly.scad>

//! There are two y-axes in the machine. To assemble one y-axis, do the following:
//!
//! 1. Mount the y-axis holders onto the wide side of the 3060 profile. Align the edges.
//! 2. Mount the limit switches on the desired side of the profile. Align the edges.
//! 3. Insert the metal rods into the y-carriage base assembly.
//! 4. Place the rods together with the y-carriage base into the y-axis holders. Make sure that the
//!    limit switch paddles are sticking out on the side where the limit switches are!
//! 5. Secure the rods with zipties or solid core wire twisted together.
module y_axis_assembly()
assembly("y_axis") {
    holder_locations = [
        [rod_length_mm / 2 - 5.5, ew / 2, ew / 2],
        [-rod_length_mm / 2 + 5.5, ew / 2, ew / 2],
        [-rod_length_mm / 2 + 5.5, -ew / 2, ew / 2],
        [rod_length_mm / 2 - 5.5, -ew / 2, ew / 2]
    ];

    rotate([0, 90, 0])
    extrusion(double_width_extrusion_type, rod_length_mm);

    for (loc = holder_locations) {
        translate(loc)
        rotate([0, 0, 90])
        y_axis_holder_assembly();
    }

    translate([0, -ew / 2, y_holder_rod_offset + ew / 2])
    rotate([90, 0, 90])
    rod(8, rod_length_mm);
    
    translate([0, ew / 2, y_holder_rod_offset + ew / 2])
    rotate([90, 0, 90])
    rod(8, rod_length_mm);

    translate([rod_length_mm / 2 - ew / 2, ew, -ew / 2])
    rotate([0, 0, 90])
    y_limit_switch_assembly();

    translate([-rod_length_mm / 2 + ew / 2, ew, -ew / 2])
    mirror([0, 1, 0])
    rotate([0, 0, -90])
    y_limit_switch_assembly();

    translate([0, 0, ew / 2 + y_holder_rod_offset])
    rotate([0, 0, 90])
    y_carriage_base_assembly();
}

if ($preview) {
    y_axis_assembly();
}