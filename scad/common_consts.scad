include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/extrusions.scad>

y_holder_rod_offset = 9 + 8 - 0.5;

rod_length_mm = 335;
rod_pressfit_length_mm = 10;
extrusion_type = E3030;
double_width_extrusion_type = E3060;

ew = extrusion_width(extrusion_type);
inner_width = rod_length_mm - rod_pressfit_length_mm * 2;
outer_width = inner_width + 2 * 2 * ew;

echo(str("outer_width = ", outer_width, " mm"));