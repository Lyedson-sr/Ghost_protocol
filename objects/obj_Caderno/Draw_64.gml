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
var _tab_w = (_w - 2 * _tab_margin - (total_abas - 1) * _tab_gap) / total_abas;

var _page_x = _x + 28;
var _page_y = _y + 88;
var _page_w = (_w - 56) / 2;
var _page_h = _h - 108;

var _right_x = _page_x + _page_w + 4;
var _fonte_anterior = draw_get_font();
draw_set_font(fonte_caderno);

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
// 4. ABAS
// --------------------------------------------------

var _nomes_abas = [
    "EVIDENCIAS",
    "FERRAMENTAS",
    "CATALOGO",
    "GLOSSARIO"
];

for (var i = 0; i < total_abas; i++)
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
    var _fase2 = global.incidente_001_confirmado && global.incidente_005_concluido;
    var _evidencias_atuais = _fase2 ? evidencias_fase2 : evidencias;
    for (var i = 0; i < array_length(evidencias); i++)
    {
        var _cx = _page_x + 30;
        var _cy = _page_y + 86 + i * evidencia_espaco;

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
        if (_evidencias_atuais[i])
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

        // Dica de onde procurar
        if (evidencias_dica[i] != "")
        {
            draw_set_color(cor_secundaria);
            texto_bloco(_cx + 36, _cy + 30, evidencias_dica[i], _page_x + _page_w - 20 - (_cx + 36), "");
            draw_set_font(fonte_caderno);
        }
    }

    // Objetivo e roteiro de investigacao
    draw_set_color(cor_texto);

    var _rl = _page_w - 50;
    var _ry = _page_y + 70;
    _ry = texto_bloco(_right_x + 25, _ry, "Objetivo: entrar no servidor e desliga-lo.", _rl, "Objetivo:");
    _ry += 8;
    _ry = texto_bloco(_right_x + 25, _ry, "Roteiro de investigacao", _rl, "Roteiro de investigacao");
    _ry = texto_bloco(_right_x + 25, _ry, "1. Descubra o IP do servidor.", _rl, "");
    _ry = texto_bloco(_right_x + 25, _ry, "2. Use o nmap para ver quais portas estao abertas.", _rl, "");
    _ry = texto_bloco(_right_x + 25, _ry, "3. Porta de ssh aberta? Da para entrar, mas voce vai precisar de usuario e senha.", _rl, "");
    _ry = texto_bloco(_right_x + 25, _ry, "4. Procure as credenciais pela sala.", _rl, "");
    _ry = texto_bloco(_right_x + 25, _ry, "5. Entre com ssh e explore os arquivos com ls e cat.", _rl, "");
    _ry = texto_bloco(_right_x + 25, _ry, "6. Siga as instrucoes que encontrar.", _rl, "");
    draw_set_font(fonte_caderno);

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

    var _pode_confirmar = ((_fase2 && global.incidente_005_concluido)
        || (!_fase2 && global.incidente_001_concluido))
        && array_length(evidencias) > 0
        && _evidencias_atuais[0]
        && _evidencias_atuais[1]
        && _evidencias_atuais[2];
    if (_pode_confirmar) draw_set_color(cor_borda);
    else draw_set_color(make_color_rgb(130, 130, 110));

    draw_rectangle(
        _bx, _by,
        _bx + _bw, _by + _bh,
        true
    );

    draw_set_color(c_white);

    if (_fase2 && global.incidente_005_confirmado)
    {
        draw_text(
            _bx + 25, _by + 13,
            "Fase 2 Confirmada!"
        );
    }
    else if (!_fase2 && ameaca_confirmada)
    {
        draw_text(
            _bx + 25, _by + 13,
            "Ameaca Confirmada!"
        );
    }
    else if (_fase2 && !global.incidente_005_concluido)
    {
        draw_text(
            _bx + 25, _by + 13,
            "Aguardando conclusao da fase 2"
        );
    }
    else if (!_fase2 && !global.incidente_001_concluido)
    {
        draw_text(
            _bx + 25, _by + 13,
            "Aguardando neutralizacao"
        );
    }
    else if (!_evidencias_atuais[0] || !_evidencias_atuais[1] || !_evidencias_atuais[2])
    {
        draw_text(
            _bx + 25, _by + 13,
            "Marque todas as evidencias"
        );
    }
    else
    {
        var _texto_botao = "Confirmar Ameaca";
        if (_fase2) _texto_botao = "Confirmar Fase 2";
        draw_text(
            _bx + 25, _by + 13,
            _texto_botao
        );
    }
}

