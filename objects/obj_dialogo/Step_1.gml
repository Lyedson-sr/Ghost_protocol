if (!ativo) exit;

// ignora o frame de abertura
if (frame_abertura > 0) { frame_abertura--; exit; }

if (keyboard_check_pressed(vk_escape)) { fechar(); exit; }

if (tipo == "terminal") {
    entrada = keyboard_string;
    if (keyboard_check_pressed(vk_enter)) {
        if (entrada != "") executar_comando(entrada);
        entrada = "";
        keyboard_string = "";
    }
} else {
    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter)) fechar();
}