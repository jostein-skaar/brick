// clang-format off
// Something needs to be adjusted, at least for FDM 3D printing
// I have two printers that I need to adjust some parts for.
function brick_get_printer_adjustments(printer) =
  printer == "bambu" ? [ 
    [ "stud_d", 0.25 ], 
    [ "antistud_d", 0.4 ], 
    [ "antistud_d_outer", 0.0 ], 
    [ "antistud_single_d", 0.1 ],     
    [ "walls", 0.0 ],     
    [ "total_size", 0.0],
    [ "gears_mod", -0.01 ],
    [ "gears_axle", 0.25 ] ] : 
  printer == "ender" ? [ 
   ] : 
  undef;
// clang-format on
