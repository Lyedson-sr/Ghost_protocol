ativo = false;
tipo = "mensagem";
titulo = "";
linhas = [];
fonte_dialogo = font_add("Arial", 14, false, false, 32, 255);
if (fonte_dialogo == -1) fonte_dialogo = -1;
entrada = "";          // texto digitado (terminal)
historico = [];        // linhas exibidas no terminal
frame_abertura = 0;
altura_caixa = 150;
global.dialogo_aberto = false;

if (!variable_global_exists("dialogo_aberto")) global.dialogo_aberto = false;

abrir = function(_inst) {
    ativo = true;
    global.dialogo_aberto = true;
    tipo = _inst.tipo;
    titulo = _inst.titulo;
    linhas = _inst.linhas;
    historico = array_create(0);
    for (var i = 0; i < array_length(linhas); i++) array_push(historico, linhas[i]);
    entrada = "";
    keyboard_string = "";
    keyboard_lastkey = -1;
	frame_abertura = 2;

    if (tipo == "terminal") {
        altura_caixa = 260;
    } else {
        var _margem = 20;
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();
        var _largura_texto = _gw - (_margem * 2) - 24;
        var _texto = string_join_ext("\n", linhas);
        var _altura_texto = string_height_ext(_texto, 16, _largura_texto);

        // Calcula uma vez por abertura para manter tamanho estavel.
        altura_caixa = clamp(_altura_texto + 72, 150, _gh - (_margem * 2));
    }
};

fechar = function() {
    ativo = false;
    global.dialogo_aberto = false;
};

executar_comando = function(_cmd) {
    array_push(historico, "> " + _cmd);
    switch (string_lower(string_trim(_cmd))) {
        case "help":  array_push(historico, "Comandos: help, status, exit"); break;
        case "status": array_push(historico, "Sistema online."); break;
        case "exit":  fechar(); break;
        default:      array_push(historico, "Comando desconhecido.");
    }
    // limita o histórico
    while (array_length(historico) > 12) array_delete(historico, 0, 1);
};