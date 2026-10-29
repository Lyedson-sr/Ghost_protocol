/// Create - obj_Terminal
keyboard_string = "";
input_texto = "";

if (!variable_global_exists("dialogo_aberto")) global.dialogo_aberto = false;
if (!variable_global_exists("incidente_001_concluido")) global.incidente_001_concluido = false;
if (!variable_global_exists("incidente_001_confirmado")) global.incidente_001_confirmado = false;

// [NOVO] flags dos demais incidentes e estado persistente das dicas
for (var _n = 2; _n <= 5; _n++) {
    var _g = "incidente_00" + string(_n) + "_concluido";
    if (!variable_global_exists(_g)) variable_global_set(_g, false);
}
var _pcs = ["pc1", "pc2", "pc3"];
for (var _k = 0; _k < 3; _k++) {
    var _gp = "incidente_002_" + _pcs[_k] + "_ok";
    if (!variable_global_exists(_gp)) variable_global_set(_gp, false);
}
if (!variable_global_exists("term_estado")) global.term_estado = {};

// [NOVO] qual computador e este: "kali" (padrao), "pc1", "pc2" ou "pc3"
if (!variable_instance_exists(id, "terminal_id")) terminal_id = "kali";
eh_kali = (terminal_id == "kali");

// Aparencia
terminal_largura = 700;
terminal_altura  = 400;
terminal_barra   = 32;
terminal_margem_x = 12;
terminal_margem_y = 10;
terminal_espacamento = 20;
terminal_x = (display_get_gui_width()  - terminal_largura) / 2;
terminal_y = (display_get_gui_height() - terminal_altura)  / 2;

cor_fundo = make_color_rgb(12, 12, 12);
cor_barra = make_color_rgb(45, 45, 45);
cor_verde = make_color_rgb(40, 200, 40);
cor_azul  = make_color_rgb(80, 120, 255);
cor_texto = make_color_rgb(204, 204, 204);
cor_dica  = make_color_rgb(240, 200, 60);   // [NOVO]

// Sessao / prompt
usuario = "kali"; host = "kali"; diretorio = "~";
grupos_proprios = "";
switch (terminal_id) {   // [NOVO]
    case "pc1": usuario = "robot1"; host = "pc1"; grupos_proprios = "robot1 api-testers"; break;
    case "pc2": usuario = "robot2"; host = "pc2"; grupos_proprios = "robot2 api-testers"; break;
    case "pc3": usuario = "admin";  host = "pc3"; grupos_proprios = "admin sudo"; break;
}
usuario_local = usuario; host_local = host;
sessao = "local";            // "local" ou "ssh"
modo = "normal";             // "normal" ou "senha"
tentativas = 0;
servidor20_ligado = !global.incidente_001_concluido;   // [ALTERADO] persiste apos poweroff

// Dados do incidente #001
ip_servidor = "192.168.1.20";
usuario_ssh = "operador";
senha_correta = "r0b0t-2026";   // confira com o caderno
senha_prompt = usuario_ssh + "@" + ip_servidor + "'s password: ";

// Historico
linhas = [
    { tipo: "out", texto: "Terminal v1.0" },
    { tipo: "out", texto: "Digite 'ajuda' para ver os comandos." },
    { tipo: "out", texto: "" }
];
scroll_linha = 0;
scroll_velocidade = 3;

// Execucao com demora
ocupado = false;
timer = 0;
saida_pendente = [];
acao_pendente = "";
conclusoes_pendentes = [];   // [NOVO]

// ---------- Comandos (tabelas exatas) ----------
cmds_local = {};
cmds_ssh = {};

