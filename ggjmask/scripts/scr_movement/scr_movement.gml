function scr_overrideTopDownMovement()
{	
    hspeed = 0;
    vspeed = 0;
}

function scr_topDownKeyboard()
{	
    desiredHorizontalDirection = keyboard_check(ord("D")) - keyboard_check(ord("A"));
	desiredVerticalDirection = keyboard_check(ord("S")) - keyboard_check(ord("W"));
}

function scr_topDownToPoint(xx, yy)
{	
    desiredHorizontalDirection = sign(xx - x);
	desiredVerticalDirection = sign(yy - y);
}

function scr_topDownMovement()
{	
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