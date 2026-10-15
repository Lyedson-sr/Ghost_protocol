
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

// Travar movimento enquanto uma interface estiver aberta
if (!_interface_aberta)
{
    _dir = keyboard_check(ord("D"));
    _esq = keyboard_check(ord("A"));
    _baixo = keyboard_check(ord("S"));
    _cima = keyboard_check(ord("W"));
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

// Atualizar direcao
if (_baixo) lado = 0;
if (_cima)  lado = 1;
if (_dir)   lado = 2;
if (_esq)   lado = 3;

// Verificar movimento
if (_dir != 0 || _esq != 0 || _baixo != 0 || _cima != 0)
{
    movendo = 1;
}
else
{
    movendo = 0;
}

// Atualizar sprite
sprite_index = sprites[movendo][lado];
