// clang-format off
include<bigbricklib.scad>;
include<brick-printer-adjustments.scad>;
include<BOSL2/rounding.scad>;
include<BOSL2/joiners.scad>;
// clang-format on

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

width = 15;
// Height: 4 for phones and 6 for tablets

rounding = 5;
// echo ("physical_size_wall", physical_size_wall);
// echo ("physical_size_length", physical_size_length);
// echo ("physical_height", physical_height);
// cuboid([physical_size_length, physical_size_wall, physical_height], anchor=BOT, rounding=rounding, except = [  BOT ])
// {
//   position(LEFT+BACK) cuboid([physical_size_wall, physical_size_side, physical_height], anchor=LEFT+BACK, rounding=rounding, except = [  BOT,FWD,BACK ]);
//   position(RIGHT+BACK) cuboid([physical_size_wall, physical_size_side, physical_height], anchor=RIGHT+BACK, rounding=rounding, except = [  BOT, FWD, BACK ]);
//   fwd(physical_size_space)cuboid([physical_size_length, physical_size_wall, physical_height], rounding=rounding, except = [  BOT ]);  
// }

physical_size_wall = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(1);
wall_thickness = BIGBRICK_CALCULATE_PHYSICAL_WALL_THICKNESS();

// tablet_part();
//tablet_part_end();
// phone_part_start();
// phone_part();
// phone_part_end();

// fwd(200)bottom_part1();
// bottom_part2();

// lowerbottom_part1();
// lowerbottom_part2();
// side_normal(holes = true);

// side_back_cord_hole();

drawer();


module drawer()
{
  height = 3;    

  margin = 1;
  marginTop = 2.6;
  thickness = 2;

  
  physical_size_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width-2)-margin;
  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(9)-margin;
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height)-marginTop;

//https://github.com/BelfrySCAD/BOSL2/wiki/rounding.scad

  diff()
  cuboid([physical_size_width, physical_size_length, physical_height], anchor=BOT)
  {
  tag("remove")attach(TOP) cuboid([physical_size_width-thickness*2, physical_size_length-thickness*2, physical_height-thickness], anchor=TOP);
  #tag("remove")position(FWD+TOP) ycyl(d=20, l=thickness, anchor=CENTER+FWD);
  }

}

module side_back_cord_hole()
{
  length = 3;
  height = 5;  

  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);
    
  difference() 
  {
    union()
    {

    // Upper part (need to be much more tight)
    difference()
    {
      bigbrick(1, length, height, hollow_height=1/3, anchor = BOT, $tightness = 0.2);
      cuboid([physical_size_wall+1, physical_size_length+1, physical_height/2], anchor=BOT);
    }

    // Lower part
    difference()
    {
      bigbrick(1, length, height, hollow_height=1/3, anchor = BOT);
      up(physical_height/2+25) cuboid([physical_size_wall+1, physical_size_length+1, physical_height/2], anchor=BOT);
    }        
   } 

    
      up(40+20/2)zcopies(spacing=40, n=2) {
        xcyl(h=physical_size_wall,d=20);
      }    

      cuboid([physical_size_wall, 10, 30], anchor=BOT);
  }
  
}

module side_normal(holes = false)
{
  length = 5;
  height = 3;  

  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
  physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);
    
  difference() 
  {
    union()
    {

    // Upper part (need to be much more tight)
    difference()
    {
      bigbrick(1, length, height, hollow_height=1/3, anchor = BOT, $tightness = 0.2);
      cuboid([physical_size_wall+1, physical_size_length+1, physical_height/2], anchor=BOT);
    }

    // Lower part
    difference()
    {
      bigbrick(1, length, height, hollow_height=1/3, anchor = BOT);
      up(physical_height/2+25) cuboid([physical_size_wall+1, physical_size_length+1, physical_height/2], anchor=BOT);
    }        
   } 

    if (holes)
    {
      up(40+20/2)zcopies(spacing=40, n=2) {
        xcyl(h=physical_size_wall,d=20);
      }
    }
  }
  
}

