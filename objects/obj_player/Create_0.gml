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
    show_error("Nao foi possivel carregar a fonte dos avisos de interacao.", true);
}

descricoes_objetos = [
    { objeto: obj_garrafao, tipo: "mensagem", titulo: "Bebedouro",
        linhas: ["A torneira do bebedouro esta pingando agua. Uma pequena poca comeca a se formar no chao."] },
    { objeto: obj_quadro, tipo: "mensagem", titulo: "Quadro de avisos",
        linhas: ["Parece ser a lista de funcionarios do mes, com fotos e pequenos recados de parabens."] },
    { objeto: obj_quadros, tipo: "mensagem", titulo: "Quadros na parede",
        linhas: ["Relatorios e graficos emoldurados mostram os resultados da equipe nos ultimos meses."] },
    { objeto: obj_cafeteira, tipo: "mensagem", titulo: "Cafeteira",
        linhas: ["Ainda ha um pouco de cafe na jarra. O cheiro forte sugere que ele esta aqui ha algumas horas."] },
    { objeto: obj_impressora, tipo: "mensagem", titulo: "Impressora",
        linhas: ["A impressora esta em modo de espera. Algumas folhas em branco aguardam na bandeja."] },
    { objeto: obj_me_impre, tipo: "mensagem", titulo: "Mesa de impressao",
        linhas: ["Uma mesa com equipamento de impressao e papeis organizados ao lado, pronta para mais um dia de trabalho."] },
    { objeto: obj_lixeira, tipo: "mensagem", titulo: "Lixeira",
        linhas: ["A lixeira tem copos descartaveis e embalagens de lanche. Alguem precisa recolher o lixo."] },
    { objeto: ob_movel1, tipo: "mensagem", titulo: "Estante",
        linhas: ["Um armario de escritorio com as portas fechadas. A pintura esta gasta perto dos puxadores."] },
    { objeto: obj_movel2, tipo: "mensagem", titulo: "Arquivo",
        linhas: ["Um pequeno arquivo de madeira. As gavetas estao fechadas e ha uma fina camada de poeira sobre ele."] },
    { objeto: obj_m1, tipo: "mensagem", titulo: "Balcao",
        linhas: ["Um balcao com gavetas para guardar materiais de escritorio. A superficie esta limpa e bem cuidada."] },
    { objeto: obj_m2, tipo: "mensagem", titulo: "Estacao de trabalho",
        linhas: ["Uma estacao de trabalho com cadeira e equipamentos de escritorio. Parece que o expediente terminou ha pouco."] },
    { objeto: obj_mesa, tipo: "mensagem", titulo: "Mesa",
        linhas: ["Uma mesa simples de madeira. Pequenos riscos na superficie mostram as marcas do uso diario."] },
    { objeto: obj_mesa_grande, tipo: "mensagem", titulo: "Mesa de reuniao",
        linhas: ["Uma grande mesa cercada de cadeiras. Da para imaginar as longas reunioes que acontecem aqui."] },
    { objeto: Object29, tipo: "mensagem", titulo: "Equipamento de escritorio",
        linhas: ["Um equipamento instalado ao lado da passagem. O painel esta silencioso e a estrutura tem marcas de uso."] },
    { objeto: Object30, tipo: "mensagem", titulo: "Equipamento de escritorio",
        linhas: ["Outro equipamento de escritorio, semelhante ao que esta do outro lado. Parece fazer parte da rotina do lugar."] },
    { objeto: obj_sono, tipo: "mensagem", titulo: "Area de descanso",
        linhas: ["Um cantinho para descansar durante os intervalos. Parece um bom lugar para recuperar as energias."] },
    { objeto: obj_porta, tipo: "mensagem", titulo: "Porta",
        linhas: ["Uma porta que liga os ambientes do predio. A pintura ao redor da passagem esta desgastada."] },
    { objeto: obj_portal_1, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Esta passagem leva a outro ambiente do predio. O corredor do outro lado esta silencioso."] },
    { objeto: obj_portal_2, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Uma passagem entre as salas do predio. Uma corrente de ar frio vem do outro lado."] },
    { objeto: obj_portal_3, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Uma passagem bloqueada. Ela sera liberada quando a fase atual for concluida."] },
    { objeto: obj_portal_4, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Uma passagem entre as salas do predio."] },
    { objeto: obj_portal_5, tipo: "mensagem", titulo: "Passagem",
        linhas: ["Uma passagem bloqueada. Ela sera liberada quando a investigacao desta sala for concluida."] }
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
if (!variable_global_exists("incidente_003_concluido")) global.incidente_003_concluido = false;
if (!variable_global_exists("incidente_003_confirmado")) global.incidente_003_confirmado = false;

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