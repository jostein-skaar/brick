// clang-format off
include<common.scad>;
include<bricklib.scad>;
// clang-format on

$fn = 32;
extra_size_for_better_remove = 0.001;

// Textures: https://github.com/revarbat/BOSL2/wiki/skin.scad#function-texture

// Dictionary:
// Spline: The small parts sticking out of the walls to give better grip.

// The "correct" math
BIGBRICK_SIZE_P = BRICK_SIZE_P*2;
BIGBRICK_SIZE_WALL = BRICK_SIZE_WALL; 
BIGBRICK_SIZE_H = BRICK_SIZE_H*2;
BIGBRICK_SIZE_h = BRICK_SIZE_h*2;
BIGBRICK_SIZE_STUD_D = BRICK_SIZE_STUD_D *2;
BIGBRICK_SIZE_STUD_D_MASK = BRICK_SIZE_STUD_D_MASK*2;
BIGBRICK_SIZE_STUD_H = BRICK_SIZE_STUD_H*2; 
BIGBRICK_SIZE_STUD_D_TO_D = BRICK_SIZE_STUD_D_TO_D *2;
BIGBRICK_SIZE_STUD_SPACING = BRICK_SIZE_STUD_SPACING *2;
BIGBRICK_SIZE_REDUCER = BRICK_SIZE_REDUCER;
BIGBRICK_SIZE_ANTISTUD_D = BRICK_SIZE_ANTISTUD_D*2;
BIGBRICK_SIZE_ANTISTUD_D_OUTER = BRICK_SIZE_ANTISTUD_D_OUTER*2;
BIGBRICK_SIZE_ANTISTUD_SINGLE_D = BRICK_SIZE_ANTISTUD_SINGLE_D*2;
BIGBRICK_SIZE_ROOF = BRICK_SIZE_ROOF;
BIGBRICK_SIZE_ROOF_TILE = BRICK_SIZE_ROOF_TILE;
BIGBRICK_SIZE_ANTISTUD_SUPPORT_WIDTH = BRICK_SIZE_ANTISTUD_SUPPORT_WIDTH*2;

BIGBRICK_SIZE_WALL_SPLINE_WIDTH = 1.1;
BIGBRICK_SIZE_WALL_SPLINE_DEPTH = 1.8;

BIGBRICK_SIZE_STUD_D_INNER = BIGBRICK_SIZE_STUD_D - 1.3*2;

// Some parts we want to be a bit tighter or more loose.
BIGBRICK_TIGHTNESS_LOOSE = -0.05;
BIGBRICK_TIGHTNESS_DEFAULT = 0.0;
BIGBRICK_TIGHTNESS_TIGHT = 0.05;

module bigbrick(width, length, height, is_tile = false, is_closed = false, hollow_height = undef,
             limit_studs_polygon = undef, texture = undef, tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = BOT,
             spin = 0, orient = UP)
{
  is_single = min(width, length) == 1;

  physical_wall_thickness = BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BIGBRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  size = [ physical_width, physical_length, physical_height ];

  actual_hollow_height = is_undef(hollow_height) ? min(height, 1) : min(height, hollow_height);
  physical_hollow_width = physical_width - 2 * physical_wall_thickness;
  physical_hollow_length = physical_length - 2 * physical_wall_thickness;
  physical_hollow_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(actual_hollow_height) - physical_roof_thickness;



  attachable(anchor, spin, orient, size = size)
  {
    diff() bigbrick_block(size = size, texture = texture, tex_size = tex_size, tex_scale = tex_scale)
    {
      if (!is_tile)
      {
        tag("keep") position(TOP) bigbrick_studs(width, length, inside = limit_studs_polygon);
      }
      
      if (!is_closed)
      {
        tag("remove") down(extra_size_for_better_remove) position(BOT) cuboid(
          [ physical_hollow_width, physical_hollow_length, physical_hollow_height + extra_size_for_better_remove ],
          anchor = BOT);
        tag("keep") position(BOT) bigbrick_antistuds(width, length, actual_hollow_height);


        // tag("remove")left(physical_hollow_height + extra_size_for_better_remove) attach(RIGHT) cuboid(
        //   [ physical_hollow_width, physical_hollow_length, physical_hollow_height + extra_size_for_better_remove],
        //   anchor = BOT);
        // tag("keep") attach(RIGHT) bigbrick_antistuds(width, length, actual_hollow_height);


        // tag("remove")fwd(physical_hollow_height+extra_size_for_better_remove) attach(BACK) cuboid(
        //   [ physical_hollow_width, physical_hollow_length, physical_hollow_height + extra_size_for_better_remove],
        //   anchor = BOT);
        // tag("keep") attach(BACK) bigbrick_antistuds(width, length, actual_hollow_height);

      }

      // if (!is_single)
      {
        tag("keep") attach(BOT) bigbrick_splines(width, length, height);      
      }    

      // {
      //   tag("keep") attach(BOT) bigbrick_splines(width, length, height);
      //   tag("keep") attach(RIGHT) bigbrick_splines(width, length, height);
      //   tag("keep") attach(BACK) bigbrick_splines(width, length, height);
      // }    
    }

    children();
  }
}