module lowerbottom_part1()
{  
    length = 9;
  height = 1/9;  

  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);
  physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
  physical_size_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
  
  limit_studs_polygon = 
  difference(
    difference(rect([physical_size_length, physical_size_width]),
      move([0,0,0], p= rect([physical_size_space_length_mask, physical_size_wall*length]))      
    )    
  );

  // up(11)color("green")region(limit_studs_polygon);
  bigbrick(width, length, height, is_closed=true, limit_studs_polygon=limit_studs_polygon, anchor = BOT);
}

module lowerbottom_part2()
{  
    length = 8;
  height = 1/9;  

  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);
  physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
  physical_size_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
  
  limit_studs_polygon = 
  difference(
    difference(rect([physical_size_length, physical_size_width]),
      move([0,-physical_size_width/2+physical_size_wall + physical_size_wall*2,0], p= rect([physical_size_space_length_mask, physical_size_wall*length]))      
    )    
  );

  // up(11)color("green")region(limit_studs_polygon);
  bigbrick(width, length, height, is_closed=true, limit_studs_polygon=limit_studs_polygon, anchor = BOT);
}

module bottom_part1()
{  
    length = 8;
  height = 1/2;  

  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);
  physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
  physical_size_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
  
  limit_studs_polygon = 
  difference(
    difference(rect([physical_size_length, physical_size_width]),
      move([0,-physical_size_width/2+physical_size_wall + physical_size_wall,0], p= rect([physical_size_space_length_mask, physical_size_wall*2])),    
      move([0,-physical_size_width/2+physical_size_wall + physical_size_wall*4,0], p= rect([physical_size_space_length_mask, physical_size_wall*2]))
    ),
    move([0,-physical_size_width/2+physical_size_wall + physical_size_wall*7,0], p= rect([physical_size_space_length_mask, physical_size_wall*2]))
  );

  // up(11)color("green")region(limit_studs_polygon);
  bigbrick(width, length, height, limit_studs_polygon=limit_studs_polygon, anchor = BOT);
}

module bottom_part2()
{  
  length = 9;
  height = 1/2;    
  
  physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
  physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);
  physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
  physical_size_width = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
  
  limit_studs_polygon = 
  difference(
    difference(rect([physical_size_length, physical_size_width]),
      move([0,-physical_size_width/2+physical_size_wall + physical_size_wall*0,0], p= rect([physical_size_space_length_mask, physical_size_wall*2])),
      move([0,-physical_size_width/2+physical_size_wall + physical_size_wall*3,0], p= rect([physical_size_space_length_mask, physical_size_wall*2]))
    ),
    move([0,-physical_size_width/2+physical_size_wall + physical_size_wall*6,0], p= rect([physical_size_space_length_mask, physical_size_wall*2]))
  );

  // up(11)color("green")region(limit_studs_polygon);
  bigbrick(width, length, height, limit_studs_polygon=limit_studs_polygon, anchor = BOT);
}



module tablet_part()
{
    length = 3;
  height = 6;
  dow_height = 20;

  physical_size_side = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);

physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  difference()
  {  
    bigbrick_box(width, length, height, hollow_height=1/3, is_tile=true); 
    
    fwd(physical_size_wall)cuboid([physical_size_space_length_mask, physical_size_wall+1,physical_height+1], anchor=BOT);

    // Rounding
    back(physical_size_side/2)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=LEFT, spin=180, anchor=CENTER, $fn=64);
    back(physical_size_side/2-physical_size_wall)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=RIGHT, spin=0, anchor=CENTER, $fn=64);    

    // dove tail
    left(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
    right(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
  }

  fwd(physical_size_wall)left(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);
  fwd(physical_size_wall)right(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);


  up(physical_height-dow_height-5)left(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);
  up(physical_height-dow_height-5)right(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);

}

module tablet_part_end()
{
    length = 3;
  height = 6;
  dow_height = 20;

  physical_size_side = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);

physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  difference()
  {  
    bigbrick_box(width, length, height, hollow_height=1/3, is_tile=true); 
    
    fwd(physical_size_wall)cuboid([physical_size_space_length_mask, physical_size_wall+1,physical_height+1], anchor=BOT);

    // Rounding
    back(physical_size_side/2)up(physical_height)rounding_edge_mask(l=physical_size_length, r=rounding, orient=LEFT, spin=180, anchor=CENTER, $fn=64);
    back(physical_size_side/2-physical_size_wall)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=RIGHT, spin=0, anchor=CENTER, $fn=64);    
  }

  fwd(physical_size_wall)left(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);
  fwd(physical_size_wall)right(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);

  up(physical_height-dow_height-5)left(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);
  up(physical_height-dow_height-5)right(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);

}

