function scr_shadow()
{	
	var xPos=sprite_get_xoffset(sprite_index);
	var yPos=sprite_get_yoffset(sprite_index);
	
	gpu_set_fog(true,c_black,0,1);
	
	shader_set(sh_blurBlack);
	shader_set_uniform_f(uniformTexelW,texture_get_texel_width(sprite_get_texture(sprite_index,image_index)));
	shader_set_uniform_f(uniformTexelH,texture_get_texel_height(sprite_get_texture(sprite_index,image_index)));
	shader_set_uniform_f(uniformRadius,0.5);
	
	draw_sprite_ext(sprite_index,image_index, x, y, 1.1, 1.1, 0, c_black, 0.5 );
	shader_reset();
	gpu_set_fog(false,c_white,0,0);
}