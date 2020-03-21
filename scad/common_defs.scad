include <NopSCADlib/vitamins/nuts.scad>

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
        cylinder(r1 = screw_r * 1.05, r2 = screw_r, h = depth);
    }
}