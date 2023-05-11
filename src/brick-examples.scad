// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

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

// ribs, trunc_ribs, trunc_ribs_vnf, wave_ribs, diamonds, diamonds_vnf, pyramids, pyramids_vnf
// trunc_pyramids, trunc_pyramids_vnf, hills, bricks, bricks_vnf, checkers, cones, cubes
// trunc_diamonds, dimples, dots, tri_grid, hex_grid, rough
// texture = "trunc_diamonds";
texture = undef;
tex_size = [ 10, 10 ];
tex_scale = 0.5;
// tex_size = [ BRICK_CALCULATE_PHYSICAL_LENGTH(width) / width, BRICK_CALCULATE_PHYSICAL_HEIGHT(length) / length ];

// linear_sweep(shape, h = 10, texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = true);

// brick_from_region(rgn = rgn, width = 6, length = 6, height = 2);

width = 6;
length = 8;
height = 4;

brick_box(width = width, length = length, height = height, texture = texture, tex_size = tex_size,
          tex_scale = tex_scale);