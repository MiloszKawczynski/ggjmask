surf = surface_create(200, 200);

//ps_door
_ps = part_system_create();
part_system_draw_order(_ps, true);

//Emitter
_ptype1 = part_type_create();
part_type_shape(_ptype1, pt_shape_star);
part_type_size(_ptype1, 2, 5, 0, 0.1);
part_type_scale(_ptype1, 0.1, 0.1);
part_type_speed(_ptype1, 0, 0, 0, 0.1);
part_type_direction(_ptype1, 0, 360, 0, 0);
part_type_gravity(_ptype1, 0, 270);
part_type_orientation(_ptype1, 0, 360, 1, 5, false);
part_type_colour3(_ptype1, $BC37FF, $FFE5FF, $7FFFF6);
part_type_alpha3(_ptype1, 0, 1, 0);
part_type_blend(_ptype1, false);
part_type_life(_ptype1, 32, 64);

_pemit1 = part_emitter_create(_ps);
part_emitter_region(_ps, _pemit1, -100, 100, -100, 100, ps_shape_rectangle, ps_distr_linear);
part_emitter_delay(_ps, _pemit1, 1, 0, time_source_units_seconds)
part_emitter_interval(_ps, _pemit1, 0.5, 0, time_source_units_seconds);

part_system_position(_ps, (bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2);
