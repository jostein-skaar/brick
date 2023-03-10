// clang-format off
// Something needs to be adjusted, at least for FDM 3D printing
// I have two printers that I need to adjust some parts for.
function brick_get_printer_adjustments(printer) =
  printer == "bambu" ? [ 
    [ "stud_d", 0.25 ],
    [ "antistud_d", 0.3 ], 
    [ "antistud_d_outer", -0.2 ],
    [ "antistud_single_d", 0.2 ],
    [ "walls", 0.0 ],
    [ "total_size", 0.1 ],
    [ "gears_mod", -0.01 ],
    [ "gears_axle", 0.25 ] ] : 
  printer == "mingda" ? [ 
    [ "stud_d", 0.12 ], 
    [ "antistud_d", 0.3 ], 
    [ "antistud_d_outer", -0.06 ], 
    [ "antistud_single_d", 0.0 ],
    [ "walls", -0.04 ],
    [ "total_size", 0.0 ],
    [ "gears_mod", 0.0 ],
    [ "gears_axle", 0.0 ] 
   ] : 
  undef;
// clang-format on

// Places where tightness could be adjusted?
// top: stud_d,
// bottom: antistud_d_outer and walls