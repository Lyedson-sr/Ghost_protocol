
/// Evento Etapa (Step) - obj_player

// Voltar ao menu com ESC
if (keyboard_check_pressed(vk_escape))
{
    // Enquanto um dialogo estiver aberto, o ESC nao abre o menu.
    if (global.dialogo_aberto)
    {
        exit;
    }

    // Fechar interfaces antes de trocar de sala
    if (instance_exists(obj_Terminal))
    {
        with (obj_Terminal)
        {
            instance_destroy();
        }
        exit;
    }

    if (instance_exists(obj_Caderno)
        || instance_exists(obj_Caderno_1)
        || instance_exists(obj_Caderno_2)
        || instance_exists(obj_Caderno_3)
        || instance_exists(obj_Caderno_4))
    {
        with (obj_Caderno)
        {
            instance_destroy();
        }
        with (obj_Caderno_1)
        {
            instance_destroy();
        }
        with (obj_Caderno_2)
        {
            instance_destroy();
        }
        with (obj_Caderno_3)
        {
            instance_destroy();
        }
        with (obj_Caderno_4)
        {
            instance_destroy();
        }
        exit;
    }

    room_goto(Room_Menu);
    exit;
}

// Mantem a escala do player estavel mesmo em estados com retorno antecipado.
image_xscale = player_scale;
image_yscale = player_scale;

// Intro inicial da Room1: telefone toca e o jogador atende com E.
if (room == Room1
    && (!global.intro_ligacao_vista || global.retorno_final_pendente)
    && !global.dialogo_aberto
    && !instance_exists(obj_Terminal)
    && !instance_exists(obj_Caderno)
    && !instance_exists(obj_Caderno_1))
{
    if (intro_ligacao_estado == 0)
    {
        intro_ligacao_estado = 1;
        if (!audio_is_playing(snd_phone_ring))
        {
            audio_play_sound(snd_phone_ring, 10, true);
        }
    }

    if (intro_ligacao_estado == 1)
    {
        if (keyboard_check_pressed(ord("E")))
        {
            audio_stop_sound(snd_phone_ring);

            var _dialogo_intro = instance_find(obj_dialogo, 0);

            if (_dialogo_intro == noone)
            {
                _dialogo_intro = instance_create_depth(0, 0, -10000, obj_dialogo);
            }

            var _ligacao = instance_create_depth(x, y, -10001, obj_interactive);
            _ligacao.tipo = "mensagem";
            _ligacao.titulo = "Telefone - Central";
            if (global.incidente_005_confirmado)
            {
                _ligacao.linhas = [
                    "Durante anos, construi esta empresa, enfrentei invasoes, desenvolvi sistemas e protegi aquilo que conquistei.",
                    "Mas chegou o momento de repassar esta empresa a voce.",
                    "Meu tempo neste plano acabou, mas meu legado continua..."
                ];
            }
            else
            {
                _ligacao.linhas = [
                    "Alerta da Central de Seguranca.",
                    "Sua tarefa e identificar e neutralizar as ameacas de seguranca do predio.",
                    "Investigue cada sala e elimine os riscos para liberar as saidas.",
                    "Para encontrar pistas, interaja com os objetos da sala usando a tecla E.",
                    "Pressione C para abrir o caderno com informacoes importantes da operacao."
                ];
            }

            _dialogo_intro.abrir(_ligacao);
            with (_ligacao) instance_destroy();

            audio_play_sound(snd_phone_talking, 11, false);
            intro_fala_tocando = true;
            intro_ligacao_estado = 2;
            global.intro_ligacao_vista = true;
            global.retorno_final_pendente = false;
            exit;
        }

        // Durante o toque, aguarda o atendimento e trava outras acoes.
        exit;
    }
}

if (intro_fala_tocando && !global.dialogo_aberto)
{
    if (audio_is_playing(snd_phone_talking))
    {
        audio_stop_sound(snd_phone_talking);
    }
    intro_fala_tocando = false;
}

// Verificar se alguma interface esta aberta
var _interface_aberta =
    instance_exists(obj_Terminal)
    || instance_exists(obj_Caderno)
    || instance_exists(obj_Caderno_1)
    || instance_exists(obj_Caderno_2)
    || instance_exists(obj_Caderno_3)
    || instance_exists(obj_Caderno_4);

