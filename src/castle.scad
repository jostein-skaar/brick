// clang-format off
include<BOSL2/hinges.scad>;
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

$fn = 64;

printer = "bambu";

$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

texture = "bricks_vnf";
// texture = undef;
tex_size = [ 10, 10 ];
tex_scale = 0.5;

part = "prison_hatch";

echo(part, printer);

if (part == "wall")
{
  castle_wall(width = 2, length = 8, height = 2);
}
else if (part == "wall_top")
{
  castle_wall_top(width = 2, length = 8, height = 2);
}
else if (part == "tower")
{
  castle_tower();
}
else if (part == "tower_window")
{
  castle_tower_window();
}
else if (part == "tower_bottom_inner")
{
  castle_tower_bottom_inner();
}
else if (part == "tower_bottom_outer")
{
  castle_tower_bottom_outer();
}
else if (part == "tower_roof")
{
  castle_tower_roof();
}
else if (part == "prison")
{
  castle_prison(width = 6, length = 8, height = 6);
}
else if (part == "prison_hatch")
{
  castle_prison_hatch(width = 6, length = 8);
}
else if (part == "prison_cage")
{
  castle_prison_cage(width = 6, length = 8, height = 6);
}
else if (part == "prison_door_frame")
{
  castle_prison_door_frame(length = 4, height = 6);
}
else if (part == "prison_door")
{
  castle_prison_door(length = 4, height = 6);
}

module castle_wall(width, length, height)
{
  $tightness = BRICK_TIGHTNESS_LOOSE;
  brick(width, length, height, texture = texture, tex_size = tex_size, tex_scale = tex_scale);
}

module castle_wall_top(width, length, height)
{
  $tightness = BRICK_TIGHTNESS_LOOSE;
  brick(width, length, height - 1, texture = texture, tex_size = tex_size, tex_scale = tex_scale)
  {
    position("2x_pos1")
      brick(width, 2, 1, is_closed = true, texture = texture, tex_size = tex_size, tex_scale = tex_scale);
    position("2x_pos3")
      brick(width, 2, 1, is_closed = true, texture = texture, tex_size = tex_size, tex_scale = tex_scale, spin = 90);
  };
}

module castle_tower(height = 6)
{
  brick_circle(outer_size = 8, inner_size = 6, height = height, texture = texture, tex_size = tex_size,
               tex_scale = tex_scale);
}

module castle_tower_window(printer)
{
  height = 6;
  outer_size = 8;
  tower_outer_size_d = BRICK_CALCULATE_PHYSICAL_LENGTH(outer_size);

  difference()
  {
    castle_tower(height = height);
    up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1)) fwd(tower_outer_size_d / 4)
      castle_tower_window_opening(tower_outer_size_d, is_mask = true);
  }
  up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1)) fwd(tower_outer_size_d / 4)
    castle_tower_window_opening(tower_outer_size_d, is_mask = false);
}

module castle_tower_window_opening(tower_d, is_mask = false, is_door = false, anchor = BOT, spin = 0, orient = UP)
{
  width_total = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(4);
  height_total = BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(is_door ? 5 : 4);

  d_cyl = width_total;

  width_cube = width_total;
  height_cube = height_total - d_cyl / 2;

  size = [ width_cube, tower_d / 2, height_total ];

  attachable(anchor, spin, orient, size = size)
  {
    if (is_mask)
    {
      down(d_cyl / 4)
      {
        cuboid([ width_cube, tower_d / 2, height_cube ], anchor = CENTER);
        up(height_cube / 2) resize([ 0, 0, d_cyl ]) ycyl(d = d_cyl, h = tower_d / 2, anchor = CENTER, $fn = 200);
      }
    }
    else
    {
      // TODO: Better to create full circle and use limit_studs_polygon
      magic_number_to_align_studs_with_studs_on_top = 12;
      fwd(magic_number_to_align_studs_with_studs_on_top) down(height_total / 2) brick_studs(2, 1);
    }

    children();
  }
}

