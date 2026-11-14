/// Evento Desenhar GUI - caderno da fase 5

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _w = min(820, _gw - 40);
var _h = min(500, _gh - 40);
var _x = (_gw - _w) / 2;
var _y = (_gh - _h) / 2;
var _tab_y = _y + 20;
var _tab_h = 54;
var _tab_gap = 8;
var _tab_margin = 28;
var _tab_w = (_w - 2 * _tab_margin - 2 * _tab_gap) / 3;
var _page_x = _x + 28;
var _page_y = _y + 88;
var _page_w = (_w - 56) / 2;
var _page_h = _h - 108;
var _right_x = _page_x + _page_w + 4;

draw_set_color(cor_fundo);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_color(c_black);
draw_rectangle(_x + 6, _y + 7, _x + _w + 6, _y + _h + 7, false);
draw_set_color(cor_borda);
draw_rectangle(_x, _y, _x + _w, _y + _h, false);
draw_set_color(make_color_rgb(21, 29, 48));
draw_rectangle(_x + 4, _y + 4, _x + _w - 4, _y + _h - 4, false);

draw_set_color(cor_madeira);
draw_rectangle(_page_x - 7, _page_y - 7, _page_x + _page_w * 2 + 18, _page_y + _page_h + 7, false);
draw_set_color(cor_detalhe);
draw_rectangle(_page_x - 7, _page_y - 7, _page_x + _page_w * 2 + 18, _page_y + _page_h + 7, true);
draw_set_color(cor_papel);
draw_rectangle(_page_x, _page_y, _page_x + _page_w, _page_y + _page_h, false);
draw_rectangle(_right_x, _page_y, _right_x + _page_w, _page_y + _page_h, false);
draw_set_color(make_color_rgb(158, 118, 70));
draw_rectangle(_page_x, _page_y, _page_x + _page_w, _page_y + _page_h, true);
draw_rectangle(_right_x, _page_y, _right_x + _page_w, _page_y + _page_h, true);
draw_set_color(make_color_rgb(121, 70, 48));
draw_rectangle(_page_x + _page_w - 3, _page_y, _right_x + 3, _page_y + _page_h, false);
draw_set_color(cor_detalhe);
draw_line(_page_x + _page_w, _page_y + 8, _page_x + _page_w, _page_y + _page_h - 8);

var _nomes_abas = ["EVIDENCIAS", "FERRAMENTAS", "CATALOGO"];
for (var i = 0; i < 3; i++)
{
    var _tx = _x + _tab_margin + i * (_tab_w + _tab_gap);
    draw_set_color(i == aba_atual ? make_color_rgb(45, 65, 94) : cor_aba);
    draw_rectangle(_tx, _tab_y, _tx + _tab_w, _tab_y + _tab_h, false);
    draw_set_color(i == aba_atual ? cor_borda : cor_detalhe);
    draw_rectangle(_tx, _tab_y, _tx + _tab_w, _tab_y + _tab_h, true);
    draw_set_color(c_white);
    draw_text(_tx + 12, _tab_y + 18, _nomes_abas[i]);
}

