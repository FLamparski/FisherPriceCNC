include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/belts.scad>


include <common_consts.scad>
include <common_defs.scad>
include <x_axis_common.scad>

use <x_motor_holder_assembly.scad>
use <x_idler_assembly.scad>

mpmd_shittines_adjustment = -2;

module x_axis_assembly()
assembly("x_axis") {
    translate([0, 0, rod_z_base])
    rotate([0, 90, 0])
    rod(d = 8, l = rod_length_mm + mpmd_shittines_adjustment);
    
    translate([0, 0, rod_z_base + x_rods_pitch])
    rotate([0, 90, 0])
    rod(d = 8, l = rod_length_mm + mpmd_shittines_adjustment);

    translate([-inner_width / 2 - ew, 0, 0])
    x_motor_holder_assembly();

    translate([inner_width / 2 + ew, 0, 0])
    x_idler_assembly();
}

if ($preview) {
    x_axis_assembly();
}