// clang-format off
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

part = "tower_roof";

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
else if (part == "tower_roof")
{
  // TODO: Check
  castle_tower_roof();
}

else if (part == "tower_inner")
{
  castle_tower_inner();
}
else if (part == "tower_outer")
{
  castle_tower_outer();
}
else if (part == "tower_door")
{
  // TODO: Check
  castle_tower_with_door(printer = printer);
}
else if (part == "tower_window")
{
  // TODO: Check
  castle_tower_with_window(printer = printer);
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

module castle_tower_inner(height = 6)
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

module castle_tower_outer(height = 6)
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

  // It seems like the cyl is pushed down a bit when using tex_inset=true.
  // So it seems better to use tex_inset=false and instead make the diameter smaller.
  // This is to prevent that the texture add to the size of the cyl.
  tower_total_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(total_size);
  tower_outer_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(outer_size);
  tower_inner_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(inner_size);

  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height_033 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1 / 3);

  diff() cyl(h = physical_height, d1 = tower_total_size_d1 - tex_scale * 2, d2 = tower_d2, anchor = BOT,
             texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = false, tex_style = "concave")
  {
    attach(TOP) brick_studs(width = 1, length = 1, $tightness = BRICK_TIGHTNESS_TIGHT);

    tag("remove") up(physical_height_033) position(BOT)
      cyl(h = physical_height - physical_height_033, d1 = tower_inner_size_d1, d2 = 0, anchor = BOT);

    tag("remove") position(BOT) cyl(h = physical_height_033, d = tower_total_size_d1, anchor = BOT);
  }

  brick_circle(outer_size = total_size, inner_size = inner_size, height = 1 / 3, is_tile = true);
}

module castle_tower_roof_v1()
{
  height = 6;

  total_size = 10;
  outer_size = 8;
  inner_size = 6;

  tower_d2 = 2.5 * 2;

  // It seems like the cyl is pushed down a bit when using tex_inset=true.
  // So it seems better to use tex_inset=false and instead make the diameter smaller.
  // This is to prevent that the texture add to the size of the cyl.
  tower_total_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(total_size) - tex_scale * 2;
  tower_outer_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(outer_size);
  tower_inner_size_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(inner_size);

  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height_1 = BRICK_CALCULATE_PHYSICAL_HEIGHT(1);

  diff() cyl(h = physical_height, d1 = tower_total_size_d1, d2 = tower_d2, anchor = BOT, texture = texture,
             tex_size = tex_size, tex_scale = tex_scale, tex_inset = false, tex_style = "concave")
  {
    attach(TOP) brick_studs(width = 1, length = 1, $tightness = BRICK_TIGHTNESS_TIGHT);

    tag("remove") position(BOT) cyl(h = physical_height, d1 = tower_inner_size_d1, d2 = 0, anchor = BOT);

    tag("remove") position(BOT)
      tube(h = physical_height_1, od = tower_outer_size_d1, id = tower_inner_size_d1, anchor = BOT);
  }

  brick_circle(outer_size = outer_size, inner_size = inner_size, height = 1, is_tile = true);
}
module castle_tower_roof_3()
{
  height = 6;
  size = 10;
  size_tower_part = 8;
  tower_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(size);
  tower_part_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(size_tower_part);
  tower_d2 = 2.5 * 2;
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  hollow_height = 1 / 3;

  rgn = [circle(d = tower_part_d1)];
  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  physical_roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(hollow_height);
  physical_hollow_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(hollow_height) - physical_roof_thickness;

  antistud_outer_d = brick_calculate_adjusted_antistud_d_outer();
  limit_antistuds_polygon = offset(rgn, delta = antistud_outer_d / 2, closed = true);
  shape_for_walls = offset(rgn, delta = -physical_wall_thickness, closed = true);
  // negative_shape = difference(offset(rgn[0], delta = antistud_outer_d, closed = true), rgn);

  diff() cyl(h = physical_height, d1 = tower_d1, d2 = tower_d2, anchor = BOT, texture = texture, tex_size = tex_size,
             tex_scale = tex_scale, tex_inset = true, tex_style = "concave")
  {
    attach(TOP) brick_studs(width = 1, length = 1, $tightness = BRICK_TIGHTNESS_TIGHT);

    tag("remove") position(BOT) linear_sweep(shape_for_walls, h = physical_hollow_height);

    tag("remove") position(BOT) brick_studs(width = size_tower_part, length = size_tower_part, is_mask = true);
  }

