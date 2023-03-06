// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

// texture = "bricks_vnf";
// texture = "bricks";
texture = undef;
tex_size = [ 10, 10 ];
tex_scale = 0.5;

// linear_sweep(shape, h = 10, texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = true);

// brick_from_region(rgn = rgn, width = 6, length = 6, height = 2);

brick_circle(outer_size = 4, inner_size = 2, height = 1, texture = texture, tex_size = tex_size, tex_scale = tex_scale);

left(60) brick_circle(outer_size = 4, height = 1, texture = texture, tex_size = tex_size, tex_scale = tex_scale);

outer_d = BRICK_CALCULATE_PHYSICAL_LENGTH(6);
inner_d = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
rgn = [ circle(d = outer_d, $fn = 5), circle(d = inner_d, $fn = 3) ];
rgn2 = offset(rgn, delta = 8, closed = true, check_valid = false);
fwd(60) brick_from_region(rgn, 6, 6, 1, texture = texture, tex_size = tex_size, tex_scale = tex_scale);
