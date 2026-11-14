var _obj_bloco_notas = asset_get_index("obj_bloco_notas");

if (!variable_global_exists("notas_abertas")) global.notas_abertas = false;
if (!variable_global_exists("anotacoes_jogador")) global.anotacoes_jogador = "";
if (!variable_instance_exists(id, "notas_cursor_pos")) notas_cursor_pos = string_length(global.anotacoes_jogador);

var _hud_gw = display_get_gui_width();
var _hud_gh = display_get_gui_height();
var _hud_margem = 18;

if (!variable_global_exists("hud_escudo_sprite")) global.hud_escudo_sprite = -1;
if (!variable_global_exists("hud_escudo_arquivo")) global.hud_escudo_arquivo = "escudo.png";

if (global.hud_escudo_sprite == -1)
{
    var _p1_hud = working_directory + "datafiles/" + global.hud_escudo_arquivo;
    var _p2_hud = working_directory + "datafiles\\" + global.hud_escudo_arquivo;
    var _p3_hud = working_directory + global.hud_escudo_arquivo;
    var _p4_hud = program_directory + "datafiles/" + global.hud_escudo_arquivo;
    var _p5_hud = program_directory + global.hud_escudo_arquivo;

    if (file_exists(_p1_hud)) global.hud_escudo_sprite = sprite_add(_p1_hud, 1, false, false, 0, 0);
    else if (file_exists(_p2_hud)) global.hud_escudo_sprite = sprite_add(_p2_hud, 1, false, false, 0, 0);
    else if (file_exists(_p3_hud)) global.hud_escudo_sprite = sprite_add(_p3_hud, 1, false, false, 0, 0);
    else if (file_exists(_p4_hud)) global.hud_escudo_sprite = sprite_add(_p4_hud, 1, false, false, 0, 0);
    else if (file_exists(_p5_hud)) global.hud_escudo_sprite = sprite_add(_p5_hud, 1, false, false, 0, 0);
}

var _spr_escudo_hud = -1;
if (variable_global_exists("hud_escudo_sprite")
    && global.hud_escudo_sprite != -1
    && sprite_exists(global.hud_escudo_sprite))
{
    _spr_escudo_hud = global.hud_escudo_sprite;
}
if (_spr_escudo_hud == -1) _spr_escudo_hud = asset_get_index("spr_hud_escudo");
var _usa_sprite_escudo = (_spr_escudo_hud != -1);

var _escudos_total = 5;
var _bloco_w = 36;
var _bloco_h = 16;
var _bloco_gap = 4;
var _escudo_lateral_w = _usa_sprite_escudo ? 30 : 18;
var _ponta_w = 0;
var _hud_larg_total = _escudo_lateral_w + (_bloco_w * _escudos_total) + (_bloco_gap * (_escudos_total - 1)) + _ponta_w;
var _hud_x1 = _hud_gw - _hud_margem - _hud_larg_total;
var _hud_y1 = 12;
var _hud_y2 = _hud_y1 + _bloco_h;

var _fps = game_get_speed(gamespeed_fps);
var _tempo_max = max(1, tempo_limite_sala_seg * _fps);
var _proporcao_tempo = clamp(tempo_restante_sala / _tempo_max, 0, 1);
var _bloco_tempo = _tempo_max / _escudos_total;
var _escudos_ativos = clamp(ceil(tempo_restante_sala / _bloco_tempo), 0, _escudos_total);

var _mostrar_hud_tempo = !(variable_global_exists("game_over_ativo") && global.game_over_ativo)
        && (room == Room1 || room == Room2 || room == Room3 || room == Room4 || room == Room5);
