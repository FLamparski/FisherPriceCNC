include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pin_headers.scad>
include <NopSCADlib/vitamins/green_terminals.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/toggles.scad>
include <NopSCADlib/vitamins/leds.scad>

include <common_consts.scad>

use <square_nut_lug.scad>

function xy_center(vec) = [-vec[0] / 2, -vec[1] / 2, 0];

module cube_bounded_honeycomb_cutout(cube_size, r = 3, space = 2, center = false) {
    intersection() {
        union() {
            n_x = round(cube_size[0] / (r * 2)) + 5;
            n_y = round(cube_size[1] / (r * 2)) + 5;

            for (x = [0 : n_x]) {
                for (y = [0 : n_y]) {
                    x_pos = x * (r * 2.5 + space);
                    x_shift = y % 2 == 0 ? 0 : r * 1.25 + space * 0.5;
                    y_pos = y * (r + space * 2);
                    translate([x_pos + x_shift, y_pos, 0])
                    cylinder(r=r, h=cube_size[2], $fn = 6);
                }
            }
        }

        cube(cube_size, center = center);
    }
}

th = pcb_thickness(ArduinoUno3);
arduino_holes = [for (h = pcb_holes(ArduinoUno3)) h + xy_center([pcb_length(ArduinoUno3), pcb_width(ArduinoUno3)])];
arduino_mounting_holes = [arduino_holes[1], arduino_holes[2], arduino_holes[3]];
perf_mounting_holes = [
    for (x = [[1,1], [-1,1], [-1,-1], [1,-1]])
    [(pcb_length(PERF80x20) / 2 - 2) * x[0], (pcb_width(PERF80x20) / 2 - 2) * x[1]]
];
wall_thickness = 2;
standoff_r = nut_radius(M3_nut) + 1;
standoff_h = nut_thickness(M3_nut) + 2;

function ele_position(ele) = ele[0];
function ele_rotation(ele) = ele[1];

ele_arduino = [[-16, 15, 0], [0, 0, 0]];
ele_perfboard = [[-10, -30, 0], [0, 0, 0]];
ele_laser_module = [[55, 0, 36], [0, -90, 0]];
ele_cnc_shield = [ele_position(ele_arduino) + [0, 0, 12.5], ele_rotation(ele_arduino)];

module in_ele_space(ele) {
    translate(ele_position(ele))
    rotate(ele_rotation(ele))
    children();
}

box_inner_dims = [110, 90, 53];
box_outer_dims = [for (dim = box_inner_dims) dim + wall_thickness * 2];
base_height = 20;

box_mating_holes = [
    [-box_outer_dims[0] / 2 - 5, 0, 0],
    [box_outer_dims[0] / 2 + 5, -box_outer_dims[1] / 3, 0],
    [box_outer_dims[0] / 2 + 5, box_outer_dims[1] / 3, 0]
];

module ele_box_base_stl() {
    stl("ele_box_base");

