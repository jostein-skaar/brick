// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 2;
length = 4;
height = 2;

brick(width, length, height, printer = printer, anchor = BOT);

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