module castle_tower_bottom_inner(height = 6)
{
  mask_length1 = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(4);
  mask_length2 = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(6);
  length1 = BRICK_CALCULATE_PHYSICAL_LENGTH(2);
  length2 = BRICK_CALCULATE_PHYSICAL_LENGTH(6);
  mask_height = BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(height + 1);
  difference()
  {
    castle_tower(height = height);
    down(0.001) back(length2 / 2) right(length2 / 2)
      cuboid([ mask_length2, mask_length2 + 100, mask_height ], anchor = BOT);
    down(0.001) fwd(length2 / 2) left(length2 / 2) cuboid([ mask_length2, mask_length2, mask_height ], anchor = BOT);
  }
}

module castle_tower_bottom_outer(height = 6)
{
  mask_length = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(6);
  length = BRICK_CALCULATE_PHYSICAL_LENGTH(2);
  mask_height = BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(height + 1);
  difference()
  {
    castle_tower(height = height);
    down(0.001) back(length / 2) right(length / 2) cuboid([ mask_length, mask_length, mask_height ], anchor = BOT);
  }
}

module castle_tower_roof()
{
  height = 6;

  total_size = 10;
  outer_size = 8;
  inner_size = 6;

  tower_d2 = 2.5 * 2;

  tower_total_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(total_size);
  tower_outer_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(outer_size);
  tower_inner_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(inner_size);

  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height_1 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 2);

  // It seems like the cyl is pushed down a bit when using tex_inset=true.
  // So it seems better to use tex_inset=false and instead make the diameter smaller.
  // This is to prevent that the texture add to the size of the cyl.
  up(physical_height_1) diff()
    cyl(h = physical_height - physical_height_1, d1 = tower_total_size_d1 - tex_scale * 2, d2 = tower_d2, anchor = BOT,
        texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = false, tex_style = "concave")
  {
    attach(TOP) brick_studs(width = 1, length = 1, $tightness = BRICK_TIGHTNESS_TIGHT);

    tag("remove") position(BOT)
      cyl(h = physical_height - physical_height_1, d1 = tower_inner_size_d1, d2 = 0, anchor = BOT);
  }

  brick_circle(outer_size = total_size, inner_size = inner_size, height = 1 / 2, is_tile = true, texture = texture,
               tex_size = tex_size, tex_scale = tex_scale);
}

module castle_prison(width, length, height)
{
  $tightness = BRICK_TIGHTNESS_LOOSE;

  width_door = 4;
  height_window = 3;

  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_LENGTH(1);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height_window = BRICK_CALCULATE_PHYSICAL_HEIGHT(height_window);
  physical_height033 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3);
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_width_door_opening = BRICK_CALCULATE_PHYSICAL_LENGTH(width_door);
  d_hinge = physical_height033;

  door_stopper = (physical_wall_thickness - d_hinge) / 2;

  difference()
  {
    brick_box(width, length, height, hollow_height = 1 / 3, texture = texture, tex_size = tex_size,
              tex_scale = tex_scale);

    // Door openeing
    fwd(physical_length / 2 - physical_wall_thickness / 2) up(physical_height033)
    {
      // Inside part of door opening
      back((physical_wall_thickness - door_stopper) / 2) up(1) cuboid(
        [
          physical_width_door_opening - 2, door_stopper + extra_size_for_better_remove,
          physical_height - physical_height033 * 2 - 2
        ],
        anchor = BOT);

      // Outside part of door opening
      fwd(door_stopper / 2 + extra_size_for_better_remove) cuboid(
        [
          physical_width_door_opening, physical_wall_thickness + extra_size_for_better_remove - door_stopper,
          physical_height - physical_height033 * 2
        ],
        anchor = BOT);

      // Hinge
      left(BRICK_SIZE_STUD_D_TO_D * width_door / 2 - BRICK_SIZE_STUD_D_TO_D / 2)
      {
        up(physical_height - physical_height033 * 2) sphere(d = d_hinge);
        up(0) sphere(d = d_hinge);
      }
    }

    // Window opening
    back(physical_length / 2 - physical_wall_thickness / 2) up(physical_height033 + physical_height033 * 3 * 3)
    {
      cuboid(
        [
          physical_width_door_opening, physical_wall_thickness + extra_size_for_better_remove,
          physical_height_window - physical_height033 * 2 +
          physical_height033
        ],
        anchor = BOT);
    }
  }

  // Window bars
  back(physical_length / 2 - physical_wall_thickness / 2) up(physical_height033 + physical_height033 * 3 * 3)
  {
    zrot(90) castle_prison_row_with_bars(width, height_window - 1 / 3);
  }
}

