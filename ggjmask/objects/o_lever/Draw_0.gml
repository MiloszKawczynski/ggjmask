draw_set_color(c_black)
var tx = lengthdir_x(range, dir);
var ty = lengthdir_y(range, dir);
var stx = xstart;
var sty = ystart;
if (tx < 0)
{
    stx += tx / 2;
}

if (ty > 0)
{
    sty += ty / 2;
}

draw_sprite_ext(s_hole, 0, stx, sty, max(abs(tx / 200), 0.3), max(abs(ty / 200), 0.3), 0, c_white, 1);
draw_self()