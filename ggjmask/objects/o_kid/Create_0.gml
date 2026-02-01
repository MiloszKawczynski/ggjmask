acceleration = 1;
deceleration = 0.5;
maximumSpeed = 12;
desiredHorizontalDirection = 0;
desiredVerticalDirection = 0;

rope = array_create();
ropePointLength = 25;
ropeArrayLength = 8 * 12;
ropeMaxStrength = 5;
ropeAnchor = undefined;
ropeStrength = ropeMaxStrength;
maxRopeLength = ropePointLength * (ropeArrayLength - 1);

homeBed = instance_nearest(x, y, o_bed);

addRopeNodes(ropeArrayLength);

debugX = 0;
debugY = 0;

ropeColor = make_color_rgb(141, 171, 229);
ropeOutlineColor = make_color_rgb(36, 133, 153);

pulseTimer = 0;
surf = surface_create(room_width, room_height);

alarm[0] = random_range(60, 60 * 10);

isDead = false;
isDeaded = false;

//ps_death
_ps = part_system_create();
part_system_draw_order(_ps, true);

//Emitter
_ptype1 = part_type_create();
part_type_shape(_ptype1, pt_shape_cloud);
part_type_size(_ptype1, 1, 7, -0.05, 0);
part_type_scale(_ptype1, 0.2, 0.2);
part_type_speed(_ptype1, 1, 4, 0, 0.1);
part_type_direction(_ptype1, 70, 120, 0, 0);
part_type_gravity(_ptype1, 0, 270);
part_type_orientation(_ptype1, 0, 360, 1, 0, false);
part_type_colour3(_ptype1, $72BEE5, $5BA0D4, $4EA1CC);
part_type_alpha3(_ptype1, 1, 0.949, 0.659);
part_type_blend(_ptype1, false);
part_type_life(_ptype1, 32, 64);

_pemit1 = part_emitter_create(_ps);
part_emitter_region(_ps, _pemit1, -20, 20, -20, 20, ps_shape_rectangle, ps_distr_linear);
part_emitter_delay(_ps, _pemit1, 1, 0, time_source_units_seconds)
