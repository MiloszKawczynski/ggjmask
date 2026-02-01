draw_set_color(c_black);
for (var i = 0; i < 10; i++)
{
    draw_set_alpha(lerp(0.15, 0.05, i / 9));
    var dist = lerp(0.75, 1, i / 9);
    draw_ellipse(x - 75 * dist, ystart + 100 - 40 * dist, x + 75 * dist, ystart + 100 + 40 * dist, false);
}
draw_set_alpha(1);

surface_set_target(surf);
draw_clear_alpha(c_black, 0);
draw_sprite_ext(s_door, image_index, 100, y - ystart + 100, 1, 1, image_angle, c_white, 1);
surface_reset_target();

shader_set(shd_glow);
var tex = surface_get_texture(surf);
var u_texel = shader_get_uniform(shd_glow, "u_texel");
shader_set_uniform_f(u_texel, texture_get_texel_width(tex), texture_get_texel_height(tex));
shader_set_uniform_f(shader_get_uniform(shd_glow,"u_strength"), 0.4 + sin(current_time / (100)) * 0.15);
draw_surface_ext(surf, x - 100, y - 100, 1, 1, 0, c_white, 1);
shader_reset();
