// Velocidade e movimento
vel = 4;
velh = 0;
velv = 0;
movendo = 0;
lado = 0; // 0: frente, 1: costas, 2: direita, 3: esquerda
lado_anterior = lado;
ultimo_lado_input = lado;

// Usa escala nativa dos sprites para evitar qualquer deformacao visual.
player_scale = 1.00;
alvo = noone;

// Mantem uma mascara de colisao fixa para evitar variacao entre sprites.
mask_index = spr_move_direita;

// Remove colisao da cabeca: usa somente a metade inferior (corpo/pes).
sprite_collision_mask(
	spr_move_direita,
	true,
	2,
	6,
	15,
	25,
	31,
	1,
	0
);

// Ordena desenho por Y para evitar que objetos "engulam" o player visualmente.
depth = -y;

if (!variable_global_exists("dialogo_aberto")) global.dialogo_aberto = false;
if (!variable_global_exists("incidente_001_concluido")) global.incidente_001_concluido = false;
if (!variable_global_exists("incidente_001_confirmado")) global.incidente_001_confirmado = false;

// Matriz de sprites
sprites = array_create(2);
sprites[0] = array_create(4);
sprites[1] = array_create(4);

// Parados (movendo = 0)
sprites[0][0] = spr_fente;
sprites[0][1] = spr_costas;
sprites[0][2] = spr_direita;
sprites[0][3] = spr_esquerda;

// Em movimento (movendo = 1)
sprites[1][0] = spr_move_frente;
sprites[1][1] = spr_move_cima;
sprites[1][2] = spr_move_direita;
sprites[1][3] = spr_move_esquerda;