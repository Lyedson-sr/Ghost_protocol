
/// Evento Criar - obj_Caderno

// Aba selecionada:
// 0 = Evidências
// 1 = Ferramentas
// 2 = Catálogo
aba_atual = 0;

// Evidências selecionadas
evidencias = array_create(5, false);

evidencias_nome = [
    "E-mail de Phishing",
    "Registro de Login Suspeito",
    "Trafego de Rede Anomalo",
    "Arquivo de Sistema Modificado",
    "Dispositivo USB Desconhecido"
];

// Estado da ameaça
ameaca_confirmada = false;

// Cores do caderno
cor_fundo = make_color_rgb(10, 14, 27);
cor_borda = make_color_rgb(109, 222, 237);
cor_madeira = make_color_rgb(104, 48, 34);
cor_detalhe = make_color_rgb(207, 145, 65);
cor_papel = make_color_rgb(244, 231, 177);
cor_texto = make_color_rgb(35, 29, 27);
cor_aba = make_color_rgb(27, 38, 61);
cor_verde = make_color_rgb(93, 190, 107);

// Controle de visibilidade
// Este objeto deve existir enquanto o caderno estiver aberto.
