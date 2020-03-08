// Fisher Price CNC

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/rod.scad>

include <common_consts.scad>

use <y_rod_assembly.scad>
use <frame_assembly.scad>

//! * Assembles the CNC. ALL T-nuts must be inserted prior to assembling the
//! * frame with the corner brackets.
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

}

main_assembly();
