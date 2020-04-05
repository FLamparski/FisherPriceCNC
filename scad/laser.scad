include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/fans.scad>

screw_holes = [
    [0, 0, 6],
    [10, 0, 6],
    [-10, 0, 6],
    [0, 0, 28],
    [0, 0, 46],
    [10, 0, 46],
    [-10, 0, 46]
];

module laser_screw_hole_positions() {
    for (pos = screw_holes) {
        translate(pos) {
            children();
        }
    }
}

module laser() {
    vitamin("laser module");
    screw_r = screw_radius(M3_cap_screw);

    color("#111111")
    difference() {
        union() {
            translate([-20, -20, 0])
            cube([40, 40, 75]);

            translate([0, 0, -8.25])
            cylinder(r = 10, h = 6);

            translate([0, 0, -8.25])
            cylinder(r = 6, h = 8.25);
        }

        translate([0, 0, -8.26])
        cylinder(r = 4, h = 2);

        // cooling fins
        for (i=[0:8]) {
            translate([20 - 6 - i * 3.8, 15.1, -0.1])
            cube([2, 5, 75.2]);
        }
        for (i=[0:6]) {
            rotate([0, 0, 90])
            translate([20 - 10 - i * 4, 10.1, -0.1])
            cube([2, 10, 75.2]);
        }
        for (i=[0:6]) {
            rotate([0, 0, -90])
            translate([20 - 10 - i * 4, 10.1, -0.1])
            cube([2, 10, 75.2]);
        }

        // screw holes
        laser_screw_hole_positions() {
            translate([0, -14, 0])
            rotate([90, 0, 0])
            cylinder(r = screw_r, h = 7);
        }
    }
}

//! Typically the fan should come pre-installed,
//! but you may need to do it yourself.
module laser_module_assembly()
assembly("laser_module") {
    laser();

    translate([0, 0, 80.5])
    fan(fan40x11);
}

if ($preview) {
    laser_module_assembly();
}