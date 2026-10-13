// Capturar o texto que o jogador digita no teclado
input_texto = keyboard_string;

// Se o jogador apertar ENTER, processar o comando
if (keyboard_check_pressed(vk_enter))
{
    // Adicionar o comando digitado ao histórico
    historico += "> " + input_texto + "\n";
    
    // Processar comandos
    var _cmd = string_lower(string_trim(input_texto));
    
    if (_cmd == "ls") {
        historico += "  documentos/\n  senhas.txt\n  projeto_secreto.gml\n";
    }
    else if (_cmd == "ajuda" || _cmd == "help") {
        historico += "  Comandos disponiveis: ls, ajuda, cls, sair\n";
    }
    else if (_cmd == "cls" || _cmd == "limpar") {
        historico = ""; // Limpa a tela
    }
    else if (_cmd == "sair" || _cmd == "exit") {
        instance_destroy(); // Fecha o terminal
    }
    else if (_cmd != "") {
        historico += "  Comando nao reconhecido: " + input_texto + "\n";
    }
    
    // Resetar a string do teclado para o próximo comando
    keyboard_string = "";
    input_texto = "";
}

// Tecla ESC para fechar o terminal
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
}