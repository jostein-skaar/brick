include<BOSL2\std.scad>;
include <bricklib.scad>;

$fn = 64;

tower_d1 = 40.0 *2;
tower_d2 = 2.5*2; 

size = 6;
height = 6;

tower_height = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

difference()
{
cyl(h=tower_height, d1=tower_d1, d2=tower_d2, texture="bricks_vnf", tex_size=[10,10], tex_scale=0.5, tex_style="concave");
down(2)cyl(h=tower_height, d1=tower_d1-2, d2=tower_d2-2);
}

// path = cuboid([50,50,50]);
// linear_sweep(
//     path, texture="bricks_vnf", tex_size=[10,10],
//     tex_scale=0.25, h=40);

// tex = texture("bricks_vnf");
// linear_sweep(
//     rect(50), texture=tex, h=40,
//     tex_size=[5,5]
// );


