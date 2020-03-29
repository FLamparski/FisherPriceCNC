include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>

printed_part_color = "orange";

y_holder_rod_offset = 9 + 8 - 0.5;

rod_length_mm = 345;
inner_margin = -10;
extrusion_type = E3030;
double_width_extrusion_type = E3060;

ew = extrusion_width(extrusion_type);
inner_width = rod_length_mm + inner_margin * 2;
outer_width = inner_width + 2 * 2 * ew;

echo(str("outer_width = ", outer_width));

layer_height = 0.2;