    difference() {
        union() {
            difference() {
                union() {
                    translate(xy_center(box_outer_dims))
                    cube([box_outer_dims[0], box_outer_dims[1], wall_thickness]);

                    translate(xy_center(box_outer_dims) + [0, 0, wall_thickness])
                    difference() {
                        cube([box_outer_dims[0], box_outer_dims[1], base_height]);

                        translate([wall_thickness, wall_thickness, -1])
                        cube([box_inner_dims[0], box_inner_dims[1], base_height + 2]);
                    }
                }

                // USB cutout
                in_ele_space(ele_arduino) {
                    translate([-50, 4.5, wall_thickness + standoff_h + th])
                    cube([20, 13, 11.5]);
                }

                // cutout for the 12v supply
                translate([30, box_inner_dims[1] / 2, wall_thickness + 10])
                rotate([90, 0, 0])
                cylinder(r=11.4/2, h=10, center=true);

                translate([24, box_outer_dims[1] / 2, wall_thickness + 7])
                mirror([1, 0, 0])
                rotate([90, 0, 0])
                linear_extrude(wall_thickness / 2) {
                    text("12V 5A", font="Lato:style=Regular", size=5);
                }
            }

            // builtin standoff for the arduino
            in_ele_space(ele_arduino) {
                for (pos = arduino_mounting_holes) {
                    nut_r = nut_radius(M3_nut);
                    translate(pos)
                    cylinder(r = nut_r + 1, h = wall_thickness + standoff_h);
                }
            }

            // builtin standoff for the 2x8cm auxilliary PCB
            in_ele_space(ele_perfboard) {
                for (pos = perf_mounting_holes) {
                    nut_r = nut_radius(M2_nut);
                    translate(pos)
                    cylinder(r=nut_r + 1, h= wall_thickness + standoff_h);
                }
            }

            // mounting bits for the top part of the box
            for (hole = box_mating_holes) {
                translate(hole + [0, 0, base_height - 0.7])
                rotate([0, 0, hole[0] < 0 ? 90 : -90])
                square_nut_lug(M3nS_thin_nut, flying = true);
            }
        }

        // mounting nut for the arduino
        in_ele_space(ele_arduino) {
            for (pos = arduino_mounting_holes) {
                translate(pos)
                nut_trap(M3_cap_screw, M3_nut);
            }
        }

        // mounting nut for the 2x8cm auxilliary PCB
        in_ele_space(ele_perfboard) {
            for (pos = perf_mounting_holes) {
                translate(pos)
                nut_trap(M2_cap_screw, M2_nut);
            }
        }

        // holes for securing the box to the bracket
        translate([25, 15, 0])
        cylinder(r = screw_clearance_radius(M3_cap_screw), h = 10, center = true);

        translate([25, -10, 0])
        cylinder(r = screw_clearance_radius(M3_cap_screw), h = 10, center = true);
    }
}

module ele_box_top_stl() {
    stl("ele_box_top");

    difference() {
        union() {
            translate(xy_center(box_outer_dims))
            cube([box_outer_dims[0], box_outer_dims[1], box_outer_dims[2] - base_height - wall_thickness]);

            // mounting thingies
            for (hole = box_mating_holes) {
                size = nut_square_width(M3nS_thin_nut) * 2;
                translate(xy_center([size, size]) + hole)
                cube([size, size, wall_thickness]);
            }

            // add cable gland things
            translate([-10 - box_inner_dims[0] / 3, -box_outer_dims[1] / 2, 2])
            rotate([90, 0, 0])
            minkowski() {
                pyramid([20, 30], [20, 10], h = 10);
                cylinder(r = 1, h = 0.1);
            }

            translate([-10 + box_inner_dims[0] / 3, -box_outer_dims[1] / 2, 2])
            rotate([90, 0, 0])
            minkowski() {
                pyramid([20, 30], [20, 10], h = 10);
                cylinder(r = 1, h = 0.1);
            }
        }

        // hollow the box out
        translate(xy_center(box_outer_dims) + [wall_thickness, wall_thickness, - 1])
        cube([box_inner_dims[0], box_inner_dims[1], box_inner_dims[2] - base_height + 1]);

        // holes for screws that will hold the thing together
        for (hole = box_mating_holes) {
            translate(hole)
            cylinder(r = screw_clearance_radius(M3_cap_screw), h = 10, center = true);
        }

        // cable gland holes
        translate([-10 + box_inner_dims[0] / 3 + wall_thickness, -box_inner_dims[1] / 2, 2])
        rotate([90, 0, 0])
        union() {
            minkowski() {
                pyramid([20 - wall_thickness * 2, 30 - wall_thickness], [20 - wall_thickness * 2, 10 - wall_thickness], h = 10);
                cylinder(r = 1, h = 0.1);
            }

            translate([0, 10 + wall_thickness / 2, wall_thickness])
            minkowski() {
                cube([20 - wall_thickness * 2, 10 - wall_thickness, 20]);
                cylinder(r = 1, h = 0.1);
            }

            translate([15.5, -5, 10])
            rotate([-90, 90, 0])
            cube([7, 2, 50]);

            translate([2.5, -5, 10])
            rotate([-90, 90, 0])
            cube([7, 2, 50]);
        }

        translate([-10 - box_inner_dims[0] / 3 + wall_thickness, -box_inner_dims[1] / 2, 2])
        rotate([90, 0, 0])
        union() {
            minkowski() {
                pyramid([20 - wall_thickness * 2, 30 - wall_thickness], [20 - wall_thickness * 2, 10 - wall_thickness], h = 10);
                cylinder(r = 1, h = 0.1);
            }

            translate([0, 10 + wall_thickness / 2, wall_thickness])
            minkowski() {
                cube([20 - wall_thickness * 2, 10 - wall_thickness, 20]);
                cylinder(r = 1, h = 0.1);
            }

            translate([2.5, -5, 10])
            rotate([-90, 90, 0])
            cube([7, 2, 50]);

            translate([15.5, -5, 10])
            rotate([-90, 90, 0])
            cube([7, 2, 50]);
        }

        // mounting holes for the laser driver
        translate([box_inner_dims[0] / 2, -30, 15])
        rotate([0, 90, 0])
        cylinder(r=screw_clearance_radius(M4_cap_screw), h=10, center=true);

        translate([box_inner_dims[0] / 2, 30, 15])
        rotate([0, 90, 0])
        cylinder(r=screw_clearance_radius(M4_cap_screw), h=10, center=true);

        // panel mount switch for turning the laser on and off
        translate([-box_outer_dims[0] / 2, -30, (box_outer_dims[2] - base_height) / 2 + 2])
        rotate([0, 90, 0]) { 
            toggle_hole(CK7101, 10);

            translate([0, 10, 0])
            cylinder(r = 2.5, h = 10, center = true);
        }

        // cooling/material removal/pretty patterns
        translate([-box_inner_dims[0] / 2, box_inner_dims[1] / 2 + wall_thickness, wall_thickness])
        rotate([90, 0, 0]) {
            if (!$preview) {
                cube_bounded_honeycomb_cutout([box_inner_dims[0], box_inner_dims[2] - base_height - 2, wall_thickness], space = 1);
            }
            else {
                cube([box_inner_dims[0], box_inner_dims[2] - base_height - 2, wall_thickness]);
            }
        }

        translate(xy_center(box_inner_dims) + [10, 10, box_inner_dims[2] - base_height]) {
            if (!$preview) {
                cube_bounded_honeycomb_cutout([box_inner_dims[0] - 20, box_inner_dims[1] - 20, wall_thickness], space = 1);
            }
            else {
                cube([box_inner_dims[0] - 20, box_inner_dims[1] - 20, wall_thickness]);
            }
        }

        translate([-20, -box_inner_dims[1] / 2, wall_thickness])
        rotate([90, 0, 0]) {
            if (!$preview) {
                cube_bounded_honeycomb_cutout([40, box_inner_dims[2] - base_height - 2, wall_thickness], space = 1);
            }
            else {
                cube([40, box_inner_dims[2] - base_height - 2, wall_thickness]);
            }
        }
    }
}

