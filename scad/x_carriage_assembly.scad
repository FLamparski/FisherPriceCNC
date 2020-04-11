include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/linear_bearings.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/zipties.scad>

include <common_consts.scad>
include <common_defs.scad>
include <x_axis_common.scad>

use <laser.scad>

bearing_type = LM8UU;
b_len = bearing_length(bearing_type);
b_dia = bearing_dia(bearing_type);
rod_dia = bearing_rod_dia(bearing_type);

belt_thk = belt_thickness(GT2x6);
belt_p = belt_pitch(GT2x6);
tooth_h = belt_tooth_height(GT2x6);

belt_nut_size = nut_radius(M3_nut) * 2;
belt_chan_w = belt_width(GT2x6) + 1;
belt_h = b_dia / 2 + 4.5;

module x_carriage_back_base() {
    difference() {
        union() {
            translate([20, 10, 60])
            rotate([0, 90, 180])
            linear_extrude(40)
            polygon([[5, 0], [0, 10], [80, 10], [75, 0]]);

            translate([0, 0, x_rods_pitch / 2])
            cube([40, 10, 20], center = true);
        }
    
        // space for the bearings
        rotate([0, 90, 0]) {
            cylinder(r = b_dia / 2 + 0.1, h = b_len + 0.2, center = true);
            cylinder(r = rod_dia / 2 + 1, h = 41, center = true);
        }

        translate([0, 0, x_rods_pitch])
        rotate([0, 90, 0]) {
            cylinder(r = b_dia / 2 + 0.1, h = b_len + 0.2, center = true);
            cylinder(r = rod_dia / 2 + 1, h = 41, center = true);
        }
    }
}

module x_carriage_back_stl() {
    stl("x_carriage_back");

    difference() {
        x_carriage_back_base();

        // space for the belt
        translate([-25, -rod_r, x_rods_pitch / 2])
        translate([0, -5, -18/2])
        cube([50, rod_r * 2 + 5, 4]);

        // this is where the belt fits in
        num_teeth = 15 / belt_p;
        translate([-20, -rod_r, x_rods_pitch / 2])
        translate([0, -5, 18/2 - 1]) {
            cube([15, rod_r * 2 + 5, 1]);
            for (i = [0:num_teeth]) {
                translate([i * belt_p, 0, -1])
                cube([1, rod_r * 2 + 5, 1]);
                
                rotate([5, 0, 0])
                translate([i * belt_p, -5, -2])
                cube([1, rod_r * 2 + 5, 0.75]);
            }
        }

        translate([5, -rod_r, x_rods_pitch / 2])
        translate([0, -5, 18/2 - 1]) {
            cube([15, rod_r * 2 + 5, 1]);
            for (i = [0:num_teeth]) {
                translate([i * belt_p, 0, -1])
                cube([1, rod_r * 2 + 5, 1]);

                rotate([5, 0, 0])
                translate([i * belt_p, -5, -2])
                cube([1, rod_r * 2 + 5, 0.75]);
            }
        }

        // holes for screws holding the x-carriage together
        screw_pos = [
            [0, 0, -b_dia / 2 - 5],
            [0, 0, x_rods_pitch + b_dia / 2 + 5],
            [0, 0, x_rods_pitch / 2]
        ];
        for (pos = screw_pos) {
            translate(pos)
            rotate([90, 0, 0]) {
                cylinder(r = screw_clearance_radius(M3_cap_screw), h = 30, center = true);

                translate([0, 0, -8])
                cylinder(r = screw_head_radius(M3_cap_screw) + 1, h = 10, center = true);
            }
        }
    }
}

module x_carriage_front_stl() {
    stl("x_carriage_front");

