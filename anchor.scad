use <util.scad>

$fn = 20;

lace_diameter = 3.5;
tiewrap_width = 2.5;
tiewrap_thickness = 0.65;
lace_clearance = 0.4;
pipe_diam = 2.3;
leg_y_spacing = 1.4 - pipe_diam * 0.2;
connector_length = lace_diameter + 2 * lace_clearance + 2 * pipe_diam;
leg_depth = 2 * pipe_diam + leg_y_spacing;
smoothness = pipe_diam / 2;
tiewrap_hole_width = tiewrap_width * 1.1;
leg_length = tiewrap_hole_width + pipe_diam * 2;
leg_spacing = tiewrap_thickness * 1.7 - 0.5;
leg_offset = [leg_length / 2 + lace_diameter / 2 + lace_clearance, 1, 0];
total_height = 3 * pipe_diam + 2 * leg_spacing;
hook_height = pipe_diam * 1.4;

module lock() {
    adjust = 3.6;
    mirror_copy(0, 0, 1)
        translate([-leg_length / 2 + ((leg_length - adjust)/2),
                   leg_depth / 2 - pipe_diam / 2,
                   pipe_diam + leg_spacing])
            smooth_cube(leg_length - adjust,
                        pipe_diam,
                        pipe_diam,
                        smoothness, center = true);
}

module leg() {
    // back
    translate([0, -leg_depth / 2 + pipe_diam / 2, 0])
        smooth_cube(leg_length,
                    pipe_diam,
                    pipe_diam * 1.4,
                    smoothness, center = true);
    lock();

    // hook
    translate([leg_length/2 - pipe_diam / 2, 0, 0]) {
        smooth_cube(pipe_diam, leg_depth, hook_height, smoothness, center = true);

        translate([0, leg_depth/2 - smoothness, 0])
            rotate([0, 0, 32])
                translate([0, leg_depth*0.8/2 - smoothness, 0])
                    smooth_cube(pipe_diam, leg_depth*0.8, hook_height, smoothness, center = true);
    }

    hull() {
        // vertical
        translate([- leg_length / 2, -leg_depth / 2, -hook_height / 2])
            smooth_cube(pipe_diam,
                        leg_depth,
                        total_height / 2 + hook_height / 2,
                        smoothness);

        // bottom
        translate([- leg_length / 2, -pipe_diam / 2 - leg_offset[1], -total_height / 2])
            smooth_cube(pipe_diam,
                        leg_depth/2 - (-pipe_diam/2 - leg_offset[1]),
                        pipe_diam,
                        smoothness);
    }
}

module leg_placement() translate(leg_offset) children();

module roof()
    hull()
        rotate_copy(0, 0, 180)
            leg_placement()
                translate([-leg_length / 2, -leg_depth / 2, -pipe_diam / 2 + pipe_diam + leg_spacing])
                    smooth_cube(
                        pipe_diam,
                        leg_depth,
                        pipe_diam, smoothness);

module bottom_bar()
    translate([0, 0, -leg_spacing - pipe_diam])
        smooth_cube(lace_diameter + 2 * (lace_clearance + pipe_diam),
          pipe_diam, pipe_diam, smoothness, center = true);

module anchor() {
    roof();
    bottom_bar();
    rotate_copy(0, 0, 180)
        leg_placement()
            leg();
}

color("grey")
    anchor();
