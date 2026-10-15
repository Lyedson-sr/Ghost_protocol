/// Evento Criar - obj_menu

mostrar_controles = false;
mostrar_configuracoes = false;
hover_indice = -1;
hover_voltar = false;
hover_volume_menos = false;
hover_volume_mais = false;

botao_largura = 320;
botao_altura = 56;
botao_espaco = 18;

titulo = "GHOST PROTOCOL";

botoes = [
    "START",
    "CONTROLES",
    "CONFIGURACOES",
    "SAIR"
];

if (!variable_global_exists("volume_master"))
{
    global.volume_master = 0.65;
}

volume_passo = 0.10;

audio_master_gain(global.volume_master);

if (!audio_is_playing(snd_menu))
{
    audio_play_sound(snd_menu, 0, true);
}