module castle_prison_cage(width, length, height)
{
  $tightness = BRICK_TIGHTNESS_LOOSE;

  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_LENGTH(1);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height033 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3);
  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  d_for_bars = physical_height033;
  width_door = 4;
  physical_width_door_opening = BRICK_CALCULATE_PHYSICAL_LENGTH(width_door);
  d_hinge = physical_height033;
  door_stopper = (physical_wall_thickness - d_hinge) / 2;

  difference()
  {
    union()
    {
      brick_box(width, length, 1 / 3, is_tile = true, texture = undef, tex_size = tex_size, tex_scale = tex_scale);

      left(physical_width / 2 - physical_wall_thickness / 2) up(physical_height033)
        castle_prison_row_with_bars(length, height - 1 / 3);

      right(physical_width / 2 - physical_wall_thickness / 2) up(physical_height033)
        castle_prison_row_with_bars(length, height - 1 / 3);

      fwd(physical_length / 2 - physical_wall_thickness / 2) up(physical_height033) zrot(90)
        castle_prison_row_with_bars(width, height - 1 / 3, include_bars = false);

      back(physical_length / 2 - physical_wall_thickness / 2) up(physical_height033) zrot(90)
        castle_prison_row_with_bars(width, height - 1 / 3);

      // Door stopper
      back((physical_wall_thickness - door_stopper) / 2) fwd(physical_length / 2 - physical_wall_thickness / 2)
        up(physical_height033) right(physical_width_door_opening / 2 - 4)
      {
        cuboid([ 3, door_stopper, 1 ], anchor = BOT, rounding = 0.4, edges = [TOP]);
      }
    }
    // Hinge
    fwd(physical_length / 2 - physical_wall_thickness / 2) up(physical_height033)
      left(BRICK_SIZE_STUD_D_TO_D * width_door / 2 - BRICK_SIZE_STUD_D_TO_D / 2)
    {
      up(physical_height - physical_height033 * 2) sphere(d = d_hinge);
      up(0) sphere(d = d_hinge);
    }
  }

  // Horizontal bars
  height_for_horizontal_bars = physical_height / 3;
  left(physical_width / 2 - physical_wall_thickness / 2)
    zcopies(l = height_for_horizontal_bars, n = 2, sp = [ 0, 0, height_for_horizontal_bars ])
      cuboid([ physical_height033, BRICK_SIZE_STUD_D_TO_D * (length - 1) + physical_height033, 1.2 ],
             rounding = physical_height033 / 2, edges = "Z", anchor = BOT);
  right(physical_width / 2 - physical_wall_thickness / 2)
    zcopies(l = height_for_horizontal_bars, n = 2, sp = [ 0, 0, height_for_horizontal_bars ])
      cuboid([ physical_height033, BRICK_SIZE_STUD_D_TO_D * (length - 1) + physical_height033, 1.2 ],
             rounding = physical_height033 / 2, edges = "Z", anchor = BOT);
  back(physical_length / 2 - physical_wall_thickness / 2)
    zcopies(l = height_for_horizontal_bars, n = 2, sp = [ 0, 0, height_for_horizontal_bars ])
      cuboid([ BRICK_SIZE_STUD_D_TO_D * (width - 1) + physical_height033, physical_height033, 1.2 ],
             rounding = physical_height033 / 2, edges = "Z", anchor = BOT);
}

module castle_prison_hatch(width, length)
{
  height = 1 / 3;
  $tightness = BRICK_TIGHTNESS_DEFAULT;
  brick_box(width, length, height, texture = undef, tex_size = tex_size, tex_scale = tex_scale);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_inner_width = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width - 2);
  physical_inner_length = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(length - 2);
  d_for_bars = physical_height;

  ycopies(spacing = BRICK_SIZE_STUD_D_TO_D, n = length - 1)
    xcyl(d = d_for_bars, h = physical_inner_width, anchor = BOT);

  xcopies(spacing = BRICK_SIZE_STUD_D_TO_D, n = width - 1)
    ycyl(d = d_for_bars, h = physical_inner_length, anchor = BOT);
}

