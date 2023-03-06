// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 2;
length = 4;
height = 1 / 3;
is_closed = false;
tightness = BRICK_TIGHTNESS_DEFAULT;

// texture = "bricks_vnf";
texture = undef;
tex_size = [ 10, 10 ];
tex_scale = 0.5;

brick(width, length, height, is_closed = is_closed, texture = texture, tex_size = tex_size, tex_scale = tex_scale,
      anchor = BOT, $tightness = tightness);
