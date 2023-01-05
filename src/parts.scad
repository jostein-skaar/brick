include <bricklib.scad>;

// printer = "bambu";
printer = "ender";

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

size = 6;
height = 6;

texture_depth = 0.5;
physical_size = BRICK_CALCULATE_PHYSICAL_LENGTH(size);
physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

difference()
{
    brick_box(size, size, height, is_tile=false, printer=printer);
    rect_tube(size=physical_size, h=physical_height, wall=texture_depth, anchor=BOT);
}

difference()
{
    linear_sweep(rect(physical_size), h=physical_height, texture="bricks_vnf", tex_size=[50,50], tex_scale=texture_depth/1, tex_inset=true);
    cuboid([physical_size-texture_depth*2, physical_size-texture_depth*2, physical_height], anchor=BOT);
}




// cuboid([physical_size, physical_size, physical_height], anchor=CENTER);
