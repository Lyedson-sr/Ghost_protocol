var _obj_bloco_notas = asset_get_index("obj_bloco_notas");

if (!variable_global_exists("notas_abertas")) global.notas_abertas = false;
if (!variable_global_exists("anotacoes_jogador")) global.anotacoes_jogador = "";
if (!variable_instance_exists(id, "notas_cursor_pos")) notas_cursor_pos = string_length(global.anotacoes_jogador);

if (global.notas_abertas)
{
    var _gw_n = display_get_gui_width();
    var _gh_n = display_get_gui_height();
    var _w_n = min(840, _gw_n - 80);
    var _h_n = min(520, _gh_n - 80);
    var _x_n = (_gw_n - _w_n) * 0.5;
    var _y_n = (_gh_n - _h_n) * 0.5;

    var _tx = _x_n + 30;
    var _ty = _y_n + 88;
    var _tw = _w_n - 60;
    var _th = _h_n - 130;

    var _line_h = 20;
    var _max_linhas = max(1, floor(_th / _line_h));
    var _larg_linha = max(80, _tw - 16);

    draw_set_alpha(0.82);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw_n, _gh_n, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(245, 237, 210));
    draw_rectangle(_x_n, _y_n, _x_n + _w_n, _y_n + _h_n, false);
    draw_set_color(make_color_rgb(108, 76, 45));
    draw_rectangle(_x_n, _y_n, _x_n + _w_n, _y_n + _h_n, true);

    draw_set_color(make_color_rgb(228, 209, 165));
    draw_rectangle(_x_n, _y_n, _x_n + _w_n, _y_n + 58, false);
    draw_set_color(make_color_rgb(108, 76, 45));
    draw_line(_x_n, _y_n + 58, _x_n + _w_n, _y_n + 58);
    draw_text(_x_n + 18, _y_n + 18, "BLOCO DE NOTAS");

    draw_set_color(make_color_rgb(247, 241, 222));
    draw_rectangle(_tx, _ty, _tx + _tw, _ty + _th, false);
    draw_set_color(make_color_rgb(190, 170, 135));
    for (var _ln = 1; _ln < _max_linhas; _ln++)
    {
        var _ly = _ty + _ln * _line_h;
        draw_line(_tx + 8, _ly, _tx + _tw - 8, _ly);
    }
    draw_set_color(make_color_rgb(108, 76, 45));
    draw_rectangle(_tx, _ty, _tx + _tw, _ty + _th, true);

    var _vis = [];
    var _partes = string_split(global.anotacoes_jogador, "\n");
    var _cursor_global = notas_cursor_pos;
    var _cursor_contagem = 0;
    var _cursor_vis_idx = 0;
    var _cursor_vis_char = 0;

    for (var _p = 0; _p < array_length(_partes); _p++)
    {
        var _linha = _partes[_p];
        var _atual = "";

        if (string_length(_linha) == 0)
        {
            array_push(_vis, "");
            if (_cursor_global == _cursor_contagem)
            {
                _cursor_vis_idx = array_length(_vis) - 1;
                _cursor_vis_char = 0;
            }
            _cursor_contagem += 1;
            continue;
        }

        for (var _c = 1; _c <= string_length(_linha); _c++)
        {
            var _ch = string_char_at(_linha, _c);
            if (string_width(_atual + _ch) > _larg_linha && _atual != "")
            {
                array_push(_vis, _atual);
                if (_cursor_global >= _cursor_contagem && _cursor_global <= _cursor_contagem + string_length(_atual))
                {
                    _cursor_vis_idx = array_length(_vis) - 1;
                    _cursor_vis_char = _cursor_global - _cursor_contagem;
                }
                _cursor_contagem += string_length(_atual);
                _atual = _ch;
            }
            else
            {
                _atual += _ch;
            }
        }

        array_push(_vis, _atual);
        if (_cursor_global >= _cursor_contagem && _cursor_global <= _cursor_contagem + string_length(_atual))
        {
            _cursor_vis_idx = array_length(_vis) - 1;
            _cursor_vis_char = _cursor_global - _cursor_contagem;
        }
        _cursor_contagem += string_length(_atual) + 1;
    }

    if (array_length(_vis) == 0)
    {
        array_push(_vis, "");
    }

    var _ini = max(0, array_length(_vis) - _max_linhas);
    var _fim = min(array_length(_vis), _ini + _max_linhas);

    draw_set_color(make_color_rgb(34, 29, 21));
    for (var _i = _ini; _i < _fim; _i++)
    {
        draw_text(_tx + 10, _ty + 3 + (_i - _ini) * _line_h, _vis[_i]);
    }

    if ((current_time div 500) mod 2 == 0)
    {
        if (_cursor_vis_idx >= _ini && _cursor_vis_idx < _fim)
        {
            var _linha_cursor = _vis[_cursor_vis_idx];
            var _cx = _tx + 10 + string_width(string_copy(_linha_cursor, 1, _cursor_vis_char));
            var _cy = _ty + 4 + (_cursor_vis_idx - _ini) * _line_h;
            draw_set_color(make_color_rgb(120, 90, 58));
            draw_line_width(_cx, _cy, _cx, _cy + _line_h - 6, 2);
        }
    }

    draw_set_color(make_color_rgb(56, 42, 24));
    draw_text(_x_n + 18, _y_n + _h_n - 30, "[N] ou [B] abre | [ESC] fecha");
    draw_set_color(c_white);
    exit;
}

if (global.dialogo_aberto
    || instance_exists(obj_Terminal)
    || instance_exists(obj_Caderno)
    || instance_exists(obj_Caderno_1)
    || (_obj_bloco_notas != -1 && instance_exists(_obj_bloco_notas))) exit;

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
