// Fisher Price CNC

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>

include <common_consts.scad>
include <common_defs.scad>

use <y_rod_assembly.scad>
use <frame_assembly.scad>
use <y_motor_assembly.scad>
use <y_idler_assembly.scad>
use <y_carriage_base_assembly.scad>
use <y_limit_switch_assembly.scad>

//! Assembles the CNC. ALL T-nuts must be inserted prior to assembling the
//! frame with the corner brackets.
module main_assembly()
assembly("main") {
    frame_assembly();

    inner_slot_offset = ew / 2;
    outer_slot_offset = ew * 1.5;
    
    translate([inner_width / 2 + inner_slot_offset, 0, ew / 2])
    y_rod_assembly();
    translate([inner_width / 2 + outer_slot_offset, 0, ew / 2])
    y_rod_assembly();
    translate([-inner_width / 2 - inner_slot_offset, 0, ew / 2])
    y_rod_assembly();
    translate([-inner_width / 2 - outer_slot_offset, 0, ew / 2])
    y_rod_assembly();

    stepper_offset = NEMA_width(NEMA17S) / 2;
    translate([-inner_width / 2 - 16, rod_length_mm / 2 + stepper_offset, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, -90, 0])
    y_motor_left_assembly();

    translate([inner_width / 2 + 16, rod_length_mm / 2 + stepper_offset, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, 90, 0])
    y_motor_right_assembly();

    translate([-inner_width / 2 - ew, -rod_length_mm / 2 - ew / 2, ew / 2])
    y_idler_assembly();

    translate([-inner_width / 2 - ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, 90, 0])
    belt(GT2x6, [
        [0, -rod_length_mm / 2 - ew / 2, 8],
        [0, rod_length_mm / 2 + ew / 2 + 6, 8]
    ]);

    translate([inner_width / 2 + ew, -rod_length_mm / 2 - ew / 2, ew / 2])
    y_idler_assembly();

    translate([inner_width / 2 + ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, 90, 0])
    belt(GT2x6, [
        [0, -rod_length_mm / 2 - ew / 2, 8],
        [0, rod_length_mm / 2 + ew / 2 + 6, 8]
    ]);

    translate([outer_width / 2 - ew, 0, ew / 2 + y_holder_rod_offset])
    y_carriage_base_assembly();

    translate([outer_width / 2, -rod_length_mm / 2 + ew / 2, - ew / 2])
    y_limit_switch_assembly();

    translate([outer_width / 2, rod_length_mm / 2 - ew / 2, - ew / 2])
    mirror([0, 1, 0])
    y_limit_switch_assembly();
}

main_assembly();
