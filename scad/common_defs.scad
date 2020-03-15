include <NopSCADlib/vitamins/nuts.scad>

// The Monoprice Mini Delta uses 4mm width belts
GT2x4 = ["GT", 2.0, 4, 1.38, 0.75, 0.254];

MPMD_pulley = [
    "MPMD_pulley",
    "MPMD Pulley",
    14, // number of teeth
    8.65, // outer diameter
    GT2x4, // belt
    5.3, // width of belt channel
    9.6, // hub diameter
    5.5, // hub length
    5, // bore
    10.8, // flange diameter
    1.0, // flange thickness
    0, // screw l
    0, // screw z
    false, // screw
    0 // num. screws
];

MPMD_idler = [
    "MPMD_idler",
    "MPMD Idler",
    14, // number of teeth
    8.65, // outer diameter
    GT2x4, // belt
    6, // width of belt channel
    9.6, // hub diameter
    0, // hub length
    5, // bore
    10.8, // flange diameter
    1.0, // flange thickness
    0, // screw l
    0, // screw z
    false, // screw
    0 // num. screws
];

module pyramid(dim_bottom, dim_top, h) {
    difference() {
        cube(concat(dim_bottom, h));

        x_diff = (dim_bottom[0] - dim_top[0]) / 2;
        x_angle = atan(h / x_diff);
        x_h_diff = sin(x_angle) / x_diff + 10;
        
        rotate([0, 90 - x_angle, 0])
        translate([-dim_bottom[0], 0, 0])
        cube([dim_bottom[0], dim_bottom[1], h + x_h_diff]);

        translate([dim_bottom[0], 0, 0])
        rotate([0, -(90 - x_angle), 0])
        cube([dim_bottom[0], dim_bottom[1], h + x_h_diff]);

        y_diff = (dim_bottom[1] - dim_top[1]) / 2;
        y_angle = atan(h / y_diff);
        y_h_diff = sin(y_angle) / y_diff + 10;
        
        translate([0, dim_bottom[1], 0])
        rotate([90 - y_angle, 0, 0])
        cube([dim_bottom[0], dim_bottom[1], h + y_h_diff]);

        rotate([-(90 - y_angle), 0, 0])
        translate([0, -dim_bottom[1], 0])
        cube([dim_bottom[0], dim_bottom[1], h + y_h_diff]);
    }
}

module square_nut_trap(type, length = 10, depth = 100) {
    width = nut_square_width(type);
    height = nut_square_thickness(type) + layer_height;
    screw_r = nut_square_size(type) / 2;

    union() {
        translate([-width / 2, -width / 2])
        cube([width, length, height]);
        cylinder(r1 = screw_r, r2 = screw_r, h = depth);
    }
}