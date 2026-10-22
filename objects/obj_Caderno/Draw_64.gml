/// Evento Desenhar GUI - obj_Caderno

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

// --------------------------------------------------
// 1. FUNDO E MOLDURA EXTERNA
// --------------------------------------------------

draw_set_alpha(1);
draw_set_color(cor_fundo);
draw_rectangle(0, 0, _gw, _gh, false);

// Sombra externa
draw_set_color(c_black);
draw_rectangle(
    _x + 6, _y + 7,
    _x + _w + 6, _y + _h + 7,
    false
);

// Borda externa azul-clara
draw_set_color(cor_borda);
draw_rectangle(_x, _y, _x + _w, _y + _h, false);

// Interior escuro da moldura
draw_set_color(make_color_rgb(21, 29, 48));
draw_rectangle(
    _x + 4, _y + 4,
    _x + _w - 4, _y + _h - 4,
    false
);

// --------------------------------------------------
// 2. MOLDURA DE MADEIRA
// --------------------------------------------------

draw_set_color(cor_madeira);
draw_rectangle(
    _page_x - 7, _page_y - 7,
    _page_x + _page_w * 2 + 18, _page_y + _page_h + 7,
    false
);

draw_set_color(cor_detalhe);
draw_rectangle(
    _page_x - 7, _page_y - 7,
    _page_x + _page_w * 2 + 18, _page_y + _page_h + 7,
    true
);

// --------------------------------------------------
// 3. PAGINAS DO CADERNO
// --------------------------------------------------

draw_set_color(cor_papel);
draw_rectangle(
    _page_x, _page_y,
    _page_x + _page_w, _page_y + _page_h,
    false
);

draw_rectangle(
    _right_x, _page_y,
    _right_x + _page_w, _page_y + _page_h,
    false
);

// Contorno das paginas
draw_set_color(make_color_rgb(158, 118, 70));

draw_rectangle(
    _page_x, _page_y,
    _page_x + _page_w, _page_y + _page_h,
    true
);

draw_rectangle(
    _right_x, _page_y,
    _right_x + _page_w, _page_y + _page_h,
    true
);

// Lombada central
draw_set_color(make_color_rgb(121, 70, 48));
draw_rectangle(
    _page_x + _page_w - 3, _page_y,
    _right_x + 3, _page_y + _page_h,
    false
);

draw_set_color(cor_detalhe);
draw_line(
    _page_x + _page_w, _page_y + 8,
    _page_x + _page_w, _page_y + _page_h - 8
);

// --------------------------------------------------
// 4. TRES ABAS
// --------------------------------------------------

var _nomes_abas = [
    "EVIDENCIAS",
    "FERRAMENTAS",
    "CATALOGO"
];

draw_set_font(-1);

for (var i = 0; i < 3; i++)
{
    var _tx = _x + _tab_margin
        + i * (_tab_w + _tab_gap);

    var _ativa = (aba_atual == i);

    // Sombra da aba
    draw_set_color(c_black);
    draw_rectangle(
        _tx + 3, _tab_y + 4,
        _tx + _tab_w + 3, _tab_y + _tab_h + 4,
        false
    );

    // Fundo da aba
    if (_ativa)
    {
        draw_set_color(make_color_rgb(45, 65, 94));
    }
    else
    {
        draw_set_color(cor_aba);
    }

    draw_rectangle(
        _tx, _tab_y,
        _tx + _tab_w, _tab_y + _tab_h,
        false
    );

    // Contorno
    draw_set_color(_ativa ? cor_borda : cor_detalhe);

    draw_rectangle(
        _tx, _tab_y,
        _tx + _tab_w, _tab_y + _tab_h,
        true
    );

    // Nome da aba
    draw_set_color(c_white);

    draw_text(
        _tx + 12,
        _tab_y + 18,
        _nomes_abas[i]
    );
}

// --------------------------------------------------
// 5. CONTEUDO DA ABA EVIDENCIAS
// --------------------------------------------------

