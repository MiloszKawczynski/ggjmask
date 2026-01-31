var wantedToMove = scr_topDownMovement();

rope[0].xx = x;
rope[0].yy = y;

updatePreviousPosisiton();

repeat (10) 
{
    pullTo(x, y);
    pullBackTo(o_bed.x, o_bed.y)
    solveRopeCollisions();
}

solveKidRopeCollisions();

if (place_meeting(x, y, o_collision))
{
    image_blend = c_red;
}
else 
{
	image_blend = c_white;
}

if (mouse_check_button_pressed(mb_left))
{
    x = rope[1].xx;
    y = rope[1].yy;
}