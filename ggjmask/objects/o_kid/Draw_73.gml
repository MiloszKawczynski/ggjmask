draw_set_color(c_black);
draw_set_font(f_font);
draw_text(x, y - 200, fps_real);

for (var i = 0; i < ropeArrayLength; i++)
{
    var ropePoint = rope[i];
    
    if (i > 0)
    {
        var ropeConnection = rope[i].connectsForward;
        draw_set_color(c_black)
        draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy, 12);
    }
    
    draw_set_color(c_red)
    draw_circle(ropePoint.xx, ropePoint.yy, 14, false);
}

draw_self();