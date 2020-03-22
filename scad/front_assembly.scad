include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <common_consts.scad>

use <y_idler_assembly.scad>

//! This is the front side of the machine. Mount the idler assemblies onto the 3030 profile
//! taking care to align the edges together.
module front_assembly()
assembly("front") {
    rotate([0, 90, 0])
    extrusion(extrusion_type, outer_width);

    translate([-inner_width / 2 - ew, 0, ew / 2])
    y_idler_assembly();

    translate([inner_width / 2 + ew, 0, ew / 2])
    y_idler_assembly();
}

if ($preview) {
    front_assembly();
}