module bigbrick_splines(width, length, height)
{  
  physical_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1));
  physical_wall = BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();

// Splines for width
  grid_copies(n=[width, 2], spacing=[BIGBRICK_SIZE_STUD_D_TO_D, physical_length-physical_wall*2-BIGBRICK_SIZE_WALL_SPLINE_DEPTH]) {
     cuboid([ BIGBRICK_SIZE_WALL_SPLINE_WIDTH, BIGBRICK_SIZE_WALL_SPLINE_DEPTH, physical_height ], anchor = TOP);
  }

// Splines for length
    grid_copies(n=[2, length], spacing=[physical_width-physical_wall*2-BIGBRICK_SIZE_WALL_SPLINE_DEPTH, BIGBRICK_SIZE_STUD_D_TO_D]) {
     cuboid([ BIGBRICK_SIZE_WALL_SPLINE_DEPTH, BIGBRICK_SIZE_WALL_SPLINE_WIDTH, physical_height ], anchor = TOP);
  }
}


module bigbrick_circle(outer_size, inner_size = 0, height = 1, hollow_height = undef, is_tile = false, texture = undef,
                    tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = BOT, spin = 0, orient = UP)
{
  outer_d = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(outer_size);
  inner_d = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(inner_size);
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  rgn = inner_size == 0 ? [circle(d = outer_d)] : [ circle(d = outer_d), circle(d = inner_d) ];
  bigbrick_from_region(rgn = rgn, width = outer_size, length = outer_size, height = height, hollow_height = hollow_height,
                    is_tile = is_tile, texture = texture, tex_size = tex_size, tex_scale = tex_scale, anchor = anchor,
                    spin = spin, orient = orient);
}

module bigbrick_box(width, length, height, hollow_height = undef, is_tile = false, texture = undef, tex_size = [ 10, 10 ],
                 tex_scale = 0.5, anchor = BOT, spin = 0, orient = UP)
{
  physical_size_x = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_size_y = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_size_inner_x = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width - 2);
  physical_size_inner_y = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(length - 2);

  rgn = [
    rect(size = [ physical_size_x, physical_size_y ]), rect(size = [ physical_size_inner_x, physical_size_inner_y ])
  ];
  bigbrick_from_region(rgn, width + 2, length + 2, height = height, hollow_height = hollow_height, is_tile = is_tile,
                    texture = texture, tex_size = tex_size, tex_scale = tex_scale);
}

module bigbrick_from_region(rgn, width, length, height, hollow_height = undef, is_tile = false, texture = undef,
                         tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = BOT, spin = 0, orient = UP)
{
  physical_wall_thickness = BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BIGBRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  stud_d = bigbrick_calculate_adjusted_stud_d();
  antistud_outer_d = bigbrick_calculate_adjusted_antistud_d_outer();

  limit_studs_polygon = offset(rgn, delta = -stud_d / 2, closed = true);

  limit_antistuds_polygon = offset(rgn, delta = antistud_outer_d / 2, closed = true);
  shape_for_walls = offset(rgn, delta = -physical_wall_thickness, closed = true);

  // We need a little outer offset to get rid of any antistuds within antistud_outer_d
  // Using only the outer shape (rgn[0]) seems to be the right thing to do
  // rgn_adjusted_for_texture_inset is to get rid of teh antistuds sticking out of the texture
  rgn_adjusted_for_texture_inset = offset(rgn, delta = -tex_scale, closed = true);
  negative_shape = difference(offset(rgn[0], delta = antistud_outer_d, closed = true), rgn_adjusted_for_texture_inset);

  // !region(negative_shape);
  // down(1)
  // {
    // up(10) color("brown") region(limit_studs_polygon);
    // up(5) color("yellow") region(limit_antistuds_polygon);
    // color("green") region(shape_for_walls);
    // down(5) color("red") region(rgn);
    // down(10) color("blue") region(negative_shape);
  // }

  actual_hollow_height = is_undef(hollow_height) ? min(height, 1) : min(height, hollow_height);
  physical_hollow_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(actual_hollow_height) - physical_roof_thickness;

  // Shape and studs
  diff() linear_sweep(rgn, h = physical_height, texture = texture, tex_size = tex_size, tex_scale = tex_scale,
                      tex_inset = true)
  {
    if (!is_tile)
    {
      position(TOP) bigbrick_studs(width = width, length = length, inside = limit_studs_polygon);
    }

    tag("remove") down(extra_size_for_better_remove) position(BOT)
      linear_sweep(shape_for_walls, h = physical_hollow_height + extra_size_for_better_remove * 2);
    tag("remove") down(extra_size_for_better_remove) position(BOT)
      bigbrick_studs(width = width, length = length, is_mask = true);
  }

  // Antistuds
  diff()
    bigbrick_antistuds(width = width, length = length, height = actual_hollow_height, inside = limit_antistuds_polygon)
  {
    // Remove antistuds sticking outside shape
    tag("remove") down(extra_size_for_better_remove) position(BOT)
    linear_sweep(negative_shape, h = physical_height + extra_size_for_better_remove * 2);
  }
}

