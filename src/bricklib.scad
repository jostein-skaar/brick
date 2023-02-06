// clang-format off
include<common.scad>;
// clang-format on

$fn = 32;

// Textures: https://github.com/revarbat/BOSL2/wiki/skin.scad#function-texture

// Dictionary:
// Spline: The small parts sticking out of the walls to give better grip.

// The "correct" math
BRICK_SIZE_P = 8.0;
BRICK_SIZE_WALL = 1.5; // Some bricks have 1.2, single and some have 1.5.
BRICK_SIZE_H = 9.6;
BRICK_SIZE_h = 3.2;
BRICK_SIZE_STUD_D = 4.8;
BRICK_SIZE_STUD_D_MASK = 5.5;
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

// Some parts we want to be a bit tighter or more loose.
// antistud_d and antistud_d_outer are the keys that needs to be overrriden.
BRICK_TIGHTNESS_LOOSE = -0.05;
BRICK_TIGHTNESS_DEFAULT = 0.0;
BRICK_TIGHTNESS_TIGHT = 0.05;

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

function brick_calculate_adjusted_stud_d() =
  BRICK_SIZE_STUD_D + brick_get_printer_adjustment("stud_d");

function brick_calculate_adjusted_stud_d_mask() =
  BRICK_SIZE_STUD_D_MASK + brick_get_printer_adjustment("stud_d");

function brick_calculate_adjusted_antistud_d() =
  BRICK_SIZE_ANTISTUD_D + brick_get_printer_adjustment("antistud_d");  

function brick_calculate_adjusted_antistud_d_outer() =
  BRICK_SIZE_ANTISTUD_D_OUTER + brick_get_printer_adjustment("antistud_d_outer");  

function BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS() = 
  BRICK_SIZE_WALL + brick_get_printer_adjustment("walls");

function BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height) = 
  height < 1 ? BRICK_SIZE_ROOF_TILE : BRICK_SIZE_ROOF;

