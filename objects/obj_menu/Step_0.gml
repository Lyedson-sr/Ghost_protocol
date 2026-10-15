
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _total_botoes = array_length(botoes);

var _bloco_altura = (_total_botoes * botao_altura)
    + ((_total_botoes - 1) * botao_espaco);

var _x1 = (_gui_w - botao_largura) * 0.5;
var _y1 = (_gui_h - _bloco_altura) * 0.5;

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);


if (mostrar_controles)
{
    var _voltar_largura = 220;
    var _voltar_altura = 52;

    var _voltar_x1 = (_gui_w - _voltar_largura) * 0.5;
    var _voltar_y1 = _gui_h - 110;
    var _voltar_x2 = _voltar_x1 + _voltar_largura;
    var _voltar_y2 = _voltar_y1 + _voltar_altura;

    hover_voltar =
        _mouse_x >= _voltar_x1
        && _mouse_x <= _voltar_x2
        && _mouse_y >= _voltar_y1
        && _mouse_y <= _voltar_y2;

    if (keyboard_check_pressed(vk_escape)
        || (mouse_check_button_pressed(mb_left) && hover_voltar))
    {
        mostrar_controles = false;
    }

    hover_indice = -1;
    exit;
}

hover_indice = -1;
hover_voltar = false;

for (var i = 0; i < _total_botoes; i++)
{
    var _topo = _y1 + i * (botao_altura + botao_espaco);

    var _dentro =
        _mouse_x >= _x1
        && _mouse_x <= _x1 + botao_largura
        && _mouse_y >= _topo
        && _mouse_y <= _topo + botao_altura;

    if (_dentro)
    {
        hover_indice = i;
        break;
    }
}

if (mouse_check_button_pressed(mb_left) && hover_indice != -1)
{
    switch (hover_indice)
    {
        case 0:
            room_goto(Room1);
            break;

        case 1:
            mostrar_controles = true;
            break;

        case 2:
            game_end();
            break;
    }
}
