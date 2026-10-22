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
        var _texto_largura = string_width("Pressione [E]");
        var _texto_x = clamp(
            x,
            _texto_largura * 0.5 + 4,
            room_width - _texto_largura * 0.5 - 4
        );
        draw_set_color(c_black);
        draw_text(_texto_x + 1, _texto_y + 1, "Pressione [E]");
        draw_set_color(make_color_rgb(255, 220, 70));
        draw_text(_texto_x, _texto_y, "Pressione [E]");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}