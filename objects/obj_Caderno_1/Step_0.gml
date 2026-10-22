
/// Evento Etapa - obj_Caderno

// Dimensoes da interface
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _w = min(820, _gw - 40);
var _h = min(500, _gh - 40);

var _x = (_gw - _w) / 2;
var _y = (_gh - _h) / 2;

// Abas
var _tab_y = _y + 20;
var _tab_h = 54;
var _tab_gap = 8;
var _tab_margin = 28;
var _tab_w = (_w - 2 * _tab_margin - 2 * _tab_gap) / 3;

// Paginas
var _page_x = _x + 28;
var _page_y = _y + 88;
var _page_w = (_w - 56) / 2;
var _page_h = _h - 108;

var _right_x = _page_x + _page_w + 4;

// Mouse na GUI
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Fechar com ESC
if (keyboard_check_pressed(vk_escape))
{
    instance_destroy();
    exit;
}

// Detectar cliques
if (mouse_check_button_pressed(mb_left))
{
    ameaca_confirmada = global.incidente_002_confirmado;

    // Selecionar uma das tres abas
    for (var i = 0; i < 3; i++)
    {
        var _tx = _x + _tab_margin
            + i * (_tab_w + _tab_gap);

        if (_mx >= _tx && _mx <= _tx + _tab_w
            && _my >= _tab_y && _my <= _tab_y + _tab_h)
        {
            aba_atual = i;
        }
    }

    // Interacoes da aba Evidencias
    if (aba_atual == 0)
    {
        // Marcar ou desmarcar evidencias
        for (var i = 0; i < array_length(evidencias); i++)
        {
            var _cx = _page_x + 30;
            var _cy = _page_y + 86 + i * 48;

            if (_mx >= _cx && _mx <= _cx + 28
                && _my >= _cy && _my <= _cy + 28)
            {
                evidencias[i] = !evidencias[i];
                ameaca_confirmada = false;
                global.incidente_002_confirmado = false;
            }
        }

        // Botao Confirmar Ameaca
        var _bx = _right_x + 24;
        var _by = _page_y + _page_h - 82;
        var _bw = _page_w - 48;
        var _bh = 46;

        if (_mx >= _bx && _mx <= _bx + _bw
            && _my >= _by && _my <= _by + _bh)
        {
            var _todas_selecionadas = true;
            for (var i = 0; i < array_length(evidencias); i++)
            {
                if (!evidencias[i])
                {
                    _todas_selecionadas = false;
                }
            }

            if (global.incidente_002_concluido && _todas_selecionadas)
            {
                ameaca_confirmada = true;
                global.incidente_002_confirmado = true;
                finalizado = true;
            }
        }
    }
}
