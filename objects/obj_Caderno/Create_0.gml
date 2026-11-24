
/// Evento Criar - obj_Caderno

// Aba selecionada:
// 0 = Evidencias
// 1 = Ferramentas
// 2 = Catalogo
// 3 = Glossario
aba_atual = 0;
total_abas = 4;
ferramentas_pagina = 0;
ferramentas_total_paginas = 2;
nav_anim_prev = 0;
nav_anim_next = 0;

// Evidencias selecionadas
evidencias = array_create(3, false);
evidencias_fase2 = array_create(3, false);

evidencias_nome = [
    "IP do servidor",
    "Usuario",
    "Senha"
];

// Dica de onde procurar cada evidencia ("" = sem dica)
evidencias_dica = [
    "Servidores costumam ter uma etiqueta.",
    "",
    "Nem todo mundo descarta papeis com cuidado..."
];

// Distancia vertical entre os itens da lista (usada no Step e no Draw)
evidencia_espaco = 64;

// Estado da ameaca
if (!variable_global_exists("incidente_001_concluido")) global.incidente_001_concluido = false;
if (!variable_global_exists("incidente_001_confirmado")) global.incidente_001_confirmado = false;
if (!variable_global_exists("incidente_005_concluido")) global.incidente_005_concluido = false;
if (!variable_global_exists("incidente_005_confirmado")) global.incidente_005_confirmado = false;
ameaca_confirmada = global.incidente_001_confirmado;

// Cores do caderno
cor_fundo = make_color_rgb(10, 14, 27);
cor_borda = make_color_rgb(32, 64, 83);
cor_madeira = make_color_rgb(121, 69, 43);
cor_detalhe = make_color_rgb(213, 180, 100);
cor_papel = make_color_rgb(244, 231, 177);
cor_texto = make_color_rgb(35, 29, 27);
cor_aba = make_color_rgb(24, 39, 59);
cor_verde = make_color_rgb(93, 190, 107);
cor_comando = make_color_rgb(32, 64, 110);
cor_secundaria = make_color_rgb(110, 78, 50);
fonte_caderno = font_add("Consolas", 16, false, false, 32, 255);
if (fonte_caderno == -1) fonte_caderno = -1;

// Fontes menores para o corpo do texto e para comandos.
// Criadas uma unica vez (globais) para nao acumular fontes a cada abertura.
if (!variable_global_exists("fonte_caderno_corpo"))
{
    global.fonte_caderno_corpo = font_add("Arial", 12, false, false, 32, 255);
}
if (!variable_global_exists("fonte_caderno_cmd"))
{
    global.fonte_caderno_cmd = font_add("Consolas", 12, false, false, 32, 255);
}

// Desenha um paragrafo com quebra de linha e devolve o Y logo abaixo dele.
// _destaque: trecho inicial do texto que sera desenhado em "negrito" (opcional).
texto_bloco = function(_tx, _ty, _texto, _largura, _destaque)
{
    draw_set_font(global.fonte_caderno_corpo);
    draw_text_ext(_tx, _ty, _texto, -1, _largura);
    if (_destaque != "")
    {
        draw_text(_tx + 1, _ty, _destaque);
    }
    return _ty + string_height_ext(_texto, -1, _largura);
};

// Desenha uma linha de comando (fonte monoespacada) e devolve o Y abaixo dela.
texto_comando = function(_tx, _ty, _texto)
{
    draw_set_font(global.fonte_caderno_cmd);
    draw_text(_tx, _ty, _texto);
    return _ty + string_height(_texto) + 2;
};

// Desenha a faixa de titulo de uma ferramenta/ameaca e devolve o Y abaixo dela.
caixa_titulo = function(_bx, _by, _largura, _texto)
{
    draw_set_color(make_color_rgb(225, 211, 161));
    draw_rectangle(_bx, _by, _bx + _largura, _by + 36, false);
    draw_set_color(cor_texto);
    draw_set_font(fonte_caderno);
    draw_text(_bx + 10, _by + 9, _texto);
    return _by + 48;
};

// Controle de visibilidade
// Este objeto deve existir enquanto o caderno estiver aberto.
