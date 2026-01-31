function scr_topDownMovement()
{	
    var desiredHorizontalDirection = keyboard_check(vk_right) - keyboard_check(vk_left);
	var desiredVerticalDirection = keyboard_check(vk_down) - keyboard_check(vk_up);
     
	hspeed += desiredHorizontalDirection * acceleration;
	vspeed += desiredVerticalDirection * acceleration;
	
	if (desiredHorizontalDirection == 0)
	{
		hspeed -= sign(hspeed) * deceleration;
	}
	
	if (desiredVerticalDirection == 0)
	{
		vspeed -= sign(vspeed) * deceleration;
	}
	
	if (abs(speed) < deceleration)
	{
        speed = 0;
	}
	
	if (abs(hspeed) < deceleration)
	{
		hspeed = 0;
	}
	
	if (abs(vspeed) < deceleration)
	{
		vspeed = 0;
	}
    
    speed = min(maximumSpeed, speed);
	
	scr_topDownCollision();
    
    return abs(desiredHorizontalDirection) || abs(desiredVerticalDirection)
}

function scr_topDownCollision()
{	
    if (place_meeting(x + hspeed, y, o_collision))
	{
        if (!place_meeting(x + sign(hspeed), y, o_collision))
		{
			while (!place_meeting(x + sign(hspeed), y, o_collision))
			{
				x += sign(hspeed);
			}
		}
        
        hspeed = 0;
	}
    
    if (place_meeting(x, y + vspeed, o_collision))
	{
        if (!place_meeting(x, y + sign(vspeed), o_collision))
		{
			while (!place_meeting(x, y + sign(vspeed), o_collision))
			{
				y += sign(vspeed);
			}
		}
        
        vspeed = 0;
	}
    
    if (place_meeting(x + hspeed, y + vspeed, o_collision))
	{
        if (!place_meeting(x + sign(hspeed), y + sign(vspeed), o_collision))
		{
			while (!place_meeting(x + sign(hspeed), y + sign(vspeed), o_collision))
			{
				x += sign(hspeed);
				y += sign(vspeed);
			}
		}
        
        hspeed = 0;
        vspeed = 0;
	}
}