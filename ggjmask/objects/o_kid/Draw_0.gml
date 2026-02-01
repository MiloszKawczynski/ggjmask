draw_set_color(c_black);
for (var i = 0; i < 10; i++)
{
    draw_set_alpha(lerp(0.15, 0.05, i / 9));
    var dist = lerp(0.75, 1, i / 9);
    draw_ellipse(x - 75 * dist, y + 50 - 40 * dist, x + 75 * dist, y + 50 + 40 * dist, false);
}