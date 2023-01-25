include<BOSL2\std.scad>;
include <bricklib.scad>;

$fn = 64;

printer = "bambu";

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

BRICK_FLAGS_HOLLOW_ALL_THE_WAY = false;


module brick_tower_roof()
{

  height = 6;
  size_roof = 11;
  wall_size = 2.4;

  texture_scale = 0.5;

  // It seems like the cyl is pushed down a bit when using tex_inset=true.
  // So it seems better to use tex_inset=false and instead make the diameter smaller.
  // This is to prevent that the texture add to the size of the cyl.
  tower_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(size_roof) - 2 * texture_scale;
  tower_d2 = 2.5*2; 

  tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  // The cyl (roof)
  difference()
  {
      cyl(h=tower_height, d1=tower_d1, d2=tower_d2, anchor=BOT, texture="bricks_vnf", tex_size=[10,10], tex_scale=texture_scale, tex_inset=false, tex_style="concave")
      {
          attach(TOP) BRICK_STUDS(1, 1);   
      }
      down(wall_size)cyl(h=tower_height, d1=tower_d1-wall_size, d2=tower_d2-wall_size, anchor=BOT);
  }

  // Close the cyl
  magic_number_to_make_sure_we_close_the_gap = 0.2;
  difference()
  {
    cyl(h=wall_size, d=tower_d1-wall_size*2+magic_number_to_make_sure_we_close_the_gap, anchor=BOT);
    brick(6, 6, 1, is_tile=true, is_closed=true, printer=printer);
  }

  // Bottom brick
  brick_box(6, 6, 1, is_tile=true, printer=printer);
}