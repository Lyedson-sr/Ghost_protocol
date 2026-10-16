# Ghost Protocol 👾

## Sobre o projeto

O **Ghost Protocol** é um jogo educativo desenvolvido pelos alunos da UECE no contexto da disciplina de Extensão II, ministrada pelo professor Ismayle . O projeto tem como objetivo ensinar conceitos e práticas de cibersegurança por meio de desafios interativos, nos quais o jogador assume o papel de um Analista de Segurança responsável por investigar incidentes, coletar evidências e identificar possíveis falhas de segurança.

## Equipe

O projeto está sendo desenvolvido pela equipe composta pelos menbros Lyedson, Lyanderson, Gabriel Pinheiro e Salete Yara, como parte das atividades da disciplina de Extensão II.

## Estado atual do projeto

Atualmente, o jogo possui um menu inicial com opções para iniciar a partida, consultar os controles, ajustar o volume e sair, acompanhado por uma trilha sonora. Também foram desenvolvidas as telas de controles e configurações, permitindo que o jogador consulte as teclas utilizadas durante a partida e ajuste o volume.

A jogabilidade conta com um personagem que pode se movimentar em oito direções e interagir com objetos presentes nos cenários. Entre as principais mecânicas implementadas estão o acesso ao terminal por meio de um notebook e o caderno de investigação, que possui três abas: Evidências, Ferramentas e Catálogo. O caderno permite consultar informações de apoio à investigação, conhecer comandos e ferramentas disponíveis e registrar evidências encontradas durante a resolução dos desafios.

A primeira fase, intitulada **Incidente #001: O Servidor Desconhecido**, encontra-se implementada com o fluxo principal de resolução. Nela, o jogador deve investigar um servidor desconhecido, identificar os serviços disponíveis utilizando o Nmap, encontrar credenciais no ambiente, acessar o servidor por SSH e consultar os arquivos disponíveis para descobrir o comando necessário à conclusão do incidente. Ao finalizar o desafio, o jogador pode registrar as evidências coletadas no caderno e avançar para o próximo cenário.

A segunda fase, denominada **Incidente #002: O Arquivo Exposto**, também já possui parte de sua estrutura desenvolvida, dando continuidade à proposta de investigação de incidentes de segurança. Entretanto, suas mecânicas de terminal e registro de evidências ainda precisam ser implementadas.

## Próximos passos

As próximas etapas incluem os robôs e novos cenários, ampliando a variedade de desafios apresentados ao jogador. Também está prevista a implementação de um contador de nível de ameaça associado ao tempo disponível para investigar cada fase. Caso esse limite seja ultrapassado, o jogador perderá, adicionando um elemento de urgência à experiência.

Além disso, serão adicionados efeitos sonoros durante as fases para aumentar a imersão do jogador. Também serão realizados ajustes nas mecânicas existentes, especialmente na movimentação do personagem próximo aos objetos e nas interações com o ambiente, buscando aprimorar a fluidez e a experiência geral de jogo.