module dc_jack(length = 10) {
    translate([0, 0, -length])
    difference() {
        color("#222222")
        union() {
            translate([0, 0, length])
            cylinder(r=13.5/2, h=1);

            cylinder(r=11.4/2, h=length);
        }

        color("#999999")
        translate([2.5, 0, length + 1 - 5.6])
        cylinder(r=2.1, h=5.6);
    }
}

module motor_driver() {
    MotorDriverHeatSinkColor = "DeepSkyBlue";
    MotorDriver = ["MotorDriver", "Stepper Motor Driver",
        20, 14, 1.6, 0, 3, 0, "red", false, [],
        [
            [  10,  1,  0, "-2p54header", 8, 1 ,undef, grey20 ],
            [  10, 13,  0, "-2p54header", 8, 1],
            [  12,  7,  0, "-chip", 6, 4, 1, grey20 ],
            // mock up a heat sink
            [  10,  7,  0, "block", 9, 9,  2, MotorDriverHeatSinkColor ],
            [  10, 11,  0, "block", 9, 1, 5, MotorDriverHeatSinkColor ],
            [  10,  9,  0, "block", 9, 1, 5, MotorDriverHeatSinkColor ],
            [  10,  7,  0, "block", 9, 1, 5, MotorDriverHeatSinkColor ],
            [  10,  5,  0, "block", 9, 1, 5, MotorDriverHeatSinkColor ],
            [  10,  3,  0, "block", 9, 1, 5, MotorDriverHeatSinkColor ],
        ],
        []
    ];

