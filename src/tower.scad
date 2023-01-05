include <bricklib.scad>;



printer = "bambu";

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


brick_box(6, 6, 0.51, is_tile=true, printer=printer);

// Values from svg file
// Physical height: 57.600
tower_d1 = 40.0 *2;
tower_d2 = 2.5*2; 


size = 6;
height = 6;

tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);




h = BRICK_CALCULATE_PHYSICAL_HEIGHT(6);
d = BRICK_CALCULATE_PHYSICAL_LENGTH(6+3);
echo("H6, D6", h, d);






BRICK_TOWER(size, height)
{
    attach(TOP) BRICK_STUDS(1, 1);    
}


module BRICK_TOWER(size, height, anchor = BOT, spin = 0, orient = UP)
{   
    total_tower_size = size+3; 
    tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
    // tower_d1 = 
    // tower_d2 = BRICK_CALCULATE_PHYSICAL_LENGTH(2);

    attachable(anchor=anchor, spin=spin, orient=orient, d1=tower_d1, d2=tower_d2, l=tower_height)
    {
        down(tower_height/2) rotate_extrude($fn = 200) import("shape-tower.svg");

        children();
    }
}