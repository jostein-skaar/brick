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


size_roof = 11;

brick_tower_with_window(height=6, printer=printer);

module brick_tower_with_window(height, printer)
{
    size = 6;
    size_ground = 9;    
    tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);    
    magic_number_to_fit_cyl_to_brick = 3.2; // Just to reduce total size (and cost/weight of filament)
    tower_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size_ground)-magic_number_to_fit_cyl_to_brick;
    // left(4)fwd(tower_d/2-20.8)ruler(100, width=8, orient=LEFT, anchor=LEFT);
        
    difference()
    {
        brick_tower(height=height, printer=printer);
        up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1))fwd(tower_d/4) BRICK_WINDOW(tower_d, is_mask=true);
    }            
    up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1))fwd(tower_d/4) BRICK_WINDOW(tower_d, is_mask=false);
}

module brick_tower(height, printer)
{
    size = 6;
    size_ground = 9;    
    tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
    magic_number_to_fit_cyl_to_brick = 3.2; // Just to reduce total size (and cost/weight of filament)
    tower_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size_ground)-magic_number_to_fit_cyl_to_brick;

    difference()
    {
        cyl(h=tower_height, d=tower_d, anchor=BOT, texture="bricks_vnf", tex_size=[10,10], tex_scale=0.5, tex_inset=true, tex_style="concave");
        brick(size, size, height, is_tile=true, is_closed=true, printer=printer);
    }

    brick_box(size, size, height, printer=printer);
}

module BRICK_WINDOW(tower_d, is_mask=false, anchor=BOT, spin = 0, orient = UP)
{    
    width_total = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(4);
    height_total = 40;

    d_cyl = width_total;        
    
    width_cube = width_total;
    height_cube = height_total-d_cyl/2;

    size = [ width_cube, tower_d/2, height_total ];

    attachable(anchor, spin, orient, size = size)
    {
        if (is_mask)
        {
            down(d_cyl/4)
            {                
                cuboid([width_cube, tower_d/2, height_cube], anchor=CENTER);                
                up(height_cube/2)resize([0,0,d_cyl])ycyl(d=d_cyl, h=tower_d/2, anchor=CENTER, $fn=200);
            }
        }
        else 
        {        
            magic_number_to_align_studs_with_studs_on_top = 6.8;  
            fwd(magic_number_to_align_studs_with_studs_on_top) down(height_total/2) BRICK_STUDS(4, 2);                        
        }

        children();
    }
}


// brick_box(6, 6, 1, is_tile=true, printer=printer);

// path = cuboid([50,50,50]);
// linear_sweep(
//     path, texture="bricks_vnf", tex_size=[10,10],
//     tex_scale=0.25, h=40);

// tex = texture("bricks_vnf");
// linear_sweep(
//     rect(50), texture=tex, h=40,
//     tex_size=[5,5]
// );


