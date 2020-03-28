include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/microswitches.scad>
include <common_consts.scad>
include <common_defs.scad>

motor_w = NEMA_width(NEMA17S);
thickness = 2;

module y_idler_stl() {
    stl("y_idler");

    h = motor_w / 2 - 13;
    difference() {
        // mounting plate + riser for the idler
        union() {
            translate([-ew, -ew/2, 0])
            cube([2 * ew, ew, thickness]);

            translate([-ew / 2, -ew / 2, thickness])
            pyramid([ew, ew], [ew / 2, ew * 0.8], h - thickness);

            translate([-ew / 4, -(ew * 0.8)/2, h])
            cube([ew / 2, ew * 0.8, motor_w / 2]);

            translate([-ew, ew / 2 - thickness, thickness])
            cube([ew * 2, thickness, 15]);
        }

        // space for the idler
        translate([
            -pulley_height(GT2x20_toothed_idler) / 2 - 0.5,
            -(ew * 0.8) / 2 - 1,
            h
        ])
        cube([
            pulley_height(GT2x20_toothed_idler) + 1,
            ew,
            motor_w / 2 + 1
        ]);

        // Pulley affixation - should be M5 in general release
        pulley_affixation_size = 4 / 2 + 0.1;
        translate([0, 0, motor_w / 2])
        rotate([0, 90, 0])
        union() {
            translate([0,3, 0])
            cylinder(r1 = pulley_affixation_size, r2 = pulley_affixation_size, h = 20, center = true);

            translate([0, -3, 0])
            cylinder(r1 = pulley_affixation_size, r2 = pulley_affixation_size, h = 20, center = true);

            translate([-pulley_affixation_size, -pulley_affixation_size, -10])
            cube([pulley_affixation_size * 2, pulley_affixation_size * 2, 20]);
        }


        translate([0, ew / 2, motor_w])
        rotate([45, 0, 0])
        cube([ew * 2, ew, ew], center = true);

        translate([0, -ew / 2, motor_w])
        rotate([45, 0, 0])
        cube([ew * 2, ew, ew], center = true);

        // holes for mounting on the extrusion and adjusting belt tension
        translate([ew - 7, 0, -0.5])
        union() {
            translate([0, 0, 0])
            cylinder(r1 = 2.1, r2 = 2.1, thickness + 1);
        }

        translate([-ew + 7, 0, -0.5])
        union() {
            translate([0, 0, 0])
            cylinder(r1 = 2.1, r2 = 2.1, thickness + 1);
        }
    }
}

//! Mount the idler into the bracket
module y_idler_assembly()
assembly("y_idler") {
    color(printed_part_color)
    y_idler_stl();

    // idler and screw
    translate([-pulley_height(GT2x20_toothed_idler)/2, 0, motor_w / 2])
    rotate([0, 90, 0])
    pulley(GT2x20_toothed_idler);
    
    // Pulley affixation - should be M5 in general release
    translate([8.5, 0, motor_w / 2])
    rotate([0, 90, 0])
    screw(M4_cap_screw, 20);

    translate([-8.5, 0, motor_w / 2])
    rotate([0, 90, 0])
    washer(M4_washer);
    translate([7.5, 0, motor_w / 2])
    rotate([0, 90, 0])
    washer(M4_washer);

    translate([-12, 0, motor_w / 2])
    rotate([0, 90, 0])
    nut(M4_nut);

    // mounting holes and screws
    translate([-ew + 7, 0, -1.5])
    rotate([180, 0, 0])
    sliding_t_nut(M4_sliding_t_nut);

    translate([-ew + 7, 0, 2])
    screw(M4_cap_screw, 10);

    translate([ew - 7, 0, -1.5])
    rotate([180, 0, 0])
    sliding_t_nut(M4_sliding_t_nut);

    translate([ew - 7, 0, 2])
    screw(M4_cap_screw, 10);
}

if ($preview) {
    y_idler_assembly();
}