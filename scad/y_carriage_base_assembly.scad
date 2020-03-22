include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/linear_bearings.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/belts.scad>

include <common_consts.scad>
include <common_defs.scad>

bearing_type = LM8UU;
b_len = bearing_length(bearing_type);
b_dia = bearing_dia(bearing_type);
rod_dia = bearing_rod_dia(bearing_type);
housing_len = b_len * 2 + 4;
joiner_screw_offset = housing_len / 2 - 10;

belt_thk = belt_thickness(GT2x6);
belt_p = belt_pitch(GT2x6);
tooth_h = belt_tooth_height(GT2x6);

num_teeth = housing_len / belt_p;
belt_nut_size = nut_radius(M3_nut) * 2;
belt_chan_w = belt_width(GT2x6) + 1;
belt_h = b_dia / 2 + 4.5;

mounting_screw_positions = [
    [ew / 2 + 5, housing_len / 2 - 5, b_dia / 2 + 7],
    [-ew / 2 - 5, housing_len / 2 - 5, b_dia / 2 + 7],
    [-ew / 2 - 5, -housing_len / 2 + 5, b_dia / 2 + 7],
    [ew / 2 + 5, -housing_len / 2 + 5, b_dia / 2 + 7]
];

module y_carriage_base_stl() { //! The bottom half of the y-carriage - houses linear bearings and grips the belt.
    stl("y_carriage_base");

    difference() {
        union() {
            difference() {
                union() {
                    translate([-ew/2, 0, 0])
                    bearing_holder_2();

                    translate([ew/2, 0, 0])
                    bearing_holder_1();

                    translate([-(ew + b_dia + 2) / 2, -housing_len / 2, b_dia - 6])
                    cube([ew + b_dia + 2, housing_len, 9]);

                    rotate([180, 0, 0])
                    translate([-b_dia / 2, -housing_len / 2, -9])
                    pyramid([b_dia, housing_len], [b_dia, housing_len - 5], 3);
                }

                // belt channel
                translate([-belt_chan_w/2, -housing_len/2 - 1, belt_h])
                cube([belt_chan_w, housing_len + 2, 10]);
            }

            // belt teeth
            for (i = [0 : belt_p : housing_len]) {
                translate([belt_chan_w / 2, -housing_len / 2 + i, belt_h])
                rotate([0, -90, 0])
                cube([tooth_h, 1, belt_chan_w]);
            }
        }

        // nut trap for belt clamp
        translate([0, 0, b_dia - 9])
        rotate([0, 0, 30])
        nut_trap(M3_cap_screw, M3_nut);

        // cut off overhanging teeth
        translate([-belt_chan_w / 2 - 1, housing_len / 2, 0])
        cube([belt_chan_w + 2, belt_chan_w, 100]);
        translate([-belt_chan_w / 2 - 1, -housing_len / 2 - belt_chan_w, 0])
        cube([belt_chan_w + 2, belt_chan_w, 100]);

        // nut traps for mounting stuff on top of this thing
        for (pos = mounting_screw_positions) {
            translate(pos)
            rotate([0, 0, pos[0] < 0 ? 90 : -90])
            square_nut_trap(M3nS_thin_nut);
        }

        translate([ew / 2 + 5, 10, 9])
        rotate([90, 0, 90])
        square_nut_trap(M3nS_thin_nut, length = 30);

        translate([ew / 2 + 5, -10, 9])
        rotate([90, 0, 90])
        square_nut_trap(M3nS_thin_nut, length = 30);
    }

    module bearing_holder_1() {
        difference() {
            union() {
                rotate([90, 0, 0])
                cylinder(r1 = b_dia / 2 + 1, r2 = b_dia / 2 + 1, h = housing_len, center = true);
                
                translate([0, 0, b_dia / 2])
                cube([b_dia + 2, housing_len, b_dia], center = true);
            }

            remaining_len = housing_len - b_len;
            translate([0, remaining_len / 4 + 1, 0])
            rotate([90, 0, 0])
            cylinder(r1 = b_dia / 2, r2 = b_dia / 2, h = b_len + remaining_len / 2 + 2, center = true);

            rotate([90, 0, 0])
            cylinder(r1 = rod_dia / 2 + 1, r2 = rod_dia / 2 + 1, h = housing_len + 2, center = true);

            translate([0, 0, -b_dia / 2])
            cube([1, housing_len, 6], center = true);
        }

    }