  // Antistuds
  diff() brick_antistuds(width = size_tower_part, length = size_tower_part, height = hollow_height,
                         inside = limit_antistuds_polygon)
  {
    // Remove antistuds sticking outside shape
    // tag("remove") position(BOT)
    //   tube(id1 = tower_d1, id2 = tower_d2, wall = antistud_outer_d * 4, h = physical_height, anchor = BOT);
  }
}

module castle_tower_roof2()
{
  height = 6;
  size_roof = 8;

  texture_scale = 0.5;

  // It seems like the cyl is pushed down a bit when using tex_inset=true.
  // So it seems better to use tex_inset=false and instead make the diameter smaller.
  // This is to prevent that the texture add to the size of the cyl.
  tower_d1 = BRICK_CALCULATE_PHYSICAL_LENGTH(size_roof) - 2 * texture_scale;
  tower_d2 = 2.5 * 2;

  tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  // The cyl (roof)
  difference()
  {
    cyl(h = tower_height, d1 = tower_d1, d2 = tower_d2, anchor = BOT, texture = "bricks_vnf", tex_size = [ 10, 10 ],
        tex_scale = texture_scale, tex_inset = false, tex_style = "concave")
    {
      attach(TOP) BRICK_STUDS(1, 1);
    }
    down(wall_size) cyl(h = tower_height, d1 = tower_d1 - wall_size, d2 = tower_d2 - wall_size, anchor = BOT);
  }

  // Close the cyl
  magic_number_to_make_sure_we_close_the_gap = 0.2;
  difference()
  {
    cyl(h = wall_size, d = tower_d1 - wall_size * 2 + magic_number_to_make_sure_we_close_the_gap, anchor = BOT);
    brick(6, 6, 1, is_tile = true, is_closed = true, printer = printer);
  }

  // Bottom brick
  brick_box(6, 6, 1, is_tile = true, printer = printer);
}

module castle_BRICK_WITH_TEXTURES(width, length, height, printer)
{
  texture_scale = 0.5;

  physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_length = BRICK_CALCULATE_PHYSICAL_LENGTH(length);
  physical_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  physical_height1 = BRICK_CALCULATE_PHYSICAL_HEIGHT_MASK(1);

  difference()
  {
    linear_sweep(rect([ physical_width, physical_length ]), h = physical_height, texture = "bricks_vnf",
                 tex_size = [ 10, 10 ], tex_scale = tex_scale, tex_inset = true)
    {
      attach(TOP) BRICK_STUDS(width = width, length = length);
    };
    cuboid([ physical_width - texture_scale * 2, physical_length - texture_scale * 2, physical_height1 ], anchor = BOT);
  }

  difference()
  {
    brick(width = width, length = length, height = 1, is_tile = true, printer = printer);
    rect_tube(size = [ physical_width, physical_length ], wall = texture_scale, h = physical_height1, anchor = BOT);
  }
}

module brick_tower_with_window(printer)
{
  height = 6;
  size = 6;
  size_ground = 9;
  tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  magic_number_to_fit_cyl_to_brick = 3.2; // Just to reduce total size (and cost/weight of filament)
  tower_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size_ground) - magic_number_to_fit_cyl_to_brick;

  difference()
  {
    brick_tower(height = height, printer = printer);
    up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1)) fwd(tower_d / 4) BRICK_TOWER_WINDOW(tower_d, is_mask = true);
  }
  up(BRICK_CALCULATE_PHYSICAL_HEIGHT(1)) fwd(tower_d / 4) BRICK_TOWER_WINDOW(tower_d, is_mask = false);
}

module BRICK_TOWER_WINDOW(tower_d, is_mask = false, is_door = false, anchor = BOT, spin = 0, orient = UP)
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
      magic_number_to_align_studs_with_studs_on_top = 6.8;
      fwd(magic_number_to_align_studs_with_studs_on_top) down(height_total / 2) BRICK_STUDS(4, 2);
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