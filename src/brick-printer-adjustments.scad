// clang-format off
// Something needs to be adjusted, at least for FDM 3D printing
// I have two printers that I need to adjust some parts for.
function brick_get_printer_adjustments(printer, tightness=0.0) =
  printer == "bambu" ? [ 
    [ "stud_d", 0.25 + tightness ],     
    [ "antistud_d", 0.3 ], 
    [ "antistud_d_outer", -0.2  + tightness],     
    [ "antistud_single_d", 0.2 ],     
    [ "walls", 0.0 ],     
    [ "total_size", 0.1],
    [ "gears_mod", -0.01 ],
    [ "gears_axle", 0.25 ] ] : 
  printer == "mingda" ? [ 
    [ "stud_d", 0.1 + tightness ], 
    [ "antistud_d", 0.3 ], 
    [ "antistud_d_outer", -0.05 + tightness], 
    [ "antistud_single_d", 0.0 ],     
    [ "walls", -0.04+tightness],     
    [ "total_size", 0.0],
    [ "gears_mod", 0.0 ],
    [ "gears_axle", 0.0 ] 
   ] : 
  undef;
// clang-format on
