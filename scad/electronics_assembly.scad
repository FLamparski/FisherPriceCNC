include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/pcbs.scad>
include <NopSCADlib/vitamins/pin_headers.scad>
include <NopSCADlib/vitamins/green_terminals.scad>
include <NopSCADlib/vitamins/fans.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/nuts.scad>


th = pcb_thickness(ArduinoUno3);
arduino_holes = pcb_holes(ArduinoUno3);
mounting_holes = [arduino_holes[1], arduino_holes[2], arduino_holes[3]];

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

wall_thickness = 2;
standoff_r = nut_radius(M3_nut) + 1;
standoff_h = nut_thickness(M3_nut);

module controller_box_base_stl() {
    stl("controller_box_base");

    poly_path = [
        [-41, -35],
        [-41, 35],
        [40, 35],
        [40, -35]
    ];
    union() {
        difference() {
            union() {
                linear_extrude(wall_thickness) {
                    polygon(poly_path);
                }

                translate([0, 0, wall_thickness])
                pcb_screw_positions(ArduinoUno3) {
                    cylinder(r = standoff_r, h = standoff_h);
                }
            }

            for (hole = mounting_holes) {
                hole_pos = hole - [pcb_length(ArduinoUno3), pcb_width(ArduinoUno3)] / 2;
                translate([hole_pos[0], hole_pos[1], 0])
                nut_trap(M3_cap_screw, M3_nut);
            }
        }

        difference() {
            linear_extrude(standoff_h + wall_thickness + th + 12.5)
            polygon(
                points=[
                    poly_path[0],
                    poly_path[1],
                    poly_path[2],
                    poly_path[3],
                    poly_path[0] + [2, 2],
                    poly_path[1] + [2, -2],
                    poly_path[2] + [-2, -2],
                    poly_path[3] + [-2, 2]
                ],
                paths=[[0,1,2,3],[4,5,6,7]]
            );

            translate([-41.5, 4.5, standoff_h + wall_thickness + th - 0.5])
            cube([wall_thickness + 1, 13, 12]);
        }

        translate([-38, -40, standoff_h + wall_thickness + th + 12.5])
        rotate([0, 90, 0])
        linear_extrude(20)
        polygon([
            [0, 0],
            [0, 5],
            [5, 5]
        ]);
    }
    
}

fan60x11 = [60, 11, 57, 25, M4_cap_screw, 29, 2.4, 60, 7, 7.7, 63];

module electronics_assembly()
assembly("electronics") {
    translate([0, 0, standoff_h + wall_thickness])
    pcb(ArduinoUno3);

    translate([0, 0, standoff_h + wall_thickness + 12.5])
    *cnc_shield();

    translate([0, 0, 50])
    *fan(fan60x11);

    translate([0, 0, 0])
    controller_box_base_stl();

    // barrel plug to screw terminals converter
    translate([-28, -35, standoff_h + wall_thickness + 12.1 + 8]) {
        color(grey20)
        cube([15, 11, 12], center=true);

        translate([0, 15/2, 1])
        color("green")
        cube([10, 4, 10], center=true);
    }

    for (hole = mounting_holes) {
        hole_pos = hole - [pcb_length(ArduinoUno3), pcb_width(ArduinoUno3)] / 2;
        translate([hole_pos[0], hole_pos[1], 0.5])
        nut(M3_nut);

        translate([hole_pos[0], hole_pos[1], standoff_h + th + 2])
        screw(M3_pan_screw, 6);
    }
}

if ($preview) {
    electronics_assembly();
}