if (eh_kali) {
    // Incidente #001: nmap
    variable_struct_set(cmds_local, "nmap 192.168.1.20", { duracao: 10, acao: "", saida: [
        "Nmap scan report for 192.168.1.20",
        "Host is up (0.21s latency).",
        "PORT   STATE SERVICE",
        "22/tcp open  ssh",
        "80/tcp open  http",
        "",
        "Nmap done: 1 IP address (1 host up) scanned in 0.53 seconds"
    ]});

    // Incidente #005: nmap -sV
    var _sv = { duracao: 10, acao: "", saida: [
        "Nmap scan report for 192.168.1.50",
        "Host is up (0.21s latency).",
        "PORT   STATE SERVICE VERSION",
        "22/tcp open  ssh     OpenSSH 6.6.1p1",
        "80/tcp open  http    Apache httpd 2.4.7",
        "",
        "Nmap done: 1 IP address (1 host up) scanned in 0.53 seconds"
    ]};
    variable_struct_set(cmds_local, "nmap -sv 192.168.1.50", _sv);

    // Incidente #005: script vulners
    var _vul = { duracao: 10, acao: "", saida: [
        "Nmap scan report for 192.168.1.50",
        "Host is up (0.14s latency).",
        "PORT   STATE SERVICE VERSION",
        "22/tcp open  ssh     OpenSSH 6.6.1p1",
        "| vulners:",
        "|   CVE-2016-3115  6.4  https://vulners.com/cve/CVE-2016-3115",
        "|   CVE-2015-6563  6.4  https://vulners.com/cve/CVE-2015-6563",
        "|_  CVE-2016-10011 6.2  https://vulners.com/cve/CVE-2016-10011",
        "PORT   STATE SERVICE VERSION",
        "80/tcp open  http    Apache httpd 2.4.7",
        "| vulners:",
        "|   CVE-2016-8612  4.3  https://vulners.com/cve/CVE-2016-8612",
        "|   CVE-2015-3185  4.3  https://vulners.com/cve/CVE-2015-3185",
        "|_  CVE-2014-0117  4.3  https://vulners.com/cve/CVE-2014-0117",
        "",
        "Nmap done: 1 IP address (1 host up) scanned in 12.16 seconds"
    ]};
    variable_struct_set(cmds_local, "nmap -sv --script vulners 192.168.1.50", _vul);
    variable_struct_set(cmds_local, "nmap -sv --script=vulners 192.168.1.50", _vul);
    variable_struct_set(cmds_local, "nmap --script vulners -sv 192.168.1.50", _vul);
    variable_struct_set(cmds_local, "nmap --script=vulners -sv 192.168.1.50", _vul);

    // Dentro do servidor (ssh)
    variable_struct_set(cmds_ssh, "ls", { duracao: 0, acao: "", saida: ["README.txt"] });
    variable_struct_set(cmds_ssh, "cat readme.txt", { duracao: 0, acao: "", saida: ["sudo poweroff"] });
    variable_struct_set(cmds_ssh, "sudo poweroff", { duracao: 3, acao: "poweroff", saida: [
        "Connection to 192.168.1.20 closed by remote host."
    ]});
}
if (terminal_id == "pc1" || terminal_id == "pc2") {
    variable_struct_set(cmds_local, "ls", { duracao: 0, acao: "", saida: ["collection.yml"] });
}

// ---------- Funcoes ----------
adicionar = function(_tipo, _texto) {
    array_push(linhas, { tipo: _tipo, texto: _texto, u: usuario, h: host, d: diretorio });
};

normalizar = function(_s) {
    _s = string_lower(string_trim(_s));
    while (string_pos("  ", _s) > 0) _s = string_replace_all(_s, "  ", " ");
    return _s;
};

quebrar = function(_txt, _larg) {
    var _res = [];
    var _atual = "";
    for (var c = 1; c <= string_length(_txt); c++) {
        var _ch = string_char_at(_txt, c);
        if (string_width(_atual + _ch) > _larg && _atual != "") {
            array_push(_res, _atual);
            _atual = _ch;
        } else _atual += _ch;
    }
    array_push(_res, _atual);
    return _res;
};

definir_sessao_local = function() {
    sessao = "local"; usuario = usuario_local; host = host_local; diretorio = "~";   // [ALTERADO]
};

definir_sessao_ssh = function() {
    sessao = "ssh"; usuario = usuario_ssh; host = "server01"; diretorio = "~";
};

// ----- [NOVO] Objetivos, erros e dicas -----
passo = function(_o) {
    return {
        base:        _o.base,
        aceita:      _o[$ "aceita"] ?? [],
        todos:       _o[$ "todos"] ?? [],
        um_de:       _o[$ "um_de"] ?? [],
        proibe:      _o[$ "proibe"] ?? [],
        dicas:       _o.dicas,
        senha:       _o[$ "senha"] ?? false,
        reabrir:     _o[$ "reabrir"] ?? false,
        saida:       _o[$ "saida"],            // undefined = usa as tabelas acima
        duracao:     _o[$ "duracao"] ?? 0,
        requer:      _o[$ "requer"] ?? [],
        saida_antes: _o[$ "saida_antes"]
    };
};

