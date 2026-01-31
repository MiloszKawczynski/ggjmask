speed -= deceleration
speed = clamp(speed, 0, maximumSpeed);

scr_topDownCollision();