// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 4;
length = 8;
height = 6; // 3,6,9,12
is_closed = false;

// texture = "bricks_vnf";
// texture = "pyramids_vnf";
// texture = "hex_grid";
// texture = "trunc_pyramids_vnf";
// texture = "trunc_diamonds";
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

//  brick_box(width = width, length = length, height = height - 1 / 3, is_tile = true);

tube_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
tube_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
tube_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
brick_height = 1 / 3;
brick_physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(brick_height);
// tube_wall = BRICK_CALCULATE_PHYSICAL_LENGTH(1 / 4);
tube_wall = 2;
brick_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
echo("tube_wall", tube_wall, "tube_width", tube_width);

tex_size = [ BRICK_CALCULATE_PHYSICAL_LENGTH(4) / 4, BRICK_CALCULATE_PHYSICAL_HEIGHT(4) / 4 ];
path = difference(rect([ tube_width, tube_length ]), rect([ tube_width - tube_wall * 2, tube_length - tube_wall * 2 ]));
diff()
  linear_sweep(path, texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = true, h = tube_height)
{
  tag("remove") position(BOT)
    cuboid([ tube_width - brick_wall_thickness * 2, tube_length - brick_wall_thickness * 2, brick_physical_height ],
           anchor = BOT);
}

difference()
{
  brick(width, length, brick_height, is_closed = false, is_tile = true, texture = undef, tex_size = tex_size,
        tex_scale = tex_scale, anchor = BOT);

  rect_tube(h = brick_physical_height, size = [ tube_width, tube_length ], wall = 1);
}

// diff() brick(width, length, brick_height, is_closed = false, is_tile = true, texture = undef, tex_size = tex_size,
//              tex_scale = tex_scale, anchor = BOT)
// {
//   //#tag("remove") position(BOT) rect_tube(h = brick_physical_height, size = [ tube_width, tube_length ], wall =
//   1);
// }

// cyl(d = tube_width, h = 20, $fn = 4, anchor = BOT, spin = 45);
// diff()

//   rect_tube(h = tube_height, size = [ tube_width, tube_length ], wall = tube_wall)
// {
//   tag("remove") position(BOT)
//     cuboid([ tube_width - brick_wall_thickness * 2, tube_length - brick_wall_thickness * 2, brick_physical_height
//     ],
//            anchor = BOT);
// }

// brick(width, length, brick_height, is_closed = false, is_tile = true, texture = texture, tex_size = tex_size,
//       tex_scale = tex_scale, anchor = BOT);