module bigbrick_block(size, texture = undef, tex_size = [ 10, 10 ], tex_scale = 0.5, anchor = CENTER, spin = 0,
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

module bigbrick_studs(width, length, is_mask = false, inside = undef, anchor = BOT, spin = 0, orient = UP)
{
  d = is_mask ? bigbrick_calculate_adjusted_stud_d_mask() : bigbrick_calculate_adjusted_stud_d();
  id = bigbrick_calculate_adjusted_stud_d_inner();
  echo("brick_studs d", d, "is_mask", is_mask);
  h = is_mask ? BIGBRICK_SIZE_STUD_H + 0.5 : BIGBRICK_SIZE_STUD_H;
  size = [ (width - 1) * BIGBRICK_SIZE_STUD_D_TO_D + d, (length - 1) * BIGBRICK_SIZE_STUD_D_TO_D + d, h ];

  attachable(anchor, spin, orient, size = size)
  {
    // grid_copies(n = [ width, length ], spacing = BIGBRICK_SIZE_STUD_D_TO_D, inside = inside) cyl(d = d, h = h);
    grid_copies(n = [ width, length ], spacing = BIGBRICK_SIZE_STUD_D_TO_D, inside = inside) tube(h = h, od = d, id = id);;
    children();
  }
}

module bigbrick_antistuds(width, length, height, inside = undef, is_solid = false, anchor = BOT, spin = 0, orient = UP)
{
  is_single = min(width, length) == 1;

  roof_thickness = BIGBRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(min(height, 1)) - roof_thickness;

  if (is_single)
  {
    d = BIGBRICK_SIZE_ANTISTUD_SINGLE_D + brick_get_printer_adjustment("big_antistud_single_d");    
    physical_wall_thickness = BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
    physical_length_support_grid = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(1) - physical_wall_thickness * 2;
    actual_spin = width == 1 && length > 1 ? spin : spin + 90;
    width_or_length = max(width, length);

    size = [ physical_length_support_grid, (width_or_length - 1) * BIGBRICK_SIZE_STUD_D_TO_D + d, physical_height ];

    attachable(anchor, actual_spin, orient, size = size)
    {
      grid_copies(n = [ 1, width_or_length - 1 ], spacing = BIGBRICK_SIZE_STUD_D_TO_D, inside = inside)
      {
        cyl(d = d, h = physical_height);
        cuboid([ physical_length_support_grid, BIGBRICK_SIZE_ANTISTUD_SUPPORT_WIDTH, physical_height ]);
      }

      children();
    }
  }
  else
  {
    od = bigbrick_calculate_adjusted_antistud_d_outer();
    echo("brick_antistuds od", od);
    id = bigbrick_calculate_adjusted_antistud_d();

    size = [ (width - 1) * BIGBRICK_SIZE_STUD_D_TO_D + od, (length - 1) * BIGBRICK_SIZE_STUD_D_TO_D + od, physical_height ];

    attachable(anchor, spin, orient, size = size)
    {
      grid_copies(n = [ width - 1, length - 1 ], spacing = BIGBRICK_SIZE_STUD_D_TO_D, inside = inside)
        tube(h = physical_height, od = od, id = id);

      children();
    }
  }
}


// clang-format off
function BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length) = 
  length * BIGBRICK_SIZE_P - BIGBRICK_SIZE_REDUCER + brick_get_printer_adjustment("big_total_size");

function BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(length) = 
  length * BIGBRICK_SIZE_P + brick_get_printer_adjustment("big_total_size");

function BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height) = 
  height * BIGBRICK_SIZE_H;

function BIGBRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(height) = 
  height * BIGBRICK_SIZE_H;

function bigbrick_calculate_adjusted_stud_d() =
  BIGBRICK_SIZE_STUD_D + brick_get_printer_adjustment("big_stud_d");

function bigbrick_calculate_adjusted_stud_d_mask() =
  BIGBRICK_SIZE_STUD_D_MASK + brick_get_printer_adjustment("big_stud_d");

function bigbrick_calculate_adjusted_stud_d_inner() =
  BIGBRICK_SIZE_STUD_D_INNER + brick_get_printer_adjustment("big_stud_d_inner");

function bigbrick_calculate_adjusted_antistud_d() =
  BIGBRICK_SIZE_ANTISTUD_D + brick_get_printer_adjustment("big_antistud_d");  

function bigbrick_calculate_adjusted_antistud_d_outer() =
  BIGBRICK_SIZE_ANTISTUD_D_OUTER + brick_get_printer_adjustment("big_antistud_d_outer");  

function BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS() = 
  BIGBRICK_SIZE_WALL + brick_get_printer_adjustment("big_walls");

function BIGBRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height) = 
  height < 1 ? BIGBRICK_SIZE_ROOF_TILE : BIGBRICK_SIZE_ROOF;

// clang-format on