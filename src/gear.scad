include<BOSL2\std.scad>;
include<BOSL2\gears.scad>;
include <bricklib.scad>;

$fn = 64;

// For now, the adjustment is equal for all printers (so no need to specify printer as long that remain true).
printer = "bambu";
teeth = 24;
clearance = 0.0; // Must be overridden for teeth=8 (-0.2 or something)
extra_adjust_axle = 0.0; // Lesser is more tight

  // TODO: Set one place
  adjustments = BRICK_ADJUSTMENTS_FOR_PRINTER(printer);
  echo (adjustments);
  $BRICK_ADJUST_STUD_D = adjustments[1];
  $BRICK_ADJUST_ANTISTUD_D = adjustments[2];
  $BRICK_ADJUST_ANTISTUD_D_OUTER = adjustments[3];
  $BRICK_ADJUST_WALLS = adjustments[4];
  $BRICK_ADJUST_TOTAL_SIZE = adjustments[5];
  $BRICK_ADJUST_ANTISTUD_SINGLE_D = adjustments[6];
  $BRICK_ADJUST_WALLS_SINGLE = adjustments[7];
  $BRICK_ADJUST_GEARS_MOD = adjustments[8];
  $BRICK_ADJUST_AXLE = adjustments[9];
  $BRICK_ADJUST_WALL_SPLINE_WIDTH = adjustments[10];

actual_mod = BRICK_SIZE_GEARS_MOD + $BRICK_ADJUST_GEARS_MOD;
actual_axle_width = BRICK_SIZE_AXLE_WIDTH + $BRICK_ADJUST_AXLE + extra_adjust_axle;
actual_axle_length = BRICK_SIZE_AXLE_LENGTH + $BRICK_ADJUST_AXLE + extra_adjust_axle;

thickness = BRICK_CALCULATE_PHYSICAL_LENGTH(1);
pressure_angle = BRICK_SIZE_GEARS_PRESSURE_ANGLE;
shaft_diam = 0;
text_height = 0.4;

pr = pitch_radius(mod = BRICK_SIZE_GEARS_MOD, teeth = teeth);
actual_pr = pitch_radius(mod = actual_mod, teeth = teeth);
echo("pitch_radius (original vs actual) for teeth=", teeth, pr, actual_pr);

difference()
{
  spur_gear(mod = actual_mod, teeth = teeth, thickness = thickness, shaft_diam = shaft_diam, pressure_angle = pressure_angle,
            clearance = clearance, anchor = BOT);
  BRICK_AXLE_HOLE(actual_axle_width, actual_axle_length, thickness);

  // Add text with teeth number if many teeth (no room when few)
  if (teeth > 15)
  {
    fwd(actual_axle_width + 0.7 + teeth/10) up(thickness - text_height)
    linear_extrude(height = text_height)
    text(str(teeth), size = 3.4, font = "Liberation Sans:style=Bold", halign = "center", valign = "center", spacing = 1, $fn = 16);  
  }
}