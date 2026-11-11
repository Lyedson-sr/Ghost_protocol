if (room == Room1
	&& !global.intro_ligacao_vista
	&& intro_ligacao_estado == 1
	&& !global.dialogo_aberto)
{
	var _gw = display_get_gui_width();
	var _texto = "Pressione [E] para atender";

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(c_black);
	draw_text(_gw * 0.5 + 1, 56 + 1, _texto);
	draw_set_color(make_color_rgb(255, 220, 70));
	draw_text(_gw * 0.5, 56, _texto);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}
