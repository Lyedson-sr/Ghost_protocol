/// Evento Criar - obj_bloco_notas
if (!variable_global_exists("anotacoes_jogador")) global.anotacoes_jogador = "";

keyboard_string = "";
texto_notas = global.anotacoes_jogador;
cursor_pos = string_length(texto_notas);

limite_caracteres = 1800;

// Cores da interface
cor_fundo_sombra = c_black;
cor_painel = make_color_rgb(245, 237, 210);
cor_painel_borda = make_color_rgb(108, 76, 45);
cor_linha = make_color_rgb(190, 170, 135);
cor_titulo = make_color_rgb(56, 42, 24);
cor_texto = make_color_rgb(34, 29, 21);
cor_destaque = make_color_rgb(120, 90, 58);

fechar_bloco = function() {
    global.anotacoes_jogador = texto_notas;
    keyboard_string = "";
    instance_destroy();
};
