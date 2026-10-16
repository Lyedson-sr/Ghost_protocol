if (alvo != noone && !global.dialogo_aberto) {
    draw_set_halign(fa_center);
    draw_text(display_get_gui_width()/2, display_get_gui_height() - 40, "[E] Interagir");
    draw_set_halign(fa_left);
}