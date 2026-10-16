/// Create - obj_Terminal
keyboard_string = "";
input_texto = "";

if (!variable_global_exists("dialogo_aberto")) global.dialogo_aberto = false;
if (!variable_global_exists("incidente_001_concluido")) global.incidente_001_concluido = false;
if (!variable_global_exists("incidente_001_confirmado")) global.incidente_001_confirmado = false;

// Aparência
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

// Sessão / prompt
usuario = "kali"; host = "kali"; diretorio = "~";
sessao = "local";            // "local" ou "ssh"
modo = "normal";             // "normal" ou "senha"
tentativas = 0;
servidor20_ligado = true;

// Dados do incidente #001
ip_servidor = "192.168.1.20";
usuario_ssh = "operador";
senha_correta = "r0b0t-2026";   // confira com o caderno
senha_prompt = usuario_ssh + "@" + ip_servidor + "'s password: ";

// Histórico
linhas = [
    { tipo: "out", texto: "Terminal v1.0" },
    { tipo: "out", texto: "Digite 'ajuda' para ver os comandos." },
    { tipo: "out", texto: "" }
];
scroll_linha = 0;
scroll_velocidade = 3;

// Execução com demora
ocupado = false;
timer = 0;
saida_pendente = [];
acao_pendente = "";

// ---------- Comandos ----------
cmds_local = {};
cmds_ssh = {};

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

// ---------- Funções ----------
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
    sessao = "local"; usuario = "kali"; host = "kali"; diretorio = "~";
};

definir_sessao_ssh = function() {
    sessao = "ssh"; usuario = usuario_ssh; host = "server01"; diretorio = "~";
};

rodar_entrada = function(_e) {
    if (_e.duracao > 0) {
        ocupado = true;
        timer = _e.duracao * game_get_speed(gamespeed_fps);
        saida_pendente = _e.saida;
        acao_pendente = _e.acao;
    } else {
        for (var i = 0; i < array_length(_e.saida); i++) adicionar("out", _e.saida[i]);
        if (_e.acao != "") finalizar_acao(_e.acao);
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
        adicionar("out", "Comandos: nmap, ssh, ls, cat, sudo, clear, exit");
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

    // ssh (somente na sessão local)
    if (sessao == "local" && string_copy(_cmd, 1, 4) == "ssh ") {
        var _alvo = string_delete(_cmd, 1, 4);
        if (_alvo == usuario_ssh + "@" + ip_servidor) {
            if (servidor20_ligado) {
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
        }
        return;
    }

    var _tab = (sessao == "local") ? cmds_local : cmds_ssh;
    if (variable_struct_exists(_tab, _cmd)) {
        rodar_entrada(variable_struct_get(_tab, _cmd));
        return;
    }

    // Tratamentos genéricos
    var _partes = string_split(_cmd, " ");
    var _prog = _partes[0];
    if (_prog == "nmap") {
        adicionar("out", "Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn");
        adicionar("out", "Nmap done: 1 IP address (0 hosts up) scanned in 3.01 seconds");
    } else if (_prog == "ls" && sessao == "local") {
        // diretório vazio
    } else if (_prog == "cat" && array_length(_partes) > 1) {
        adicionar("out", "cat: " + _partes[1] + ": No such file or directory");
    } else if (_prog == "sudo") {
        adicionar("out", "sudo: comando invalido");
    } else {
        adicionar("out", "bash: " + _prog + ": command not found");
    }
};

processar_senha = function(_senha) {
    adicionar("out", senha_prompt);
    tentativas++;
    if (_senha == senha_correta) {
        modo = "normal";
        definir_sessao_ssh();
    } else if (tentativas >= 3) {
        adicionar("out", usuario_ssh + "@" + ip_servidor + ": Permission denied (publickey,password).");
        modo = "normal";
    } else {
        adicionar("out", "Permission denied, please try again.");
    }
};