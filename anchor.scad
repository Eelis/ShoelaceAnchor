use <util.scad>

$fn = 20;

tiewrap_width = 2.5;
tiewrap_thickness = 0.65;
lace_clearance = 0.2;
pole_to_pole = 9;
pipe_diam = 2.5;
leg_y_spacing = 1.4 - pipe_diam * 0.2;
leg_depth = 2 * pipe_diam + leg_y_spacing;
smoothness = pipe_diam / 2;
tiewrap_hole_width = tiewrap_width * 1.4;
leg_length = tiewrap_hole_width + pipe_diam * 2;
leg_spacing = tiewrap_thickness * 1.7 - 0.5;
leg_offset = [10, 2, 0];
total_height = 3 * pipe_diam + 2 * leg_spacing;
hook_height = pipe_diam * 1.4;
pole_height = 2.5;

module lock() {
    adjust = 3.7;
    mirror_copy(0, 0, 1)
        translate([-leg_length / 2 + ((leg_length - adjust)/2),
                   leg_depth / 2 - pipe_diam / 2,
                   pipe_diam + leg_spacing])
            smooth_cube(leg_length - adjust,
                        pipe_diam,
                        pipe_diam,
                        smoothness, center = true);
}

module angled_sidewall()
    translate([-3, -1.5, 0])
        rotate([0, 0, 23])
            translate([-pipe_diam / 2, -pole_height-pipe_diam / 2, -(pipe_diam * 1.4) / 2])
                smooth_cube(pipe_diam,
                            pole_height + pipe_diam,
                            pipe_diam * 1.4,
                            smoothness);

module leg() {
    lock();

    // hook
    translate([leg_length/2 - pipe_diam / 2, 0, 0]) {
        smooth_cube(pipe_diam, leg_depth, hook_height, smoothness, center = true);

        translate([0, leg_depth/2 - smoothness, 0])
            rotate([0, 0, 32])
                translate([0, leg_depth*0.8/2 - smoothness, 0])
                    smooth_cube(pipe_diam, leg_depth*0.8, hook_height, smoothness, center = true);
    }

    // straight sidewall:
    translate([- leg_length / 2, -leg_depth/2, -total_height / 2])
        smooth_cube(pipe_diam,
                    leg_depth,
                    total_height,
                    smoothness);

    hull() {
        angled_sidewall();
        // back bone:
        translate([0, -leg_depth / 2 + pipe_diam / 2, 0])
            smooth_cube(leg_length,
                        pipe_diam,
                        pipe_diam * 1.4,
                        smoothness, center = true);

    }

    // wedge:
    hull() {
        translate([- leg_length / 2, -leg_depth/2, -total_height / 2])
            smooth_cube(pipe_diam,
                        pipe_diam,
                        total_height,
                        smoothness);

        angled_sidewall();
    }
}

module leg_placement() translate(leg_offset) children();

module roof()
    hull()
        rotate_copy(0, 0, 180)
            leg_placement()
                translate([-leg_length / 2, -pipe_diam / 2, total_height / 2 - pipe_diam])
                    smooth_cube(
                        pipe_diam,
                        pipe_diam,
                        pipe_diam, smoothness);

module floor()
    hull()
        rotate_copy(0, 0, 180)
            leg_placement()
                translate([-leg_length / 2, -pipe_diam / 2, -total_height / 2])
                    smooth_cube(
                        pipe_diam,
                        pipe_diam,
                        pipe_diam, smoothness);

module anchor() {
    roof();
    floor();
    rotate_copy(0, 0, 180)
        leg_placement()
            leg();

    // center pole
    cylinder(r = pipe_diam/2, h = total_height - pipe_diam, center = true);
}

color("grey")
    anchor();