module phone_part_start()
{
    length = 3;    
  height = 6;
  height2 = 3;
  dow_height = 20;

  physical_size_side = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);  
physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);

physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);
physical_height2 = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height2);



  difference()
  {  
    bigbrick_box(width, length, height, hollow_height=1/3, is_tile=true); 
    
    fwd(physical_size_wall)cuboid([physical_size_space_length_mask, physical_size_wall+1,physical_height+1], anchor=BOT);
    up(physical_height2)fwd(physical_size_wall)cuboid([physical_size_length, physical_size_space,physical_height+1], anchor=BOT);

    // Rounding
    back(physical_size_side/2)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=LEFT, spin=180, anchor=CENTER, $fn=64);
    back(physical_size_side/2-physical_size_wall)up(physical_height)rounding_edge_mask(l=physical_size_length, r=rounding, orient=RIGHT, spin=0, anchor=CENTER, $fn=64);    
    

    // dove tail
    left(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
    right(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
  }

  fwd(physical_size_wall)left(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height2-10], anchor=BOT);
  fwd(physical_size_wall)right(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height2-10], anchor=BOT);


  up(physical_height2-dow_height-5)left(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);
  up(physical_height2-dow_height-5)right(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);

}

module phone_part()
{
    length = 3;
  height = 3;
  dow_height = 20;

  physical_size_side = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);

physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);

  difference()
  {  
    bigbrick_box(width, length, height, hollow_height=1/3, is_tile=true); 
    
    fwd(physical_size_wall)cuboid([physical_size_space_length_mask, physical_size_wall+1,physical_height+1], anchor=BOT);

    // Rounding
    back(physical_size_side/2)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=LEFT, spin=180, anchor=CENTER, $fn=64);
    back(physical_size_side/2-physical_size_wall)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=RIGHT, spin=0, anchor=CENTER, $fn=64);    

    // dove tail
    left(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
    right(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
  }

  fwd(physical_size_wall)left(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);
  fwd(physical_size_wall)right(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);


  up(physical_height-dow_height-5)left(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);
  up(physical_height-dow_height-5)right(physical_size_length/2-physical_size_wall/2)fwd(physical_size_side/2+8)dovetail("male", slide=20, width=12, height=9, angle=25, orient=FWD, anchor=FWD+TOP);

}

module phone_part_end()
{
    length = 4;
  height = 3;
  dow_height = 20;

  physical_size_side = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(length);
physical_size_length = BIGBRICK_CALCULATE_PHYSICAL_LENGTH(width);
physical_size_space_length_mask = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(width-2);

physical_size_space = BIGBRICK_CALCULATE_PHYSICAL_LENGTH_MASK(3);
physical_height = BIGBRICK_CALCULATE_PHYSICAL_HEIGHT(height);

echo ("physical_height", physical_height);

  difference()
  {  
    bigbrick_box(width, length, height, hollow_height=1/3, is_tile=true); 
      

    // Rounding
    back(physical_size_side/2)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=LEFT, spin=180, anchor=CENTER, $fn=64);
    back(physical_size_side/2-physical_size_wall)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=RIGHT, spin=0, anchor=CENTER, $fn=64); 

    fwd(physical_size_side/2)up(physical_height)rounding_edge_mask(l=physical_size_length, r=rounding, orient=RIGHT, spin=0, anchor=CENTER, $fn=64);
    fwd(physical_size_side/2-physical_size_wall)up(physical_height)rounding_edge_mask(l=physical_size_space_length_mask, r=rounding, orient=LEFT, spin=180, anchor=CENTER, $fn=64); 

    // dove tail
    left(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
    right(physical_size_length/2-physical_size_wall/2)back(physical_size_side/2-8)dovetail("female", slide=physical_height-4, width=12, height=8, angle=25, orient=FWD, anchor=FWD+TOP, $slop=0.1);
  }

  fwd(physical_size_wall)left(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);
  fwd(physical_size_wall)right(physical_size_space_length_mask/2+wall_thickness/2)cuboid([wall_thickness, physical_size_wall, physical_height-10], anchor=BOT);
  
}