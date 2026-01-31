image_angle = dir;

speed -= deceleration
speed = clamp(speed, 0, maximumSpeed);
x = clamp(x, min(xstart, xstart + lengthdir_x(range, dir)), max(xstart, xstart + lengthdir_x(range, dir)));
y = clamp(y, min(ystart, ystart + lengthdir_y(range, dir)), max(ystart, ystart + lengthdir_y(range, dir)));

for (var i = 0; i < array_length(myConnections); i++)
{
    //myConnections[i].x = myConnections[i].xstart + (x - xstart) * (lerp(1, -1, inverse));
    //myConnections[i].y = myConnections[i].ystart + (y - ystart) * (lerp(1, -1, inverse));
    var ratio = point_distance(xstart, ystart, x, y) / range;
    with(myConnections[i])
    {
        var xr = lengthdir_x(range * 200, dir);
        var yr = lengthdir_y(range * 200, dir);
        x = lerp(xstart, xstart + xr, ratio);
        y = lerp(ystart, ystart + yr, ratio);
    }
}