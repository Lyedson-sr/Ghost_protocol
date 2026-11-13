if (global.dialogo_aberto
    || instance_exists(obj_Terminal)
    || instance_exists(obj_Caderno)
    || instance_exists(obj_Caderno_1)
    || instance_exists(obj_Caderno_2)) exit;

var _texto = "";
var _atendendo = room == Room1 && !global.intro_ligacao_vista;

if (_atendendo)
{
    if (intro_ligacao_estado != 1) exit;
    _texto = "Pressione [E] para atender";
}
else
{
    var _notebook = instance_nearest(x, y, obj_notebook);
    if (_notebook != noone
        && point_distance(x, y, _notebook.x, _notebook.y) < 50)
    {
        _texto = "[E] Acessar: Terminal";
    }
    else if (instance_exists(alvo))
    {
        var _nome = is_undefined(alvo_descricao) ? alvo.titulo : alvo_descricao.titulo;
        _texto = "[E] Examinar: " + _nome;
    }
    else exit;
}

var _gw = display_get_gui_width();
var _fonte_anterior = draw_get_font();
draw_set_font(fonte_interacao);
var _texto_x = round(_gw * 0.5);
var _texto_y = round(_atendendo ? 56 : display_get_gui_height() - 40);
var _escala = min(1, (_gw - 32) / max(1, string_width(_texto)));

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(_texto_x - 1, _texto_y, _texto, _escala, _escala, 0);
draw_text_transformed(_texto_x + 1, _texto_y, _texto, _escala, _escala, 0);
draw_text_transformed(_texto_x, _texto_y - 1, _texto, _escala, _escala, 0);
draw_text_transformed(_texto_x, _texto_y + 1, _texto, _escala, _escala, 0);
draw_set_color(make_color_rgb(255, 220, 70));
draw_text_transformed(_texto_x, _texto_y, _texto, _escala, _escala, 0);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_font(_fonte_anterior);
