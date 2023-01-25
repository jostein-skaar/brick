include<BOSL2\std.scad>;

$fn = 32;

// Dictionary:
// Spline: The small parts sticking out of the walls to give better grip.

// The "correct" math
BRICK_SIZE_P = 8.0;
BRICK_SIZE_WALL = 1.5;
BRICK_SIZE_WALL_SINGLE = 1.5;
BRICK_SIZE_H = 9.6;
BRICK_SIZE_h = 3.2;
BRICK_SIZE_STUD_D = 4.8;
BRICK_SIZE_STUD_H = 1.8; // 1.7 or 1.8? Seen both numbers.
BRICK_SIZE_STUD_D_TO_D = 8.0;
BRICK_SIZE_STUD_SPACING = 3.2;
BRICK_SIZE_REDUCER = 0.2;
BRICK_SIZE_ANTISTUD_D = 4.8;
BRICK_SIZE_ANTISTUD_D_OUTER = 6.5;
BRICK_SIZE_ANTISTUD_SINGLE_D = 3;
BRICK_SIZE_WALL_SPLINE_WIDTH = 0.6;
BRICK_SIZE_WALL_SPLINE_DEPTH = 0.3;
BRICK_SIZE_ROOF = 1.2;
BRICK_SIZE_ROOF_TILE = 1;
BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH = 0.8;

// Technic
BRICK_SIZE_GEARS_MOD = 1;
BRICK_SIZE_GEARS_PRESSURE_ANGLE = 20;
BRICK_SIZE_AXLE_WIDTH = 1.83;
BRICK_SIZE_AXLE_LENGTH = 4.78;


BRICK_FLAGS_HOLLOW_ALL_THE_WAY = true;


// Something needs to be adjusted, at least for FDM 3D printing
// $BRICK_ADJUST_STUD_D: less is less tight
// $BRICK_ADJUST_ANTISTUD_D: less is more tight
// $BRICK_ADJUST_ANTISTUD_D_OUTER: less is more tight
// $BRICK_ADJUST_WALLS: less is less tight
// $BRICK_ADJUST_TOTAL_SIZE: less is smaller
// $BRICK_ADJUST_ANTISTUD_SINGLE_D: less is more tight
// $BRICK_ADJUST_WALLS_SINGLE: less is less tight
// $BRICK_ADJUST_GEARS_MOD: less is smaller
// $BRICK_ADJUST_AXLE: less is more tight
// $BRICK_ADJUST_WALL_SPLINE_WIDTH;
BRICK_PRINTER_ADJUSTMENTS = [
  // ["bambu", 0.14, 0.4, 0.14, 0.2, 0.06, -0.1, -0.02, -0.04, 0.3], 
  // ["ender", 0.14, 0.4, 0.06, 0.0, 0.02, 0.06, -0.1, -0.04, 0.3]
  // Restart calib 2  
  // #1
  // ["bambu", 0.15, 0.4, 0.1, 0.05, 0.0, -0.1, -0.02, -0.01, 0.25, 0.1], 
  // ["ender", 0.15, 0.4, 0.05, 0.0, 0.0, -0.1, -0.1, -0.01, 0.35, 0.0]
  // #2
  // ["bambu", 0.22, 0.4, 0.1, 0.0, 0.0, -0.1, -0.05, -0.01, 0.25, 0.1], 
  // ["ender", 0.15, 0.4, 0.05, 0.0, 0.0, -0.1, -0.1, -0.01, 0.35, 0.0]
    // #3
  // ["bambu", 0.28, 0.4, 0.0, 0.0, 0.0, -0.1, -0.1, -0.01, 0.25, 0.0], 
  // ["ender", 0.15, 0.4, 0.05, 0.0, 0.0, -0.1, -0.1, -0.01, 0.35, 0.0]
    // #4
  // ["bambu", 0.24, 0.4, 0.0, 0.0, 0.0, -0.1, -0.06, -0.01, 0.25, 0.0], 
  // ["ender", 0.15, 0.4, 0.05, 0.0, 0.0, -0.1, -0.1, -0.01, 0.35, 0.0]
// #5
  ["bambu", 0.25, 0.4, 0.0, 0.1, 0.2, -0.1, 0.0, -0.01, 0.25, 0.0], 
  ["ender", 0.15, 0.4, 0.05, 0.0, 0.0, -0.1, -0.1, -0.01, 0.35, 0.0]

];



