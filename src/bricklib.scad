include<BOSL2\std.scad>;

$fn = 32;

// Dictionary:
// Spline: The small parts sticking out of the walls to give better grip.

// The "correct" math
BRICK_SIZE_P = 8.0;
BRICK_SIZE_WALL = 1.2;
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

// Something needs to be adjusted, at least for FDM 3D printing
// $BRICK_ADJUST_STUD_D: less is less tight
// $BRICK_ADJUST_ANTISTUD_D: less is more tight
// $BRICK_ADJUST_ANTISTUD_D_OUTER: less is more tight
// $BRICK_ADJUST_WALLS: less is less tight
// $BRICK_ADJUST_TOTAL_SIZE: less is more tight
// $BRICK_ADJUST_ANTISTUD_SINGLE_D: less is more tight
// $BRICK_ADJUST_WALLS_SINGLE: less is less tight
BRICK_PRINTER_ADJUSTMENTS = [
  ["bambu", 0.24, 0.4, 0.14, -0.1, -0.06, 0, 0], 
  ["ender", 0.14, 0.4, -0.1, -0.1, 0.1, 0, 0]
];


module brick(width, length, height, printer="bambu", anchor = BOT)
{
  adjustments = BRICK_ADJUSTMENTS_FOR_PRINTER(printer);
  echo (adjustments);
  $BRICK_ADJUST_STUD_D = adjustments[1];
  $BRICK_ADJUST_ANTISTUD_D = adjustments[2];
  $BRICK_ADJUST_ANTISTUD_D_OUTER = adjustments[3];
  $BRICK_ADJUST_WALLS = adjustments[4];
  $BRICK_ADJUST_TOTAL_SIZE = adjustments[5];
  $BRICK_ADJUST_ANTISTUD_SINGLE_D = adjustments[6];
  $BRICK_ADJUST_WALLS_SINGLE = adjustments[7];
  
  is_single = min(width, length) == 1;

  BRICK_BLOCK(width, length, height, anchor = anchor)
  {
    attach(TOP) BRICK_STUDS(width, length);
    if (is_single)
    {
      attach(BOT) BRICK_ANTISTUDS_SINGLE(width, length);
    } else {
      attach(BOT) BRICK_ANTISTUDS(width, length);
    }
    
    if (!is_single)
    {
      attach(BOT) BRICK_SPLINES(width, length);
    }    
  }
}

module BRICK_BLOCK(width, length, height, anchor, spin = 0, orient = UP)
{
  physical_width = width * BRICK_SIZE_P - BRICK_SIZE_REDUCER;
  physical_length = length * BRICK_SIZE_P - BRICK_SIZE_REDUCER;
  physical_height = height * BRICK_SIZE_H;

  size = [ physical_width-$BRICK_ADJUST_TOTAL_SIZE, physical_length-$BRICK_ADJUST_TOTAL_SIZE, physical_height ];

  is_single = min(width, length) == 1;
  wall_thickness = is_single ? BRICK_SIZE_WALL_SINGLE : BRICK_SIZE_WALL;
  roof_thickness = BRICK_SIZE_WALL;
  adjust_walls =  is_single ? $BRICK_ADJUST_WALLS_SINGLE : $BRICK_ADJUST_WALLS;

  attachable(anchor, spin, orient, size = size)
  {
    diff() cuboid(size)
    {
      tag("remove") attach(BOT) cuboid(
        [ physical_width - wall_thickness * 2 - adjust_walls*2, physical_length - wall_thickness * 2 - adjust_walls*2, BRICK_SIZE_H - roof_thickness ],
        anchor = TOP);
    }

    children();
  }
}

module BRICK_SPLINES(width, length)
{
  physical_width = width * BRICK_SIZE_P - BRICK_SIZE_REDUCER;
  physical_length = length * BRICK_SIZE_P - BRICK_SIZE_REDUCER;

  // Splines for width
  union()
  {
    offset_x = -(width - 1) / 2 * BRICK_SIZE_STUD_D_TO_D;
    offset_y = physical_length / 2 - BRICK_SIZE_WALL;
    for (x = [0:width - 1])
    {
      translate([ offset_x + x * BRICK_SIZE_STUD_D_TO_D, offset_y, 0 ])
        cuboid([ BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_H ], anchor = TOP);

      translate([ offset_x + x * BRICK_SIZE_STUD_D_TO_D, -offset_y, 0 ])
        cuboid([ BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_H ], anchor = TOP);
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
        cuboid([ BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_H ], anchor = TOP);

      translate([ -offset_x, offset_y + y * BRICK_SIZE_STUD_D_TO_D, 0 ])
        cuboid([ BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_WALL_SPLINE_WIDTH, BRICK_SIZE_H ], anchor = TOP);
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

module BRICK_ANTISTUDS(width, length)
{
  offset_x = -(width - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;
  offset_y = -(length - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;

  translate([ offset_x, offset_y, 0 ])
  {
    for (y = [0:length - 2])
    {
      for (x = [0:width - 2])
      {
        translate([ x * BRICK_SIZE_STUD_D_TO_D, y * BRICK_SIZE_STUD_D_TO_D, 0 ]) 
        {
          // Antistud
          diff() cylinder(d = BRICK_SIZE_ANTISTUD_D_OUTER-$BRICK_ADJUST_ANTISTUD_D_OUTER, h = BRICK_SIZE_H, anchor = TOP)
          {
            tag("remove") attach(TOP)
              cylinder(d = BRICK_SIZE_STUD_D +$BRICK_ADJUST_ANTISTUD_D, h = BRICK_SIZE_H - BRICK_SIZE_WALL, anchor = TOP);
          }
        }
      }
    }
  }
}

module BRICK_ANTISTUDS_SINGLE(width, length)
{
  offset_x = -(width - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;
  offset_y = -(length - 2) / 2 * BRICK_SIZE_STUD_D_TO_D;
  
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
          cylinder(d = BRICK_SIZE_ANTISTUD_SINGLE_D-$BRICK_ADJUST_ANTISTUD_SINGLE_D, h = BRICK_SIZE_H, anchor = TOP);          
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
          cylinder(d = BRICK_SIZE_ANTISTUD_SINGLE_D-$BRICK_ADJUST_ANTISTUD_SINGLE_D, h = BRICK_SIZE_H, anchor = TOP);          
        }
      }
    }
  }
}

function BRICK_ADJUSTMENTS_FOR_PRINTER(printer) = BRICK_PRINTER_ADJUSTMENTS[search([printer], BRICK_PRINTER_ADJUSTMENTS)[0]];