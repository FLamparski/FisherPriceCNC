include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>
include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/screws.scad>
include <common_consts.scad>
include <common_defs.scad>

motor_w = NEMA_width(NEMA17S);
motor_l = NEMA_length(NEMA17S);
boss_clearance = NEMA_big_hole(NEMA17S);
screw_pitch = NEMA_hole_pitch(NEMA17S);
mount_thickness = 5;
plate_thickness = 2;
plate_width = ew;
plate_y_offset = motor_w / 2 - ew / 2;
outer_lip = 10;

module y_motor_left_impl() {
    union() {
        // motor mounting plate
        difference() {
            diff_hole_h = mount_thickness + 1;
            diff_hole_h_offset = diff_hole_h / 2;
            cube([motor_w, motor_w, mount_thickness], center = true);

            translate([0, 0, -diff_hole_h_offset])
            NEMA_screw_positions(NEMA17S) {
                cylinder(r1 = 2, r2 = 2, h = diff_hole_h);
            }

            translate([0, 0, -diff_hole_h_offset])
            cylinder(r1 = boss_clearance, r2 = boss_clearance, h = diff_hole_h);

            translate([boss_clearance, 0, 0])
            cube([20, boss_clearance * 2, diff_hole_h], center = true);

            translate([boss_clearance * 2, 0, 0])
            rotate([0, 0, 45])
            cube([boss_clearance * 2, boss_clearance * 2, diff_hole_h], center = true);

            translate([boss_clearance * 2, motor_w - boss_clearance, 0])
            rotate([0, 0, 45])
            cube([boss_clearance * 2, boss_clearance * 2, diff_hole_h], center = true);

            translate([boss_clearance * 2, -motor_w + boss_clearance, 0])
            rotate([0, 0, 45])
            cube([boss_clearance * 2, boss_clearance * 2, diff_hole_h], center = true);
        }

        // bracket for mounting on the extrusion
        translate([-motor_w / 2 - (plate_thickness / 2), -plate_y_offset, 0])
        rotate([0, 90, 0])
        difference() {
            cube([motor_l * 2 + mount_thickness + outer_lip * 2, ew, plate_thickness], center = true);

            adj = ew + 9;
            translate([-motor_l - mount_thickness / 2 - outer_lip - adj, -motor_l/2, -plate_thickness/2-1])
            cube([motor_l + outer_lip, motor_w, motor_w]);

            translate([motor_l + outer_lip / 2 + 2, 0, -(plate_thickness + 1)/2])
            cylinder(r1 = 2, r2 = 2, h = plate_thickness + 1);

            translate([-motor_l/2 - 5, 0, -(plate_thickness + 1)/2])
            cylinder(r1 = 2, r2 = 2, h = plate_thickness + 1);
        }

        // connecting tissue
        translate([-motor_w/2 - plate_thickness / 2, 0, 0])
        cube([plate_thickness, motor_w, mount_thickness + outer_lip], center = true);
        // TODO: add some corner shaping to this

        // rod limit
        difference() {
            union() {
                translate([-motor_w / 2, -21, ew - 11])
                cube([motor_w / 2 - 5, 10, ew - 8]);
            }
        }
    }
}

module y_motor_left_mount_stl() {
    stl("y_motor_left_mount");

    y_motor_left_impl();
}

module y_motor_right_mount_stl() {
    stl("y_motor_right_mount");

    mirror([1, 0, 0]) {
        y_motor_left_impl();
    }
    
}

nut_thickness = nut_thickness(M4_sliding_t_nut);
nut_offset = nut_thickness/2 + motor_w/2 + plate_thickness - 0.5;

//! Orient the motor so that the back is towards the hole closer to the edge
//! of the mounting plate, and that the cable comes out towards the rear of
//! the unit.
//!
//! Use M3*8 screws to affix the motor to the holder part.
//!
//! To mount to the frame, make sure that the motor shaft is pointing towards
//! the end of the extrusion. You could try to install the T-nuts loosely on
//! screws going through the mounting plate and then slide the whole module
//! onto the extrusion. Align the edge of the mounting plate with the edge of
//! the extrusion and tighten the M4 screws.
module y_motor_left_assembly()
assembly("y_motor_left") {
    NEMA(NEMA17S);

    translate([0, 0, 3])
    pulley(GT2x20ob_pulley);

    translate([0, 0, 2.5])
    color(printed_part_color)
    y_motor_left_mount_stl();

    translate([0, 0, 5])
    NEMA_screws(NEMA17S, M3_cap_screw);

    // nut & screw on the motor side
    translate([-nut_offset, -plate_y_offset, -motor_l - outer_lip / 2 + 0.5])
    rotate([0, -90, 0])
    sliding_t_nut(M4_sliding_t_nut);

    translate([-nut_offset + plate_thickness + 1, -plate_y_offset, -motor_l - outer_lip / 2 + 0.5])
    rotate([0, 90, 0])
    screw(M4_cap_screw, 10);

    // nut & screw on the pulley side
    translate([-nut_offset, -plate_y_offset, motor_l/2 + 7.5])
    rotate([0, -90, 0])
    sliding_t_nut(M4_sliding_t_nut);

    translate([-nut_offset + plate_thickness + 1, -plate_y_offset, motor_l/2 + 7.5])
    rotate([0, 90, 0])
    screw(M4_cap_screw, 10);
}

//! Orient the motor so that the back is towards the hole closer to the edge
//! of the mounting plate, and that the cable comes out towards the rear of
//! the unit.
//!
//! Use M3*8 screws to affix the motor to the holder part.
//!
//! To mount to the frame, make sure that the motor shaft is pointing towards
//! the end of the extrusion. You could try to install the T-nuts loosely on
//! screws going through the mounting plate and then slide the whole module
//! onto the extrusion. Align the edge of the mounting plate with the edge of
//! the extrusion and tighten the M4 screws.
module y_motor_right_assembly()
assembly("y_motor_right") {
    NEMA(NEMA17S);

    translate([0, 0, 3])
    pulley(GT2x20ob_pulley);

    translate([0, 0, 2.5])
    color(printed_part_color)
    y_motor_right_mount_stl();

    translate([0, 0, 5])
    NEMA_screws(NEMA17S, M3_cap_screw);

    // nut & screw on the motor side
    translate([nut_offset, -plate_y_offset, -motor_l - outer_lip / 2 + 0.5])
    rotate([0, 90, 0])
    sliding_t_nut(M4_sliding_t_nut);

    translate([nut_offset - plate_thickness - 1, -plate_y_offset, -motor_l - outer_lip / 2 + 0.5])
    rotate([0, -90, 0])
    screw(M4_cap_screw, 10);

    // nut & screw on the pulley side
    translate([nut_offset, -plate_y_offset, motor_l/2 + 7.5])
    rotate([0, 90, 0])
    sliding_t_nut(M4_sliding_t_nut);

    translate([nut_offset - plate_thickness - 1, -plate_y_offset, motor_l/2 + 7.5])
    rotate([0, -90, 0])
    screw(M4_cap_screw, 10);
}

if ($preview) {
    translate([50, 0, 0])
    y_motor_right_assembly();

    translate([-50, 0, 0])
    y_motor_left_assembly();
}
else {
    translate([0, 25, motor_w / 2 + plate_thickness])
    rotate([0, 90, 0])
    y_motor_right_mount_stl();

    translate([0, -25, motor_w / 2 + plate_thickness])
    rotate([0, -90, 180])
    y_motor_left_mount_stl();
}