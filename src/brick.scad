// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);

width = 2;
length = 4;
height = 1;

brick(width, length, height, printer = printer, anchor = BOT);

left(30) brick(width, length, height, printer = printer, anchor = TOP);

left(70) brick(3, 4, height, printer = printer, anchor = LEFT + FWD + BOT);

right(20) brick(1, length, height, printer = printer, anchor = BOT);
right(50) brick(length, 1, height, printer = printer, anchor = BOT);

back(50) diff() cyl(d = 30, h = 8)
{
  position(TOP) BRICK_STUDS(3, 3);
  tag("remove") position(BOT) brick_anti(5, 5, 1 / 3);
};

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
