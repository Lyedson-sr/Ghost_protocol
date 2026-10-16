ativo = false;
tipo = "mensagem";
titulo = "";
linhas = [];
entrada = "";          // texto digitado (terminal)
historico = [];        // linhas exibidas no terminal
frame_abertura = 0;
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