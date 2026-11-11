/// Evento Desenhar GUI - obj_bloco_notas
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _w = min(840, _gw - 80);
var _h = min(520, _gh - 80);

var _x = (_gw - _w) * 0.5;
var _y = (_gh - _h) * 0.5;

var _texto_x = _x + 30;
var _texto_y = _y + 88;
var _texto_w = _w - 60;
var _texto_h = _h - 130;

var _larg_linha = max(80, _texto_w - 16);
var _altura_linha = 20;
var _max_linhas = max(1, floor(_texto_h / _altura_linha));

var _titulo = "BLOCO DE NOTAS";

var _fechar_x = _x + _w - 42;
var _fechar_y = _y + 12;
var _fechar_hover = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _fechar_x, _fechar_y, _fechar_x + 26, _fechar_y + 26);

// Fundo escurecido
draw_set_alpha(0.82);
draw_set_color(cor_fundo_sombra);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// Painel principal
draw_set_color(cor_painel);
draw_rectangle(_x, _y, _x + _w, _y + _h, false);
draw_set_color(cor_painel_borda);
draw_rectangle(_x, _y, _x + _w, _y + _h, true);

// Cabecalho
draw_set_color(make_color_rgb(228, 209, 165));
draw_rectangle(_x, _y, _x + _w, _y + 58, false);
draw_set_color(cor_painel_borda);
draw_line(_x, _y + 58, _x + _w, _y + 58);

draw_set_color(cor_titulo);
draw_text(_x + 18, _y + 18, _titulo);

// Botao fechar
draw_set_color(_fechar_hover ? make_color_rgb(185, 75, 75) : make_color_rgb(145, 58, 58));
draw_rectangle(_fechar_x, _fechar_y, _fechar_x + 26, _fechar_y + 26, false);
draw_set_color(c_white);
draw_line_width(_fechar_x + 7, _fechar_y + 7, _fechar_x + 19, _fechar_y + 19, 2);
draw_line_width(_fechar_x + 19, _fechar_y + 7, _fechar_x + 7, _fechar_y + 19, 2);

// Area de anotacao
draw_set_color(make_color_rgb(247, 241, 222));
draw_rectangle(_texto_x, _texto_y, _texto_x + _texto_w, _texto_y + _texto_h, false);
draw_set_color(cor_linha);
for (var _ln = 1; _ln < _max_linhas; _ln++) {
    var _ly = _texto_y + _ln * _altura_linha;
    draw_line(_texto_x + 8, _ly, _texto_x + _texto_w - 8, _ly);
}
draw_set_color(cor_painel_borda);
draw_rectangle(_texto_x, _texto_y, _texto_x + _texto_w, _texto_y + _texto_h, true);

// Quebra de texto em linhas visuais
var _vis = [];
var _partes = string_split(texto_notas, "\n");
var _cursor_global = cursor_pos;
var _cursor_contagem = 0;
var _cursor_vis_idx = 0;
var _cursor_vis_char = 0;

for (var _p = 0; _p < array_length(_partes); _p++) {
    var _linha = _partes[_p];
    var _atual = "";

    if (string_length(_linha) == 0) {
        array_push(_vis, "");
        if (_cursor_global == _cursor_contagem) {
            _cursor_vis_idx = array_length(_vis) - 1;
            _cursor_vis_char = 0;
        }
        _cursor_contagem += 1;
        continue;
    }

    for (var _c = 1; _c <= string_length(_linha); _c++) {
        var _ch = string_char_at(_linha, _c);
        if (string_width(_atual + _ch) > _larg_linha && _atual != "") {
            array_push(_vis, _atual);
            if (_cursor_global >= _cursor_contagem && _cursor_global <= _cursor_contagem + string_length(_atual)) {
                _cursor_vis_idx = array_length(_vis) - 1;
                _cursor_vis_char = _cursor_global - _cursor_contagem;
            }
            _cursor_contagem += string_length(_atual);
            _atual = _ch;
        } else {
            _atual += _ch;
        }
    }

    array_push(_vis, _atual);
    if (_cursor_global >= _cursor_contagem && _cursor_global <= _cursor_contagem + string_length(_atual)) {
        _cursor_vis_idx = array_length(_vis) - 1;
        _cursor_vis_char = _cursor_global - _cursor_contagem;
    }
    _cursor_contagem += string_length(_atual) + 1;
}

if (array_length(_vis) == 0) {
    array_push(_vis, "");
}

var _inicio = max(0, array_length(_vis) - _max_linhas);
var _fim = min(array_length(_vis), _inicio + _max_linhas);

for (var _i = _inicio; _i < _fim; _i++) {
    var _txt = _vis[_i];
    var _dy = _texto_y + 3 + (_i - _inicio) * _altura_linha;
    draw_set_color(cor_texto);
    draw_text(_texto_x + 10, _dy, _txt);
}

if ((current_time div 500) mod 2 == 0) {
    if (_cursor_vis_idx >= _inicio && _cursor_vis_idx < _fim) {
        var _linha_cursor = _vis[_cursor_vis_idx];
        var _cx = _texto_x + 10 + string_width(string_copy(_linha_cursor, 1, _cursor_vis_char));
        var _cy = _texto_y + 4 + (_cursor_vis_idx - _inicio) * _altura_linha;
        draw_set_color(cor_destaque);
        draw_line_width(_cx, _cy, _cx, _cy + _altura_linha - 6, 2);
    }
}

draw_set_color(cor_titulo);
draw_text(_x + 18, _y + _h - 30, "[N] ou [ESC] para fechar | No terminal, digite: notas");