draw_set_color(cor_texto);
if (aba_atual == 0)
{
    draw_text(_page_x + 25, _page_y + 23, "Mapeamento de Evidencias");
    draw_text(_right_x + 25, _page_y + 23, "O ARQUIVO EXPOSTO");
    draw_set_color(make_color_rgb(93, 66, 43));
    draw_line(_page_x + 20, _page_y + 57, _page_x + _page_w - 20, _page_y + 57);
    draw_line(_right_x + 20, _page_y + 57, _right_x + _page_w - 20, _page_y + 57);
    for (var j = 0; j < array_length(evidencias); j++)
    {
        var _cx = _page_x + 30;
        var _cy = _page_y + 86 + j * 48;
        draw_set_color(cor_texto);
        draw_rectangle(_cx, _cy, _cx + 27, _cy + 27, false);
        draw_set_color(c_white);
        draw_rectangle(_cx + 3, _cy + 3, _cx + 24, _cy + 24, false);
        if (evidencias[j])
        {
            draw_set_color(make_color_rgb(34, 48, 62));
            draw_line(_cx + 5, _cy + 5, _cx + 22, _cy + 22);
            draw_line(_cx + 22, _cy + 5, _cx + 5, _cy + 22);
        }
        draw_set_color(cor_texto);
        draw_text(_cx + 36, _cy + 4, evidencias_nome[j]);
    }
    draw_text_ext(_right_x + 25, _page_y + 82,
        "Dois computadores apresentam acesso a um arquivo que deveria estar protegido no servidor Linux.",
        16, _page_w - 50);

    var _bx = _right_x + 24;
    var _by = _page_y + _page_h - 82;
    var _bw = _page_w - 48;
    draw_set_color(global.incidente_005_confirmado ? make_color_rgb(48, 111, 74) : make_color_rgb(117, 67, 70));
    draw_rectangle(_bx, _by, _bx + _bw, _by + 46, false);
    draw_set_color(global.incidente_005_concluido && evidencias[0] && evidencias[1] ? cor_borda : make_color_rgb(130, 130, 110));
    draw_rectangle(_bx, _by, _bx + _bw, _by + 46, true);
    draw_set_color(c_white);
    var _texto = "Confirmar Ameaca";
    if (global.incidente_005_confirmado) _texto = "Ameaca Confirmada!";
    else if (!global.incidente_005_concluido) _texto = "Aguardando analise do terminal";
    else if (!evidencias[0] || !evidencias[1]) _texto = "Marque todas as evidencias";
    draw_text(_bx + 25, _by + 13, _texto);
    draw_set_color(cor_texto);
    draw_text(_page_x + 12, _page_y + _page_h - 28, "Pagina 1");
}
else if (aba_atual == 1)
{
    draw_text(_page_x + 25, _page_y + 23, "Ferramentas de Investigacao");
    draw_text(_right_x + 25, _page_y + 23, "Permissoes e Grupos");
    draw_set_color(make_color_rgb(93, 66, 43));
    draw_line(_page_x + 20, _page_y + 57, _page_x + _page_w - 20, _page_y + 57);
    draw_line(_right_x + 20, _page_y + 57, _right_x + _page_w - 20, _page_y + 57);
    draw_set_color(cor_texto);
    draw_text(_page_x + 25, _page_y + 84, "Comandos de investigacao");
    draw_text(_page_x + 25, _page_y + 126, "ls -l -> exibe arquivos e permissoes");
    draw_text(_page_x + 25, _page_y + 168, "groups -> exibe os grupos de um usuario.");
    draw_text_ext(_page_x + 25, _page_y + 218,
        "gpasswd -d -> remove um usuario de um grupo.",
        16, _page_w - 50);
    draw_text_ext(_right_x + 25, _page_y + 82,
        "As permissoes definem quem pode ler, modificar ou executar arquivos. r = leitura, w = escrita, x = execucao. Os grupos permitem compartilhar permissoes entre usuarios.",
        16, _page_w - 50);
    draw_text(_page_x + 12, _page_y + _page_h - 28, "Pagina 2");
}
else
{
    draw_text(_page_x + 25, _page_y + 23, "Catalogo de Ameacas");
    draw_text(_right_x + 25, _page_y + 23, "Sobre o Catalogo");
    draw_set_color(make_color_rgb(93, 66, 43));
    draw_line(_page_x + 20, _page_y + 57, _page_x + _page_w - 20, _page_y + 57);
    draw_line(_right_x + 20, _page_y + 57, _right_x + _page_w - 20, _page_y + 57);
    draw_set_color(cor_texto);
    draw_text(_page_x + 25, _page_y + 84, "Exposicao de informacoes");
    draw_text_ext(_page_x + 25, _page_y + 126,
        "Usuarios de grupos nao autorizados podem acessar arquivos internos da aplicacao devido a permissoes inadequadas.",
        16, _page_w - 50);
    draw_text_ext(_right_x + 25, _page_y + 82,
        "Consulte aqui as categorias de ameacas identificadas durante a investigacao.",
        16, _page_w - 50);
    draw_text(_page_x + 12, _page_y + _page_h - 28, "Pagina 3");
}