// --------------------------------------------------
// 6. CONTEUDO DA ABA FERRAMENTAS
// --------------------------------------------------

else if (aba_atual == 1)
{
    draw_set_color(cor_texto);

    // Ordem das paginas segue o caminho da fase: descobrir -> entrar -> explorar -> anotar
    var _titulo_esq = (ferramentas_pagina == 0) ? "1. Descobrir" : "3. Explorar";
    var _titulo_dir = (ferramentas_pagina == 0) ? "2. Entrar" : "4. Anotar";

    draw_text(_page_x + 25, _page_y + 23, _titulo_esq);
    draw_text(_right_x + 25, _page_y + 23, _titulo_dir);

    draw_line(
        _page_x + 20, _page_y + 57,
        _page_x + _page_w - 20, _page_y + 57
    );
    draw_line(
        _right_x + 20, _page_y + 57,
        _right_x + _page_w - 20, _page_y + 57
    );

    var _fl = _page_w - 50;
    var _fy;

    if (ferramentas_pagina == 0)
    {
        // ---------- Esquerda: Nmap ----------
        _fy = caixa_titulo(_page_x + 20, _page_y + 70, _page_w - 40, "Nmap - Portas abertas");

        draw_set_color(cor_comando);
        _fy = texto_comando(_page_x + 25, _fy, "nmap IP");
        draw_set_color(cor_secundaria);
        _fy = texto_comando(_page_x + 25, _fy, "Exemplo: nmap 10.0.0.5");
        _fy += 10;

        draw_set_color(cor_texto);
        _fy = texto_bloco(_page_x + 25, _fy, "Como ler o resultado:", _fl, "Como ler o resultado:");
        draw_set_color(cor_comando);
        _fy = texto_comando(_page_x + 25, _fy, "PORT    numero da porta");
        _fy = texto_comando(_page_x + 25, _fy, "STATE   open = aberta");
        _fy = texto_comando(_page_x + 25, _fy, "SERVICE servico que esta ali");
        _fy += 10;

        draw_set_color(cor_texto);
        texto_bloco(_page_x + 25, _fy, "Uma porta aberta e um caminho possivel para entrar no computador.", _fl, "");

        // ---------- Direita: SSH ----------
        _fy = caixa_titulo(_right_x + 20, _page_y + 70, _page_w - 40, "SSH - Acesso remoto");

        draw_set_color(cor_comando);
        _fy = texto_comando(_right_x + 25, _fy, "ssh usuario@IP");
        draw_set_color(cor_secundaria);
        _fy = texto_comando(_right_x + 25, _fy, "Exemplo: ssh maria@10.0.0.5");
        _fy += 10;

        draw_set_color(cor_texto);
        _fy = texto_bloco(_right_x + 25, _fy, "Depois, o terminal pede a senha (password:). A senha NAO aparece enquanto voce digita. Isso e normal: digite e aperte Enter.", _fl, "");
        _fy += 10;
        texto_bloco(_right_x + 25, _fy, "Deu certo? O inicio da linha muda de kali@kali para usuario@servidor. Agora voce esta dentro do servidor.", _fl, "");
    }
    else
    {
        // ---------- Esquerda: ls e cat ----------
        _fy = caixa_titulo(_page_x + 20, _page_y + 70, _page_w - 40, "ls e cat - Ler arquivos");

        draw_set_color(cor_comando);
        _fy = texto_comando(_page_x + 25, _fy, "ls");
        draw_set_color(cor_texto);
        _fy = texto_bloco(_page_x + 25, _fy, "Lista os arquivos da pasta atual.", _fl, "");
        _fy += 10;

        draw_set_color(cor_comando);
        _fy = texto_comando(_page_x + 25, _fy, "cat arquivo");
        draw_set_color(cor_texto);
        _fy = texto_bloco(_page_x + 25, _fy, "Mostra o que esta escrito dentro do arquivo.", _fl, "");
        draw_set_color(cor_secundaria);
        _fy = texto_comando(_page_x + 25, _fy, "Exemplo: cat recado.txt");
        _fy += 10;

        draw_set_color(cor_texto);
        texto_bloco(_page_x + 25, _fy, "Arquivos .txt costumam guardar anotacoes e instrucoes.", _fl, "");

        // ---------- Direita: Bloco de notas ----------
        _fy = caixa_titulo(_right_x + 20, _page_y + 70, _page_w - 40, "Bloco de notas");

        draw_set_color(cor_comando);
        _fy = texto_comando(_right_x + 25, _fy, "Tecla N");
        draw_set_color(cor_texto);
        _fy = texto_bloco(_right_x + 25, _fy, "Abre o bloco para anotar pistas.", _fl, "");
        _fy += 10;

        draw_set_color(cor_comando);
        _fy = texto_comando(_right_x + 25, _fy, "notas");
        draw_set_color(cor_texto);
        _fy = texto_bloco(_right_x + 25, _fy, "Digitado no terminal, mostra o que voce anotou.", _fl, "");
        _fy += 10;

        texto_bloco(_right_x + 25, _fy, "Dica: anote o IP, o usuario e a senha assim que encontrar. Voce vai precisar deles no terminal.", _fl, "Dica:");
    }

    draw_set_font(fonte_caderno);

    if (ferramentas_total_paginas > 1)
    {
        draw_set_color(make_color_rgb(158, 118, 70));

        // Setas sem pagina naquela direcao ficam apagadas
        var _alpha_prev = (ferramentas_pagina > 0) ? 1 : 0.25;
        var _alpha_next = (ferramentas_pagina < ferramentas_total_paginas - 1) ? 1 : 0.25;

        // Triangulo de voltar
        draw_set_alpha(_alpha_prev);
        draw_triangle(
            _right_x + _page_w - 52, _page_y + _page_h - 34,
            _right_x + _page_w - 74, _page_y + _page_h - 22,
            _right_x + _page_w - 52, _page_y + _page_h - 10,
            true
        );
        draw_triangle(
            _right_x + _page_w - 51, _page_y + _page_h - 34,
            _right_x + _page_w - 73, _page_y + _page_h - 22,
            _right_x + _page_w - 51, _page_y + _page_h - 10,
            true
        );

        // Triangulo de avancar
        draw_set_alpha(_alpha_next);
        draw_triangle(
            _right_x + _page_w - 40, _page_y + _page_h - 34,
            _right_x + _page_w - 18, _page_y + _page_h - 22,
            _right_x + _page_w - 40, _page_y + _page_h - 10,
            true
        );
        draw_triangle(
            _right_x + _page_w - 41, _page_y + _page_h - 34,
            _right_x + _page_w - 19, _page_y + _page_h - 22,
            _right_x + _page_w - 41, _page_y + _page_h - 10,
            true
        );
        draw_set_alpha(1);

        if (nav_anim_prev > 0)
        {
            var _pulso_prev = 2 + floor(nav_anim_prev / 2);
            draw_set_alpha(0.7);
            draw_set_color(cor_detalhe);
            draw_triangle(
                _right_x + _page_w - 52 + _pulso_prev, _page_y + _page_h - 34 - _pulso_prev,
                _right_x + _page_w - 74 - _pulso_prev, _page_y + _page_h - 22,
                _right_x + _page_w - 52 + _pulso_prev, _page_y + _page_h - 10 + _pulso_prev,
                true
            );
            draw_set_alpha(0.35);
            draw_triangle(
                _right_x + _page_w - 52 + _pulso_prev + 2, _page_y + _page_h - 34 - _pulso_prev - 2,
                _right_x + _page_w - 74 - _pulso_prev - 2, _page_y + _page_h - 22,
                _right_x + _page_w - 52 + _pulso_prev + 2, _page_y + _page_h - 10 + _pulso_prev + 2,
                true
            );
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(158, 118, 70));
        }

        if (nav_anim_next > 0)
        {
            var _pulso_next = 2 + floor(nav_anim_next / 2);
            draw_set_alpha(0.7);
            draw_set_color(cor_detalhe);
            draw_triangle(
                _right_x + _page_w - 40 - _pulso_next, _page_y + _page_h - 34 - _pulso_next,
                _right_x + _page_w - 18 + _pulso_next, _page_y + _page_h - 22,
                _right_x + _page_w - 40 - _pulso_next, _page_y + _page_h - 10 + _pulso_next,
                true
            );
            draw_set_alpha(0.35);
            draw_triangle(
                _right_x + _page_w - 40 - _pulso_next - 2, _page_y + _page_h - 34 - _pulso_next - 2,
                _right_x + _page_w - 18 + _pulso_next + 2, _page_y + _page_h - 22,
                _right_x + _page_w - 40 - _pulso_next - 2, _page_y + _page_h - 10 + _pulso_next + 2,
                true
            );
            draw_set_alpha(1);
            draw_set_color(make_color_rgb(158, 118, 70));
        }
    }
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
        "Como se proteger"
    );

    draw_line(
        _right_x + 20, _page_y + 57,
        _right_x + _page_w - 20, _page_y + 57
    );

    var _cl = _page_w - 50;

    // ---------- Esquerda: o que e ----------
    var _cy = _page_y + 124;
    draw_set_color(cor_secundaria);
    _cy = texto_bloco(_page_x + 25, _cy, "(\"mergulho no lixo\")", _cl, "");
    _cy += 10;
    draw_set_color(cor_texto);
    _cy = texto_bloco(_page_x + 25, _cy, "Tecnica em que alguem procura informacoes uteis no LIXO de uma empresa: senhas anotadas, documentos, relatorios.", _cl, "");
    _cy += 10;
    texto_bloco(_page_x + 25, _cy, "Parece simples, mas funciona: muita gente joga fora papeis com dados importantes sem destrui-los.", _cl, "");

    // ---------- Direita: como se proteger ----------
    _cy = _page_y + 70;
    _cy = texto_bloco(_right_x + 25, _cy, "- Rasgue ou triture papeis com informacoes sensiveis.", _cl, "");
    _cy += 6;
    _cy = texto_bloco(_right_x + 25, _cy, "- Nunca anote senhas em papeis soltos.", _cl, "");
    _cy += 6;
    _cy = texto_bloco(_right_x + 25, _cy, "- Use um gerenciador de senhas.", _cl, "");
    _cy += 16;
    draw_set_color(cor_secundaria);
    texto_bloco(_right_x + 25, _cy, "Seguranca nao e so tecnologia: tambem depende dos habitos das pessoas.", _cl, "");

    draw_set_color(cor_texto);
    draw_set_font(fonte_caderno);
}

