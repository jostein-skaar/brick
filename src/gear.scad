// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

teeth = 24;
clearance = 0.0;         // Must be overridden for teeth=8 (-0.2 or something)
extra_adjust_axle = 0.0; // Lesser is more tight

brick_gear(teeth = teeth, clearance = clearance, $tightness = extra_adjust_axle);