// clang-format off
include<common.scad>;
// clang-format on

$fn = 32;

rgn = [ star(n = 5, step = 2, d = 100, spin = 00), circle(d = 30) ];
rgn2 = offset(rgn, delta = -2);
// difference()
// {
//   cyl(h = 5, d = 120);
grid_copies(size = [ 120, 120 ], spacing = [ 4, 4 ], inside = rgn2) cyl(h = 10, d = 2);
// }
region(rgn);