// Abrir/fechar o caderno com C (toggle), se o terminal nao estiver aberto
if (!instance_exists(obj_Terminal)
    && keyboard_check_pressed(ord("C")))
{
    if (instance_exists(obj_Caderno)
        || instance_exists(obj_Caderno_1)
        || instance_exists(obj_Caderno_2)
        || instance_exists(obj_Caderno_3)
        || instance_exists(obj_Caderno_4))
    {
        with (obj_Caderno)
        {
            instance_destroy();
        }
        with (obj_Caderno_1)
        {
            instance_destroy();
        }
        with (obj_Caderno_2)
        {
            instance_destroy();
        }
        with (obj_Caderno_3)
        {
            instance_destroy();
        }
        with (obj_Caderno_4)
        {
            instance_destroy();
        }
    }
    else
    {
        if (room == Room2)
        {
            instance_create_depth(0, 0, -10000, obj_Caderno_1);
        }
        else if (room == Room3)
        {
            instance_create_depth(0, 0, -10000, obj_Caderno_2);
        }
        else if (room == Room4)
        {
            instance_create_depth(0, 0, -10000, obj_Caderno_3);
        }
        else if (room == Room5)
        {
            instance_create_depth(0, 0, -10000, obj_Caderno_4);
        }
        else
        {
            instance_create_depth(0, 0, -10000, obj_Caderno);
        }
    }
}

if (global.mensagem_final_pendente
    && !global.mensagem_final_exibida
    && !instance_exists(obj_Caderno_4))
{
    var _dialogo_final = instance_find(obj_dialogo, 0);
    if (_dialogo_final == noone) _dialogo_final = instance_create_depth(0, 0, -10000, obj_dialogo);
    var _mensagem_final = {
        tipo: "mensagem",
        titulo: "Conclusao",
        linhas: [
            "Parabens. Voce concluiu o ultimo desafio.",
            "Durante anos, construi esta empresa, enfrentei invasoes, desenvolvi sistemas e protegi aquilo que conquistei.",
            "Mas chegou o momento de repassar esta empresa a voce. Meu tempo neste plano acabou, mas meu legado continua..."
        ]
    };
    _dialogo_final.abrir(_mensagem_final);
    global.mensagem_final_exibida = true;
    global.mensagem_final_pendente = false;
}

// Teclas de movimentacao
var _dir = 0;
var _esq = 0;
var _baixo = 0;
var _cima = 0;
var _x_ant = x;
var _y_ant = y;
var _lado_ant = lado;

if (global.dialogo_aberto) exit;   // trava o movimento enquanto a janela está aberta

alvo = collision_circle(x, y, 36, obj_interactive, false, true);

var _servidor = instance_nearest(x, y, obj_servidor);
if (_servidor != noone)
{
    var _ponto_x = clamp(x, _servidor.bbox_left, _servidor.bbox_right);
    var _ponto_y = clamp(y, _servidor.bbox_top, _servidor.bbox_bottom);

    if (point_distance(x, y, _ponto_x, _ponto_y) < 48)
    {
        alvo = _servidor;
    }
}

// Armarios sao interativos mesmo sem usar obj_interactive.
if (alvo == noone)
{
    var _armario_aberto = instance_nearest(x, y, obj_estante_aberto);
    var _armario_fechado = instance_nearest(x, y, obj_estante_fechado);
    var _armario = noone;
    var _dist_armario = 72;

    if (_armario_aberto != noone)
    {
        var _ponto_aberto_x = clamp(x, _armario_aberto.bbox_left, _armario_aberto.bbox_right);
        var _ponto_aberto_y = clamp(y, _armario_aberto.bbox_top, _armario_aberto.bbox_bottom);
        var _dist_aberto = point_distance(x, y, _ponto_aberto_x, _ponto_aberto_y);
        if (_dist_aberto < _dist_armario)
        {
            _armario = _armario_aberto;
            _dist_armario = _dist_aberto;
        }
    }

    if (_armario_fechado != noone)
    {
        var _ponto_fechado_x = clamp(x, _armario_fechado.bbox_left, _armario_fechado.bbox_right);
        var _ponto_fechado_y = clamp(y, _armario_fechado.bbox_top, _armario_fechado.bbox_bottom);
        var _dist_fechado = point_distance(x, y, _ponto_fechado_x, _ponto_fechado_y);
        if (_dist_fechado < _dist_armario)
        {
            _armario = _armario_fechado;
        }
    }

    if (_armario != noone)
    {
        alvo = _armario;
    }
}

