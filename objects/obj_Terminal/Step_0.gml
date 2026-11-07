/// Step - obj_Terminal
terminal_x = (display_get_gui_width()  - terminal_largura) / 2;
terminal_y = (display_get_gui_height() - terminal_altura)  / 2;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Botão fechar (X)
var _bx = terminal_x + terminal_largura - 30;
var _by = terminal_y + 4;
if (mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, _bx, _by, _bx + 24, _by + 24)) {
    instance_destroy();
    exit;
}

if (keyboard_check_pressed(vk_escape)) { instance_destroy(); exit; }

// Rolagem
if (point_in_rectangle(_mx, _my, terminal_x, terminal_y, terminal_x + terminal_largura, terminal_y + terminal_altura)) {
    if (mouse_wheel_up())   scroll_linha += scroll_velocidade;
    if (mouse_wheel_down()) scroll_linha -= scroll_velocidade;
}
scroll_linha = max(0, scroll_linha);

if (ocupado) {
    keyboard_string = "";
    input_texto = "";
    timer--;
    if (timer <= 0) {
        for (var i = 0; i < array_length(saida_pendente); i++) {
            adicionar("out", saida_pendente[i]);
            if (saida_pendente[i] == "Nmap scan report for 192.168.1.50") {
                global.incidente_002_concluido = true;
            }
        }
        var _a = acao_pendente;
        saida_pendente = [];
        acao_pendente = "";
        ocupado = false;
        scroll_linha = 0;
        if (_a != "") finalizar_acao(_a);
    }
} else {
    if (string_length(keyboard_string) > 120) keyboard_string = string_copy(keyboard_string, 1, 120);
    input_texto = keyboard_string;

    if (keyboard_check_pressed(vk_enter)) {
        var _entrada = input_texto;
        keyboard_string = "";
        input_texto = "";
        if (modo == "senha") processar_senha(_entrada);
        else executar(string_trim(_entrada));
        scroll_linha = 0;
    }
}