    translate([-pcb_width(MotorDriver) / 2, 0, 0]) {
        sock_width = hdr_pin_width(2p54header);
        translate([pcb_width(MotorDriver) - sock_width - 0.4, 0, th])
        rotate([0, 0, 90])
        pin_socket(2p54header, 8, 1);

        translate([sock_width + 0.4, 0, th])
        rotate([0, 0, 90])
        pin_socket(2p54header, 8, 1);

        translate([pcb_width(MotorDriver) / 2, 0, 12.5])
        rotate([0, 0, 90])
        pcb(MotorDriver);
    }
}

module cnc_shield() {
    color("red")
    difference() {
        linear_extrude(th)
        polygon(pcb_polygon(ArduinoUno3));

        pcb_screw_positions(ArduinoUno3) {
            cylinder(r=1.75, h=10, center=true);
        }
    }

    translate([-10.5, 12.5, 0])
    motor_driver();

    translate([10.5, 12.5, 0])
    motor_driver();

    translate([-10.5, -12.5, 0])
    motor_driver();

    translate([10.5, -12.5, 0])
    motor_driver();

    translate([-30, -13, th])
    rotate([0, 0, -90])
    green_terminal(gt_3p5, 2);
}

module laser_driver_mount() {
    translate([-36/2, -51/2, 0]) {
        color("#222222") {
            difference() {
                union() {
                    cube([36, 51, 11.5]);

                    translate([0, -10, 0])
                    cube([4, 71, 11.5]);

                    translate([12, -10, 0])
                    cube([12.5, 71, 4]);
                }

                translate([2, 2, 2])
                cube([32, 47, 10]);

                translate([18.5, -5, 0]) {
                    cylinder(r = 2.5, h = 10, center = true);

                    translate([-15, 0, 7])
                    rotate([0, 90, 0])
                    cylinder(r = 2.5, h = 10, center = true);
                }

                translate([18.5, 55, 0]) {
                    cylinder(r = 2.5, h = 10, center = true);

                    translate([-15, 0, 7])
                    rotate([0, 90, 0])
                    cylinder(r = 2.5, h = 10, center = true);
                }
            }
        }

        color("green")
        translate([2, 2, 3])
        cube([32, 47, th]);
    }
}

fan60x11 = [60, 11, 57, 25, M4_cap_screw, 29, 2.4, 60, 7, 7.7, 63];

module ele_box_base_assembly()
assembly("ele_box_base") {
    color(printed_part_color)
    ele_box_base_stl();

    // mounting nut for the arduino
    in_ele_space(ele_arduino) {
        for (pos = arduino_mounting_holes) {
            translate(pos)
            nut(M3_nut);
        }
    }

    // mounting nut for the 2x8cm auxilliary PCB
    in_ele_space(ele_perfboard) {
        for (pos = perf_mounting_holes) {
            translate(pos)
            nut(M2_nut);
        }
    }

    // square nuts used to mount the top part of the box
    for (hole = box_mating_holes) {
        translate(hole + [0, 0, base_height - 1.5])
        nut_square(M3nS_thin_nut);
    }
}

module ele_box_top_assembly()
assembly("ele_box_top") {
    color(printed_part_color)
    ele_box_top_stl();

    translate([-box_outer_dims[0] / 2 + 2.5, -30, (box_outer_dims[2] - base_height) / 2 + 2])
    rotate([90, 0, -90]) {
        toggle(CK7101, 3);

        translate([-10, 0, 0])
        led(LED5mm, "red");
    }
}

module electronics_assembly()
assembly("electronics") {
    ele_box_base_assembly();

    translate([0, 0, base_height + wall_thickness])
    ele_box_top_assembly();

    translate([0, 0, standoff_h + wall_thickness]) {
        in_ele_space(ele_arduino) {
            pcb(ArduinoUno3);
        }

        in_ele_space(ele_cnc_shield) {
            cnc_shield();
        }

        in_ele_space(ele_perfboard) {
            pcb(PERF80x20);
        }
    }

    translate([30, box_inner_dims[1] / 2 + wall_thickness, wall_thickness + 10])
    rotate([-90, -90, 0])
    dc_jack();

    in_ele_space(ele_laser_module) {
        laser_driver_mount();
    }

    // square nuts used to mount the top part of the box
    for (hole = box_mating_holes) {
        translate(hole + [0, 0, base_height + wall_thickness + 2])
        screw(M3_pan_screw, 8);
    }
}

if ($preview) {
    electronics_assembly();
}