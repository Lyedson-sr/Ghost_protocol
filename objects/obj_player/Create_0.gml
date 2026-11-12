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
alvo_descricao = undefined;
fonte_interacao = font_add("Arial", 14, false, false, 32, 255);
if (fonte_interacao == -1)
{
    show_error("Não foi possível carregar a fonte dos avisos de interação.", true);
}

descricoes_objetos = [
    { objeto: obj_garrafao, tipo: "mensagem", titulo: "Bebedouro",
        linhas: ["A torneira do bebedouro está pingando água. Uma pequena poça começa a se formar no chão."] },
    { objeto: obj_quadro, tipo: "mensagem", titulo: "Quadro de avisos",
        linhas: ["Parece ser a lista de funcionários do mês, com fotos e pequenos recados de parabéns."] },
    { objeto: obj_quadros, tipo: "mensagem", titulo: "Quadros na parede",
        linhas: ["Relatórios e gráficos emoldurados mostram os resultados da equipe nos últimos meses."] },
    { objeto: obj_cafeteira, tipo: "mensagem", titulo: "Cafeteira",
        linhas: ["Ainda há um pouco de café na jarra. O cheiro forte sugere que ele está aqui há algumas horas."] },
    { objeto: obj_impressora, tipo: "mensagem", titulo: "Impressora",
        linhas: ["A impressora está em modo de espera. Algumas folhas em branco aguardam na bandeja."] },
    { objeto: obj_me_impre, tipo: "mensagem", titulo: "Mesa de impressão",
        linhas: ["Uma mesa com equipamento de impressão e papéis organizados ao lado, pronta para mais um dia de trabalho."] },
    { objeto: obj_lixeira, tipo: "mensagem", titulo: "Lixeira",
        linhas: ["A lixeira tem copos descartáveis e embalagens de lanche. Alguém precisa recolher o lixo."] },
    { objeto: ob_movel1, tipo: "mensagem", titulo: "Armário",
        linhas: ["Um armário de escritório com as portas fechadas. A pintura está gasta perto dos puxadores."] },
    { objeto: obj_movel2, tipo: "mensagem", titulo: "Arquivo",
        linhas: ["Um pequeno arquivo de madeira. As gavetas estão fechadas e há uma fina camada de poeira sobre ele."] },
    { objeto: obj_m1, tipo: "mensagem", titulo: "Balcão",
        linhas: ["Um balcão com gavetas para guardar materiais de escritório. A superfície está limpa e bem cuidada."] },
    { objeto: obj_m2, tipo: "mensagem", titulo: "Estação de trabalho",
        linhas: ["Uma estação de trabalho com cadeira e equipamentos de escritório. Parece que o expediente terminou há pouco."] },
    { objeto: obj_mesa, tipo: "mensagem", titulo: "Mesa",
        linhas: ["Uma mesa simples de madeira. Pequenos riscos na superfície mostram as marcas do uso diário."] },
    { objeto: obj_mesa_grande, tipo: "mensagem", titulo: "Mesa de reunião",
        linhas: ["Uma grande mesa cercada de cadeiras. Dá para imaginar as longas reuniões que acontecem aqui."] },
    { objeto: Object29, tipo: "mensagem", titulo: "Equipamento de escritório",
        linhas: ["Um equipamento instalado ao lado da passagem. O painel está silencioso e a estrutura tem marcas de uso."] },
    { objeto: Object30, tipo: "mensagem", titulo: "Equipamento de escritório",
        linhas: ["Outro equipamento de escritório, semelhante ao que está do outro lado. Parece fazer parte da rotina do lugar."] },
    { objeto: obj_sono, tipo: "mensagem", titulo: "Área de descanso",
        linhas: ["Um cantinho para descansar durante os intervalos. Parece um bom lugar para recuperar as energias."] },
    { objeto: obj_porta, tipo: "mensagem", titulo: "Porta",
        linhas: ["Uma porta que liga os ambientes do prédio. A pintura ao redor da passagem está desgastada."] },
    { objeto: obj_portal_1, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Esta passagem leva a outro ambiente do prédio. O corredor do outro lado está silencioso."] },
    { objeto: obj_portal_2, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Uma passagem entre as salas do prédio. Uma corrente de ar frio vem do outro lado."] }
];

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
if (!variable_global_exists("intro_ligacao_vista")) global.intro_ligacao_vista = false;
if (!variable_global_exists("incidente_001_concluido")) global.incidente_001_concluido = false;
if (!variable_global_exists("incidente_001_confirmado")) global.incidente_001_confirmado = false;
if (!variable_global_exists("incidente_002_concluido")) global.incidente_002_concluido = false;
if (!variable_global_exists("incidente_002_confirmado")) global.incidente_002_confirmado = false;
if (!variable_global_exists("anotacoes_jogador")) global.anotacoes_jogador = "";
if (!variable_global_exists("notas_abertas")) global.notas_abertas = false;

notas_cursor_pos = string_length(global.anotacoes_jogador);
notas_limite_caracteres = 1800;

intro_ligacao_estado = 0; // 0: sem chamada, 1: tocando, 2: atendida
intro_fala_tocando = false;

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