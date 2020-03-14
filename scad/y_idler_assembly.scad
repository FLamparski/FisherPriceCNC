include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/screws.scad>
include <common_consts.scad>
include <common_defs.scad>

motor_w = NEMA_width(NEMA17S);
thickness = 2;

module mpmd_idler() { //! Idler part from the Mini Delta - it's the one riveted to a bracket
    vitamin("Idler MPMD idler");
    
    color("grey")
    difference() {
        translate([-13/2, -11/2, 0])
        union() {
            cube([13, 11, 1]);
            cube([13, 1, 17.5]);
            translate([0, 10, 0])
            cube([13, 1, 17.5]);
        }

        cylinder(r1 = 1.5, r2 = 1.5, h = 2);
    }

    translate([0, 4, 13])
    rotate([90, 0, 0])
    pulley(MPMD_idler);
}

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
        }

        // hollow out the riser
        id = ew - thickness;
        translate([-id / 2, -id / 2, -0.01])
        pyramid([id, id], [id / 2, id * 0.8], h - thickness);

        // screw hole for the idler
        cylinder(r1 = 3/2, r2 = 3/2, h + 1);

        // holes for mounting on the extrusion and adjusting belt tension
        translate([ew - 7, 0, -0.5])
        union() {
            translate([-4/2, -5, 0])
            cube([4, 10, thickness + 1]);
            
            translate([0, 5, 0])
            cylinder(r1 = 4/2, r2 = 4/2, thickness + 1);

            translate([0, -5, 0])
            cylinder(r1 = 4/2, r2 = 4/2, thickness + 1);
        }

        translate([-ew + 7, 0, -0.5])
        union() {
            translate([-4/2, -5, 0])
            cube([4, 10, thickness + 1]);
            
            translate([0, 5, 0])
            cylinder(r1 = 4/2, r2 = 4/2, thickness + 1);

            translate([0, -5, 0])
            cylinder(r1 = 4/2, r2 = 4/2, thickness + 1);
        }
    }
}

module y_idler_assembly()
assembly("y_idler") {
    color(printed_part_color)
    y_idler_stl();

    // idler and screw
    translate([0, 0, motor_w / 2 - 13])
    rotate([0, 0, 90])
    mpmd_idler();

    translate([0, 0, motor_w / 2 - 15])
    rotate([0, 180, 0])
    screw(M3_cap_screw, 6);

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