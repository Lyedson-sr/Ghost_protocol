draw_self();

if (instance_exists(obj_player)
    && instance_nearest(obj_player.x, obj_player.y, obj_servidor) == id
    && !global.dialogo_aberto)
{
    var _ponto_x = clamp(obj_player.x, bbox_left, bbox_right);
    var _ponto_y = clamp(obj_player.y, bbox_top, bbox_bottom);

    if (point_distance(obj_player.x, obj_player.y, _ponto_x, _ponto_y) < 48)
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _texto_x = (bbox_left + bbox_right) * 0.5;
        var _texto_y = bbox_top - 8;

        if (_texto_y < 18)
        {
            _texto_y = bbox_bottom + 14;
        }

        draw_set_color(c_black);
        draw_text(_texto_x + 1, _texto_y + 1, "Pressione [E]");
        draw_set_color(make_color_rgb(255, 220, 70));
        draw_text(_texto_x, _texto_y, "Pressione [E]");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }
}
