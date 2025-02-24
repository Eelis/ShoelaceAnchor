include <anchor.scad>

$fn = 20;

lace_diameter = 3.5;

module lace() {
    translate([-lace_diameter + lace_clearance + 1, 0, 0])
        rotate([90, 0, 0])
            cylinder(h = 10, r = lace_diameter/2, center=true);

/*
    arc_radius = 3.5;
    translate([0, 0, -arc_radius])
        rotate([90, 0, 100])
            rotate_extrude(angle = 180)
                translate([arc_radius, 0, 0])
                    circle(lace_diameter / 2);
                    */
}

module tiewrap(r = 7.5)
    rotate([0, -90, 0])
        translate([0, -r, 0])
            rotate_extrude(angle = 180)
                translate([r, 0, 0])
                    square(size = [tiewrap_thickness, tiewrap_width], center = true);

module swooping_tiewrap()
    leg_placement()
        for (i = [0 : 1 : 8]) {
            a = -54 + i * 18;
            j = 8 - i;
            translate([-0.3-j/20, 1.5, 0])
                rotate([0, 0, 90 - a])
                    translate([0, -1, 0])
                        tiewrap(7);
        }

module context() {
    lace();
    swooping_tiewrap();
}

context();
