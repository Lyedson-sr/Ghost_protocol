draw_self();

// Verifica se o jogador existe na sala antes de calcular a distância
if (instance_exists(obj_player)) 
{
    // Se o jogador estiver a menos de 50 pixels, mostra o aviso centralizado em cima
    if (point_distance(x, y, obj_player.x, obj_player.y) < 50
        && !global.dialogo_aberto)
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _texto_y = bbox_top - 8;
        draw_set_color(c_black);
        draw_text(x + 1, _texto_y + 1, "Pressione [E]");
        draw_set_color(make_color_rgb(255, 220, 70));
        draw_text(x, _texto_y, "Pressione [E]");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}