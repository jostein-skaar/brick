// clang-format off
include<common.scad>;
// clang-format on

$fn = 32;

// Dictionary:
// Spline: The small parts sticking out of the walls to give better grip.

// The "correct" math
BRICK_SIZE_P = 8.0;
BRICK_SIZE_WALL = 1.5; // Some bricks have 1.2, single and some have 1.5.
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
BRICK_SIZE_ROOF = 1.2;
BRICK_SIZE_ROOF_TILE = 1;
BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH = 0.8;

// Let's not use splines at all, and same wall size for single and double etc
// BRICK_SIZE_WALL_SPLINE_WIDTH = 0.6;
// BRICK_SIZE_WALL_SPLINE_DEPTH = 0.3;
// BRICK_SIZE_WALL_SINGLE = 1.5;

// Technic
BRICK_SIZE_GEARS_MOD = 1;
BRICK_SIZE_GEARS_PRESSURE_ANGLE = 20;
BRICK_SIZE_AXLE_WIDTH = 1.83;
BRICK_SIZE_AXLE_LENGTH = 4.78;

BRICK_FLAGS_HOLLOW_ALL_THE_WAY = true;

// clang-format off
function brick_get_printer_adjustment(key) = 
  get_printer_adjustment(key, $brick_printer_adjustments);

function BRICK_CALCULATE_PHYSICAL_LENGTH(length) = 
  length * BRICK_SIZE_P - BRICK_SIZE_REDUCER + brick_get_printer_adjustment("total_size");

function BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(length) = 
  length * BRICK_SIZE_P + brick_get_printer_adjustment("total_size");

function BRICK_CALCULATE_PHYSICAL_HEIGHT(height) = 
  height * BRICK_SIZE_H;

function BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(height) = 
  height * BRICK_SIZE_H;

function BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS() = 
  BRICK_SIZE_WALL + brick_get_printer_adjustment("walls");

function BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height) = 
  height < 1 ? BRICK_SIZE_ROOF_TILE : BRICK_SIZE_ROOF;
// clang-format on

module brick(width, length, height, is_tile = false, is_closed = false, printer = "bambu", anchor = BOT, spin = 0,
             orient = UP)
{
  is_single = min(width, length) == 1;

  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  size = [ physical_width, physical_length, physical_height ];

  attachable(anchor, spin, orient, size = size)
  {
    diff()
    {
      cuboid(size);
      if (!is_tile)
      {
        position(TOP) BRICK_STUDS(width, length);
      }
      if (!is_closed)
      {
        tag("remove") position(BOT) brick_anti(width, length, height);
      }
    }

    children();
  }
}

module brick_anti(width, length, height, anchor = BOT, spin = 0, orient = UP)
{
  is_single = min(width, length) == 1;

  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);

  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width) - physical_wall_thickness * 2;
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length) - physical_wall_thickness * 2;
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height) - physical_roof_thickness;

  size = [ physical_width, physical_length, physical_height ];

  attachable(anchor, spin, orient, size = size)
  {
    difference()
    {
      cuboid(size);
      if (is_single)
      {
        BRICK_ANTISTUDS_SINGLEV2(width, length, height);
      }
      else
      {
        BRICK_ANTISTUDSV2(width, length, height);
        BRICK_SUPPORT_GRIDV2(width, length, height);
      }
    }

    children();
  }
}

module BRICK_SUPPORT_GRIDV2(width, length, height)
{
  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width) - physical_wall_thickness * 2;
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length) - physical_wall_thickness * 2;
  physical_height =
    BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1)) - physical_roof_thickness;
  od = BRICK_SIZE_ANTISTUD_D_OUTER + brick_get_printer_adjustment("antistud_d_outer");
  id = BRICK_SIZE_ANTISTUD_D + brick_get_printer_adjustment("antistud_d");
  // If we use od we may get "Object may not be a valid 2-manifold and may need repair!""
  // Using the middle of the anti stud should do it
  middleD = od - (od - id) / 2;

  difference()
  {
    // Support
    union()
    {
      xcopies(n = width - 1, spacing = BRICK_SIZE_STUD_D_TO_D)
        cuboid([ BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_length, physical_height ]);

      ycopies(n = length - 1, spacing = BRICK_SIZE_STUD_D_TO_D)
        cuboid([ physical_width, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height ]);
    }

    // Remove the center so that anti studs remain hollow
    grid_copies(n = [ width - 1, length - 1 ], spacing = BRICK_SIZE_STUD_D_TO_D) cyl(d = middleD, h = physical_height);
  }
}

module BRICK_ANTISTUDSV2(width, length, height, is_solid = false)
{
  // physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1)) - roof_thickness;
  od = BRICK_SIZE_ANTISTUD_D_OUTER + brick_get_printer_adjustment("antistud_d_outer");
  id = BRICK_SIZE_ANTISTUD_D + brick_get_printer_adjustment("antistud_d");

  grid_copies(n = [ width - 1, length - 1 ], spacing = BRICK_SIZE_STUD_D_TO_D)
    tube(h = physical_height, od = od, id = id);
}

module BRICK_ANTISTUDS_SINGLEV2(width, length, height)
{
  d = BRICK_SIZE_ANTISTUD_SINGLE_D + brick_get_printer_adjustment("antistud_single_d");
  // physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1)) - roof_thickness;
  physical_height_support_grid =
    BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1)) - roof_thickness;
  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_length_support_grid = BRICK_CALCULATE_PHYSICAL_LENGTH(1) - physical_wall_thickness * 2;

  if (width == 1 && length > 1)
  {
    grid_copies(n = [ 1, length - 1 ], spacing = BRICK_SIZE_STUD_D_TO_D)
    {
      cyl(d = d, h = physical_height);
      cuboid([ physical_length_support_grid, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height_support_grid ]);
    }
  }
  else if (width > 1 && length == 1)
  {
    grid_copies(n = [ width - 1, 1 ], spacing = BRICK_SIZE_STUD_D_TO_D)
    {
      cyl(d = d, h = physical_height);
      cuboid([ BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_length_support_grid, physical_height_support_grid ]);
    }
  }
}

