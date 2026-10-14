
/// Evento Etapa - obj_Terminal

// 1. Capturar o texto digitado
input_texto = keyboard_string;

// 2. Posição e tamanho do terminal
var _x = 150;
var _y = 100;
var _largura = terminal_largura;
var _altura = terminal_altura;

// 3. Detectar o mouse dentro do terminal
var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _mouse_dentro =
    _mouse_x >= _x &&
    _mouse_x <= _x + _largura &&
    _mouse_y >= _y &&
    _mouse_y <= _y + _altura;

// 4. Controlar a rolagem
if (_mouse_dentro)
{
    if (mouse_wheel_up())
    {
        scroll_linha += scroll_velocidade;
    }

    if (mouse_wheel_down())
    {
        scroll_linha -= scroll_velocidade;
    }
}

scroll_linha = max(0, scroll_linha);

// 5. Processar comando ao pressionar ENTER
if (keyboard_check_pressed(vk_enter))
{
    var _entrada = string_trim(input_texto);
    var _cmd = string_lower(_entrada);

    historico += "> " + _entrada + "\n";

    if (_cmd == "ls")
    {
        historico +=
            "  documentos/\n" +
            "  senhas.txt\n" +
            "  projeto_secreto.gml\n";
    }
    else if (_cmd == "ajuda" || _cmd == "help")
    {
        historico +=
            "  Comandos disponiveis: ls, ajuda, cls, limpar, sair\n";
    }
    else if (_cmd == "cls" || _cmd == "limpar")
    {
        historico = "";
    }
    else if (_cmd == "sair" || _cmd == "exit")
    {
        instance_destroy();
        exit;
    }
    else if (_cmd != "")
    {
        historico +=
            "  Comando nao reconhecido: " + _entrada + "\n";
    }

    // Limpar o texto digitado
    keyboard_string = "";
    input_texto = "";

    // Mostrar o final do histórico
    scroll_linha = 0;
}

// 6. Fechar terminal com ESC
if (keyboard_check_pressed(vk_escape))
{
    instance_destroy();
    exit;
}