if (aba_atual == 0)
{
    // Cabecalhos
    draw_set_color(cor_texto);

    draw_text(
        _page_x + 25, _page_y + 23,
        "Mapeamento de Evidencias"
    );

    draw_text(
        _right_x + 25, _page_y + 23,
        "SERVIDOR DESCONHECIDO"
    );

    draw_set_color(make_color_rgb(93, 66, 43));

    draw_line(
        _page_x + 20, _page_y + 57,
        _page_x + _page_w - 20, _page_y + 57
    );

    draw_line(
        _right_x + 20, _page_y + 57,
        _right_x + _page_w - 20, _page_y + 57
    );

    // Lista de evidencias
    for (var i = 0; i < array_length(evidencias); i++)
    {
        var _cx = _page_x + 30;
        var _cy = _page_y + 86 + i * 48;

        // Caixa de selecao
        draw_set_color(cor_texto);
        draw_rectangle(
            _cx, _cy,
            _cx + 27, _cy + 27,
            false
        );

        draw_set_color(c_white);
        draw_rectangle(
            _cx + 3, _cy + 3,
            _cx + 24, _cy + 24,
            false
        );

        // Marca de selecao
        if (evidencias[i])
        {
            draw_set_color(make_color_rgb(34, 48, 62));

            draw_line(
                _cx + 5, _cy + 5,
                _cx + 22, _cy + 22
            );

            draw_line(
                _cx + 22, _cy + 5,
                _cx + 5, _cy + 22
            );
        }

        // Texto da evidencia
        draw_set_color(cor_texto);

        draw_text(
            _cx + 36,
            _cy + 4,
            evidencias_nome[i]
        );
    }

    // Descricao da ameaca
    draw_set_color(cor_texto);

    draw_text_ext(
        _right_x + 25,
        _page_y + 82,
        "Um servidor desconhecido foi identificado na rede interna. Descubra quais serviços estão expostos e desligue-o.",
        16,
        _page_w - 50
    );

    // Botao de confirmacao
    var _bx = _right_x + 24;
    var _by = _page_y + _page_h - 82;
    var _bw = _page_w - 48;
    var _bh = 46;

    draw_set_color(make_color_rgb(54, 42, 44));

    draw_rectangle(
        _bx + 3, _by + 3,
        _bx + _bw + 3, _by + _bh + 3,
        false
    );

    draw_set_color(
        ameaca_confirmada
        ? make_color_rgb(48, 111, 74)
        : make_color_rgb(117, 67, 70)
    );

    draw_rectangle(
        _bx, _by,
        _bx + _bw, _by + _bh,
        false
    );

    draw_set_color(
        (global.incidente_001_concluido
            && array_length(evidencias) > 0
            && evidencias[0]
            && evidencias[1]
            && evidencias[2])
        ? cor_borda
        : make_color_rgb(130, 130, 110)
    );

    draw_rectangle(
        _bx, _by,
        _bx + _bw, _by + _bh,
        true
    );

    draw_set_color(c_white);

    if (ameaca_confirmada)
    {
        draw_text(
            _bx + 25, _by + 13,
            "Ameaca Confirmada!"
        );
    }
    else if (!global.incidente_001_concluido)
    {
        draw_text(
            _bx + 25, _by + 13,
            "Aguardando neutralizacao"
        );
    }
    else if (!evidencias[0] || !evidencias[1] || !evidencias[2])
    {
        draw_text(
            _bx + 25, _by + 13,
            "Marque todas as evidencias"
        );
    }
    else
    {
        draw_text(
            _bx + 25, _by + 13,
            "Confirmar Ameaca"
        );
    }

    // Numero da pagina
    draw_set_color(cor_texto);

    draw_text(
        _page_x + 12,
        _page_y + _page_h - 28,
        "Pagina 1"
    );
}

// --------------------------------------------------
// 6. CONTEUDO DA ABA FERRAMENTAS
// --------------------------------------------------

