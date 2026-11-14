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
    { objeto: ob_movel1, tipo: "mensagem", titulo: "Armario",
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
if (!variable_global_exists("incidente_004_concluido")) global.incidente_004_concluido = false;
if (!variable_global_exists("incidente_004_confirmado")) global.incidente_004_confirmado = false;
if (!variable_global_exists("incidente_005_concluido")) global.incidente_005_concluido = false;
if (!variable_global_exists("incidente_005_confirmado")) global.incidente_005_confirmado = false;
if (!variable_global_exists("mensagem_final_exibida")) global.mensagem_final_exibida = false;
if (!variable_global_exists("mensagem_final_pendente")) global.mensagem_final_pendente = false;
if (!variable_global_exists("retorno_final_pendente")) global.retorno_final_pendente = false;
if (!variable_global_exists("anotacoes_jogador")) global.anotacoes_jogador = "";
if (!variable_global_exists("notas_abertas")) global.notas_abertas = false;
if (!variable_global_exists("nivel_ameaca_seguranca")) global.nivel_ameaca_seguranca = 0;
if (!variable_global_exists("game_over_ativo")) global.game_over_ativo = false;
if (!variable_global_exists("game_over_msg")) global.game_over_msg = "";
if (!variable_global_exists("jogo_pausado")) global.jogo_pausado = false;
if (!variable_global_exists("sala_retorno_pausa")) global.sala_retorno_pausa = Room1;
if (!variable_global_exists("forcar_reset_timer")) global.forcar_reset_timer = false;
if (!variable_global_exists("hud_escudo_sprite")) global.hud_escudo_sprite = -1;
if (!variable_global_exists("sirene_ultimo_min_sound")) global.sirene_ultimo_min_sound = -1;
if (!variable_global_exists("sirene_ultimo_min_arquivo")) global.sirene_ultimo_min_arquivo = "alarm_last_min.ogg";
if (!variable_global_exists("sirene_ultimo_min_fallback")) global.sirene_ultimo_min_fallback = snd_phone_ring;

if (string_lower(global.sirene_ultimo_min_arquivo) == "alarm_last_min.mp3")
{
    global.sirene_ultimo_min_arquivo = "alarm_last_min.ogg";
}

if (!variable_global_exists("hud_escudo_arquivo"))
{
    global.hud_escudo_arquivo = "escudo.png";
}

if (global.hud_escudo_sprite == -1)
{
    var _p1 = working_directory + "datafiles/" + global.hud_escudo_arquivo;
    var _p2 = working_directory + "datafiles\\" + global.hud_escudo_arquivo;
    var _p3 = working_directory + global.hud_escudo_arquivo;
    var _p4 = program_directory + "datafiles/" + global.hud_escudo_arquivo;
    var _p5 = program_directory + global.hud_escudo_arquivo;

    if (file_exists(_p1)) global.hud_escudo_sprite = sprite_add(_p1, 1, false, false, 0, 0);
    else if (file_exists(_p2)) global.hud_escudo_sprite = sprite_add(_p2, 1, false, false, 0, 0);
    else if (file_exists(_p3)) global.hud_escudo_sprite = sprite_add(_p3, 1, false, false, 0, 0);
    else if (file_exists(_p4)) global.hud_escudo_sprite = sprite_add(_p4, 1, false, false, 0, 0);
    else if (file_exists(_p5)) global.hud_escudo_sprite = sprite_add(_p5, 1, false, false, 0, 0);
}

if (global.sirene_ultimo_min_sound == -1)
{
    var _nome_sirene = string_lower(global.sirene_ultimo_min_arquivo);
    var _arquivo_ogg = string_pos(".ogg", _nome_sirene) == string_length(_nome_sirene) - 3;

    if (_arquivo_ogg)
    {
        var _s1 = working_directory + "datafiles/" + global.sirene_ultimo_min_arquivo;
        var _s2 = working_directory + "datafiles\\" + global.sirene_ultimo_min_arquivo;
        var _s3 = working_directory + global.sirene_ultimo_min_arquivo;
        var _s4 = program_directory + "datafiles/" + global.sirene_ultimo_min_arquivo;
        var _s5 = program_directory + global.sirene_ultimo_min_arquivo;

        if (file_exists(_s1)) global.sirene_ultimo_min_sound = audio_create_stream(_s1);
        else if (file_exists(_s2)) global.sirene_ultimo_min_sound = audio_create_stream(_s2);
        else if (file_exists(_s3)) global.sirene_ultimo_min_sound = audio_create_stream(_s3);
        else if (file_exists(_s4)) global.sirene_ultimo_min_sound = audio_create_stream(_s4);
        else if (file_exists(_s5)) global.sirene_ultimo_min_sound = audio_create_stream(_s5);
    }
}

tempo_limite_sala_seg = 5 * 60;
tempo_restante_sala = tempo_limite_sala_seg * game_get_speed(gamespeed_fps);
sala_timer_room = room;
taxa_dreno_base = 1;
multiplicador_ameaca_alta = 3.0;
limite_ameaca_alta = 80;
game_over_disparado = false;

aviso_1min_emitido = false;
aviso_1min_pendente = false;
sirene_1min_tocando = false;
sirene_1min_liberada = false;
sirene_1min_instancia = -1;
sirene_1min_usando_fallback = false;

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