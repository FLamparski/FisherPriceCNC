include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/nuts.scad>

include <common_consts.scad>
include <common_defs.scad>

module square_nut_lug(nut_type = M3nS_thin_nut, flying = false) {
    nut_h = nut_square_thickness(nut_type);
    nut_w = nut_square_width(nut_type);

    union() {
        difference() {
            cube([nut_w * 2, nut_w * 2, nut_h * 3], center = true);

            translate([0, 0, -nut_h / 2])
            square_nut_trap(nut_type);
        }

        if (flying) {
            translate([nut_w, -nut_w, -nut_h * 3 / 2])
            rotate([-90, 0, 90])
            linear_extrude(nut_w * 2)
            polygon(points=[
                [0, 0],
                [0, nut_w * 2],
                [nut_w * 2, 0]
            ]);
        }
    }
}

if ($preview) {
    square_nut_lug(flying = true);
}