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

// roof, tower, door, window
part = "wall-top";


echo (part, printer);

if (part == "roof")
{
    brick_tower_roof();
}
else if (part == "tower")
{
    brick_tower(printer=printer);
}
else if (part == "door")
{
    brick_tower_with_door(printer=printer);
}
else if (part == "window")
{
    brick_tower_with_window(printer=printer);
}
else if (part == "wall")
{
    brick_castle_wall(height=6, printer=printer);
}
else if (part == "wall-top")
{
    brick_castle_wall_top(printer=printer);
}

module brick_castle_wall_top(printer)
{
    width = 2;
    length = 12;   
    height = 6;

    physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
    physical_length2 = BRICK_CALCULATE_PHYSICAL_LENGTH(2);
    physical_length_mask2 = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(2);
    physical_height_minus1 = BRICK_CALCULATE_PHYSICAL_HEIGHT(height-1);

    startPosFirstTopBrick = physical_length/2-physical_length2/2;
    
    BRICK_CASTLE_BRICK_WITH_TEXTURES(width=width, length=length, height=height-1, printer=printer);

    up(physical_height_minus1)
    {
        fwd(startPosFirstTopBrick) BRICK_CASTLE_BRICK_WITH_TEXTURES(width=width, length=2, height=1, printer=printer);
        fwd(startPosFirstTopBrick-physical_length_mask2*2) BRICK_CASTLE_BRICK_WITH_TEXTURES(width=width, length=2, height=1, printer=printer);
        fwd(startPosFirstTopBrick-physical_length_mask2*4) BRICK_CASTLE_BRICK_WITH_TEXTURES(width=width, length=2, height=1, printer=printer);        
    }
}

module brick_castle_wall(height, printer)
{
    width = 2;
    length = 12;   
    height = 6;
    
    BRICK_CASTLE_BRICK_WITH_TEXTURES(width=width, length=length, height=height, printer=printer);
}

module BRICK_CASTLE_BRICK_WITH_TEXTURES(width, length, height, printer)
{    
    texture_scale = 0.5;    

    physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
    physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
    physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
    physical_height1 = BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(1);
    
    difference()
    {
        linear_sweep(rect([physical_width, physical_length]), h=physical_height, texture="bricks_vnf", tex_size=[10,10],tex_scale=0.5, tex_inset=true)
        {
            attach(TOP) BRICK_STUDS(width=width, length=length);
        };
        cuboid([physical_width-texture_scale*2, physical_length-texture_scale*2, physical_height1], anchor=BOT);
    }
    
    difference()
    {        
        brick(width=width, length=length, height=1, is_tile=true, printer=printer);
        rect_tube(size=[physical_width, physical_length], wall=texture_scale, h=physical_height1, anchor=BOT);
    }
}

module brick_tower_with_window(printer)
{
    height = 6;
    size = 6;
    size_ground = 9;    
    tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);    
    magic_number_to_fit_cyl_to_brick = 3.2; // Just to reduce total size (and cost/weight of filament)
    tower_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size_ground)-magic_number_to_fit_cyl_to_brick;    
        
    difference()
    {
        brick_tower(height=height, printer=printer);
        up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1))fwd(tower_d/4) BRICK_TOWER_WINDOW(tower_d, is_mask=true);
    }            
    up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1))fwd(tower_d/4) BRICK_TOWER_WINDOW(tower_d, is_mask=false);
}

module brick_tower(printer)
{
    height = 6;
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

module BRICK_TOWER_WINDOW(tower_d, is_mask=false, is_door=false, anchor=BOT, spin = 0, orient = UP)
{    
    width_total = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(4);
    height_total = BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(is_door ? 5 : 4);

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



// module brick_tower_with_door(height, printer)
// {
//     size = 6;
//     size_ground = 9;    
//     tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);    
//     magic_number_to_fit_cyl_to_brick = 3.2; // Just to reduce total size (and cost/weight of filament)
//     tower_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size_ground)-magic_number_to_fit_cyl_to_brick;    
        
//     difference()
//     {
//         brick_tower(height=height, printer=printer);
//         fwd(tower_d/4) BRICK_TOWER_WINDOW(tower_d, is_mask=true, is_door=true);
//     }                
// }