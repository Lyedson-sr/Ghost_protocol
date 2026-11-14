# Ghost Protocol 👾

## Sobre o projeto

O **Ghost Protocol** é um jogo educativo 2D desenvolvido pelos alunos da UECE na disciplina de Extensão II, ministrada pelo professor Ismayle. O projeto ensina conceitos e práticas de cibersegurança por meio de desafios interativos: o jogador assume o papel de um **Analista de Segurança** que investiga incidentes, coleta evidências e identifica falhas em um prédio comprometido.

## Equipe

Lyedson, Lyanderson, Gabriel Pinheiro e Salete Yara.

## Como jogar

| Tecla | Ação |
|-------|------|
| **W A S D** | Movimentar o personagem |
| **E** | Examinar objetos, usar o notebook e atender o telefone |
| **C** | Abrir/fechar o caderno de investigação |
| **N** ou **B** | Abrir o bloco de notas |
| **ESC** | Fechar a interface aberta ou voltar ao menu/pausar |
| **X**, **E** ou **Enter** | Fechar a caixa de descrição de um objeto |

## Mecânicas

- **Menu inicial** com iniciar, controles, volume e sair, acompanhado de trilha sonora.
- **Exploração:** o personagem se move pelas salas e examina objetos. Ao se aproximar, o aviso **[E] Examinar: nome do objeto** indica o objeto selecionado. Objetos sem pista também exibem uma descrição; piso e paredes não têm descrição.
- **Terminal:** acessado pelo notebook de cada sala. Simula comandos reais de Linux e de ferramentas como `nmap`, `ssh`, `curl`, `ls`, `cat`, `sudo`, `groups` e `gpasswd`.
- **Sistema de dicas:** quando o jogador erra comandos repetidas vezes, o terminal exibe até 3 dicas progressivas para o passo atual.
- **Caderno de investigação** com três abas: **Evidências** (registro do que foi encontrado), **Ferramentas** (comandos disponíveis) e **Catálogo** (falhas e soluções).
- **Bloco de notas:** o jogador anota pistas durante o jogo, tanto pela tecla **N** quanto pelo terminal (`notas`, `notas add <texto>`, `notas limpar`, `notas abrir`).
- **Escudo de ameaça:** cada sala tem um tempo limite. O escudo no canto superior direito, com 5 blocos, mostra o avanço da ameaça. No último minuto há um alerta da Central de Segurança e uma sirene. Se o tempo acabar, o jogador perde.
- **Portas e passagens bloqueadas:** só são liberadas depois que o incidente da sala é resolvido e confirmado no caderno.

## Fases

| Fase | Tema |
|------|------|
| **Incidente #001: O Servidor Desconhecido** | Varredura com Nmap, busca de credenciais no ambiente, acesso por SSH e desligamento do servidor |
| **Incidente #002: O Arquivo Exposto** | Verificação de permissões de arquivos e grupos, e revogação de acesso indevido com `gpasswd` |
| **Incidente #003** | Falha de Path Traversal em um servidor de arquivos interno |
| **Incidente #004** | Contorno de autenticação em um formulário de login |
| **Incidente #005** | Identificação de versões vulneráveis com Nmap e o script `vulners` |

Cada fase termina com o registro das evidências no caderno, que libera a passagem para a próxima sala. O jogo se encerra com uma ligação final ao voltar à primeira sala.

## Próximos passos

- Revisar a movimentação do personagem perto dos objetos e as interações com o ambiente.
- Ampliar os efeitos sonoros durante as fases.
- Testar o equilíbrio do tempo de cada sala e a dificuldade das dicas.
- Finalizar a documentação do projeto (GDD).