confere_passo = function(_p, _cmd) {
    if (_p.senha) return false;
    var _ok = false;
    for (var i = 0; i < array_length(_p.aceita); i++) if (_cmd == _p.aceita[i]) _ok = true;
    if (!_ok && array_length(_p.todos) > 0) {
        _ok = true;
        for (var j = 0; j < array_length(_p.todos); j++) if (string_pos(_p.todos[j], _cmd) == 0) _ok = false;
        if (_ok && array_length(_p.um_de) > 0) {
            var _alg = false;
            for (var k = 0; k < array_length(_p.um_de); k++) if (string_pos(_p.um_de[k], _cmd) > 0) _alg = true;
            _ok = _alg;
        }
    }
    if (_ok) for (var m = 0; m < array_length(_p.proibe); m++) if (string_pos(_p.proibe[m], _cmd) > 0) _ok = false;
    return _ok;
};

obter_estado = function(_inc) {
    var _chave = _inc + "_" + terminal_id;
    if (!variable_struct_exists(global.term_estado, _chave)) {
        var _n = array_length(variable_struct_get(cadeias, _inc));
        variable_struct_set(global.term_estado, _chave, {
            feitos: array_create(_n, false), erros: array_create(_n, 0),
            dicas: array_create(_n, 0), concluida: false
        });
    }
    return variable_struct_get(global.term_estado, _chave);
};

requisitos_ok = function(_p, _st) {
    for (var i = 0; i < array_length(_p.requer); i++) if (!_st.feitos[_p.requer[i]]) return false;
    return true;
};

primeiro_pendente = function(_st) {
    for (var i = 0; i < array_length(_st.feitos); i++) if (!_st.feitos[i]) return i;
    return -1;
};

cadeia_ativa = function() {
    if (!eh_kali) return variable_struct_exists(cadeias, "i2") ? "i2" : "";
    var _n = 0;
    if (variable_global_exists("incidente_atual")) _n = global.incidente_atual;   // se o seu jogo ja controla a fase
    else {
        for (var i = 1; i <= 5; i++) {
            if (i == 2) continue;   // #002 acontece nos PCs dos robos
            if (!variable_global_get("incidente_00" + string(i) + "_concluido")) { _n = i; break; }
        }
    }
    var _k = "i" + string(_n);
    return variable_struct_exists(cadeias, _k) ? _k : "";
};

registrar_erro = function() {
    var _inc = cadeia_ativa();
    if (_inc == "") return;
    var _st = obter_estado(_inc);
    var _i = primeiro_pendente(_st);
    if (_i < 0) return;
    _st.erros[_i] += 1;
    if (_st.erros[_i] mod 2 == 0 && _st.dicas[_i] < 3) {
        var _ps = variable_struct_get(cadeias, _inc);
        var _txt = _ps[_i].dicas[_st.dicas[_i]];
        adicionar("dica", "[DICA " + string(_st.dicas[_i] + 1) + "/3] " + _txt);
        _st.dicas[_i] += 1;
    }
};

verificar_fim = function(_inc, _st) {
    if (_st.concluida) return;
    for (var i = 0; i < array_length(_st.feitos); i++) if (!_st.feitos[i]) return;
    array_push(conclusoes_pendentes, _inc);
};

marcar = function(_cmd) {
    var _nomes = variable_struct_get_names(cadeias);
    for (var c = 0; c < array_length(_nomes); c++) {
        var _ps = variable_struct_get(cadeias, _nomes[c]);
        var _st = obter_estado(_nomes[c]);
        for (var i = 0; i < array_length(_ps); i++) {
            if (!_st.feitos[i] && confere_passo(_ps[i], _cmd) && requisitos_ok(_ps[i], _st)) {
                _st.feitos[i] = true;
                verificar_fim(_nomes[c], _st);
            }
        }
    }
};

marcar_senha = function() {
    var _nomes = variable_struct_get_names(cadeias);
    for (var c = 0; c < array_length(_nomes); c++) {
        var _ps = variable_struct_get(cadeias, _nomes[c]);
        var _st = obter_estado(_nomes[c]);
        for (var i = 0; i < array_length(_ps); i++) {
            if (_ps[i].senha && !_st.feitos[i]) { _st.feitos[i] = true; verificar_fim(_nomes[c], _st); }
        }
    }
};