// --------------------------------------------------
// 8. CONTEUDO DA ABA GLOSSARIO
// --------------------------------------------------

else if (aba_atual == 3)
{
    draw_set_color(cor_texto);

    draw_text(_page_x + 25, _page_y + 23, "Glossario");
    draw_text(_right_x + 25, _page_y + 23, "Termos da Fase 1");

    draw_line(
        _page_x + 20, _page_y + 57,
        _page_x + _page_w - 20, _page_y + 57
    );
    draw_line(
        _right_x + 20, _page_y + 57,
        _right_x + _page_w - 20, _page_y + 57
    );

    // Cada termo: [nome, definicao, comparacao do dia a dia]
    var _termos = [
        ["IP", "IP: o endereco de um computador na rede. Ex: 192.168.1.20", "Como o endereco de uma casa: e por ele que voce encontra quem procura."],
        ["Porta", "Porta: um canal de entrada do computador. Cada servico usa uma porta com um numero.", "Como as portas de um predio: cada uma leva a uma sala diferente."],
        ["Servico", "Servico: programa que espera conexoes numa porta. Ex: ssh (porta 22) e site (porta 80).", "Como um atendente esperando clientes atras de um balcao."],
        ["SSH", "SSH: forma segura de entrar em outro computador e usar o terminal dele, a distancia. Precisa de usuario e senha.", "Como ter a chave da casa: com ela, voce entra e mexe em tudo."],
        ["Terminal", "Terminal: a tela onde voce digita comandos em vez de clicar.", "Como dar ordens por escrito ao computador."],
        ["Diretorio", "Diretorio: o mesmo que pasta. Guarda arquivos.", "Como uma gaveta de arquivo."]
    ];

    var _gl = _page_w - 50;
    var _metade = ceil(array_length(_termos) / 2);
    var _gy_esq = _page_y + 70;
    var _gy_dir = _page_y + 70;

    for (var i = 0; i < array_length(_termos); i++)
    {
        var _na_esquerda = (i < _metade);
        var _gx = _na_esquerda ? _page_x + 25 : _right_x + 25;
        var _gy = _na_esquerda ? _gy_esq : _gy_dir;
        var _t = _termos[i];

        draw_set_color(cor_texto);
        _gy = texto_bloco(_gx, _gy, _t[1], _gl, _t[0] + ":");
        draw_set_color(cor_secundaria);
        _gy = texto_bloco(_gx, _gy, _t[2], _gl, "");
        _gy += 12;

        if (_na_esquerda) _gy_esq = _gy;
        else _gy_dir = _gy;
    }

    draw_set_color(cor_texto);
    draw_set_font(fonte_caderno);
}

// Restaurar configuracoes de desenho
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(_fonte_anterior);