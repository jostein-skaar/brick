// clang-format off
include<bigbricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 1;
length = 3;
// height = 1/9;
height = 2+1/2;
is_closed = false;
// tightness = BIGBRICK_TIGHTNESS_DEFAULT;
tightness = BIGBRICK_TIGHTNESS_LOOSE-0.1;

physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);
echo("physical_height", physical_height);

echo("width", BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length));
echo("height", BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height));

// texture = "bricks_vnf";
texture = undef;
tex_size = [ 10, 10 ];
tex_scale = 0.5;

bigbrick(width, length, height, is_closed = is_closed, texture = texture, tex_size = tex_size, tex_scale = tex_scale,
      anchor = BOT, $tightness = tightness);
