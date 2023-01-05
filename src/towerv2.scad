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



tower_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(10);
tower_d2 = 2.5*2; 

size = 6;
height = 6;
tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

difference()
{
    cyl(h=tower_height, d1=tower_d1, d2=tower_d2, anchor=BOT, texture="bricks_vnf", tex_size=[10,10], tex_scale=0.5, tex_style="concave")
    {
        attach(TOP) BRICK_STUDS(1, 1);   
    }
    down(2)cyl(h=tower_height, d1=tower_d1-2, d2=tower_d2-2, anchor=BOT);
}
brick_box(6, 6, 1.0, is_tile=true, printer=printer);

// path = cuboid([50,50,50]);
// linear_sweep(
//     path, texture="bricks_vnf", tex_size=[10,10],
//     tex_scale=0.25, h=40);

// tex = texture("bricks_vnf");
// linear_sweep(
//     rect(50), texture=tex, h=40,
//     tex_size=[5,5]
// );