if (_mostrar_hud_tempo)
{
    var _cor_borda = c_black;
    var _cor_ativo = make_color_rgb(103, 157, 208);
    var _cor_inativo = make_color_rgb(28, 28, 32);
    var _cor_base = make_color_rgb(210, 218, 230);

    // Cabeca do escudo (esquerda)
    var _hx1 = _hud_x1;
    var _hx2 = _hx1 + _escudo_lateral_w;
    var _hxm = (_hx1 + _hx2) * 0.5;

    if (_usa_sprite_escudo)
    {
        var _spr_w = max(1, sprite_get_width(_spr_escudo_hud));
        var _spr_h = max(1, sprite_get_height(_spr_escudo_hud));
        var _draw_h = _bloco_h + 18;
        var _draw_w = _escudo_lateral_w;
        var _escala = min(_draw_w / _spr_w, _draw_h / _spr_h);
        var _sx = _escala;
        var _sy = _escala;
        var _cx = _hx1 + _escudo_lateral_w * 0.5;
        var _cy = _hud_y1 + _bloco_h * 0.5 - 16;
    }
    else
    {
        draw_set_color(_cor_base);
        draw_triangle(_hx1, _hud_y1 + 2, _hx2, _hud_y1 + 2, _hxm, _hud_y1 - 8, false);
        draw_rectangle(_hx1 + 2, _hud_y1 + 2, _hx2 - 2, _hud_y2 - 2, false);
        draw_triangle(_hx1 + 2, _hud_y2 - 2, _hx2 - 2, _hud_y2 - 2, _hxm, _hud_y2 + 8, false);

        draw_set_color(_cor_borda);
        draw_triangle(_hx1, _hud_y1 + 2, _hx2, _hud_y1 + 2, _hxm, _hud_y1 - 8, true);
        draw_rectangle(_hx1 + 2, _hud_y1 + 2, _hx2 - 2, _hud_y2 - 2, true);
        draw_triangle(_hx1 + 2, _hud_y2 - 2, _hx2 - 2, _hud_y2 - 2, _hxm, _hud_y2 + 8, true);
    }

    var _inicio_barra = _hx2 + 1;
    for (var _i_esc = 0; _i_esc < _escudos_total; _i_esc++)
    {
        var _x1_esc = _inicio_barra + _i_esc * (_bloco_w + _bloco_gap);
        var _x2_esc = _x1_esc + _bloco_w;
        var _ativo = (_i_esc < _escudos_ativos);

        var _cor_bloco = _ativo ? _cor_ativo : _cor_inativo;
        var _cor_reflexo = _ativo ? make_color_rgb(132, 186, 236) : make_color_rgb(90, 90, 96);

        draw_set_color(_cor_bloco);
        draw_rectangle(_x1_esc, _hud_y1, _x2_esc, _hud_y2, false);

        draw_set_color(_cor_borda);
        draw_rectangle(_x1_esc, _hud_y1, _x2_esc, _hud_y2, true);
        draw_set_color(_cor_reflexo);
        draw_line(_x1_esc + 2, _hud_y1 + 2, _x2_esc - 2, _hud_y1 + 2);
    }

    // Desenha o escudo por cima para nao ficar atras da barra.
    if (_usa_sprite_escudo)
    {
        var _tex_filter_antigo = gpu_get_texfilter();
        gpu_set_texfilter(true);
        draw_sprite_ext(_spr_escudo_hud, 0, _cx, _cy, _sx, _sy, 0, c_white, 1);
        gpu_set_texfilter(_tex_filter_antigo);
    }

    if (_escudos_ativos <= 1)
    {
        draw_set_color(make_color_rgb(235, 85, 85));
        draw_text(_hud_x1, _hud_y2 + 8, "AMEACA CRITICA");
    }
}

if (global.notas_abertas)
{
    var _gw_n = _hud_gw;
    var _gh_n = _hud_gh;
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
    || instance_exists(obj_Caderno_2)
    || instance_exists(obj_Caderno_3)
    || instance_exists(obj_Caderno_4)
    || (_obj_bloco_notas != -1 && instance_exists(_obj_bloco_notas))) exit;

var _texto = "";
var _atendendo = room == Room1
    && (!global.intro_ligacao_vista || global.retorno_final_pendente);

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