module castle_prison_door_frame(length, height)
{
  $tightness = BRICK_TIGHTNESS_LOOSE;

  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_LENGTH(1);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height033 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  d_for_bars = physical_height033;
  door_frame = 2;
  height_transistion = 2.4;
  d_hinge = physical_height033;

  difference()
  {
    union()
    {
      up(physical_height - physical_height033) brick(1, length, 1 / 3, is_closed = true);
      brick(1, length, 1 / 3, is_tile = true)
      {
        position(TOP + FWD)
          cuboid([ physical_wall_thickness, door_frame, physical_height - physical_height033 * 2 ], anchor = BOT + FWD);
        position(TOP + BACK) cuboid([ physical_wall_thickness, door_frame, physical_height - physical_height033 * 2 ],
                                    anchor = BOT + BACK);
      }
    }

    fwd(BRICK_SIZE_STUD_D_TO_D * length / 2 - BRICK_SIZE_STUD_D_TO_D / 2)
    {
      up(physical_height - physical_height033) sphere(d = d_hinge);
      up(physical_height033) sphere(d = d_hinge);
    }
  }
}

module castle_prison_door(length, height)
{
  $tightness = BRICK_TIGHTNESS_LOOSE;

  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_LENGTH(1);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height033 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  d_for_bars = physical_height033;

  height_transistion = 2.4;

  door_margin_brick_unit = 0.07;
  door_border = 2;

  actual_height_brick_unit = height - 1 / 3 - door_margin_brick_unit;
  physical_actual_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(actual_height_brick_unit);

  castle_prison_row_with_bars(length, actual_height_brick_unit, include_top = false);

  // Horizontal bars
  zcopies(l = physical_actual_height - physical_height033 - door_border, n = 4, sp = [ 0, 0, 0 ])
    cuboid([ physical_height033, BRICK_SIZE_STUD_D_TO_D * (length - 1) + physical_height033, door_border ],
           rounding = physical_height033 / 2, edges = "Z", anchor = BOT);

  d_hinge = physical_height033 - 0.1;
  hinge_offset = 1;

  // Hinge part
  fwd(BRICK_SIZE_STUD_D_TO_D * length / 2 - BRICK_SIZE_STUD_D_TO_D / 2)
  {
    up(physical_actual_height - physical_height033) sphere(d = d_hinge);
    up(0) sphere(d = d_hinge);
  }

  // Door knob
  up((physical_actual_height - physical_height033) / 2)
    back(BRICK_SIZE_STUD_D_TO_D * length / 2 - BRICK_SIZE_STUD_D_TO_D / 2 - BRICK_SIZE_STUD_D_TO_D / 2)

      cuboid([ physical_height033, BRICK_SIZE_STUD_D_TO_D, BRICK_SIZE_STUD_D_TO_D ], rounding = physical_height033 / 2,
             edges = "X")
  {
    attach(RIGHT) brick_studs(1, 1, $tightness = BRICK_TIGHTNESS_DEFAULT);
  }
}

module castle_prison_row_with_bars(length, height, include_bars = true, include_top = true)
{
  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_LENGTH(1);

  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height - 1 / 3);
  physical_height033 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3);
  d_for_bars = physical_height033;
  height_transistion = 2.4;

  if (include_bars)
    ycopies(spacing = BRICK_SIZE_STUD_D_TO_D, n = length) { zcyl(d = d_for_bars, h = physical_height, anchor = BOT); }

  diff_height = physical_height033 - height_transistion;
  diff_width = physical_wall_thickness - d_for_bars;
  if (include_top)
  {
    up(physical_height)
      prismoid(size1 = [ d_for_bars, physical_length - diff_width ],
               size2 = [ physical_wall_thickness, physical_length ], h = height_transistion, anchor = BOT)
    {
      position(TOP) cuboid([ physical_wall_thickness, physical_length, diff_height ], anchor = BOT)
      {
        position(TOP) brick_studs(1, length);
      }
    }
  }
}

// clang-format off

// clang-format on