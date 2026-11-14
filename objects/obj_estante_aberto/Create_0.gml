tipo = "mensagem";
titulo = "Estante";
linhas = ["Nenhum projeto foi deixado aqui."];

if (room == Room3 && x == 356)
{
    titulo = "Projeto arquivado";
    linhas = [
        "PROJETO ARQUIVADO",
        "https://internal-files.example.com",
        "192.168.1.30",
        "web/",
        "  ...",
        "Estagiario, lembre-se de nao enviar o arquivo config.txt para producao.",
        "http://internal-files.example.com/download?file=../config.txt"
    ];
}
else if (room == Room4)
{
    titulo = "Dados do sistema";
    linhas = [
        "DADOS DO SISTEMA:",
        "Servidor: 192.168.1.40",
        "Aplicacao: http://internal/login.php"
    ];
}
