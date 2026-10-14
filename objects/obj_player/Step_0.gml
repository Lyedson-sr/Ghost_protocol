// Teclas de movimentação (com trava para o terminal)
var _dir = 0;
var _esq = 0;
var _baixo = 0;
var _cima = 0;

if (!instance_exists(obj_Terminal))
{
    _dir = keyboard_check(ord("D"));
    _esq = keyboard_check(ord("A"));
    _baixo = keyboard_check(ord("S"));
    _cima = keyboard_check(ord("W"));
}

// Calcular velocidade
velh = (_dir - _esq) * vel;
velv = (_baixo - _cima) * vel;

// Colisão Horizontal Fluida
if (place_meeting(x + velh, y, obj_Colisao_Pai))
{
    while (!place_meeting(x + sign(velh), y, obj_Colisao_Pai))
    {
        x += sign(velh);
    }
    velh = 0;
}
else
{
    x += velh;
}

// Colisão Vertical Fluida
if (place_meeting(x, y + velv, obj_Colisao_Pai))
{
    while (!place_meeting(x, y + sign(velv), obj_Colisao_Pai))
    {
        y += sign(velv);
    }
    velv = 0;
}
else
{
    y += velv;
}

// Atualizar direção (lado) com base na última tecla pressionada
if (_baixo)  lado = 0;
if (_cima)   lado = 1;
if (_dir)    lado = 2;
if (_esq)    lado = 3;

// Verificar se está em movimento
if (_dir != 0 || _esq != 0 || _baixo != 0 || _cima != 0) {
    movendo = 1;
} else {
    movendo = 0;
}

// Trocar o sprite atual dinamicamente
sprite_index = sprites[movendo][lado];