module brick(width, length, height, is_tile=false, is_closed=false, printer="bambu", anchor = BOT)
{
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
  
  is_single = min(width, length) == 1;

//   rotate_y = is_tile ? 180 : 0;
//   offset_z = is_tile ? BRICK_CALCULATE_PHYSICAL_HEIGHT(height) : 0;

// up(offset_z)yrot(rotate_y)
  BRICK_BLOCK(width, length, height, is_closed=is_closed, anchor = anchor)
  {
    if (!is_tile)
    {
      attach(TOP) BRICK_STUDS(width, length);
    }
    
    if (!is_closed)
    {
      if (is_single)
      {
        attach(BOT) BRICK_ANTISTUDS_SINGLE(width, length, height);
      } else {
        attach(BOT) BRICK_ANTISTUDS(width, length, height);
      }
      
      if (!is_single)
      {
        // attach(BOT) BRICK_SPLINES(width, length, height);
      }    

      if (!is_single)
      {
        attach(BOT) BRICK_SUPPORT_GRID(width, length, height);    
      }  
    }  
  }
}

module brick_box(width, length, height, is_tile=false, is_closed=false, printer="bambu", anchor = BOT)
{
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

  thickness = 1; // This would be width if regular brick.
  is_single = thickness == 1;

  lw = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  ll = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  lt = BRICK_CALCULATE_PHYSICAL_LENGTH(thickness);
  lh = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  offset_x = lw/2-lt/2;
  offset_y = ll/2-lt/2;

  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  

  wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS(is_single);
  magic_number_to_make_sure_we_erase_wall = 0.1;
  offset_thickness = lt/2 - wall_thickness/2;

  wall_thickness_to_erase = wall_thickness + magic_number_to_make_sure_we_erase_wall;
  wall_length_to_erase = lt-wall_thickness*2;
  wall_height_to_erase = lh - roof_thickness;

  
  // Width part 1
  difference()
  {
    fwd(offset_y) brick(width, thickness, height, is_tile=is_tile, is_closed=is_closed, printer=printer, anchor=anchor);
    
    if (!is_closed) fwd(offset_y-offset_thickness) 
    {
      left(offset_x)cube([wall_length_to_erase,wall_thickness_to_erase,wall_height_to_erase], anchor=anchor);  
      right(offset_x)cube([wall_length_to_erase,wall_thickness_to_erase,wall_height_to_erase], anchor=anchor);  
    }  
  }

  // Width part 2
  difference()
  {
    back(offset_y) brick(width, thickness, height, is_tile=is_tile, is_closed=is_closed, printer=printer, anchor=anchor);
    if (!is_closed) back(offset_y-offset_thickness) 
    {
      left(offset_x)cube([wall_length_to_erase,wall_thickness_to_erase,wall_height_to_erase], anchor=anchor);  
      right(offset_x)cube([wall_length_to_erase,wall_thickness_to_erase,wall_height_to_erase], anchor=anchor);  
    }  
  }

  // Length part 1
  difference()
  {  
    right(offset_x)brick(thickness, length, height, is_tile=is_tile, is_closed=is_closed, printer=printer, anchor=anchor);
    if (!is_closed) right(offset_x-offset_thickness) 
    {
      fwd(offset_y)cube([wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase], anchor=anchor);  
      back(offset_y)cube([wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase], anchor=anchor);  
    }  
  }

  // Length part 2
  difference()
  {  
    left(offset_x)brick(thickness, length, height, is_tile=is_tile, is_closed=is_closed, printer=printer, anchor=anchor);
    if (!is_closed) left(offset_x-offset_thickness) 
    {
      fwd(offset_y)cube([wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase], anchor=anchor);  
      back(offset_y)cube([wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase], anchor=anchor);  
    }  
  }
}


