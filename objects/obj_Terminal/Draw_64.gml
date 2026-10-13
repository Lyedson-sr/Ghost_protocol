// Posição fixa no ecrã (independente da câmara)
var _x = 150; 
var _y = 100;
var _largura = 500;
var _altura = 300;

// Desenhar fundo preto do terminal com borda branca
draw_set_color(c_black);
draw_rectangle(_x, _y, _x + _largura, _y + _altura, false);
draw_set_color(c_white);
draw_rectangle(_x, _y, _x + _largura, _y + _altura, true);

// Desenhar o texto do histórico e o que está a ser digitado
draw_set_font(-1); 
draw_set_color(c_lime); // Cor verde estilo hacker

var _texto_completo = historico + "> " + input_texto + "_";
draw_text_ext(_x + 15, _y + 15, _texto_completo, 20, _largura - 30);