buscar_regra = function(_cmd) {
    var _nomes = variable_struct_get_names(cadeias);
    for (var c = 0; c < array_length(_nomes); c++) {
        var _ps = variable_struct_get(cadeias, _nomes[c]);
        for (var i = 0; i < array_length(_ps); i++) {
            if (_ps[i].saida != undefined && confere_passo(_ps[i], _cmd)) return { passo: _ps[i], inc: _nomes[c] };
        }
    }
    return undefined;
};

checar_conclusao = function() {
    var _lista = conclusoes_pendentes;
    conclusoes_pendentes = [];
    for (var i = 0; i < array_length(_lista); i++) {
        obter_estado(_lista[i]).concluida = true;
        ao_concluir(_lista[i]);
    }
};

ao_concluir = function(_inc) {
    switch (_inc) {
        case "i1": break;   // flag e mensagem ja tratadas em finalizar_acao("poweroff")
        case "i3":
            global.incidente_003_concluido = true;
            adicionar("out", "Falha confirmada: o servidor entrega arquivos fora do diretorio permitido. Registre a CWE no caderno.");
            break;
        case "i4":
            global.incidente_004_concluido = true;
            adicionar("out", "Autenticacao contornada. Registre a falha no caderno.");
            break;
        case "i5":
            global.incidente_005_concluido = true;
            adicionar("out", "Versoes vulneraveis identificadas. Registre as CVEs e a medida corretiva no caderno.");
            break;
        case "i2":
            variable_global_set("incidente_002_" + terminal_id + "_ok", true);
            if (terminal_id == "pc3") adicionar("out", "Acesso dos dois robos ao grupo foi revogado.");
            else adicionar("out", "Evidencia coletada neste computador. Registre no caderno.");
            if (global.incidente_002_pc1_ok && global.incidente_002_pc2_ok && global.incidente_002_pc3_ok) {
                global.incidente_002_concluido = true;
                adicionar("out", "Incidente #002 resolvido.");
            }
            break;
    }
};

// ----- Execucao -----
rodar_entrada = function(_e) {
    if (_e.duracao > 0) {
        ocupado = true;
        timer = _e.duracao * game_get_speed(gamespeed_fps);
        saida_pendente = _e.saida;
        acao_pendente = _e.acao;
    } else {
        for (var i = 0; i < array_length(_e.saida); i++) adicionar("out", _e.saida[i]);
        if (_e.acao != "") finalizar_acao(_e.acao);
        checar_conclusao();   // [NOVO]
    }
};

finalizar_acao = function(_acao) {
    if (_acao == "poweroff") {
        servidor20_ligado = false;
        global.incidente_001_concluido = true;
        adicionar("out", "Ameaca neutralizada. Confirme a ameaca no caderno para liberar a porta.");
        definir_sessao_local();
    }
};