module BRICK_BLOCK(width, length, height, is_closed=false, anchor=BOT, spin = 0, orient = UP)
{  
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);  
  physical_height_remove = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));  

  size = [ physical_width, physical_length, physical_height ];

  is_single = min(width, length) == 1;  
  
  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
    
  wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS(is_single);
  echo("wall_thickness", wall_thickness);

  attachable(anchor, spin, orient, size = size)
  {
    diff() cuboid(size)
    {      
      if (!is_closed)
      {
        tag("remove") attach(BOT)         
          cuboid([ physical_width - wall_thickness * 2, physical_length - wall_thickness * 2, physical_height_remove - roof_thickness ],anchor = TOP);
      }
    }

    children();
  }
}

module BRICK_SPLINES(width, length, height)
{  
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));

  adjustedWidth = BRICK_SIZE_WALL_SPLINE_WIDTH + $BRICK_ADJUST_WALL_SPLINE_WIDTH;
  // Splines for width
  union()
  {
    offset_x = -(width - 1) / 2 * BRICK_SIZE_STUD_D_TO_D;
    offset_y = physical_length / 2 - BRICK_SIZE_WALL;
    for (x = [0:width - 1])
    {
      translate([ offset_x + x * BRICK_SIZE_STUD_D_TO_D, offset_y, 0 ])
        cuboid([ adjustedWidth, adjustedWidth, physical_height ], anchor = TOP);

      translate([ offset_x + x * BRICK_SIZE_STUD_D_TO_D, -offset_y, 0 ])
        cuboid([ adjustedWidth, adjustedWidth, physical_height ], anchor = TOP);
    }
  }

  // Splines for length
  union()
  {
    offset_x = physical_width / 2 - BRICK_SIZE_WALL;
    offset_y = -(length - 1) / 2 * BRICK_SIZE_STUD_D_TO_D;

    for (y = [0:length - 1])
    {
      translate([ offset_x, offset_y + y * BRICK_SIZE_STUD_D_TO_D, 0 ])
        cuboid([ adjustedWidth, adjustedWidth, physical_height ], anchor = TOP);

      translate([ -offset_x, offset_y + y * BRICK_SIZE_STUD_D_TO_D, 0 ])
        cuboid([ adjustedWidth, adjustedWidth, physical_height ], anchor = TOP);
    }
  }
}

module BRICK_STUDS(width, length)
{
  offset_x = -(width - 1) / 2 * BRICK_SIZE_STUD_D_TO_D;
  offset_y = -(length - 1) / 2 * BRICK_SIZE_STUD_D_TO_D;  
  translate([ offset_x, offset_y, 0 ])
  {
    for (y = [0:length - 1])
    {
      for (x = [0:width - 1])
      {
        translate([ x * BRICK_SIZE_STUD_D_TO_D, y * BRICK_SIZE_STUD_D_TO_D, 0 ]) 
        {
          // Stud
          cylinder(d = BRICK_SIZE_STUD_D + $BRICK_ADJUST_STUD_D, h = BRICK_SIZE_STUD_H); 
        }
      }
    }
  }
}

module BRICK_SUPPORT_GRID(width, length, height)
{
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
  
