speed -= deceleration
speed = clamp(speed, 0, maximumSpeed);

scr_topDownCollision(true);

var inst = instance_nearest(x, y, o_collision);
if (distance_to_object(inst) < 5)
{
    direction = point_direction(inst.x, inst.y, x, y);
    speed = 1;
}