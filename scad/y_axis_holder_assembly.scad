// Based loosely on the y-rod holders from Prusa i3 MK3s

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/nuts.scad>
include <NopSCADlib/vitamins/screws.scad>
include <NopSCADlib/vitamins/zipties.scad>
include <NopSCADlib/vitamins/rod.scad>

include <common_consts.scad>

module ziptie_round_edge() {
    difference() {
        translate([0,0,0]) rotate([90,0,0]) cylinder( h=3.2, r=4, $fn=50 );  
        translate([0,1,0]) rotate([90,0,0]) cylinder( h=5, r=2, $fn=50 );  
        translate([-10,-4,0]) cube([20,5,5]);
        translate([-20,-4,-13]) cube([20,5,20]);
    }
}

module y_axis_holder_stl() {
    stl("y_axis_holder");

    width = 26;
    depth = 11;
    bottom_height = 9;
    top_height = 8;
    difference() {
        union() {
            // body - bottom part with screw
            translate([-width/2, -depth/2, 0])
            cube([width, depth, bottom_height]);

            // body - top part with hole and ziptie
            translate([-width/2, -depth/2, bottom_height])
            cube([width, depth, top_height]);
        }

        // bottom corners
        translate([-15,-depth/2,-6]) rotate([45,0,0]) cube([30,5,5]);
        translate([15,depth/2,-6]) rotate([45,0,180]) cube([30,5,5]);

        // top corners
        translate([width / 2 + 5, -depth/2, 15]) rotate([0,60,0]) cube([20,30,20], center = true);
        translate([-width / 2 - 5, -depth/2, 15]) rotate([0,-60,0]) cube([20,30,20], center = true);

        // screw path
        clearance_radius = screw_clearance_radius(M4_cap_screw);
        cylinder(r1 = clearance_radius, r2 = clearance_radius, h = 5);

        head_radius = screw_head_radius(M4_cap_screw) + 0.2;
        translate([0, 0, 5])
        cylinder(r1 = head_radius, r2 = head_radius, h = 30);

        // space for the rod
        translate([0, 0, y_holder_rod_offset])
        rotate([90, 0, 0])
        rod(8, 30);
        
        // chamfers for the rod cutout:
        // side 1
        translate([0, -depth/2 + 0.9, y_holder_rod_offset])
        rotate([90, 0, 0])
        cylinder(r1 = 4, r2 = 4.5, h = 1);
        // side 2
        translate([0, depth/2 - 0.9, y_holder_rod_offset])
        rotate([-90, 0, 0])
        cylinder(r1 = 4, r2 = 4.5, h = 1);
        // from top
        translate([0, -8, y_holder_rod_offset - 4])
        rotate([45, 0, 90])
        cube([20, 8, 8]);

        // ziptie
        translate([0, -3.2/2, 0])
        union() {
            cutout_width = width * 0.6;
            cutout_height = bottom_height + 2;
            ziptie_width = 3.2;
            translate([cutout_width / 2, ziptie_width, 4 + cutout_height]) ziptie_round_edge();
            translate([-cutout_width / 2, 0, 4 + cutout_height]) rotate([0,0,180]) ziptie_round_edge();
            translate([-cutout_width / 2, 0, cutout_height]) cube([cutout_width, ziptie_width, 2]);
        }
        translate([0, -3.2/2, 30.75]) rotate([0,60,0]) cube([20,3.2,2]);
        translate([-1.75, -3.2/2, 31.75]) rotate([0,120,0]) cube([20,3.2,2]);
    }
}

//! There are 8 of these y-axis holders. For each of them, insert an M4 screw into the hole and
//! fasten a M4 T-nut at the bottom loosely. Don't tighten them too much as you will need to insert
//! the T-nut into the 3060 extrusion. Then you can tighten the screw, but make sure the alignment
//! works.
module y_axis_holder_assembly()
assembly("y_axis_holder") {
    color(printed_part_color)
    y_axis_holder_stl();

    translate([0, 0, -1.25])
    rotate([180, 0, 90])
    sliding_t_nut(M4_sliding_t_nut);

    translate([0, 0, 5])
    screw(M4_cap_screw, 10);

    translate([0, 0, y_holder_rod_offset])
    rotate([90, 100, 0])
    ziptie(small_ziptie, 9);
}


if ($preview) {
    translate([0, 0, y_holder_rod_offset])
    rotate([90, 0, 0])
    rod(8, 30);

    y_axis_holder_assembly();
}
else {
    rotate([90, 0, 0])
    y_axis_holder_stl();
}