function brick_create_named_anchors(width, length, height) = let
  (
    physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length), 
    physical_length2 = BRICK_CALCULATE_PHYSICAL_LENGTH(2),
    physical_length2_mask = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(2),
    physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height),
    pos_offset = length/2-1
  )
  [
    named_anchor("2x_pos1", [ 0, pos_offset * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos2", [ 0, (pos_offset-2) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos3", [ 0, (pos_offset-4) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos4", [ 0, (pos_offset-6) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos5", [ 0, (pos_offset-8) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos6", [ 0, (pos_offset-10) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos7", [ 0, (pos_offset-12) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos8", [ 0, (pos_offset-14) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos9", [ 0, (pos_offset-16) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    named_anchor("2x_pos10", [ 0, (pos_offset-18) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos2", [ 0, (pos_offset-1) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos3", [ 0, (pos_offset-2) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos4", [ 0, (pos_offset-3) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos5", [ 0, (pos_offset-4) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos6", [ 0, (pos_offset-5) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos7", [ 0, (pos_offset-6) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("pos8", [ 0, (pos_offset-7) * BRICK_SIZE_STUD_D_TO_D, physical_height / 2 ], UP, 0),
    // named_anchor("9os2", [ 0, BRICK_SIZE_STUD_D_TO_D*1, physical_height / 2 ], UP, 0),
    // named_anchor("pos3", [ 0, -BRICK_SIZE_STUD_D_TO_D*1, physical_height / 2 ], UP, 0),
    // named_anchor("pos4", [ 0, -BRICK_SIZE_STUD_D_TO_D*3, physical_height / 2 ], UP, 0),
    // named_anchor("2x-pos2", [ 0, 0, physical_height / 2 ], UP, 0),
    // named_anchor("2x-pos4", [ 0, -physical_length / 2 + physical_length2 / 2, physical_height / 2 ], UP, 0)
  ];

// clang-format on

module brick_circle(outer_size, inner_size = 0, height = 1, texture = undef, tex_size = [ 10, 10 ], tex_scale = 0.5,
                    anchor = BOT, spin = 0, orient = UP)
{
  // TODO: Extract as much as possible to brick_from_shape.
  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  outer_d = BRICK_CALCULATE_PHYSICAL_LENGTH(outer_size);
  inner_d = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(inner_size);

  stud_r = brick_calculate_adjusted_stud_d() / 2;
  antistud_outer_r = brick_calculate_adjusted_antistud_d_outer() / 2;
  outer_shape = circle(d = outer_d, $fn = 64);
  inner_shape = circle(d = inner_d, $fn = 64);
  shape = inner_size == 0 ? outer_shape : difference(outer_shape, inner_shape);
  // We need a little outer offset to get rid of any antistuds within antistud_outer_d
  negative_shape = difference(offset(outer_shape, delta = antistud_outer_r * 2, closed = true), shape);
  limit_studs_polygon = offset(shape, delta = -stud_r, closed = true);
  limit_antistuds_polygon = offset(shape, delta = antistud_outer_r, closed = true);
  shape_for_walls = offset(shape, delta = -physical_wall_thickness, closed = true);

  actual_hollow_height = min(height, 1);
  physical_hollow_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(actual_hollow_height) - physical_roof_thickness;

  // up(1) region(negative_shape);
  // up(tower_height) region(shape_for_walls);

  // Shape and studs
  diff() linear_sweep(shape, h = tower_height, texture = texture, tex_size = tex_size, tex_scale = tex_scale,
                      tex_inset = true)
  {
    position(TOP) brick_studs(width = outer_size, length = outer_size, inside = limit_studs_polygon);
    // position(BOT) brick_antistuds(width = outer_size, length = outer_size, height = 1);
    tag("remove") down(extra_size_for_better_remove) position(BOT)
      linear_sweep(shape_for_walls, h = physical_hollow_height + extra_size_for_better_remove * 2);

    tag("remove") down(extra_size_for_better_remove) position(BOT)
      brick_studs(width = outer_size, length = outer_size, is_mask = true);
  }

  // Antistuds
  diff() brick_antistuds(width = outer_size, length = outer_size, height = height, inside = limit_antistuds_polygon)
  {

    // Remove antistuds sticking outside shape
    tag("remove") down(extra_size_for_better_remove) position(BOT)
      linear_sweep(negative_shape, h = tower_height + extra_size_for_better_remove * 2);
  }
}

module brick_from_shape(texture = undef, tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = BOT, spin = 0, orient = UP) {}

module brick(width, length, height, is_tile = false, is_closed = false, hollow_height = undef, texture = undef,
             tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = BOT, spin = 0, orient = UP)
{
  is_single = min(width, length) == 1;

  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  size = [ physical_width, physical_length, physical_height ];

  actual_hollow_height = is_undef(hollow_height) ? min(height, 1) : min(height, hollow_height);
  physical_hollow_width = physical_width - 2 * physical_wall_thickness;
  physical_hollow_length = physical_length - 2 * physical_wall_thickness;
  physical_hollow_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(actual_hollow_height) - physical_roof_thickness;
  hollow_size = [ physical_hollow_width, physical_hollow_length, physical_hollow_height ];

  anchors = brick_create_named_anchors(width, length, height);

  attachable(anchor, spin, orient, size = size, anchors = anchors)
  {
    diff() brick_block(size = size, texture = texture, tex_size = tex_size, tex_scale = tex_scale)
    {
      if (!is_tile)
      {
        tag("keep") position(TOP) brick_studs(width, length);
      }

      if (!is_closed)
      {
        tag("remove") position(BOT) cuboid(hollow_size, anchor = BOT);
        tag("keep") position(BOT) brick_antistuds(width, length, actual_hollow_height);
      }
    }

    children();
  }
}

module brick_block(size, texture = undef, tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = CENTER, spin = 0,
                   orient = UP)
{
  attachable(anchor, spin, orient, size = size)
  {
    if (is_undef(texture))
    {
      cuboid(size);
    }
    else
    {
      linear_sweep(rect(size), h = size[2], texture = texture, tex_size = tex_size, tex_scale = tex_scale,
                   tex_inset = true, anchor = CENTER);
    }

    children();
  }
}

module brick_studs(width, length, is_mask = false, inside = undef, anchor = BOT, spin = 0, orient = UP)
{
  d = is_mask ? brick_calculate_adjusted_stud_d_mask() : brick_calculate_adjusted_stud_d();
  echo("brick_studs d", d, "is_mask", is_mask);
  h = is_mask ? BRICK_SIZE_STUD_H + 0.5 : BRICK_SIZE_STUD_H;
  size = [ (width - 1) * BRICK_SIZE_STUD_D_TO_D + d, (length - 1) * BRICK_SIZE_STUD_D_TO_D + d, h ];

  attachable(anchor, spin, orient, size = size)
  {
    grid_copies(n = [ width, length ], spacing = BRICK_SIZE_STUD_D_TO_D, inside = inside) cyl(d = d, h = h);
    children();
  }
}

module brick_antistuds(width, length, height, inside = undef, is_solid = false, anchor = BOT, spin = 0, orient = UP)
{
  is_single = min(width, length) == 1;

  roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1)) - roof_thickness;

  if (is_single)
  {
    d = BRICK_SIZE_ANTISTUD_SINGLE_D + brick_get_printer_adjustment("antistud_single_d");
    physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
    physical_length_support_grid = BRICK_CALCULATE_PHYSICAL_LENGTH(1) - physical_wall_thickness * 2;
    actual_spin = width == 1 && length > 1 ? spin : spin + 90;
    width_or_length = max(width, length);

    size = [ physical_length_support_grid, (width_or_length - 1) * BRICK_SIZE_STUD_D_TO_D + d, physical_height ];

    attachable(anchor, actual_spin, orient, size = size)
    {
      grid_copies(n = [ 1, width_or_length - 1 ], spacing = BRICK_SIZE_STUD_D_TO_D, inside = inside)
      {
        cyl(d = d, h = physical_height);
        cuboid([ physical_length_support_grid, BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height ]);
      }

      children();
    }
  }
  else
  {
    od = brick_calculate_adjusted_antistud_d_outer();
    echo("brick_antistuds od", od);
    id = brick_calculate_adjusted_antistud_d();

    size = [ (width - 1) * BRICK_SIZE_STUD_D_TO_D + od, (length - 1) * BRICK_SIZE_STUD_D_TO_D + od, physical_height ];

    attachable(anchor, spin, orient, size = size)
    {
      grid_copies(n = [ width - 1, length - 1 ], spacing = BRICK_SIZE_STUD_D_TO_D, inside = inside)
        tube(h = physical_height, od = od, id = id);

      children();
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

module BRICK_AXLE_HOLE(width, length, height)
{
  cuboid([ width, length, height ], anchor = BOT, rounding = 0.3, edges = [ FWD, BACK ], except = [ TOP, BOT ]);
  zrot(90)
    cuboid([ width, length, height ], anchor = BOT, rounding = 0.3, edges = [ FWD, BACK ], except = [ TOP, BOT ]);
}
