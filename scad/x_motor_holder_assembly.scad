include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>

include <common_consts.scad>
include <common_defs.scad>
include <x_axis_common.scad>

use <y_carriage_base_assembly.scad>

motor_tx = [-10, 13, rod_z_base + x_rods_pitch / 2];

module x_motor_holder_mount_stl() {
    stl("x_motor_holder_mount");

    difference() {
        translate([-y_carriage_base_width() / 2, -y_carriage_base_length() / 2, 0])
        union() {
            x_end_base();

            // support for the motor
            motor_bottom = rod_z_base + x_rods_pitch / 2 - NEMA_width(NEMA17M) / 2;
            motor_top = motor_bottom + NEMA_width(NEMA17M);
            motor_mount_y = x_gantry_thickness / 2 + y_carriage_base_length() / 2 + 5;
            translate([0, motor_mount_y, 0])
            rotate([90, 0, 0])
            linear_extrude(5) {
                polygon([
                    [0, base_thickness],
                    [-10, motor_bottom],
                    [-10, motor_top],
                    [y_carriage_base_width() - 10, motor_top],
                    [y_carriage_base_width() - 10, base_thickness]
                ]);
            }

            // mostly for looks
            translate([y_carriage_base_width() - 5, x_gantry_thickness / 2 + y_carriage_base_length() / 2 + 5, 0])
            rotate([0, 0, 180])
            linear_extrude(motor_top) {
                polygon([
                    [0, 5],
                    [5, 5],
                    [5, 0]
                ]);
            }
        }

        // mounting holes for the motor
        translate([-10, 13, rod_z_base + x_rods_pitch / 2])
        rotate([90, 0, 0]) {
            rbig = NEMA_big_hole(NEMA17M);
            cylinder(r=rbig, h=10, center=true);

            // TODO: make these adjustable?
            NEMA_screw_positions(NEMA17M, n = 3) {
                cylinder(r = screw_clearance_radius(M3_cap_screw), h = 10, center = true);

                translate([0, 0, 12])
                cylinder(r = screw_head_radius(M3_cap_screw) + 0.25, h = 20, center = true);
            }
        }
    }
}

module x_motor_and_pulley_assembly()
assembly("x_motor_and_pulley") {
    NEMA(NEMA17M);

    translate([0, 0, 13])
    pulley_assembly(GT2x20ob_pulley);
}

module x_motor_holder_assembly()
assembly("x_motor_holder") {
    color(printed_part_color)
    x_motor_holder_mount_stl();

    translate(motor_tx)
    rotate([90, 0, 0]) {
        x_motor_and_pulley_assembly();

        NEMA_screw_positions(NEMA17M, n = 3) {
            translate([0, 0, 4])
            screw(M3_cap_screw, 8);
        }
    }

    // Limit switch
    translate([23.9, 0, x_max_height + microswitch_thickness(medium_microswitch) - 1.2])
    rotate([0, 0, -90])
    microswitch(medium_microswitch);
}

if ($preview) {
    x_motor_holder_assembly();
}