// Velocidade e movimento
vel = 4;
velh = 0;
velv = 0;
movendo = 0;
lado = 0; // 0: frente, 1: costas, 2: direita, 3: esquerda

// Matriz de sprites
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