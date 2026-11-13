var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _total_botoes = array_length(botoes);

var _bloco_altura = (_total_botoes * botao_altura)
    + ((_total_botoes - 1) * botao_espaco);

var _x1 = (_gui_w - botao_largura) * 0.5;
var _y1 = (_gui_h - _bloco_altura) * 0.5;

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

if (!variable_global_exists("reset_total_pendente"))
{
    global.reset_total_pendente = false;
}

if (variable_global_exists("game_over_ativo") && global.game_over_ativo)
{
    var _btn_w_go = 300;
    var _btn_h_go = 62;
    var _btn_x1_go = (_gui_w - _btn_w_go) * 0.5;
    var _btn_y1_go = _gui_h * 0.62;
    var _btn_x2_go = _btn_x1_go + _btn_w_go;
    var _btn_y2_go = _btn_y1_go + _btn_h_go;

    hover_indice = -1;
    hover_voltar =
        _mouse_x >= _btn_x1_go
        && _mouse_x <= _btn_x2_go
        && _mouse_y >= _btn_y1_go
        && _mouse_y <= _btn_y2_go;
    hover_volume_menos = false;
    hover_volume_mais = false;

    if (keyboard_check_pressed(vk_enter)
        || (mouse_check_button_pressed(mb_left) && hover_voltar))
    {
        global.game_over_ativo = false;
        global.game_over_msg = "";
        global.reset_total_pendente = true;
        global.jogo_pausado = false;
        global.sala_retorno_pausa = Room1;
        global.forcar_reset_timer = true;
    }

    exit;
}

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
    hover_volume_menos = false;
    hover_volume_mais = false;
    exit;
}

if (mostrar_configuracoes)
{
    var _painel_w = min(760, _gui_w - 120);
    var _painel_h = min(430, _gui_h - 120);

    var _px1 = (_gui_w - _painel_w) * 0.5;
    var _py1 = (_gui_h - _painel_h) * 0.5;

    var _vol_w = 64;
    var _vol_h = 44;
    var _vol_gap = 16;
    var _vol_y = _py1 + 188;

    var _menos_x1 = _px1 + 56;
    var _menos_x2 = _menos_x1 + _vol_w;

    var _mais_x2 = _px1 + _painel_w - 56;
    var _mais_x1 = _mais_x2 - _vol_w;

    hover_volume_menos =
        _mouse_x >= _menos_x1
        && _mouse_x <= _menos_x2
        && _mouse_y >= _vol_y
        && _mouse_y <= _vol_y + _vol_h;

    hover_volume_mais =
        _mouse_x >= _mais_x1
        && _mouse_x <= _mais_x2
        && _mouse_y >= _vol_y
        && _mouse_y <= _vol_y + _vol_h;

    var _voltar_largura_cfg = 220;
    var _voltar_altura_cfg = 52;

    var _voltar_x1_cfg = (_gui_w - _voltar_largura_cfg) * 0.5;
    var _voltar_y1_cfg = _gui_h - 110;
    var _voltar_x2_cfg = _voltar_x1_cfg + _voltar_largura_cfg;
    var _voltar_y2_cfg = _voltar_y1_cfg + _voltar_altura_cfg;

    hover_voltar =
        _mouse_x >= _voltar_x1_cfg
        && _mouse_x <= _voltar_x2_cfg
        && _mouse_y >= _voltar_y1_cfg
        && _mouse_y <= _voltar_y2_cfg;

    if (keyboard_check_pressed(vk_escape)
        || (mouse_check_button_pressed(mb_left) && hover_voltar))
    {
        mostrar_configuracoes = false;
        exit;
    }

    if (mouse_check_button_pressed(mb_left))
    {
        if (hover_volume_menos)
        {
            global.volume_master = clamp(
                global.volume_master - volume_passo,
                0,
                1
            );

            audio_master_gain(global.volume_master);
        }
        else if (hover_volume_mais)
        {
            global.volume_master = clamp(
                global.volume_master + volume_passo,
                0,
                1
            );

            audio_master_gain(global.volume_master);
        }
    }

    hover_indice = -1;
    exit;
}

hover_indice = -1;
hover_voltar = false;
hover_volume_menos = false;
hover_volume_mais = false;

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
            audio_stop_sound(snd_menu);
            global.game_over_ativo = false;
            global.game_over_msg = "";

            if (global.reset_total_pendente)
            {
                // Reset global de progresso para recomecar do zero.
                global.incidente_001_concluido = false;
                global.incidente_001_confirmado = false;
                global.incidente_002_concluido = false;
                global.incidente_002_confirmado = false;
                global.incidente_003_concluido = false;
                global.incidente_004_concluido = false;
                global.incidente_005_concluido = false;
                global.incidente_005_confirmado = false;

                global.incidente_002_pc1_ok = false;
                global.incidente_002_pc2_ok = false;
                global.incidente_002_pc3_ok = false;

                global.incidente_atual = 1;
                global.intro_ligacao_vista = false;
                global.dialogo_aberto = false;
                global.nivel_ameaca_seguranca = 0;

                global.anotacoes_jogador = "";
                global.notas_abertas = false;

                global.jogo_pausado = false;
                global.sala_retorno_pausa = Room1;
                global.forcar_reset_timer = true;

                if (variable_global_exists("sirene_ultimo_min_sound") && global.sirene_ultimo_min_sound != -1)
                {
                    audio_stop_sound(global.sirene_ultimo_min_sound);
                }

                if (instance_exists(obj_player))
                {
                    with (obj_player)
                    {
                        aviso_1min_emitido = false;
                        aviso_1min_pendente = false;
                        sirene_1min_liberada = false;
                        sirene_1min_tocando = false;
                        sirene_1min_instancia = -1;
                        sirene_1min_usando_fallback = false;
                        game_over_disparado = false;
                        intro_ligacao_estado = 0;
                        intro_fala_tocando = false;
                    }
                }

                if (instance_exists(obj_dialogo))
                {
                    with (obj_dialogo)
                    {
                        instance_destroy();
                    }
                }

                global.reset_total_pendente = false;
                room_goto(Room1);
            }
            else if (variable_global_exists("jogo_pausado") && global.jogo_pausado)
            {
                var _sala_retorno = variable_global_exists("sala_retorno_pausa") ? global.sala_retorno_pausa : Room1;
                global.jogo_pausado = false;
                room_goto(_sala_retorno);
            }
            else
            {
                global.forcar_reset_timer = true;
                room_goto(Room1);
            }
            break;

        case 1:
            mostrar_controles = true;
            break;

        case 2:
            mostrar_configuracoes = true;
            break;

        case 3:
            audio_stop_sound(snd_menu);
            game_end();
            break;
    }
}
