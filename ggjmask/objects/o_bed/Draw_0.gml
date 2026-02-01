xx = (bbox_left + bbox_right) / 2;
yy = (bbox_bottom + bbox_top) / 2;

draw_set_color(c_black);
for (var i = 0; i < 10; i++)
{
    draw_set_alpha(lerp(0.15, 0.05, i / 9));
    var dist = lerp(0.75, 1, i / 9);
    draw_ellipse(xx - 75 * dist, yy + 50 - 40 * dist, xx + 75 * dist, yy + 50 + 40 * dist, false);
}
draw_set_alpha(1);
draw_self()