else if (aba_atual == 1)
{
    draw_set_color(cor_texto);

    draw_text(
        _page_x + 25, _page_y + 23,
        "Ferramentas de Investigacao"
    );

    draw_line(
        _page_x + 20, _page_y + 57,
        _page_x + _page_w - 20, _page_y + 57
    );

    var _ferramentas = [
        "Nmap - Descoberta de redes"
    ];

    for (var i = 0; i < array_length(_ferramentas); i++)
    {
        var _fy = _page_y + 82 + i * 48;

        draw_set_color(make_color_rgb(225, 211, 161));

        draw_rectangle(
            _page_x + 20, _fy,
            _page_x + _page_w - 20, _fy + 36,
            false
        );

        draw_set_color(cor_texto);

        draw_text(
            _page_x + 30, _fy + 10,
            _ferramentas[i]
        );
    }

    draw_text(_page_x + 25, _page_y + 126, "nmap <Ip_do_alvo>");
    draw_text(_page_x + 25, _page_y + 150, "# verificar portas abertas");

    draw_text(_page_x + 25, _page_y + 194, "Uso da ferramenta");
    draw_line(
        _page_x + 20, _page_y + 230,
        _page_x + _page_w - 20, _page_y + 230
    );
    draw_text_ext(
        _page_x + 25,
        _page_y + 248,
        "Mapear redes, descobrir hosts, verificar portas abertas e identificar serviços ou sistemas operacionais.",
        16,
        _page_w - 50
    );

    draw_set_color(cor_texto);

    draw_text(
        _right_x + 25, _page_y + 23,
        "Linux"
    );

    draw_line(
        _right_x + 20, _page_y + 57,
        _right_x + _page_w - 20, _page_y + 57
    );

    draw_text(_right_x + 25, _page_y + 62, "ls");
    draw_text(_right_x + 25, _page_y + 86, "#listar arquivos e diretórios");
    draw_text(_right_x + 25, _page_y + 110, "cat");
    draw_text(_right_x + 25, _page_y + 134, "#exibir conteúdo de arquivos");

    draw_text(_right_x + 25, _page_y + 178, "SSH");
    draw_line(
        _right_x + 20, _page_y + 214,
        _right_x + _page_w - 20, _page_y + 214
    );
    draw_text(_right_x + 25, _page_y + 232, "ssh usuario@Ip_ou_hostname");
    draw_text(_right_x + 25, _page_y + 256, "#exibir conteúdo de arquivos");

    draw_text(
        _page_x + 12,
        _page_y + _page_h - 28,
        "Pagina 2"
    );
}

// --------------------------------------------------
// 7. CONTEUDO DA ABA CATALOGO
// --------------------------------------------------

else if (aba_atual == 2)
{
    draw_set_color(cor_texto);

    draw_text(
        _page_x + 25, _page_y + 23,
        "Catalogo de Ameacas"
    );

    draw_line(
        _page_x + 20, _page_y + 57,
        _page_x + _page_w - 20, _page_y + 57
    );

    var _ameacas = [
        "Dumpster Diving"
    ];

    for (var i = 0; i < array_length(_ameacas); i++)
    {
        var _ay = _page_y + 78 + i * 43;

        draw_set_color(make_color_rgb(225, 211, 161));

        draw_rectangle(
            _page_x + 20, _ay,
            _page_x + _page_w - 20, _ay + 33,
            false
        );

        draw_set_color(cor_texto);

        draw_text(
            _page_x + 30, _ay + 8,
            _ameacas[i]
        );
    }

    draw_set_color(cor_texto);

    draw_text(
        _right_x + 25, _page_y + 23,
        "Sobre o Catalogo"
    );

    draw_line(
        _right_x + 20, _page_y + 57,
        _right_x + _page_w - 20, _page_y + 57
    );

    draw_text_ext(
        _right_x + 25,
        _page_y + 82,
        "Consulte aqui as categorias de ameacas identificadas durante a investigacao.",
        20,
        _page_w - 50
    );

    draw_text_ext(
        _page_x + 25,
        _page_y + 126,
        "Tecnica de reconhecimento em que um atacante procura informacoes uteis em materiais...",
        18,
        _page_w - 50
    );

    draw_text(
        _page_x + 12,
        _page_y + _page_h - 28,
        "Pagina 3"
    );
}

// Restaurar configuracoes de desenho
draw_set_alpha(1);
draw_set_color(c_white);