    module bearing_holder_2() {
        difference() {
            union() {
                rotate([90, 0, 0])
                cylinder(r1 = b_dia / 2 + 1, r2 = b_dia / 2 + 1, h = housing_len, center = true);
                
                translate([0, 0, b_dia / 2])
                cube([b_dia + 2, housing_len, b_dia], center = true);
            }

            rotate([90, 0, 0])
            cylinder(r1 = b_dia / 2, r2 = b_dia / 2, h = housing_len + 10, center = true);

            translate([0, 0, -b_dia / 2])
            cube([1, housing_len, 6], center = true);
        }
    }
}

module y_carriage_belt_clamp_stl() { //! Part for clamping down the belt to the y-carriage.
    stl("y_carriage_belt_clamp");

    dim_x = belt_nut_size;

    difference() {
        translate([-dim_x/2, -housing_len/2])
        cube([dim_x, housing_len, 4]);

        screw_r = screw_head_radius(M3_cap_screw);
        translate([0, 0, 4 - screw_head_height(M3_cap_screw)])
        cylinder(r = screw_r, h = screw_head_height(M3_cap_screw));

        cylinder(r = 1.5, h = 10);
    }
}

module y_limit_switch_hitter_stl() {
    stl("y_limit_switch_hitter");

    difference() {
        union() {
            difference() {
                translate([0, -housing_len/2, 0])
                cube([10, housing_len, 10]);

                rotate([0, 45, 0])
                translate([0, -housing_len/2 - 1, 0])
                cube([10, housing_len + 2, 20]);
            }

            translate([0, -housing_len/2, 8])
            cube([15, housing_len, 2]);

            translate([8, -housing_len / 2, -12]) {
                cube([7, 2, 20]);

                translate([-8, 0, 12])
                cube([10, 2, 10]);
            }

            translate([8, housing_len / 2 - 2, -12]) {
                cube([7, 2, 20]);

                translate([-8, 0, 12])
                cube([10, 2, 10]);
            }
        }

        translate([-1, -10, 5])
        rotate([0, 90, 0])
        union() {
            cylinder(r = 1.55, h = 10);

            translate([0, 0, 4])
            cylinder(r = screw_head_radius(M3_cap_screw) + 0.01, h = 5);
        }

        translate([-1, 10, 5])
        rotate([0, 90, 0])
        union() {
            cylinder(r = 1.55, h = 10);

            translate([0, 0, 4])
            cylinder(r = screw_head_radius(M3_cap_screw) + 0.01, h = 5);
        }
    }
}

//! *Before you start assembling the y-axis carriage base*, please
//! check that the belt clamps can be installed easily. If not,
//! you should sand or file down those parts **first** so that they
//! fit snugly but not be too difficult to assemble.
//!
//! First, insert all M3nS square nuts into their holes. Then, insert the
//! nut on the bottom of the carriage. You may need to use the _screw pulling_
//! technique - where you use a screw from the other side of the part
//! to pull the nut into its socket.
//!
//! Insert the LM8UU bearings into their holes, then slide the bottom part onto the smooth
//! rods. The side with two bearings in it should be oriented towards the inside
//! of the machine.
module y_carriage_base_assembly()
assembly("y_carriage_base") { //! Bottom half of the y-carriage
    color(printed_part_color)
    y_carriage_base_stl();

    translate([-ew/2, b_len / 2 + 2, 0])
    rotate([90, 0, 0])
    linear_bearing(bearing_type);

    translate([-ew/2, -b_len / 2 - 2, 0])
    rotate([90, 0, 0])
    linear_bearing(bearing_type);

    translate([ew/2, 0, 0])
    rotate([90, 0, 0])
    linear_bearing(bearing_type);

    translate([0, 0, b_dia / 2 - 1])
    rotate([0, 0, 30])
    nut(M3_nut);

    for (pos = mounting_screw_positions) {
        translate(pos)
        rotate([0, 0, pos[1] < 0 ? 180 : 0])
        nut_square(M3nS_thin_nut);
    }

    translate([ew / 2 + 5, -10, 9]) {
        rotate([0, 90, 0])
        nut_square(M3nS_thin_nut);

        translate([6.5, 0, 0])
        rotate([0, 90, 0])
        screw(M3_cap_screw, 6);
    }

    translate([ew / 2 + 5, 10, 9]) {
        rotate([0, 90, 0])
        nut_square(M3nS_thin_nut);

        translate([6.5, 0, 0])
        rotate([0, 90, 0])
        screw(M3_cap_screw, 6);
    }

    translate([ew - 6.5, 0, 4])
    color(printed_part_color)
    y_limit_switch_hitter_stl();
}

if ($preview) {
    y_carriage_base_assembly();
}