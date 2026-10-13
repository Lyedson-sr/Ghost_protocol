// Teclas de movimentação
var _dir = keyboard_check(ord("D"));
var _esq = keyboard_check(ord("A"));
var _baixo = keyboard_check(ord("S"));
var _cima = keyboard_check(ord("W"));

// Calcular velocidade
velh = (_dir - _esq) * vel;
velv = (_baixo - _cima) * vel;

// Colisão Horizontal
repeat(abs(velh))
{
    // Verifica se NÃO bate nem na parede E nem no Object7
    if (!place_meeting(x + sign(velh), y, obj_Parede) && !place_meeting(x + sign(velh), y, obj_servidor))
    {
        x += sign(velh);
    }
    else
    {
        velh = 0; // Nota: corrigido de velhh para velh
        break;
    }
}

// Colisão Vertical (Pra ele conseguir andar pra cima / baixo)
repeat(abs(velv))
{
    // Verifica se NÃO bate nem na parede E nem no Object7
    if (!place_meeting(x, y + sign(velv), obj_Parede) && !place_meeting(x, y + sign(velv), obj_servidor))
    {
        y += sign(velv);
    }
    else
    {
        velv = 0; // Nota: corrigido de velhv para velv
        break;
    }
}

// Atualizar direção (lado) com base na última tecla pressionada
if (_baixo)  lado = 0;
if (_cima)   lado = 1;
if (_dir)    lado = 2;
if (_esq)    lado = 3;

// Verificar se está em movimento
if (velh != 0 || velv != 0) {
    movendo = 1;
} else {
    movendo = 0;
}

// Trocar o sprite atual dinamicamente
sprite_index = sprites[movendo][lado];