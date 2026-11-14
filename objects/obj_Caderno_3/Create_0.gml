/// Evento Criar - caderno da fase 4

aba_atual = 0;
evidencias = [false, false, false];
evidencias_nome = ["IP", "Url", "CWE-89"];

if (!variable_global_exists("incidente_004_concluido")) global.incidente_004_concluido = false;
if (!variable_global_exists("incidente_004_confirmado")) global.incidente_004_confirmado = false;

cor_fundo = make_color_rgb(10, 14, 27);
cor_borda = make_color_rgb(32, 64, 83);
cor_madeira = make_color_rgb(121, 69, 43);
cor_detalhe = make_color_rgb(213, 180, 100);
cor_papel = make_color_rgb(244, 231, 177);
cor_texto = make_color_rgb(35, 29, 27);
cor_aba = make_color_rgb(24, 39, 59);
