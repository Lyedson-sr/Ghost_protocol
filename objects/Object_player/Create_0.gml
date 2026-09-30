// Velocidade e movimento
vel = 4;
velh = 0;
velv = 0;
movendo = 0;
lado = 0; // 0: frente, 1: costas, 2: direita, 3: esquerda

// Matriz de sprites
// Parados (movendo = 0)
sprites[0][0] = fente;
sprites[0][1] = costas;
sprites[0][2] = direita;
sprites[0][3] = esquerda;

// Em movimento (movendo = 1)
sprites[1][0] = Move_frente;
sprites[1][1] = Move_cima;
sprites[1][2] = Move_direita;
sprites[1][3] = Move_es;