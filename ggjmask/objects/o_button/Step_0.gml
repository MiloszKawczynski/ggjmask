if (place_meeting(x, y, o_kid) or place_meeting(x, y, o_crate))
{
    ratio = lerp(ratio, 1, 0.01);
}
else 
{
	ratio = lerp(ratio, 0, 0.01);
}

for (var i = 0; i < array_length(myConnections); i++)
{
    with(myConnections[i])
    {
        var xr = lengthdir_x(range * 200, dir);
        var yr = lengthdir_y(range * 200, dir);
        x = lerp(xstart, xstart + xr, other.ratio);
        y = lerp(ystart, ystart + yr, other.ratio);
    }
}