// Pistas existentes e o notebook mantem prioridade sobre as descricoes do cenario.
alvo_descricao = undefined;
var _notebook = instance_nearest(x, y, obj_notebook);
var _perto_notebook = _notebook != noone
    && point_distance(x, y, _notebook.x, _notebook.y) < 50;

if (alvo == noone && !_interface_aberta && !_perto_notebook)
{
    var _menor_distancia = 40;
    for (var _i = 0; _i < array_length(descricoes_objetos); _i++)
    {
        var _descricao = descricoes_objetos[_i];
        var _quantidade = instance_number(_descricao.objeto);
        for (var _j = 0; _j < _quantidade; _j++)
        {
            var _objeto = instance_find(_descricao.objeto, _j);
            var _px = clamp(x, _objeto.bbox_left, _objeto.bbox_right);
            var _py = clamp(y, _objeto.bbox_top, _objeto.bbox_bottom);
            var _distancia = point_distance(x, y, _px, _py);
            if (_distancia < _menor_distancia)
            {
                _menor_distancia = _distancia;
                alvo = _objeto;
                alvo_descricao = _descricao;
            }
        }
    }
}

// Na Room 4, o quadro apresenta a pista da autenticacao.
if (room == Room4)
{
    var _quadro = instance_nearest(x, y, obj_quadro);
    if (_quadro != noone)
    {
        var _quadro_x = clamp(x, _quadro.bbox_left, _quadro.bbox_right);
        var _quadro_y = clamp(y, _quadro.bbox_top, _quadro.bbox_bottom);
        if (point_distance(x, y, _quadro_x, _quadro_y) < 40)
        {
            alvo = _quadro;
            alvo_descricao = {
                tipo: "mensagem",
                titulo: "Quadro de avisos",
                linhas: ["-d \"user=' or '1'='1\" -d \"pass=\""]
            };
        }
    }
}

if (alvo != noone && !_interface_aberta && keyboard_check_pressed(ord("E"))) {
    var _dialogo = instance_find(obj_dialogo, 0);

    if (_dialogo == noone)
    {
        _dialogo = instance_create_depth(0, 0, -10000, obj_dialogo);
    }

    if (is_undefined(alvo_descricao))
    {
        _dialogo.abrir(alvo);
    }
    else
    {
        _dialogo.abrir(alvo_descricao);
    }
}

// Travar movimento enquanto uma interface estiver aberta
if (!_interface_aberta)
{
    _dir = keyboard_check(ord("D"));
    _esq = keyboard_check(ord("A"));
    _baixo = keyboard_check(ord("S"));
    _cima = keyboard_check(ord("W"));

    // Memoriza a ultima tecla de direcao apertada para usar no idle.
    if (keyboard_check_pressed(ord("D"))) ultimo_lado_input = 2;
    if (keyboard_check_pressed(ord("A"))) ultimo_lado_input = 3;
    if (keyboard_check_pressed(ord("S"))) ultimo_lado_input = 0;
    if (keyboard_check_pressed(ord("W"))) ultimo_lado_input = 1;
}

// Calcular velocidade
velh = (_dir - _esq) * vel;
velv = (_baixo - _cima) * vel;

// A mascara personalizada ja remove a cabeca da colisao.
var _offset_colisao_y = 0;
var _porta_liberada = false;
if (room == Room1)
{
    _porta_liberada = global.incidente_001_confirmado;
}
else if (room == Room2)
{
    _porta_liberada = global.incidente_002_confirmado;
}
else if (room == Room3)
{
    _porta_liberada = global.incidente_003_confirmado;
}
else if (room == Room4)
{
    _porta_liberada = global.incidente_004_confirmado;
}
else if (room == Room5)
{
    _porta_liberada = global.incidente_005_confirmado;
}