executar = function(_entrada) {
    var _cmd = normalizar(_entrada);
    adicionar("cmd", _entrada);
    if (_cmd == "") return;

    if (_cmd == "clear" || _cmd == "cls" || _cmd == "limpar") { linhas = []; return; }

    if (_cmd == "ajuda" || _cmd == "help") {
        if (eh_kali) adicionar("out", "Comandos: nmap, ssh, curl, ls, cat, sudo, clear, exit");
        else adicionar("out", "Comandos: ls, groups, sudo, gpasswd, clear, exit");
        return;
    }

    if (_cmd == "exit" || _cmd == "sair" || _cmd == "logout") {
        if (sessao == "ssh") {
            adicionar("out", "logout");
            adicionar("out", "Connection to " + ip_servidor + " closed.");
            definir_sessao_local();
        } else instance_destroy();
        return;
    }

    // ssh (somente na sessao local do Kali)
    if (eh_kali && sessao == "local" && string_copy(_cmd, 1, 4) == "ssh ") {
        var _alvo = string_delete(_cmd, 1, 4);
        if (_alvo == usuario_ssh + "@" + ip_servidor) {
            if (servidor20_ligado) {
                marcar(_cmd);
                modo = "senha";
                tentativas = 0;
            } else {
                adicionar("out", "ssh: connect to host " + ip_servidor + " port 22: Connection timed out");
            }
        } else {
            var _h = _alvo;
            var _at = string_pos("@", _alvo);
            if (_at > 0) _h = string_delete(_alvo, 1, _at);
            adicionar("out", "ssh: connect to host " + _h + " port 22: Connection timed out");
            registrar_erro();
        }
        return;
    }

    // [NOVO] comandos definidos nos objetivos (curl, ls -l, groups, gpasswd...)
    var _regra = buscar_regra(_cmd);
    if (_regra != undefined) {
        var _st = obter_estado(_regra.inc);
        if (requisitos_ok(_regra.passo, _st)) {
            marcar(_cmd);
            rodar_entrada({ duracao: _regra.passo.duracao, acao: "", saida: _regra.passo.saida });
        } else {
            rodar_entrada({ duracao: 0, acao: "", saida: _regra.passo.saida_antes ?? [] });
        }
        return;
    }

    // Tabelas exatas
    var _tab = (sessao == "local") ? cmds_local : cmds_ssh;
    if (variable_struct_exists(_tab, _cmd)) {
        marcar(_cmd);   // [NOVO]
        rodar_entrada(variable_struct_get(_tab, _cmd));
        return;
    }

    // Tratamentos genericos (cada um conta como erro, exceto ls local e groups sem argumento)
    var _partes = string_split(_cmd, " ");
    var _prog = _partes[0];
    if (eh_kali && _prog == "nmap") {
        adicionar("out", "Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn");
        adicionar("out", "Nmap done: 1 IP address (0 hosts up) scanned in 3.01 seconds");
        registrar_erro();
    } else if (eh_kali && _prog == "curl") {
        var _p1 = string_pos("://", _cmd);
        if (_p1 == 0) adicionar("out", "curl: try 'curl --help' for more information");
        else {
            var _hh = string_delete(_cmd, 1, _p1 + 2);
            var _fim = string_length(_hh) + 1;
            for (var k = 1; k <= string_length(_hh); k++) {
                var _ch = string_char_at(_hh, k);
                if (_ch == "/" || _ch == " " || _ch == "\"" || _ch == "'") { _fim = k; break; }
            }
            _hh = string_copy(_hh, 1, _fim - 1);
            if (_hh == "internal-files.example.com" || _hh == "192.168.1.30" || _hh == "internal" || _hh == "192.168.1.40") adicionar("out", "404 Not Found");
            else adicionar("out", "curl: (6) Could not resolve host: " + _hh);
        }
        registrar_erro();
    } else if (_prog == "ls" && sessao == "local") {
        // diretorio vazio
    } else if (!eh_kali && _prog == "groups") {
        if (array_length(_partes) > 1) { adicionar("out", "groups: '" + _partes[1] + "': no such user"); registrar_erro(); }
        else adicionar("out", grupos_proprios);
    } else if (_prog == "cat" && array_length(_partes) > 1) {
        adicionar("out", "cat: " + _partes[1] + ": No such file or directory");
        registrar_erro();
    } else if (_prog == "sudo") {
        adicionar("out", "sudo: comando invalido");
        registrar_erro();
    } else {
        adicionar("out", "bash: " + _prog + ": command not found");
        registrar_erro();
    }
};

processar_senha = function(_senha) {
    adicionar("out", senha_prompt);
    tentativas++;
    if (_senha == senha_correta) {
        marcar_senha();   // [NOVO]
        modo = "normal";
        definir_sessao_ssh();
    } else if (tentativas >= 3) {
        adicionar("out", usuario_ssh + "@" + ip_servidor + ": Permission denied (publickey,password).");
        modo = "normal";
        registrar_erro();   // [NOVO]
    } else {
        adicionar("out", "Permission denied, please try again.");
        registrar_erro();   // [NOVO]
    }
};

// ---------- [NOVO] Cadeias de objetivos e dicas ----------
cadeias = {};

