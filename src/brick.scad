include <bricklib.scad>;

printer = "bambu";
width = 2;
length = 4;
height = 1;
brick(width, length, height, printer, anchor = BOT);

// left(20)brick(1, 4, height, printer, anchor = BOT);

// left(50)brick(4, 1, height, printer, anchor = BOT);