include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <common_consts.scad>
include <common_defs.scad>
include <x_axis_common.scad>

use <y_carriage_base_assembly.scad>

module holder_wing() {
    thickness = 4;
    od = pulley_od(GT2x20_toothed_idler);
    base_len = 20;

    linear_extrude(thickness - 0.75) {
        difference() {
            polygon([
                [0, 0],
                [0, od],
                [od/2 + base_len, od],
                [od + base_len, od/2],
                [od/2 + base_len, 0]
            ]);

            translate([base_len + od - 2, 0, 0])
            square(size=[od, od]);
        }
    }
}

module x_idler_stl() {
    stl("x_idler");

    difference() {
        rotate([0, 0, 180])
        translate([-y_carriage_base_width() / 2, -y_carriage_base_length() / 2, 0])
        union() {
            x_end_base();

            translate([
                y_carriage_base_width() / 2 + 10,
                y_carriage_base_length() / 2 + pulley_height(GT2x20_toothed_idler) / 2 + 0.5,
                rod_z_base + x_rods_pitch / 2 - pulley_od(GT2x20_toothed_idler) / 2
            ])
            rotate([90, -45, 180])
            translate([0, -17.5, 0])
            holder_wing();

            translate([
                y_carriage_base_width() / 2 + 10,
                y_carriage_base_length() / 2 - pulley_height(GT2x20_toothed_idler) / 2 - 3.75,
                rod_z_base + x_rods_pitch / 2 - pulley_od(GT2x20_toothed_idler) / 2
            ])
            rotate([90, -45, 180])
            translate([0, -17.5, 0])
            holder_wing();
        }

        // Pulley affixation - should be M5 in general release
        translate([pulley_od(GT2x20_toothed_idler), 0, rod_z_base + x_rods_pitch / 2])
        rotate([90, 0, 0])
        cylinder(r=4.25/2, h=20, center=true);
    }
}

module x_idler_assembly()
assembly("x_idler") {
    color(printed_part_color)
    x_idler_stl();

    translate([pulley_od(GT2x20_toothed_idler), pulley_height(GT2x20_toothed_idler) / 2, rod_z_base + x_rods_pitch / 2])
    rotate([90, 0, 0])
    pulley(GT2x20_toothed_idler);

    // Pulley affixation - should be M5 in general release
    translate([pulley_od(GT2x20_toothed_idler), pulley_height(GT2x20_toothed_idler) / 2, rod_z_base + x_rods_pitch / 2])
    rotate([90, 0, 0]) {
        translate([0, 0, 12.5])
        screw(M4_cap_screw, 20);

        translate([0, 0, 12])
        washer(M4_washer);

        translate([0, 0, -4.5])
        washer(M4_washer);

        translate([0, 0, -7.5])
        nut(M4_nut);
    }
}

if ($preview) {
    x_idler_assembly();
}