w_h = 16;

difference() {

    rotate(-45)
    difference() {
        rotate(45)
        translate([-20, -20])
        cube([40, 40, w_h]);

        c = sqrt(pow(40, 2) + pow(40, 2));
        translate([-c/2, 0, -1])
        cube([c, c, w_h + 2]);
    }

    translate([10, 0, w_h / 2])
    rotate([90, 0, 0])
    cylinder(r1 = 5, r2 = 5, h = 15);

    translate([-15, 10, w_h / 2])
    rotate([0, 90, 0])
    cylinder(r1 = 5, r2 = 5, h = 15);

    translate([10, 0, w_h / 2])
    rotate([90, 0, 0])
    cylinder(r1 = 3, r2 = 3, h = 25);

    translate([-25, 10, w_h / 2])
    rotate([0, 90, 0])
    cylinder(r1 = 3, r2 = 3, h = 25);

}