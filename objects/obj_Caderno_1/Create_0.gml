
/// Evento Criar - obj_Caderno

// Aba selecionada:
// 0 = Evidências
// 1 = Ferramentas
// 2 = Catálogo
aba_atual = 1;

// Evidências selecionadas
evidencias = array_create(3, false);

evidencias_nome = [
    "CVE-2016-3115",
    "CVE-2015-6563",
    "CVE-2016-10011"
];

// Estado da ameaça
if (!variable_global_exists("incidente_002_concluido")) global.incidente_002_concluido = false;
if (!variable_global_exists("incidente_002_confirmado")) global.incidente_002_confirmado = false;
ameaca_confirmada = global.incidente_002_confirmado;
finalizado = ameaca_confirmada;

// Cores do caderno
cor_fundo = make_color_rgb(10, 14, 27);
cor_borda = make_color_rgb(32, 64, 83);
cor_madeira = make_color_rgb(121, 69, 43);
cor_detalhe = make_color_rgb(213, 180, 100);
cor_papel = make_color_rgb(244, 231, 177);
cor_texto = make_color_rgb(35, 29, 27);
cor_aba = make_color_rgb(24, 39, 59);
cor_verde = make_color_rgb(93, 190, 107);

// Controle de visibilidade
// Este objeto deve existir enquanto o caderno estiver aberto.