  offset_x = -(width - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;
  offset_y = -(length - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;  
    
  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);

  difference()
  {
    union()
    {
      translate([ offset_x, 0, 0 ])
      {      
        for (x = [0:width - 2])
        {
          translate([ x * BRICK_SIZE_STUD_D_TO_D, 0, 0 ]) 
          {
            cuboid([BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_length, physical_height], anchor = TOP);                
          }
        }
      }

      translate([ 0, offset_y, 0 ])
      {      
        for (y = [0:length - 2])
        {
          translate([ 0, y * BRICK_SIZE_STUD_D_TO_D, 0 ]) 
          {
            cuboid([physical_width, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height], anchor = TOP);                
          }
        }
      }  
    }

    BRICK_ANTISTUDS(width, length, height, is_solid=true);
  }
}

module BRICK_ANTISTUDS(width, length, height, is_solid=false)
{
  offset_x = -(width - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;
  offset_y = -(length - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;  
  
  // physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1));
  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);

  translate([ offset_x, offset_y, 0 ])
  {
    for (y = [0:length - 2])
    {
      for (x = [0:width - 2])
      {
        translate([ x * BRICK_SIZE_STUD_D_TO_D, y * BRICK_SIZE_STUD_D_TO_D, 0 ]) 
        {
          // Antistud
          diff() cylinder(d = BRICK_SIZE_ANTISTUD_D_OUTER- $BRICK_ADJUST_ANTISTUD_D_OUTER, h = physical_height, anchor = TOP)            
          {
            if (!is_solid)
            {
              tag("remove") attach(TOP)
                cylinder(d = BRICK_SIZE_ANTISTUD_D + $BRICK_ADJUST_ANTISTUD_D, h = physical_height - roof_thickness, anchor = TOP);
            }            
          }                    
        }
      }
    }
  }
}

module BRICK_ANTISTUDS_SINGLE(width, length, height)
{
  offset_x = -(width - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;
  offset_y = -(length - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;

  // physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1));
  physical_height_support_grid = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
  physical_length_1 = BRICK_CALCULATE_PHYSICAL_LENGTH(1);
  
  if (width == 1 && length > 1)
  {
    translate([ 0, offset_y, 0 ])
    {
      x = 0;
      for (y = [0:length - 2])
      {
        translate([ x * BRICK_SIZE_STUD_D_TO_D, y * BRICK_SIZE_STUD_D_TO_D, 0 ]) 
        {
          // Pin
          cylinder(d = BRICK_SIZE_ANTISTUD_SINGLE_D-$BRICK_ADJUST_ANTISTUD_SINGLE_D, h = physical_height, anchor = TOP);
          cuboid([physical_length_1, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height_support_grid], anchor=TOP);
        }
      }
    }
  }
  else if (width > 1 && length == 1)
  {
    translate([ offset_x, 0, 0 ])
    {
      y = 0;
      for (x = [0:width - 2])
      {
        translate([ x * BRICK_SIZE_STUD_D_TO_D, y * BRICK_SIZE_STUD_D_TO_D, 0 ]) 
        {
          // Pin
          cylinder(d = BRICK_SIZE_ANTISTUD_SINGLE_D-$BRICK_ADJUST_ANTISTUD_SINGLE_D, h = physical_height, anchor = TOP); 
          cuboid([BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_length_1, physical_height_support_grid], anchor=TOP);         
        }
      }
    }
  }
}

module BRICK_AXLE_HOLE(width, length, height)
{
  cuboid([ width, length, height ], anchor = BOT, rounding = 0.3, edges = [ FWD, BACK ], except = [ TOP, BOT ]);
  zrot(90)
    cuboid([ width, length, height ], anchor = BOT, rounding = 0.3, edges = [ FWD, BACK ], except = [ TOP, BOT ]);
}


function BRICK_ADJUSTMENTS_FOR_PRINTER(printer) = BRICK_PRINTER_ADJUSTMENTS[search([printer], BRICK_PRINTER_ADJUSTMENTS)[0]];

function BRICK_CALCULATE_PHYSICAL_LENGTH(length) = length * BRICK_SIZE_P - BRICK_SIZE_REDUCER + $BRICK_ADJUST_TOTAL_SIZE;
function BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(length) = length * BRICK_SIZE_P + $BRICK_ADJUST_TOTAL_SIZE;
function BRICK_CALCULATE_PHYSICAL_HEIGHT(height) =  height * BRICK_SIZE_H;
function BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(height) =  height * BRICK_SIZE_H;
function BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS(is_single) = is_single ? BRICK_SIZE_WALL_SINGLE + $BRICK_ADJUST_WALLS_SINGLE: BRICK_SIZE_WALL + $BRICK_ADJUST_WALLS;
function BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height) = height < 1 ? BRICK_SIZE_ROOF_TILE: BRICK_SIZE_ROOF;