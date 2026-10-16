if (!ativo) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();
var margem = 20;
var altura = (tipo == "terminal") ? 260 : 120;
var x1 = margem, x2 = gw - margem;
var y2 = gh - margem, y1 = y2 - altura;

// fundo
draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(x1, y1, x2, y2, false);
draw_set_alpha(1);

draw_set_color(tipo == "terminal" ? c_lime : c_white);
draw_rectangle(x1, y1, x2, y2, true);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// título
draw_text(x1 + 12, y1 + 8, titulo);

if (tipo == "terminal") {
    var yy = y1 + 32;
    for (var i = 0; i < array_length(historico); i++) {
        draw_text(x1 + 12, yy, historico[i]);
        yy += 16;
    }
    var cursor = (current_time div 500) mod 2 == 0 ? "_" : "";
    draw_text(x1 + 12, y2 - 24, "> " + entrada + cursor);
} else {
    draw_text_ext(x1 + 12, y1 + 32, string_join_ext("\n", linhas), 18, x2 - x1 - 24);
    draw_text(x2 - 160, y2 - 24, "[Esc] continuar");
}
draw_set_color(c_white);