epsilon = 0.1;

module mirror_copy(x, y, z) {
    children();
    mirror([x, y, z]) children();
}

module rotate_copy(x, y, z) {
    children();
    rotate([x, y, z]) children();
}

module optionally_translate(x, y, z, doit) {
    if (doit) translate([x, y, z]) children();
    else children();
}

module smooth_cube(x, y, z, s, center = false) {
    optionally_translate(x / 2, y / 2, z / 2, !center)
        mirror_copy(1, 0, 0)
        mirror_copy(0, 1, 0)
        mirror_copy(0, 0, 1)
            smooth_cube_corner(x / 2, y / 2, z / 2, s);
}

module smooth_cube_corner(x, y, z, s) {
    translate([s, s, s])
        cube(size = [x - s * 2, y - s * 2, z - s * 2]);

    translate([-epsilon, -epsilon, -epsilon]) {
        cube(size = [x     + epsilon, y - s + epsilon, z - s + epsilon]);
        cube(size = [x - s + epsilon, y     + epsilon, z - s + epsilon]);
        cube(size = [x - s + epsilon, y - s + epsilon, z     + epsilon]);
    }

    translate([-epsilon, y - s, z - s]) rotate([  0, 90, 0]) cylinder(h = x - s + epsilon, r = s);
    translate([x - s, y - s, -epsilon]) rotate([  0,  0, 0]) cylinder(h = z - s + epsilon, r = s);
    translate([x - s, -epsilon, z - s]) rotate([270,  0, 0]) cylinder(h = y - s + epsilon, r = s);

    translate([x - s, y - s, z - s]) sphere(s);
}
