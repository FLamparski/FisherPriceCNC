include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

include <../common_consts.scad>

module frame_assembly()
assembly("frame") {
    y_axis_offset = inner_width / 2 + ew;
    x_axis_offset = (rod_length_mm + ew) / 2;
    
    rotate([0, 0, 90]) {
        translate([0, y_axis_offset, 0])
        rotate([0, 90, 0])
        extrusion(double_width_extrusion_type, rod_length_mm);

        translate([0, -y_axis_offset, 0])
        rotate([0, 90, 0])
        extrusion(double_width_extrusion_type, rod_length_mm);

        translate([x_axis_offset, 0, 0])
        rotate([90, 90, 0])
        extrusion(extrusion_type, outer_width);

        translate([-x_axis_offset, 0, 0])
        rotate([90, 90, 0])
        extrusion(extrusion_type, outer_width);

        translate([rod_length_mm / 2, inner_width / 2, 0])
        rotate([0, 0, 180])
        extrusion_corner_bracket_assembly(E20_corner_bracket);

        translate([-rod_length_mm / 2, -inner_width / 2, 0])
        extrusion_corner_bracket_assembly(E20_corner_bracket);

        translate([rod_length_mm / 2, -inner_width / 2, 0])
        rotate([0, 0, 90])
        extrusion_corner_bracket_assembly(E20_corner_bracket);

        translate([-rod_length_mm / 2, inner_width / 2, 0])
        rotate([0, 0, -90])
        extrusion_corner_bracket_assembly(E20_corner_bracket);
    }
}