scr_topDownMovement();

rope[0].xx = x;
rope[0].yy = y;

updatePreviousPosisiton();

repeat (4) 
{
    pullTo(x, y);
    pullBackTo(o_bed.x, o_bed.y)
    solveRopeCollisions();
}

x = rope[0].xx;
y = rope[0].yy;

if (mouse_check_button_pressed(mb_left))
{
    x = mouse_x;
    y = mouse_y;
    
    room_restart();
}