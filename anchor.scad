use <util.scad>

$fn = 20;

lace_diameter = 3;
tiewrap_width = 2.5;
tiewrap_thickness = 0.65;
lace_clearance = 0.2;
pole_to_pole = 3 * lace_diameter;
lace_x_clearance = (pole_to_pole - lace_diameter) / 2;
pipe_diam = 2.3;
leg_y_spacing = 1.4 - pipe_diam * 0.2;
connector_length = lace_diameter + 2 * lace_clearance + 2 * pipe_diam;
leg_depth = 2 * pipe_diam + leg_y_spacing;
smoothness = pipe_diam / 2;
tiewrap_hole_width = tiewrap_width * 1.4;
leg_length = tiewrap_hole_width + pipe_diam * 2;
leg_spacing = tiewrap_thickness * 1.7 - 0.5;
leg_offset = [leg_length / 2 + lace_diameter / 2 + lace_x_clearance, 1, 0];
total_height = 3 * pipe_diam + 2 * leg_spacing;
hook_height = pipe_diam * 1.4;
pole_height = lace_diameter;

module lock() {
    adjust = 3.4;
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

}

module leg_placement() translate(leg_offset) children();

module roof()
    hull()
        rotate_copy(0, 0, 180)
            leg_placement()
                translate([-leg_length / 2, -leg_depth / 2, lace_diameter / 2 + lace_clearance])
                    smooth_cube(
                        pipe_diam,
                        leg_depth,
                        pipe_diam, smoothness);

module bottom_bar()
    hull()
        rotate_copy(0, 0, 180)
            leg_placement()
                translate([-leg_length / 2, -leg_depth / 2, -lace_diameter / 2 - pipe_diam - lace_clearance])
                    smooth_cube(
                        pipe_diam,
                        leg_depth,
                        pipe_diam, smoothness);

module anchor() {
    roof();
    bottom_bar();
    rotate_copy(0, 0, 180)
        leg_placement()
            leg();

    rotate([0, 0, 180])
        leg_placement()
            translate([- leg_length / 2, -leg_depth/2, -lace_diameter / 2 - pipe_diam])
                smooth_cube(pipe_diam,
                            leg_depth,
                            lace_diameter + 2 * pipe_diam,
                            smoothness);


    leg_placement()
        translate([- leg_length / 2, -leg_depth/2, -total_height / 2 - pole_height])
            smooth_cube(pipe_diam,
                        leg_depth,
                        total_height + 2 * pole_height,
                        smoothness);

}

color("grey")
    anchor();
