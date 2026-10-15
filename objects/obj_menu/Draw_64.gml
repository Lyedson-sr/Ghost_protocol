/// Evento Desenhar GUI - obj_menu

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _total_botoes = array_length(botoes);

var _bloco_altura = (_total_botoes * botao_altura)
    + ((_total_botoes - 1) * botao_espaco);

var _x1 = (_gui_w - botao_largura) * 0.5;
var _y1 = (_gui_h - _bloco_altura) * 0.5;

// Fundo do menu
var _cor_topo = make_color_rgb(7, 11, 19);
var _cor_base = make_color_rgb(16, 27, 45);

draw_set_alpha(1);
draw_rectangle_color(
    0, 0,
    _gui_w, _gui_h,
    _cor_topo, _cor_topo,
    _cor_base, _cor_base,
    false
);


draw_set_alpha(0.18);
draw_set_color(c_black);
draw_rectangle(26, 26, _gui_w - 26, _gui_h - 26, true);
draw_set_alpha(1);

if (mostrar_controles)
{
    var _painel_w = min(760, _gui_w - 120);
    var _painel_h = min(430, _gui_h - 120);

    var _px1 = (_gui_w - _painel_w) * 0.5;
    var _py1 = (_gui_h - _painel_h) * 0.5;
    var _px2 = _px1 + _painel_w;
    var _py2 = _py1 + _painel_h;

    // Painel principal
    draw_set_color(make_color_rgb(12, 20, 34));
    draw_rectangle(_px1, _py1, _px2, _py2, false);

    draw_set_color(make_color_rgb(118, 190, 255));
    draw_rectangle(_px1, _py1, _px2, _py2, true);

    // Cabecalho
    draw_set_color(make_color_rgb(20, 34, 57));
    draw_rectangle(_px1 + 1, _py1 + 1, _px2 - 1, _py1 + 74, false);

    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_gui_w * 0.5, _py1 + 38, "CONTROLES");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _linha_x1 = _px1 + 44;
    var _linha_x2 = _px2 - 44;
    var _inicio_y = _py1 + 108;
    var _espaco_y = 56;

    // Linhas de comando
    draw_set_color(make_color_rgb(162, 217, 255));
    draw_text(_linha_x1, _inicio_y, "W A S D");
    draw_set_color(c_white);
    draw_text(_linha_x1 + 190, _inicio_y, "mover personagem");

    draw_set_color(make_color_rgb(162, 217, 255));
    draw_text(_linha_x1, _inicio_y + _espaco_y, "C");
    draw_set_color(c_white);
    draw_text(_linha_x1 + 190, _inicio_y + _espaco_y, "abrir/fechar caderno");

    draw_set_color(make_color_rgb(162, 217, 255));
    draw_text(_linha_x1, _inicio_y + _espaco_y * 2, "ESC");
    draw_set_color(c_white);
    draw_text(_linha_x1 + 190, _inicio_y + _espaco_y * 2, "fechar interfaces / voltar menu");

    // Linha divisoria
    draw_set_color(make_color_rgb(73, 117, 166));
    draw_line(_linha_x1, _py2 - 118, _linha_x2, _py2 - 118);

    // Botao VOLTAR
    var _voltar_largura = 220;
    var _voltar_altura = 52;

    var _voltar_x1 = (_gui_w - _voltar_largura) * 0.5;
    var _voltar_y1 = _gui_h - 110;
    var _voltar_x2 = _voltar_x1 + _voltar_largura;
    var _voltar_y2 = _voltar_y1 + _voltar_altura;

    var _cor_btn = make_color_rgb(28, 48, 82);
    var _cor_borda_btn = make_color_rgb(130, 194, 255);

    if (hover_voltar)
    {
        _cor_btn = make_color_rgb(57, 94, 154);
        _cor_borda_btn = c_white;
    }

    draw_set_color(_cor_btn);
    draw_rectangle(_voltar_x1, _voltar_y1, _voltar_x2, _voltar_y2, false);

    draw_set_color(_cor_borda_btn);
    draw_rectangle(_voltar_x1, _voltar_y1, _voltar_x2, _voltar_y2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(_gui_w * 0.5, _voltar_y1 + _voltar_altura * 0.5, "VOLTAR");

    // Restaurar alinhamento padrao
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// Titulo
draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_text(_gui_w * 0.5, _y1 - 90, titulo);

// Moldura do menu
var _mx1 = _x1 - 28;
var _my1 = _y1 - 26;
var _mx2 = _x1 + botao_largura + 28;
var _my2 = _y1 + _bloco_altura + 26;

draw_set_alpha(0.2);
draw_set_color(c_black);
draw_rectangle(_mx1 + 8, _my1 + 8, _mx2 + 8, _my2 + 8, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(13, 22, 36));
draw_rectangle(_mx1, _my1, _mx2, _my2, false);

draw_set_color(make_color_rgb(90, 158, 224));
draw_rectangle(_mx1, _my1, _mx2, _my2, true);

for (var i = 0; i < _total_botoes; i++)
{
    var _topo = _y1 + i * (botao_altura + botao_espaco);
    var _base = _topo + botao_altura;

    var _hover = (i == hover_indice);

    var _cor_fundo = make_color_rgb(28, 48, 82);
    var _cor_borda = make_color_rgb(130, 194, 255);

    if (_hover)
    {
        _cor_fundo = make_color_rgb(54, 90, 150);
        _cor_borda = c_white;
    }

    draw_set_color(_cor_fundo);
    draw_rectangle(_x1, _topo, _x1 + botao_largura, _base, false);

    draw_set_color(_cor_borda);
    draw_rectangle(_x1, _topo, _x1 + botao_largura, _base, true);

    draw_set_color(c_white);
    draw_text(_gui_w * 0.5, _topo + botao_altura * 0.5, botoes[i]);
}

// Restaurar alinhamento padrao
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
