
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
        || instance_exists(obj_Caderno_1))
    {
        with (obj_Caderno)
        {
            instance_destroy();
        }
        with (obj_Caderno_1)
        {
            instance_destroy();
        }
        exit;
    }

    room_goto(Room_Menu);
    exit;
}

// Verificar se alguma interface esta aberta
var _interface_aberta =
    instance_exists(obj_Terminal)
    || instance_exists(obj_Caderno)
    || instance_exists(obj_Caderno_1);

// Abrir/fechar o caderno com C (toggle), se o terminal nao estiver aberto
if (!instance_exists(obj_Terminal)
    && keyboard_check_pressed(ord("C")))
{
    if (instance_exists(obj_Caderno)
        || instance_exists(obj_Caderno_1))
    {
        with (obj_Caderno)
        {
            instance_destroy();
        }
        with (obj_Caderno_1)
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
        else
        {
            instance_create_depth(0, 0, -10000, obj_Caderno);
        }
    }
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

if (alvo != noone && keyboard_check_pressed(ord("E"))) {
    var _dialogo = instance_find(obj_dialogo, 0);

    if (_dialogo == noone)
    {
        _dialogo = instance_create_depth(0, 0, -10000, obj_dialogo);
    }

    _dialogo.abrir(alvo);
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
else if (!(room == Room2 ? global.incidente_002_confirmado : global.incidente_001_confirmado)
    && (place_meeting(x + velh, y + _offset_colisao_y, obj_portal_1)
        || place_meeting(x + velh, y + _offset_colisao_y, obj_portal_2)
        || place_meeting(x + velh, y + _offset_colisao_y, obj_porta)))
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
else if (!(room == Room2 ? global.incidente_002_confirmado : global.incidente_001_confirmado)
    && (place_meeting(x, y + velv + _offset_colisao_y, obj_portal_1)
        || place_meeting(x, y + velv + _offset_colisao_y, obj_portal_2)
        || place_meeting(x, y + velv + _offset_colisao_y, obj_porta)))
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
