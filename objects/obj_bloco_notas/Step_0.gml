/// Evento Etapa - obj_bloco_notas
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _w = min(840, _gw - 80);
var _h = min(520, _gh - 80);

var _x = (_gw - _w) * 0.5;
var _y = (_gh - _h) * 0.5;

var _close_x1 = _x + _w - 42;
var _close_y1 = _y + 12;
var _close_x2 = _close_x1 + 26;
var _close_y2 = _close_y1 + 26;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

if (keyboard_check_pressed(vk_escape)) {
    fechar_bloco();
    exit;
}

if (mouse_check_button_pressed(mb_left)
    && point_in_rectangle(_mx, _my, _close_x1, _close_y1, _close_x2, _close_y2)) {
    fechar_bloco();
    exit;
}

if (keyboard_string != "") {
    var _novo = keyboard_string;
    var _antes = string_copy(texto_notas, 1, cursor_pos);
    var _depois = string_copy(texto_notas, cursor_pos + 1, string_length(texto_notas) - cursor_pos);
    texto_notas = _antes + _novo + _depois;
    cursor_pos += string_length(_novo);
    keyboard_string = "";
}

if (keyboard_check_pressed(vk_enter)) {
    var _antes_enter = string_copy(texto_notas, 1, cursor_pos);
    var _depois_enter = string_copy(texto_notas, cursor_pos + 1, string_length(texto_notas) - cursor_pos);
    texto_notas = _antes_enter + "\n" + _depois_enter;
    cursor_pos += 1;
}

if (keyboard_check_pressed(vk_left)) cursor_pos = max(0, cursor_pos - 1);
if (keyboard_check_pressed(vk_right)) cursor_pos = min(string_length(texto_notas), cursor_pos + 1);
if (keyboard_check_pressed(vk_home)) cursor_pos = 0;
if (keyboard_check_pressed(vk_end)) cursor_pos = string_length(texto_notas);

if (keyboard_check_pressed(vk_backspace) && cursor_pos > 0) {
    texto_notas = string_delete(texto_notas, cursor_pos, 1);
    cursor_pos -= 1;
}

if (keyboard_check_pressed(vk_delete) && cursor_pos < string_length(texto_notas)) {
    texto_notas = string_delete(texto_notas, cursor_pos + 1, 1);
}

if (string_length(texto_notas) > limite_caracteres) {
    texto_notas = string_copy(texto_notas, 1, limite_caracteres);
    cursor_pos = min(cursor_pos, limite_caracteres);
}

global.anotacoes_jogador = texto_notas;
