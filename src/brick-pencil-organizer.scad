// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 4;
length = 4;
height = 3; // 3,6,9,12

texture = "diamonds_vnf";
// texture = [
//   [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
//   [ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
//   [ 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1 ],
//   [ 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1 ],
//   [ 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1 ],
//   [ 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1 ],
//   [ 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1 ],
//   [ 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1 ],
//   [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ],
//   [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ],
//   [ 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1 ],
//   [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
// ];
// texture = undef;
// ribs, trunc_ribs, trunc_ribs_vnf, wave_ribs, diamonds, diamonds_vnf, pyramids, pyramids_vnf
// trunc_pyramids, trunc_pyramids_vnf, hills, bricks, bricks_vnf, checkers, cones, cubes
// trunc_diamonds, dimples, dots, tri_grid, hex_grid, rough
tex_scale = 0.5;

tube_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
tube_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
tube_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
brick_height = 1 / 3;
brick_physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(brick_height);
tube_wall = 2;
brick_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
echo("tube_wall", tube_wall, "tube_width", tube_width);

tex_size = [ BRICK_CALCULATE_PHYSICAL_LENGTH(4) / 4, BRICK_CALCULATE_PHYSICAL_HEIGHT(4) / 4 ];

// Tube with texture
path = difference(rect([ tube_width, tube_length ]), rect([ tube_width - tube_wall * 2, tube_length - tube_wall * 2 ]));
diff()
  linear_sweep(path, texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = true, h = tube_height)
{
  tag("remove") position(BOT)
    cuboid([ tube_width - brick_wall_thickness * 2, tube_length - brick_wall_thickness * 2, brick_physical_height ],
           anchor = BOT);
}

// The brick part
difference()
{
  brick(width, length, brick_height, is_tile = true, texture = undef, tex_size = tex_size, tex_scale = tex_scale,
        anchor = BOT);
  // Get rid of brick wall sticking out of tube wall's texture
  rect_tube(h = brick_physical_height, size = [ tube_width, tube_length ], wall = 1);
}