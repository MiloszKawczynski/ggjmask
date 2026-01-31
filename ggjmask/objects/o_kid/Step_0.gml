scr_topDownKeyboard();
var wantedToMove = scr_topDownMovement();
if (wantedToMove)
{
    sprite_index = s_kidWalk;
}
else 
{
	sprite_index = s_kid;
}

if (sign(hspeed) != 0)
{
    image_xscale = sign(hspeed);
}

rope[0].xx = x;
rope[0].yy = y;

updatePreviousPosisiton();

if (keyboard_check(vk_space))
{
    for (var i = 0; i < (ropeArrayLength - 1); i++)
    {
        rope[i + 1].xx = lerp(rope[i + 1].xx, rope[i].xx, 0.75);
        rope[i + 1].yy = lerp(rope[i + 1].yy, rope[i].yy, 0.75);
    }
}

repeat (10) 
{
    pullTo(x, y);
    solveRopeCollisions();
    pullBackTo(o_bed.x, o_bed.y)
    solveRopeCollisions();
    ropeInteraction();
}

solveKidRopeCollisions();

if (place_meeting(x, y, o_collisionParent))
{
    image_blend = c_red;
}
else 
{
	image_blend = c_white;
}

if (keyboard_check(vk_shift))
{
    if (mouse_check_button_pressed(mb_left))
    {
        room_goto_next();
    }
    
    if (mouse_check_button_pressed(mb_right))
    {
        room_goto_previous();
    }
}
else 
{
    //if (keyboard_check(vk_space))
    //{
        ////for (var i = 0; i < (ropeArrayLength - 2) / 2; i++)
        ////{
            ////if (point_distance(rope[i].xx, rope[i].yy, rope[i + 1].xx, rope[i + 1].yy) < 15)
            ////{
                ////continue;
            ////}
            ////rope[i + 1].xx = rope[i].xx;
            ////rope[i + 1].yy = rope[i].yy;
            ////
            ////pullTo(x, y);
            ////solveRopeCollisions();
            ////pullBackTo(o_bed.x, o_bed.y)
            ////solveRopeCollisions();
        ////}
        //
        //for (var i = 0; i < (ropeArrayLength - 1); i++)
        //{
            ////if (point_distance(rope[i].xx, rope[i].yy, rope[i + 1].xx, rope[i + 1].yy) < 15)
            ////{
                ////continue;
            ////}
            //rope[i + 1].xx = rope[i].xx;
            //rope[i + 1].yy = rope[i].yy;
            //pullTo(x, y);
            //solveRopeCollisions();
            //pullBackTo(o_bed.x, o_bed.y)
            //solveRopeCollisions();
        //}
    //}
}

if (mouse_check_button_pressed(mb_middle) or keyboard_check_pressed(ord("R")))
{
    room_restart();
}

if (place_meeting(x, y, o_door))
{
    if (room_next(room) != -1)
    {
        room_goto_next();
    }
}

if (place_meeting(x, y, o_inhalator))
{
    addRopeNodes(8 * 2);
    instance_destroy(instance_nearest(x, y, o_inhalator));
}