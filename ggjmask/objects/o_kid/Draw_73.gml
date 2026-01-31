draw_set_color(c_black);
draw_set_font(f_font);
//draw_text(x, y - 200, fps_real);
draw_self();

for (var i = 0; i < ropeArrayLength; i++)
{
    var ropePoint = rope[i];
    
    if (i > 0)
    {
        var ropeConnection = rope[i].connectsForward;
        var ropeConnection2 = rope[i].connectsForward.connectsForward;
        draw_set_color(ropeOutlineColor)
        if (ropeConnection2 != undefined)
        {
            draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection2.xx, ropeConnection2.yy, lerp(30, 12, i / ropeArrayLength));
        }
        draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy, lerp(30, 17, i / ropeArrayLength));
        draw_set_color(ropeColor)
        if (ropeConnection2 != undefined)
        {
            draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection2.xx, ropeConnection2.yy, lerp(25, 12, i / ropeArrayLength));
        }
        draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy, lerp(25, 12, i / ropeArrayLength));
    }
    
    draw_set_color(c_red)
    //draw_circle(ropePoint.xx, ropePoint.yy, 14, false);
}
//draw_sprite(s_kid, 0, debugX, debugY);