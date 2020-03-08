include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rod.scad>

include <common_consts.scad>

use <y_axis_holder_assembly.scad>

module y_rod_assembly()
assembly("y_rod") {
    translate([0, 0, y_holder_rod_offset])
    rotate([90, 0, 0])
    rod(8, rod_length_mm);

    translate([0, rod_length_mm / 2 - 5.5, 0])
    rotate([0, 0, 180])
    y_axis_holder_assembly();

    translate([0, -rod_length_mm / 2 + 5.5, 0])
    rotate([0, 0, 180])
    y_axis_holder_assembly();
}

if ($preview) {
    y_rod_assembly();
}