if (eh_kali) {
    cadeias.i1 = [
        passo({ base: "nmap", aceita: ["nmap 192.168.1.20"], dicas: [
            "Antes de tentar entrar, descubra quais servicos o servidor expoe. Qual ferramenta do caderno faz varredura de portas?",
            "Use o nmap seguido do alvo. O IP esta na etiqueta do servidor.",
            "nmap <IP-da-etiqueta>" ] }),
        passo({ base: "ssh", aceita: ["ssh operador@192.168.1.20"], reabrir: true, dicas: [
            "A porta 22 esta aberta. Que servico roda nela e como se conecta a ele remotamente?",
            "Use ssh no formato usuario@ip. As pistas indicam o usuario.",
            "ssh <usuario>@<IP>" ] }),
        passo({ base: "", senha: true, dicas: [
            "A senha nao aparece enquanto voce digita. O caderno cita as senhas do ssh: onde alguem poderia te-la deixado?",
            "Procure na lixeira da sala (dumpster diving).",
            "Digite a senha exatamente como esta escrita: letras, numeros e hifen contam." ] }),
        passo({ base: "ls", aceita: ["ls"], dicas: [
            "Voce esta dentro do servidor. Como listar os arquivos do diretorio atual?",
            "E um comando de duas letras.",
            "Comeca com 'l' e termina com 's'." ] }),
        passo({ base: "cat", aceita: ["cat readme.txt"], dicas: [
            "Como exibir o conteudo de um arquivo de texto no terminal?",
            "O comando se chama cat, seguido do nome do arquivo.",
            "cat <nome-do-arquivo-listado>" ] }),
        passo({ base: "sudo", aceita: ["sudo poweroff"], dicas: [
            "O arquivo ensina como desligar a maquina. Falta executar com privilegios administrativos.",
            "Comandos administrativos usam o prefixo sudo.",
            "sudo <comando-lido-no-arquivo>" ] })
    ];

    cadeias.i3 = [
        passo({ base: "curl", duracao: 2,
            aceita: ["curl http://internal-files.example.com", "curl http://internal-files.example.com/", "curl http://192.168.1.30", "curl http://192.168.1.30/"],
            saida: ["<!doctype html>", "<html lang=\"pt-br\">", "<head>", "<meta charset=\"UTF-8\" />",
                    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />",
                    "<title>Internal File Server</title>", "</head>", "<body>", "<h1>Internal File Server</h1>",
                    "<a href=\"/download?file=manual.pdf\">Download Manual</a>", "</body>", "</html>"],
            dicas: [
                "Voce precisa ver o que o servidor devolve. Qual ferramenta de linha de comando faz requisicoes HTTP?",
                "Use curl seguido da URL que aparece na pista da caixa do projeto arquivado.",
                "curl http://<endereco-da-pista>" ] }),
        passo({ base: "curl", duracao: 2,
            todos: ["curl", "download?file=../config.txt"], um_de: ["internal-files.example.com", "192.168.1.30"],
            saida: ["SERVER_CONFIG", "Environment: production", "Database: internal-db"],
            dicas: [
                "A aplicacao pede arquivos pelo parametro file. O catalogo de vulnerabilidades cita manipulacao de caminhos.",
                "No Path Traversal, ../ sobe um diretorio. Peça o arquivo mencionado na caixa, fora da pasta web.",
                "curl \"http://<host>/download?file=../<arquivo>\"  (aspas por causa do '?')" ] })
    ];

    cadeias.i4 = [
        passo({ base: "curl", duracao: 2,
            todos: ["curl", "http://internal/login.php"], proibe: ["-d", "-x"],
            saida: ["<!doctype html>", "<html lang=\"pt-br\">", "<head>", "<meta charset=\"UTF-8\" />", "<title>Internal System</title>", "</head>", "<body>",
                    "<h1>Internal System Login</h1>", "<form action=\"/login.php\" method=\"POST\">",
                    "<label>Username:</label> <input type=\"text\" name=\"user\"><br>",
                    "<label>Password:</label> <input type=\"password\" name=\"pass\"><br>",
                    "<input type=\"submit\" value=\"Login\">", "</form>", "</body>", "</html>"],
            dicas: [
                "Antes de atacar, examine o formulario. Qual ferramenta do caderno acessa uma pagina pelo terminal?",
                "Use curl com a URL da aplicacao, que esta na pasta antiga.",
                "curl http://<endereco-da-pista>" ] }),
        passo({ base: "curl", duracao: 2,
            todos: ["curl", "http://internal/login.php", "-d", "user=' or '1'='1", "pass="],
            saida: ["Login successful! Welcome, admin."],
            dicas: [
                "O formulario envia 'user' e 'pass' por POST. O quadro da sala tem um texto estranho com aspas.",
                "O curl envia dados de formulario com -d. Coloque o texto do quadro no campo user.",
                "curl -X POST <url> -d \"user=<texto-do-quadro>\" -d \"pass=<qualquer-valor>\"" ] })
    ];

    cadeias.i5 = [
        passo({ base: "nmap", aceita: ["nmap -sv 192.168.1.50"], dicas: [
            "O caderno fala em identificar as versoes dos servicos, nao so as portas.",
            "No nmap, a opcao de deteccao de versao comeca com -s e termina com V maiusculo.",
            "nmap -s? <IP-do-servidor-antigo>" ] }),
        passo({ base: "nmap", todos: ["nmap", "-sv", "vulners", "192.168.1.50"], dicas: [
            "O caderno cita o NSE, os scripts do nmap. As letras de papel espalhadas pela sala formam o nome do script.",
            "Sintaxe do caderno: nmap [opcoes] --script <script> <alvo>.",
            "nmap -sV --script <palavra-formada-pelas-letras> <IP>" ] })
    ];
} else {
    // Incidente #002
    var _d_ls = [
        "Voce precisa ver as permissoes do arquivo, nao so o nome. Qual opcao do ls mostra a listagem longa?",
        "A opcao e um hifen seguido da letra inicial de 'long'.",
        "ls -?  (a opcao e uma unica letra)" ];
    var _d_gr = [
        "Para saber se o robo tem acesso, descubra a quais grupos ele pertence.",
        "O comando que lista os grupos de um usuario se chama groups.",
        "groups <nome-do-robo-desta-maquina>" ];
    var _d_del = [
        "A leitura vem do grupo da collection. Remover o robo desse grupo revoga o acesso. Qual comando administra membros de grupos?",
        "O gpasswd com a opcao -d (delete) remove um usuario de um grupo e exige sudo.",
        "sudo gpasswd -d <usuario> <grupo>" ];
    var _d_conf = [
        "Confirme se a remocao realmente funcionou.",
        "Reutilize o comando que lista os grupos de um usuario.",
        "groups <usuario>" ];

    if (terminal_id == "pc1" || terminal_id == "pc2") {
        var _r = (terminal_id == "pc1") ? "robot1" : "robot2";
        var _tam = (terminal_id == "pc1") ? "842" : "916";
        cadeias.i2 = [
            passo({ base: "ls", aceita: ["ls -l"], saida: ["-rw-r----- 1 apiadmin api-testers " + _tam + " collection.yml"], dicas: _d_ls }),
            passo({ base: "groups", aceita: ["groups " + _r], saida: [_r + " : " + _r + " api-testers"], dicas: _d_gr })
        ];
    } else if (terminal_id == "pc3") {
        cadeias.i2 = [
            passo({ base: "sudo", aceita: ["sudo gpasswd -d robot1 api-testers"], saida: ["Removing user robot1 from group api-testers"], dicas: _d_del }),
            passo({ base: "sudo", aceita: ["sudo gpasswd -d robot2 api-testers"], saida: ["Removing user robot2 from group api-testers"], dicas: _d_del }),
            passo({ base: "groups", aceita: ["groups robot1"], requer: [0], saida: ["robot1 : robot1"],
                    saida_antes: ["robot1 : robot1 api-testers"], dicas: _d_conf }),
            passo({ base: "groups", aceita: ["groups robot2"], requer: [1], saida: ["robot2 : robot2"],
                    saida_antes: ["robot2 : robot2 api-testers"], dicas: _d_conf })
        ];
    }
}

// Ao reabrir: se o jogador estava dentro do ssh, volta ao passo de conexao
var _nomes0 = variable_struct_get_names(cadeias);
for (var c0 = 0; c0 < array_length(_nomes0); c0++) {
    var _ps0 = variable_struct_get(cadeias, _nomes0[c0]);
    var _st0 = obter_estado(_nomes0[c0]);
    if (_st0.concluida) continue;
    for (var i0 = 0; i0 < array_length(_ps0); i0++) {
        if (_ps0[i0].reabrir) {
            for (var j0 = i0; j0 < array_length(_ps0); j0++) _st0.feitos[j0] = false;
            break;
        }
    }
}