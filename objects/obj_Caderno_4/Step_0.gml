/// Evento Etapa - caderno da fase 5

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _w = min(820, _gw - 40);
var _h = min(500, _gh - 40);
var _x = (_gw - _w) / 2;
var _y = (_gh - _h) / 2;
var _tab_y = _y + 20;
var _tab_h = 54;
var _tab_gap = 8;
var _tab_margin = 28;
var _tab_w = (_w - 2 * _tab_margin - 2 * _tab_gap) / 3;
var _page_x = _x + 28;
var _page_y = _y + 88;
var _page_w = (_w - 56) / 2;
var _page_h = _h - 108;
var _right_x = _page_x + _page_w + 4;

if (keyboard_check_pressed(vk_escape))
{
    instance_destroy();
    exit;
}

if (mouse_check_button_pressed(mb_left))
{
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    for (var i = 0; i < 3; i++)
    {
        var _tx = _x + _tab_margin + i * (_tab_w + _tab_gap);
        if (point_in_rectangle(_mx, _my, _tx, _tab_y, _tx + _tab_w, _tab_y + _tab_h))
        {
            aba_atual = i;
        }
    }

    if (aba_atual == 0)
    {
        for (var j = 0; j < array_length(evidencias); j++)
        {
            var _cx = _page_x + 30;
            var _cy = _page_y + 86 + j * 48;
            if (point_in_rectangle(_mx, _my, _cx, _cy, _cx + 28, _cy + 28))
            {
                evidencias[j] = !evidencias[j];
                global.incidente_005_confirmado = false;
            }
        }

        var _bx = _right_x + 24;
        var _by = _page_y + _page_h - 82;
        var _bw = _page_w - 48;
        if (point_in_rectangle(_mx, _my, _bx, _by, _bx + _bw, _by + 46)
            && global.incidente_005_concluido
            && evidencias[0] && evidencias[1])
        {
            global.incidente_005_confirmado = true;

            if (!global.mensagem_final_exibida)
            {
                var _dialogo = instance_find(obj_dialogo, 0);
                if (_dialogo == noone) _dialogo = instance_create_depth(0, 0, -10000, obj_dialogo);
                var _mensagem = {
                    tipo: "mensagem",
                    titulo: "Conclusao",
                    linhas: [
                        "Parabens. Voce concluiu o ultimo desafio.",
                        "Durante anos, construi esta empresa, enfrentei invasoes, desenvolvi sistemas e protegi aquilo que conquistei.",
                        "Mas chegou o momento de repassar esta empresa a voce. Meu tempo neste plano acabou, mas meu legado continua..."
                    ]
                };
                _dialogo.abrir(_mensagem);
                global.mensagem_final_exibida = true;
            }
        }
    }
}
