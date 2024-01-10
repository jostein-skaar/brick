// clang-format off
include<bigbricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 4;
length = 4;
height = 2; // 1,2,4,6
tube_wall = 2.4;
inside_wall = 1.2;
use_inside_walls = true;
inside_wall_height_reducer = 2;
x_walls = width/2-1;
y_walls = length/2-1;
// x_walls = 1;

// texture = undef;
texture = "diamonds_vnf";
tex_scale = 0.5;
tex_size = [ BRICK_CALCULATE_PHYSICAL_LENGTH(2) / 2, BRICK_CALCULATE_PHYSICAL_HEIGHT(4) / 4 ];
inside_walls_spacing = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(2);

pencil_organizer(width, length, height);



module pencil_organizer(width, length, height)
{


tube_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);
tube_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
tube_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
brick_height = 1 / 3;
brick_physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(brick_height);

brick_wall_thickness = BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();
echo("tube_wall", tube_wall, "tube_width", tube_width);



// Tube with texture
path = difference(rect([ tube_width, tube_length ]), rect([ tube_width - tube_wall * 2, tube_length - tube_wall * 2 ]));
diff()
  linear_sweep(path, texture = texture, tex_size = tex_size, tex_scale = tex_scale, tex_inset = true, h = tube_height)
{
  tag("remove") position(BOT)
    cuboid([ tube_width - brick_wall_thickness * 2, tube_length - brick_wall_thickness * 2, brick_physical_height ],
           anchor = BOT);
  if (use_inside_walls)
  {
    position(BOT) xcopies(n=x_walls, spacing=inside_walls_spacing)cuboid([inside_wall, tube_length-tube_wall, tube_height-inside_wall_height_reducer], anchor=BOT);
    position(BOT) ycopies(n=y_walls, spacing=inside_walls_spacing)cuboid([tube_width-tube_wall, inside_wall, tube_height-inside_wall_height_reducer], anchor=BOT);
  } 
}

// The brick part
difference()
{
  bigbrick(width, length, brick_height, is_tile = true, texture = undef, tex_size = tex_size, tex_scale = tex_scale,
        anchor = BOT);
  // Get rid of brick wall sticking out of tube wall's texture
  rect_tube(h = brick_physical_height+1, size = [ tube_width, tube_length ], wall = 1);
}
}