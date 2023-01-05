include <bricklib.scad>;

printer = "ender";
width = 2;
length = 4;
height = 1;

brick(width, length, height, printer=printer, anchor = BOT);
// left(16)brick(width, length, height, printer=printer, anchor = BOT);
//left(16*2)brick(width, length, 2/3, printer=printer, anchor = BOT);


// left(20)brick(1, 4, height, printer, anchor = BOT);

// left(50)brick(4, 1, height, printer, anchor = BOT);