module brick_box(width, length, height, is_tile = false, is_closed = false, printer = "bambu", anchor = BOT)
{
  thickness = 1; // This would be width if regular brick.

  lw = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  ll = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  lt = BRICK_CALCULATE_PHYSICAL_LENGTH(thickness);
  lh = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  offset_x = lw / 2 - lt / 2;
  offset_y = ll / 2 - lt / 2;

  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);

  wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  magic_number_to_make_sure_we_erase_wall = 0.1;
  offset_thickness = lt / 2 - wall_thickness / 2;

  wall_thickness_to_erase = wall_thickness + magic_number_to_make_sure_we_erase_wall;
  wall_length_to_erase = lt - wall_thickness * 2;
  wall_height_to_erase = lh - roof_thickness;

  // Width part 1
  difference()
  {
    fwd(offset_y)
      brick(width, thickness, height, is_tile = is_tile, is_closed = is_closed, printer = printer, anchor = anchor);

    if (!is_closed)
      fwd(offset_y - offset_thickness)
      {
        left(offset_x) cube([ wall_length_to_erase, wall_thickness_to_erase, wall_height_to_erase ], anchor = anchor);
        right(offset_x) cube([ wall_length_to_erase, wall_thickness_to_erase, wall_height_to_erase ], anchor = anchor);
      }
  }

  // Width part 2
  difference()
  {
    back(offset_y)
      brick(width, thickness, height, is_tile = is_tile, is_closed = is_closed, printer = printer, anchor = anchor);
    if (!is_closed)
      back(offset_y - offset_thickness)
      {
        left(offset_x) cube([ wall_length_to_erase, wall_thickness_to_erase, wall_height_to_erase ], anchor = anchor);
        right(offset_x) cube([ wall_length_to_erase, wall_thickness_to_erase, wall_height_to_erase ], anchor = anchor);
      }
  }

  // Length part 1
  difference()
  {
    right(offset_x)
      brick(thickness, length, height, is_tile = is_tile, is_closed = is_closed, printer = printer, anchor = anchor);
    if (!is_closed)
      right(offset_x - offset_thickness)
      {
        fwd(offset_y) cube([ wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase ], anchor = anchor);
        back(offset_y) cube([ wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase ], anchor = anchor);
      }
  }

  // Length part 2
  difference()
  {
    left(offset_x)
      brick(thickness, length, height, is_tile = is_tile, is_closed = is_closed, printer = printer, anchor = anchor);
    if (!is_closed)
      left(offset_x - offset_thickness)
      {
        fwd(offset_y) cube([ wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase ], anchor = anchor);
        back(offset_y) cube([ wall_thickness_to_erase, wall_length_to_erase, wall_height_to_erase ], anchor = anchor);
      }
  }
}

module BRICK_BLOCK(width, length, height, is_closed = false, anchor = BOT, spin = 0, orient = UP)
{
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height_remove = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));

  size = [ physical_width, physical_length, physical_height ];

  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);

  wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  echo("wall_thickness", wall_thickness);

  attachable(anchor, spin, orient, size = size)
  {
    diff() cuboid(size)
    {
      if (!is_closed)
      {
        tag("remove") attach(BOT) cuboid(
          [
            physical_width - wall_thickness * 2, physical_length - wall_thickness * 2, physical_height_remove -
            roof_thickness
          ],
          anchor = TOP);
      }
    }

    children();
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
          cylinder(d = BRICK_SIZE_STUD_D + brick_get_printer_adjustment("stud_d"), h = BRICK_SIZE_STUD_H);
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
            cuboid([ BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_length, physical_height ], anchor = TOP);
          }
        }
      }

      translate([ 0, offset_y, 0 ])
      {
        for (y = [0:length - 2])
        {
          translate([ 0, y * BRICK_SIZE_STUD_D_TO_D, 0 ])
          {
            cuboid([ physical_width, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height ], anchor = TOP);
          }
        }
      }
    }

    BRICK_ANTISTUDS(width, length, height, is_solid = true);
  }
}

module BRICK_ANTISTUDS(width, length, height, is_solid = false)
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
          diff() cylinder(d = BRICK_SIZE_ANTISTUD_D_OUTER + brick_get_printer_adjustment("antistud_d_outer"),
                          h = physical_height, anchor = TOP)
          {
            if (!is_solid)
            {
              tag("remove") attach(TOP) cylinder(d = BRICK_SIZE_ANTISTUD_D + brick_get_printer_adjustment("antistud_d"),
                                                 h = physical_height - roof_thickness, anchor = TOP);
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
  physical_height_support_grid =
    BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, BRICK_FLAGS_HOLLOW_ALL_THE_WAY ? height : 1));
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
          cylinder(d = BRICK_SIZE_ANTISTUD_SINGLE_D + brick_get_printer_adjustment("antistud_single_d"),
                   h = physical_height, anchor = TOP);
          cuboid([ physical_length_1, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height_support_grid ], anchor = TOP);
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
          cylinder(d = BRICK_SIZE_ANTISTUD_SINGLE_D + brick_get_printer_adjustment("antistud_single_d"),
                   h = physical_height, anchor = TOP);
          cuboid([ BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_length_1, physical_height_support_grid ], anchor = TOP);
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
