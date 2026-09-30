// Teclas de movimentação
var _dir = keyboard_check(ord("D"));
var _esq = keyboard_check(ord("A"));
var _baixo = keyboard_check(ord("S"));
var _cima = keyboard_check(ord("W"));

// Calcular velocidade
velh = (_dir - _esq) * vel;
velv = (_baixo - _cima) * vel;

repeat(abs(velh))

{
// Colisão Horizontal
	if(!place_meeting(x + sign(velh),y, Object2))
	{
		x += sign(velh)
	}
	else
	{
		velhh = 0 
	}

}

//Pra ele conseguir andar pra cima : |

repeat(abs(velv))

{
// Colisão Horizontal
	if(!place_meeting(x,y + sign(velv), Object2))
	{
		y += sign(velv)
	}
	else
	{
		velhv = 0 
	}

}

// Atualizar direção (lado) com base na última tecla pressionada
if (_baixo)   lado = 0;
if (_cima)    lado = 1;
if (_dir)     lado = 2;
if (_esq)     lado = 3;

// Verificar se está em movimento
if (velh != 0 || velv != 0) {
    movendo = 1;
} else {
    movendo = 0;
}

// Trocar o sprite atual dinamicamente
sprite_index = sprites[movendo][lado];