// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// tightness = BRICK_TIGHTNESS_LOOSE;
tightness = BRICK_TIGHTNESS_DEFAULT;
$brick_printer_adjustments = brick_get_printer_adjustments(printer, tightness = tightness);
echo("$brick_printer_adjustments", printer, tightness, $brick_printer_adjustments);

extra_size_for_better_remove = 0.001;

width = 2;
length = 6;
height = 1 / 3;

texture = undef;
tex_size = [ 10, 10 ];
tex_scale = 0.5;

// brick(width, length, height, texture = texture, tex_size = tex_size, tex_scale = tex_scale,
//       anchor = BOT); // show_anchors();
brick_circle(outer_size = 4, inner_size = 1, height = 1, texture = texture, tex_size = tex_size, tex_scale = 0.5);

// module brick_circle()
// {
//   height = 1 / 3;
//   size = 8;
//   inner_size = 0;

//   physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
//   physical_roof_thickness = BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(height);
//   tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
//   outer_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size);
//   inner_d = BRICK_CALCULATE_PHYSICAL_LENGTH_MASK(inner_size);

//   stud_r = brick_calculate_adjusted_stud_d() / 2;
//   antistud_outer_r = brick_calculate_adjusted_antistud_d_outer() / 2;
//   outer_shape = circle(d = outer_d, $fn = 64);
//   inner_shape = circle(d = inner_d, $fn = 64);
//   shape = inner_size == 0 ? outer_shape : difference(outer_shape, inner_shape);
//   // We need a little outer offset to get rid of any antistuds within antistud_outer_d
//   negative_shape = difference(offset(outer_shape, delta = antistud_outer_r * 2, closed = true), shape);
//   limit_studs_polygon = offset(shape, delta = -stud_r, closed = true);
//   limit_antistuds_polygon = offset(shape, delta = antistud_outer_r, closed = true);
//   shape_for_walls = offset(shape, delta = -physical_wall_thickness, closed = true);

//   actual_hollow_height = min(height, 1);
//   physical_hollow_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(actual_hollow_height) - physical_roof_thickness;

//   // up(1) region(negative_shape);
//   // up(tower_height) region(shape_for_walls);

//   // Shape and studs
//   diff() linear_sweep(shape, h = tower_height, texture = texture, tex_size = tex_size, tex_scale = tex_scale,
//                       tex_inset = true)
//   {
//     position(TOP) brick_studs(width = size, length = size, inside = limit_studs_polygon);
//     // position(BOT) brick_antistuds(width = size, length = size, height = 1);
//     tag("remove") down(extra_size_for_better_remove) position(BOT)
//       linear_sweep(shape_for_walls, h = physical_hollow_height + extra_size_for_better_remove * 2);

//     tag("remove") down(extra_size_for_better_remove) position(BOT)
//       brick_studs(width = size, length = size, is_mask = true);
//   }

//   // Antistuds
//   diff() brick_antistuds(width = size, length = size, height = height, inside = limit_antistuds_polygon)
//   {

//     // Remove antistuds sticking outside shape
//     tag("remove") down(extra_size_for_better_remove) position(BOT)
//       linear_sweep(negative_shape, h = tower_height + extra_size_for_better_remove * 2);
//   }

//   // TODO: Remove places in wall that needs to be removed by diffing with brick_calculate_adjusted_antistud_d()
// }

// stroke(grid_polygon);

// brick_tower();
module brick_tower()
{
  physical_wall_thickness = BRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
  height = 1;
  // size = 6;
  size_ground = 6;
  tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);
  magic_number_to_fit_cyl_to_brick = 3.2; // Just to reduce total size (and cost/weight of filament)
  tower_d = BRICK_CALCULATE_PHYSICAL_LENGTH(size_ground) - magic_number_to_fit_cyl_to_brick;

  diff() cyl(h = tower_height, d = tower_d, anchor = BOT,
             $fn = 64) //, texture = "bricks_vnf", tex_size = [ 10, 10 ], tex_scale = 0.5,
  // tex_inset = true, tex_style = "concave")
  {
    position(TOP) brick_studs(size_ground, size_ground)
    {
      tag("remove") position(BOT) tube(od = tower_d + 50, id = tower_d, h = BRICK_SIZE_STUD_H, anchor = BOT);
    }
    tag("remove") position(BOT) cyl(d = tower_d - physical_wall_thickness * 2,
                                    h = tower_height - BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(1), anchor = BOT);
  }

  diff() brick_antistuds(size_ground, size_ground, 1)
  {
#tag("remove") position(BOT) tube(od = tower_d + 50, id = tower_d, h = tower_height, anchor = BOT);
  }

  // difference()
  // {
  // cyl(h = tower_height, d = tower_d, anchor = BOT, texture = "bricks_vnf", tex_size = [ 10, 10 ], tex_scale = 0.5,
  //     tex_inset = true, tex_style = "concave");
  // brick(size, size, height, is_tile = true, is_closed = true, printer = printer);
  // }

  // brick_box(size, size, height, printer = printer);
}

// left(30) brick(width, length, height, anchor = CENTER + FWD) show_anchors();

// left(30) brick(width, length, height, printer = printer, anchor = TOP);

// left(70) brick(3, 4, height, printer = printer, hollow_height = 10, anchor = LEFT + FWD + BOT);

// right(20) brick(1, length, height, printer = printer, anchor = BOT);
// right(20) back(40) brick(1, length, 1 / 3, printer = printer, anchor = BOT);
// right(30) brick(1, 1, height, printer = printer, anchor = BOT);
// right(40) brick(1, 1, 1 / 3, printer = printer, anchor = BOT);
// right(80) brick(length, 1, height, printer = printer, anchor = BOT);

// back(50) difference()
// {
//   diff() cyl(d = 30, h = BRICK_CALCULATE_PHYSICAL_HEIGHT(1))
//   {
//     tag("keep") position(TOP) brick_studs(3, 3);
//     tag("remove") position(BOT)
//       cyl(d = 30, h = BRICK_CALCULATE_PHYSICAL_HEIGHT(1) - BRICK_CALCULATE_PHYSICAL_ROOF_THICKNESS(1), anchor = BOT);
//     tag("keep") position(BOT) brick_antistuds(6, 6, 1);
//   }
//   tube(od = 60, id = 30, h = BRICK_CALCULATE_PHYSICAL_HEIGHT(1));
// }

// left(16)brick(width, length, height, printer=printer, anchor = BOT);
// left(16*2)brick(width, length, 2/3, printer=printer, anchor = BOT);

// left(20)brick(1, 4, height, printer, anchor = BOT);

// left(50)brick(4, 1, height, printer, anchor = BOT);

// diff() cube([ 19, 10, 19 ]) attach([FRONT]) thing(anchor = TOP);
// left(40) diff() cube([ 19, 10, 19 ]) attach([FRONT]) thing2(anchor = TOP);

module thing(anchor, spin, orient)
{
  tag("remove") attachable(size = [ 15, 15, 15 ], anchor = anchor, spin = spin, orient = orient)
  {
    cuboid([ 10, 10, 16 ]);
    union() {} // dummy children
  }
  attachable(size = [ 15, 15, 15 ], anchor = anchor, spin = spin, orient = orient)
  {
    cuboid([ 15, 15, 15 ]);
    children();
  }
}

module thing2(anchor, spin, orient)
{
  tag("remove") attachable(size = [ 15, 15, 15 ], anchor = anchor, spin = spin, orient = orient)
  {
    cuboid([ 10, 10, 16 ]);
    children();
    // union() {} // dummy children
  }
}
