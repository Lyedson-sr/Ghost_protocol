
/// Evento Desenhar GUI - obj_Terminal

var _x = 150;
var _y = 100;

var _largura = terminal_largura;
var _altura = terminal_altura;

var _margem_x = terminal_margem_x;
var _margem_y = terminal_margem_y;
var _espacamento = terminal_espacamento;

// Desenhar o fundo e a borda
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(_x, _y, _x + _largura, _y + _altura, false);

draw_set_color(c_white);
draw_rectangle(_x, _y, _x + _largura, _y + _altura, true);

// Configurar o texto
draw_set_font(-1);
draw_set_color(c_lime);

var _largura_texto = _largura - (_margem_x * 2);

// Juntar histórico e texto digitado
var _texto = historico + "> " + input_texto + "_";

// Separar os parágrafos
var _paragrafos = string_split(_texto, "\n");
var _linhas = [];

// Processar cada parágrafo
for (var p = 0; p < array_length(_paragrafos); p++)
{
    var _paragrafo = _paragrafos[p];

    if (_paragrafo == "")
    {
        array_push(_linhas, "");
    }
    else
    {
        var _palavras = string_split(_paragrafo, " ");
        var _linha = "";

        for (var w = 0; w < array_length(_palavras); w++)
        {
            var _palavra = _palavras[w];

            var _candidata = _linha;

            if (_candidata != "")
            {
                _candidata += " ";
            }

            _candidata += _palavra;

            if (string_width(_candidata) <= _largura_texto)
            {
                // A palavra cabe na linha
                _linha = _candidata;
            }
            else
            {
                // Guardar a linha atual
                if (_linha != "")
                {
                    array_push(_linhas, _linha);
                    _linha = "";
                }

                // Se a palavra for maior que a caixa,
                // quebrá-la caractere por caractere
                for (var c = 1; c <= string_length(_palavra); c++)
                {
                    var _caractere = string_char_at(_palavra, c);
                    var _teste = _linha + _caractere;

                    if (string_width(_teste) > _largura_texto
                        && _linha != "")
                    {
                        array_push(_linhas, _linha);
                        _linha = _caractere;
                    }
                    else
                    {
                        _linha = _teste;
                    }
                }
            }
        }

        // Adicionar a última linha
        array_push(_linhas, _linha);
    }
}

// Calcular quantas linhas cabem no terminal
var _altura_util = _altura - (_margem_y * 2);

var _linhas_visiveis = max(
    1,
    floor(_altura_util / _espacamento)
);

// Calcular a rolagem máxima
var _total_linhas = array_length(_linhas);

var _scroll_maximo = max(
    0,
    _total_linhas - _linhas_visiveis
);

scroll_linha = clamp(
    scroll_linha,
    0,
    _scroll_maximo
);

// Determinar o trecho visível
var _inicio = max(
    0,
    _total_linhas - _linhas_visiveis - scroll_linha
);

var _fim = min(
    _total_linhas,
    _inicio + _linhas_visiveis
);

// Desenhar somente as linhas visíveis
for (var i = _inicio; i < _fim; i++)
{
    var _pos_y = _y + _margem_y
        + ((i - _inicio) * _espacamento);

    draw_text(
        _x + _margem_x,
        _pos_y,
        _linhas[i]
    );
}

// Restaurar configurações
draw_set_color(c_white);
draw_set_alpha(1);
