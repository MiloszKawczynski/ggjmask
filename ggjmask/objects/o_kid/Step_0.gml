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

var centers = getLoopsCenters();
repeat (10) 
{
    pullTo(x, y);
    solveRopeCollisions();
    pullBackTo(homeBed.x, homeBed.y)
    solveRopeCollisions();
    ropeInteraction(centers);
}

solveKidRopeCollisions();

if (isDead)
{
    image_angle = lerp(image_angle, -90, 0.05);
    if (image_angle < -60)
    {
        image_alpha = lerp(image_alpha, 0, 0.1);
        if (!isDeaded)
        {
            part_system_position(_ps, x, y);
            part_emitter_burst(_ps, _pemit1, _ptype1, 4);
            isDeaded = true;
        }
    }
    if (!audio_is_playing(sn_oof))
    {
        room_restart();
    }
}

if (place_meeting(x, y, o_collisionParent))
{
    if (!isDead)
    {
        image_blend = c_red;
        audio_play_sound(sn_oof, 0, false);
        isDead = true;
    }
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

depth = -y + 200;