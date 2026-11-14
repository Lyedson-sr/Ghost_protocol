/// Step - obj_Terminal
terminal_x = (display_get_gui_width()  - terminal_largura) / 2;
terminal_y = (display_get_gui_height() - terminal_altura)  / 2;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Botao fechar (X)
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
		checar_conclusao();   // [NOVO] libera o progresso depois que a saida aparece

    }
} else {
    if (keyboard_check_pressed(vk_up)) {
        if (array_length(historico_comandos) > 0) {
            if (historico_indice < 0) historico_indice = array_length(historico_comandos) - 1;
            else historico_indice = max(0, historico_indice - 1);
            input_texto = historico_comandos[historico_indice];
            cursor_pos = string_length(input_texto);
        }
    } else if (keyboard_check_pressed(vk_down)) {
        if (historico_indice >= 0) {
            historico_indice++;
            if (historico_indice >= array_length(historico_comandos)) {
                historico_indice = -1;
                input_texto = "";
            } else input_texto = historico_comandos[historico_indice];
            cursor_pos = string_length(input_texto);
        }
    } else {
        if (keyboard_string != "") {
            var _novo = keyboard_string;
            var _antes = string_copy(input_texto, 1, cursor_pos);
            var _depois = string_copy(input_texto, cursor_pos + 1, string_length(input_texto) - cursor_pos);
            input_texto = _antes + _novo + _depois;
            cursor_pos += string_length(_novo);
            keyboard_string = "";
        }
        if (keyboard_check_pressed(vk_left)) cursor_pos = max(0, cursor_pos - 1);
        if (keyboard_check_pressed(vk_right)) cursor_pos = min(string_length(input_texto), cursor_pos + 1);
        if (keyboard_check_pressed(vk_backspace) && cursor_pos > 0) {
            input_texto = string_delete(input_texto, cursor_pos, 1);
            cursor_pos--;
        }
        if (keyboard_check_pressed(vk_delete) && cursor_pos < string_length(input_texto)) {
            input_texto = string_delete(input_texto, cursor_pos + 1, 1);
        }
    }
    if (string_length(input_texto) > 120) {
        input_texto = string_copy(input_texto, 1, 120);
        cursor_pos = min(cursor_pos, 120);
    }

    if (keyboard_check_pressed(vk_enter)) {
        var _entrada = input_texto;
        keyboard_string = "";
        input_texto = "";
        cursor_pos = 0;
        historico_indice = -1;
        if (string_trim(_entrada) != "") array_push(historico_comandos, _entrada);
        if (modo == "senha") processar_senha(_entrada);
        else executar(string_trim(_entrada));
        scroll_linha = 0;
    }
}