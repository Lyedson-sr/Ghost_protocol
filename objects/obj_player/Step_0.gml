
/// Evento Etapa (Step) - obj_player

// Voltar ao menu com ESC
if (keyboard_check_pressed(vk_escape))
{
    // Fechar interfaces antes de trocar de sala
    if (instance_exists(obj_Terminal))
    {
        with (obj_Terminal)
        {
            instance_destroy();
        }
        exit;
    }

    if (instance_exists(obj_Caderno))
    {
        with (obj_Caderno)
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
    || instance_exists(obj_Caderno);

// Abrir/fechar o caderno com C (toggle), se o terminal nao estiver aberto
if (!instance_exists(obj_Terminal)
    && keyboard_check_pressed(ord("C")))
{
    if (instance_exists(obj_Caderno))
    {
        with (obj_Caderno)
        {
            instance_destroy();
        }
    }
    else
    {
        instance_create_depth(
            0, 0, -10000,
            obj_Caderno
        );
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

// Colisao horizontal
if (place_meeting(x + velh, y, obj_Colisao_Pai))
{
    while (velh != 0
        && !place_meeting(x + sign(velh), y, obj_Colisao_Pai))
    {
        x += sign(velh);
    }

    velh = 0;
}
else
{
    x += velh;
}

// Colisao vertical
if (place_meeting(x, y + velv, obj_Colisao_Pai))
{
    while (velv != 0
        && !place_meeting(x, y + sign(velv), obj_Colisao_Pai))
    {
        y += sign(velv);
    }

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