    difference() {
        union() {
            rotate([0, 0, 180])
            x_carriage_back_base();

            translate([-20, -10, x_rods_pitch + b_dia / 2])
            cube([40, 10, 20]);
        }

        x_carriage_back_base();

        // Laser mounting
        translate([0, 0, x_rods_pitch / 2])
        rotate([90, 0, 0]) {
            for (x = [-10, 0, 10]) {
                translate([x, 0, 0]) {
                    cylinder(r = screw_clearance_radius(M3_pan_screw), h = 30, center = true);

                    if (x != 0) {
                        translate([0, 0, 6.5])
                        cylinder(r = screw_head_radius(M3_pan_screw) + 0.25, h = screw_head_height(M3_pan_screw) + 1, center = true);
                    }
                }
            }
        }

        translate([0, 0, x_rods_pitch / 2 + 40])
        rotate([90, 0, 0]) {
            for (x = [-10, 0, 10]) {
                translate([x, 0, 0]) {
                    cylinder(r = screw_clearance_radius(M3_pan_screw), h = 30, center = true);

                    translate([0, 0, -screw_head_height(M3_pan_screw)])
                    cylinder(r = screw_head_radius(M3_pan_screw) + 0.25, h = 10);
                }
            }
        }


        // nut traps for the x-carriage front, for screw pulled nuts
        trap_pos = [
            [0, -7, -b_dia / 2 - 5],
            [0, -7, x_rods_pitch + b_dia / 2 + 5]
        ];
        for (pos = trap_pos) {
            translate(pos)
            rotate([90, 0, 0]) {
                nut_trap(M3_cap_screw, M3_nut);
            }
        }


        // Mount for the wire holder
        translate([17, -5, 64])
        rotate([0, 0, -90])
        square_nut_trap(M3nS_thin_nut);
    }
}

module laser_wire_holder_stl() {
    stl("laser_wire_holder");

    difference() {
        union() {
            translate([-5, -5, 0])
            cube([10, 12, 2]);

            translate([-5, 5, 0])
            cube([10, 2, 20]);

            translate([0, 4, 20])
            rotate([0, 90, 0])
            cylinder(r=3, h=10, center=true);
        }

        translate([2, 4, 21.5])
        rotate([0, 90, 0])
        cylinder(r=1.75/2, h=10, center=true);

        translate([2, 4, 18.5])
        rotate([0, 90, 0])
        cylinder(r=1.75/2, h=10, center=true);

        translate([-1, 2.5, 15])
        cube([5, 5, 2]);

        translate([0, -2, 1])
        cylinder(r = screw_clearance_radius(M3_cap_screw), h = 3, center = true);
    }
}

module x_carriage_assembly()
assembly("x_carriage") {
    color(printed_part_color)
    x_carriage_back_stl();

    color(printed_part_color)
    x_carriage_front_stl();

    translate([0, 0, x_rods_pitch])
    rotate([0, 90, 0])
    linear_bearing(bearing_type);

    rotate([0, 90, 0])
    linear_bearing(bearing_type);

    translate([0, 0, -b_dia / 2 - 5])
    rotate([90, 0, 0]) {
        translate([0, 0, 4])
        nut(M3_nut);

        translate([0, 0, -5])
        rotate([0, 180, 0])
        screw(M3_cap_screw, 12);
    }

    translate([0, 0, x_rods_pitch + b_dia / 2 + 5])
    rotate([90, 0, 0]) {
        translate([0, 0, 4])
        nut(M3_nut);

        translate([0, 0, -5])
        rotate([0, 180, 0])
        screw(M3_cap_screw, 12);
    }

    translate([0, 5, x_rods_pitch / 2])
    rotate([90, 0, 180])
    screw(M3_cap_screw, 20);

    translate([0, -4, x_rods_pitch / 2 + 40]) {
        for (x = [-10, 0, 10]) {
            translate([x, 0, 0])
            rotate([90, 0, 180])
            screw(M3_pan_screw, 12);
        }
    }

    translate([17, -5, 64])
    nut_square(M3nS_thin_nut);

    translate([15, -5, 67.5])
    rotate([0, 0, 90])
    color(printed_part_color)
    laser_wire_holder_stl();

    translate([17, -5, 69.5])
    screw(M3_pan_screw, 5);

    translate([10, -3.5, 89])
    rotate([90, -90, 0])
    ziptie(small_ziptie, 5);

    translate([0, -30, 14])
    rotate([0, 0, 180])
    laser_module_assembly();
}

if ($preview) {
    x_carriage_assembly();
}