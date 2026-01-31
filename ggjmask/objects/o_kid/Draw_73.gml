var pulse = lerp(-25, ropeArrayLength + 25, pulseTimer);
pulseTimer = lerp(pulseTimer, 0, 0.05);
if (pulseTimer < 0.01)
{
    pulseTimer = 1;
}

surface_set_target(surf);
draw_clear_alpha(c_black, 0);
drawRope(floor(pulse), floor(pulse) + 20, true)
var pulse = lerp(-25, ropeArrayLength + 25, pulseTimer - pulseTimer * 0.5);
drawRope(floor(pulse), floor(pulse) + 20, true)
//drawRope(floor(pulse), floor(pulse) + 10 + 25, true)
surface_reset_target();

draw_set_alpha(1);
draw_self();
drawRope()

shader_set(shd_glow);
var tex = surface_get_texture(surf);
var u_texel = shader_get_uniform(shd_glow, "u_texel");
shader_set_uniform_f(u_texel, texture_get_texel_width(tex), texture_get_texel_height(tex));
shader_set_uniform_f(shader_get_uniform(shd_glow,"u_strength"), 0.75);
draw_surface_ext(surf, 0, 0, 1, 1, 0, c_white, 1);
shader_reset();