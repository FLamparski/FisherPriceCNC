include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/microswitches.scad>

x_rods_pitch = 40;
x_rods_margin = 20;
x_overhang = 10;
x_overhang_height = 15;
x_gantry_thickness = 16;
x_max_height = x_rods_pitch + x_rods_margin + x_overhang_height;

rod_r = 4;
rod_z_base = x_overhang_height + rod_r + x_rods_margin / 2;
base_thickness = 2;
x_rod_pressfit = 12;

module x_end_base() {
    difference() {
        union() {
            // base
            cube([y_carriage_base_width(), y_carriage_base_length(), base_thickness]);

            // stability
            translate([0, 0, base_thickness])
            pyramid(
                [y_carriage_base_width(), y_carriage_base_length()],
                [29.5, x_gantry_thickness],
                11.5
            );

            // support for the rods
            translate([0, x_gantry_thickness / 2 + y_carriage_base_length() / 2, base_thickness])
            rotate([90, 0, 0])
            linear_extrude(x_gantry_thickness) {
                polygon([
                    [0, 0],
                    [y_carriage_base_width() - x_overhang, x_max_height],
                    [y_carriage_base_width() + x_overhang, x_max_height],
                    [y_carriage_base_width() + x_overhang, x_overhang_height],
                    [y_carriage_base_width(), 0]]
                );
            }

            // mounting point for the limit switch
            translate([44.8, 21.3, x_max_height])
            cylinder(r = 1.15, h = 10);

            translate([44.8, 30.8, x_max_height])
            cylinder(r = 1.15, h = 10);
        }

        translate([y_carriage_base_width() / 2, y_carriage_base_length() / 2, 0]) {

            // the rods
            translate([y_carriage_base_width() / 2 + x_overhang - x_rod_pressfit, 0, rod_z_base])
            rotate([0, 90, 0])
            cylinder(r=rod_r + 0.05, h=50);

            translate([y_carriage_base_width() / 2 + x_overhang - x_rod_pressfit, 0, rod_z_base + x_rods_pitch])
            rotate([0, 90, 0])
            cylinder(r=rod_r + 0.05, h=50);

            // hole for the belt
            translate([-10, -rod_r, rod_z_base + x_rods_pitch / 2])
            translate([0, 0, -18/2])
            cube([50, rod_r * 2, 18]);

            y_carriage_mounting_screw_positions() {
                cylinder(r=screw_clearance_radius(M3_cap_screw), h=10);

                translate([0, 0, base_thickness])
                cylinder(r=screw_head_radius(M3_cap_screw) + 0.25, h=10);
            }

        }
    }
}