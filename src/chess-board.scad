// clang-format off
include<bricklib.scad>;
include<brick-printer-adjustments.scad>;
// clang-format on

BRICK_SIZE_STUD_H = 4; // 1.7 or 1.8? Seen both numbers.

printer = "bambu";
// printer = "mingda";
$brick_printer_adjustments = brick_get_printer_adjustments(printer);
echo("$brick_printer_adjustments", printer, $brick_printer_adjustments);

tightness = BRICK_TIGHTNESS_LOOSE -0.15;
text_height = 0.6;
width = 1;
text_margin = 6.5;

physical_width = BRICK_CALCULATE_PHYSICAL_LENGTH(width);
physical_length_2 = BRICK_CALCULATE_PHYSICAL_LENGTH(2);
physical_length_square = BRICK_CALCULATE_PHYSICAL_LENGTH(7);
physical_height_square = BRICK_CALCULATE_PHYSICAL_HEIGHT(5+2/3);

height_corresponding_to_length_2 = 1+2/3;
physical_height_2 =  BRICK_CALCULATE_PHYSICAL_HEIGHT(height_corresponding_to_length_2);

echo ("physical_length_2", physical_length_2);
echo ("physical_height_2", physical_height_2);

// length: 8 squares * 7 studs = 56 studs
// height: 8 squares * 5+2/3 studs = 45+1/3 studs
echo("physical_height_squarex8", physical_height_square*8);


// color("green")square();
// color("red")up(physical_height_square)square();
// color("green")up(physical_height_square*2)square();
// color("red")up(physical_height_square*3)square();

show_letters = true;
show_border = true;

back(80) 
border_top_and_bottom();
border_left_and_right();
 
module square()
{
      length = 7;
      height = 5+2/3;
      is_closed = false;

      echo("width", BRICK_CALCULATE_PHYSICAL_LENGTH(length));
      echo("height", BRICK_CALCULATE_PHYSICAL_HEIGHT(height));
      
      brick(width, length, height, is_closed = is_closed, anchor = BOT, $tightness = tightness);
}

module border_top_and_bottom()
{      
      border_part_bottom_1();
      up(25) border_part_top_1();
      up(50) border_part_bottom_2();
      up(75) border_part_top_2();
      up(100) border_part_bottom_3();
      up(125) border_part_top_3();
}

module border_left_and_right()
{
      border_part_left_1();
      back(20)border_part_right_1();
      back(40)border_part_left_2();
      back(60)border_part_right_2();
}

module border_part_left_1()
{
      height = 4 * (5+2/3); // Half
      length = 2;
      physical_height_total = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

      if (show_letters)
      {
            draw_number("1", 0, 1, container_width=physical_length_2);
            draw_number("2", 0, 2, container_width=physical_length_2);
            draw_number("3", 0, 3, container_width=physical_length_2);
            draw_number("4", 0, 4, container_width=physical_length_2);
      } 
      if (show_border) 
      {
            brick(width, length, height, anchor = BOT, $tightness = tightness);
      }
}

module border_part_left_2()
{
      height = 4 * (5+2/3); // Half
      length = 2;
      physical_height_total = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

      offset_height =  physical_height_square/2;
      echo("offset_height", offset_height);

      if (show_letters)
      {
            draw_number("5", 0, 1, container_width=physical_length_2);
            draw_number("6", 0, 2, container_width=physical_length_2);
            draw_number("7", 0, 3, container_width=physical_length_2);
            draw_number("8", 0, 4, container_width=physical_length_2);
      } 
      if (show_border) 
      {
            brick(width, length, height, anchor = BOT, $tightness = tightness);
      }
}

module border_part_right_1()
{
      height = 4 * (5+2/3); // Half
      length = 2;
      physical_height_total = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

      if (show_letters)
      {
            draw_number("1", 0, 1, container_width=physical_length_2, upside_down=true);
            draw_number("2", 0, 2, container_width=physical_length_2, upside_down=true);
            draw_number("3", 0, 3, container_width=physical_length_2, upside_down=true);
            draw_number("4", 0, 4, container_width=physical_length_2, upside_down=true);
      } 
      if (show_border) 
      {
            brick(width, length, height, anchor = BOT, $tightness = tightness);
      }
}

module border_part_right_2()
{
      height = 4 * (5+2/3); // Half
      length = 2;
      physical_height_total = BRICK_CALCULATE_PHYSICAL_HEIGHT(height);

      if (show_letters)
      {
            draw_number("5", 0, 1, container_width=physical_length_2, upside_down=true);
            draw_number("6", 0, 2, container_width=physical_length_2, upside_down=true);
            draw_number("7", 0, 3, container_width=physical_length_2, upside_down=true);
            draw_number("8", 0, 4, container_width=physical_length_2, upside_down=true);
      } 
      if (show_border) 
      {
            brick(width, length, height, anchor = BOT, $tightness = tightness);
      }
}

