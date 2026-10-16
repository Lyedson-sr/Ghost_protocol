/// Draw GUI - obj_Terminal
var _x = terminal_x;
var _y = terminal_y;
var _mgx = terminal_margem_x;
var _mgy = terminal_margem_y;
var _esp = terminal_espacamento;
var _larg_texto = terminal_largura - _mgx * 2;

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// draw_set_font(fnt_terminal);   // fonte monoespaçada

// Fundo, barra de título e borda
draw_set_color(cor_fundo);
draw_rectangle(_x, _y, _x + terminal_largura, _y + terminal_altura, false);
draw_set_color(cor_barra);
draw_rectangle(_x, _y, _x + terminal_largura, _y + terminal_barra, false);
draw_set_color(cor_texto);
draw_text(_x + 12, _y + 7, usuario + "@" + host + ": " + diretorio);

// Botão X
var _bx = _x + terminal_largura - 30;
var _by = _y + 4;
var _hover = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), _bx, _by, _bx + 24, _by + 24);
draw_set_color(_hover ? make_color_rgb(200, 50, 50) : cor_barra);
draw_rectangle(_bx, _by, _bx + 24, _by + 24, false);
draw_set_color(c_white);
draw_line_width(_bx + 7, _by + 7, _bx + 17, _by + 17, 2);
draw_line_width(_bx + 17, _by + 7, _bx + 7, _by + 17, 2);

draw_set_color(c_dkgray);
draw_rectangle(_x, _y, _x + terminal_largura, _y + terminal_altura, true);

// Monta as linhas visuais
var _vis = [];
for (var i = 0; i < array_length(linhas); i++) {
    var _e = linhas[i];
    var _eh_cmd = (_e.tipo == "cmd");
    var _pr = _eh_cmd ? (_e.u + "@" + _e.h + ":" + _e.d + "$ ") : "";
    var _q = quebrar(_pr + _e.texto, _larg_texto);
    for (var j = 0; j < array_length(_q); j++) {
        array_push(_vis, { t: _q[j], p: (_eh_cmd && j == 0), u: _eh_cmd ? _e.u : "", h: _eh_cmd ? _e.h : "", d: _eh_cmd ? _e.d : "", plen: string_length(_pr), cursor: false });
    }
}

if (ocupado) {
    var _pontos = string_copy("...", 1, (current_time div 400) mod 4);
    array_push(_vis, { t: "Executando" + _pontos, p: false, u: "", h: "", d: "", plen: 0, cursor: false });
} else if (modo == "senha") {
    array_push(_vis, { t: senha_prompt, p: false, u: "", h: "", d: "", plen: 0, cursor: true });
} else {
    var _pr2 = usuario + "@" + host + ":" + diretorio + "$ ";
    var _q2 = quebrar(_pr2 + input_texto, _larg_texto);
    for (var j = 0; j < array_length(_q2); j++) {
        array_push(_vis, { t: _q2[j], p: (j == 0), u: usuario, h: host, d: diretorio, plen: string_length(_pr2), cursor: (j == array_length(_q2) - 1) });
    }
}

// Rolagem
var _topo = _y + terminal_barra + _mgy;
var _visiveis = max(1, floor((terminal_altura - terminal_barra - _mgy * 2) / _esp));
var _total = array_length(_vis);
scroll_linha = clamp(scroll_linha, 0, max(0, _total - _visiveis));
var _ini = max(0, _total - _visiveis - scroll_linha);
var _fim = min(_total, _ini + _visiveis);

var _cursor_on = ((current_time div 500) mod 2 == 0);
for (var i = _ini; i < _fim; i++) {
    var _l = _vis[i];
    var _px = _x + _mgx;
    var _py = _topo + (i - _ini) * _esp;
    var _fx = _px;

    if (_l.p) {
        var _resto = string_delete(_l.t, 1, _l.plen);
        var _a = _l.u + "@" + _l.h;
        draw_set_color(cor_verde); draw_text(_px, _py, _a);  _px += string_width(_a);
        draw_set_color(cor_texto); draw_text(_px, _py, ":"); _px += string_width(":");
        draw_set_color(cor_azul);  draw_text(_px, _py, _l.d); _px += string_width(_l.d);
        draw_set_color(cor_texto); draw_text(_px, _py, "$ "); _px += string_width("$ ");
        draw_text(_px, _py, _resto);
        _fx = _px + string_width(_resto);
    } else {
        draw_set_color(cor_texto);
        draw_text(_px, _py, _l.t);
        _fx = _px + string_width(_l.t);
    }

    if (_l.cursor && _cursor_on) {
        draw_set_color(cor_texto);
        draw_rectangle(_fx + 1, _py + 2, _fx + 1 + string_width("M") * 0.6, _py + _esp - 2, false);
    }
}

draw_set_color(c_white);