//! Fisher Price CNC is a project to turn some parts from the world's worst 3D printer
//! into a reasonable CNC machine (probably a laser engraver of sorts).
//!
//! Mechanical parts can be printed out of PLA for testing and PETG for production use.
//!
//! List of purchases:
//! * Arduino + GRBL shield + motor drivers: https://smile.amazon.co.uk/gp/product/B06XJKVLG3/
//! * Belts: https://smile.amazon.co.uk/gp/product/B07JGXG7S2/
//! * Cap (hex) screws (M2/M3/M4): https://smile.amazon.co.uk/gp/product/B07KCT2F6K/
//! * M3 square nuts: https://smile.amazon.co.uk/gp/product/B075YSD5TN/
//! * Pan (phillips) screws (M3): https://smile.amazon.co.uk/gp/product/B07FTDRZRZ/
//! * LM8UU linear bearings: https://www.ebay.co.uk/itm/LM8UU-8mm-Linear-Bearing-for-Precision-shafts-3D-Printer-CNC-machine/124087391637
//!
//! If you do not have a Monoprice Mini Delta, you will also need to buy:
//! * 6x 345x8mm smooth rods, preferably steel
//! * 3x NEMA17 stepper motors

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rod.scad>
include <NopSCADlib/vitamins/belts.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>

include <common_consts.scad>
include <common_defs.scad>

use <y_motor_assembly.scad>
use <y_idler_assembly.scad>
use <y_axis_assembly.scad>
use <front_assembly.scad>
use <back_assembly.scad>
use <y_carriage_base_assembly.scad>

//! Now you are ready to assemble the whole machine.
//!
//! First, taking care to align everything properly, use the angle brackets
//! to join together the profiles. For the y-axes, make sure the limit switch paddles
//! are on the *outside* of the machine. For the back, the motors should stick out over
//! the outer edge of the machine. The idlers don't seem to care about the orientation.
//!
//! Then, you can install the y-axis belts. You will need to cut your belt to length
//! from a larger roll, then hold it in the grooves in the y-axis carriage base. You
//! will then be able to install the belt clamps to hold the belt together. It's a bit
//! fiddly, but you can get it good enough to move the carriage with the motors easily.
//! In any case, the y-idlers should provide some further ability to tighten the belts.
module main_assembly()
assembly("main") {
    bracket_positions = [
        [[inner_width / 2, rod_length_mm / 2, 0], 180],
        [[-inner_width / 2, -rod_length_mm / 2, 0], 0],
        [[inner_width / 2, -rod_length_mm / 2, 0], 90],
        [[-inner_width / 2, rod_length_mm / 2, 0], -90],
    ];

    translate([-inner_width / 2 - ew, 0, 0])
    rotate([0, 0, 90])
    y_axis_assembly();

    translate([inner_width / 2 + ew, 0, 0])
    rotate([0, 0, -90])
    y_axis_assembly();

    translate([0, -rod_length_mm / 2 - ew / 2, 0])
    front_assembly();

    translate([0, rod_length_mm / 2 + ew / 2, 0])
    back_assembly();

    for (pos = bracket_positions) {
        translate(pos[0])
        rotate([0, 0, pos[1]])
        extrusion_corner_bracket_assembly(E20_corner_bracket);
    }

    translate([-inner_width / 2 - ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, 90, 0])
    belt(GT2x6, [
        [0, -rod_length_mm / 2 - ew / 2, 8],
        [0, rod_length_mm / 2 + ew / 2 + 6, 8]
    ]);

    translate([inner_width / 2 + ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 1])
    rotate([0, 90, 0])
    belt(GT2x6, [
        [0, -rod_length_mm / 2 - ew / 2, 8],
        [0, rod_length_mm / 2 + ew / 2 + 6, 8]
    ]);

    translate([inner_width / 2 + ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 9])
    color(printed_part_color)
    y_carriage_belt_clamp_stl();

    translate([inner_width / 2 + ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 11])
    screw(M3_pan_screw, 8);

    translate([-inner_width / 2 - ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 9])
    color(printed_part_color)
    y_carriage_belt_clamp_stl();

    translate([-inner_width / 2 - ew, 0, ew / 2 + NEMA_width(NEMA17S) / 2 + 11])
    screw(M3_pan_screw, 8);
}

main_assembly();