module border_part_top_1()
{
      length = 21;
      physical_length_total = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

      if (show_letters)
      {
            draw_letter("A", physical_length_2, 1, container_height=physical_height_2, upside_down=true);
            draw_letter("B", physical_length_2, 2, container_height=physical_height_2, upside_down=true);
            draw_letter("C", physical_length_2, 3, container_height=physical_height_2, upside_down=true);
      } 
      if (show_border) 
      {
            back(physical_length_total/2)brick(width, length, height_corresponding_to_length_2, is_closed = false, is_tile=true, anchor = BOT, $tightness = tightness);
      }
}

module border_part_top_2()
{
      length = 18;
      physical_length_total = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

      if (show_letters)
      {
            draw_letter("D", physical_length_2, 1, container_height=physical_height_2, upside_down=true);
            draw_letter("E", physical_length_2, 2, container_height=physical_height_2, upside_down=true);            
      } 
      if (show_border) 
      {
            back(physical_length_total/2)brick(width, length, height_corresponding_to_length_2, is_closed = false, is_tile=true, anchor = BOT, $tightness = tightness);
      }
}

module border_part_top_3()
{
      length = 21;
      physical_length_total = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

      if (show_letters)
      {
            draw_letter("F", -physical_length_2, 1, container_height=physical_height_2, upside_down=true);
            draw_letter("G", -physical_length_2, 2, container_height=physical_height_2, upside_down=true);            
            draw_letter("H", -physical_length_2, 3, container_height=physical_height_2, upside_down=true);            
      } 
      if (show_border) 
      {
            back(physical_length_total/2)brick(width, length, height_corresponding_to_length_2, is_closed = false, is_tile=true, anchor = BOT, $tightness = tightness);
      }
}

module border_part_bottom_1()
{
      length = 21;
      physical_length_total = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

      if (show_letters)
      {
            draw_letter("A", physical_length_2, 1, container_height=physical_height_2);
            draw_letter("B", physical_length_2, 2, container_height=physical_height_2);
            draw_letter("C", physical_length_2, 3, container_height=physical_height_2);
      } 
      if (show_border) 
      {
            back(physical_length_total/2)brick(width, length, height_corresponding_to_length_2, is_closed = true, anchor = BOT, $tightness = tightness);
      }
}

module border_part_bottom_2()
{
      length = 18;
      physical_length_total = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

      if (show_letters)
      {
            draw_letter("D", physical_length_2, 1, container_height=physical_height_2);
            draw_letter("E", physical_length_2, 2, container_height=physical_height_2); 
      }
      if (show_border) 
      {
            back(physical_length_total/2)brick(width, length, height_corresponding_to_length_2, is_closed = true, anchor = BOT, $tightness = tightness);
      }            
}

module border_part_bottom_3()
{
      length = 21;
      physical_length_total = BRICK_CALCULATE_PHYSICAL_LENGTH(length);

      if (show_letters)
      {
            draw_letter("F", -physical_length_2, 1, container_height=physical_height_2);
            draw_letter("G", -physical_length_2, 2, container_height=physical_height_2);
            draw_letter("H", -physical_length_2, 3, container_height=physical_height_2);
      }
      if (show_border) 
      {
            back(physical_length_total/2)brick(width, length, height_corresponding_to_length_2, is_closed = true, anchor = BOT, $tightness = tightness);
      }              
}


module draw_letter(letter, start_offset, square_offset, container_height, upside_down=false)
{      
      font = "Arial:style=Bold";    
      font_size = 9;      
      #up(upside_down ? font_size + text_margin/2: container_height-font_size-text_margin/2)      
      right(physical_width/2-text_height/2)
      back(start_offset + (square_offset-1)*physical_length_square + physical_length_square/2)
      xrot(90)yrot(90)      
      zrot(upside_down ? 180 : 0)
      linear_extrude(height = text_height, center = true) 
      { 
            text(letter, size = font_size, font = font, halign = "center", valign = "bottom", $fn = 16); 
      }
}

module draw_number(number, start_offset, square_offset, container_width, upside_down=false)
{      
      font = "Arial:style=Bold";    
      font_size = 9;      
      #
      //up(upside_down ? font_size + text_margin/2: container_width-font_size-text_margin/2)      
      right(physical_width/2-text_height/2)
      up(start_offset + (square_offset-1)*physical_height_square + physical_height_square/2)
      xrot(90)yrot(90)      
      zrot(upside_down ? 180 : 0)
      linear_extrude(height = text_height, center = true) 
      { 
            text(number, size = font_size, font = font, halign = "center", valign = "center", $fn = 16); 
      }
}
