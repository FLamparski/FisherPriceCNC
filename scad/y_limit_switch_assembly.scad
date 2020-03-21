include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/microswitches.scad>
include <common_consts.scad>
include <common_defs.scad>

thickness = 2;
switch_w = microswitch_width(medium_microswitch);
switch_l = microswitch_length(medium_microswitch);
switch_t = microswitch_thickness(medium_microswitch);
total_h = ew + switch_l;

module y_limit_switch_impl() {
    difference() {
        union() {
            cube([thickness, ew, ew]);
            cube([thickness, switch_w, total_h]);
        }

        translate([-1, ew / 2 - 5, ew / 2])
        rotate([0, 90, 0])
        cylinder(r=2.1, h=thickness + 2);
        
        translate([-1, ew / 2 + 5, ew / 2])
        rotate([0, 90, 0])
        cylinder(r=2.1, h=thickness + 2);

        translate([
            switch_t / 2 - thickness * 2,
            switch_w / 2 - 2.6,
            ew + switch_l / 2 + 4.8
        ])
        rotate([0, 90, 0])
        cylinder(r=1.3, h=10);

        translate([
            switch_t / 2 - thickness * 2,
            switch_w / 2 - 2.6,
            ew + switch_l / 2 - 4.8
        ])
        rotate([0, 90, 0])
        cylinder(r=1.3, h=10);
    }
}

module y_limit_switch_stl() {
    stl("y_limit_switch");

    y_limit_switch_impl();
}

module y_limit_switch_assembly()
assembly("y_limit_switch") {
    translate([0, -ew / 2, 0]) {
        color(printed_part_color)
        y_limit_switch_stl();

        translate([switch_t / 2 + thickness, switch_w / 2, ew + switch_l / 2])
        rotate([0, 90, 0])
        microswitch(medium_microswitch);

        translate([
            switch_t / 2 - thickness * 2 - 0.5,
            switch_w / 2 - 2.6,
            ew + switch_l / 2 - 4.8
        ])
        rotate([0, 90, 0])
        nut(M2_nut);
        
        translate([
            switch_t + 2,
            switch_w / 2 - 2.6,
            ew + switch_l / 2 - 4.8
        ])
        rotate([0, 90, 0])
        screw(M2_cap_screw, 10);

        translate([
            switch_t / 2 - thickness * 2 - 0.5,
            switch_w / 2 - 2.6,
            ew + switch_l / 2 + 4.8
        ])
        rotate([0, 90, 0])
        nut(M2_nut);
        
        translate([
            switch_t + 2,
            switch_w / 2 - 2.6,
            ew + switch_l / 2 + 4.8
        ])
        rotate([0, 90, 0])
        screw(M2_cap_screw, 10);

        translate([-1.5, ew / 2 - 5, ew / 2])
        rotate([90, 0, -90])
        sliding_t_nut(M4_hammer_nut);

        translate([thickness, ew / 2 - 5, ew / 2])
        rotate([0, 90, 0])
        screw(M4_cap_screw, 8);

        translate([-1.5, ew / 2 + 5, ew / 2])
        rotate([90, 0, -90])
        sliding_t_nut(M4_hammer_nut);

        translate([thickness, ew / 2 + 5, ew / 2])
        rotate([0, 90, 0])
        screw(M4_cap_screw, 8);
    }
}

if ($preview) {
    y_limit_switch_assembly();
}