// Colisao horizontal
if (place_meeting(x + velh, y + _offset_colisao_y, obj_Colisao_Pai))
{
    while (velh != 0
        && !place_meeting(x + sign(velh), y + _offset_colisao_y, obj_Colisao_Pai))
    {
        x += sign(velh);
    }

    velh = 0;
}
else if (
    (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_1)
        && !global.incidente_001_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_2)
        && !global.incidente_002_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_3)
        && !global.incidente_002_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_4)
        && !global.incidente_002_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_5)
        && !global.incidente_003_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_6)
        && !global.incidente_004_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_7)
        && !global.incidente_004_confirmado)
    || (room == Room5
        && place_meeting(x + velh, y + _offset_colisao_y, Object53)
        && !global.incidente_005_confirmado)
    || (place_meeting(x + velh, y + _offset_colisao_y, obj_porta)
        && !_porta_liberada))
{
    velh = 0;
}
else
{
    x += velh;
}

// Colisao vertical
if (place_meeting(x, y + velv + _offset_colisao_y, obj_Colisao_Pai))
{
    while (velv != 0
        && !place_meeting(x, y + sign(velv) + _offset_colisao_y, obj_Colisao_Pai))
    {
        y += sign(velv);
    }

    velv = 0;
}
else if (
    (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_1)
        && !global.incidente_001_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_2)
        && !global.incidente_002_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_3)
        && !global.incidente_002_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_4)
        && !global.incidente_002_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_5)
        && !global.incidente_003_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_6)
        && !global.incidente_004_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_7)
        && !global.incidente_004_confirmado)
    || (room == Room5
        && place_meeting(x, y + velv + _offset_colisao_y, Object53)
        && !global.incidente_005_confirmado)
    || (place_meeting(x, y + velv + _offset_colisao_y, obj_porta)
        && !_porta_liberada))
{
    velv = 0;
}
else
{
    y += velv;
}

// Atualizar direcao pela entrada atual (resposta imediata, sem atraso visual)
if (_dir && !_esq)
{
    lado = 2;
}
else if (_esq && !_dir)
{
    lado = 3;
}
else if (_baixo && !_cima)
{
    lado = 0;
}
else if (_cima && !_baixo)
{
    lado = 1;
}

// Verificar movimento real (sincroniza animacao com deslocamento de fato)
if (x != _x_ant || y != _y_ant)
{
    movendo = 1;
}
else
{
    movendo = 0;
}

// Sem teclas e parado: usa a ultima direcao apertada (W/A/S/D).
if (!movendo && !_dir && !_esq && !_baixo && !_cima)
{
    lado = ultimo_lado_input;
}

// Atualizar sprite
sprite_index = sprites[movendo][lado];

// Ao trocar de direcao, reinicia a animacao para evitar pulo visual.
if (lado != _lado_ant)
{
    image_index = 0;
}

lado_anterior = lado;

// Mantem escala uniforme para evitar deformacao entre animacoes.
image_xscale = player_scale;
image_yscale = player_scale;

// Y-sort: quem esta mais abaixo na tela fica na frente.
depth = -y;

// Ajustar velocidade da animacao para acompanhar melhor o movimento
if (movendo)
{
    var _dist_mov = point_distance(_x_ant, _y_ant, x, y);
    var _px_por_quadrado = 32;
    var _frames_por_quadrado_base = 5;

    // W/S pedem um pouco mais de cadencia para evitar efeito de "deslize".
    var _ajuste_direcao = ((lado == 0 || lado == 1) ? 1.20 : 1.00);
    var _frames_por_quadrado = _frames_por_quadrado_base * _ajuste_direcao;

    // Regra base: ~5 frames por quadrado, com ajuste vertical (W/S).
    image_speed = (_dist_mov * _frames_por_quadrado) / _px_por_quadrado;
    image_speed = clamp(image_speed, 0.20, 0.80);
}
else
{
    image_speed = 0;
    image_index = 0;
}
