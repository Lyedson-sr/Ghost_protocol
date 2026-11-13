if (fonte_interacao != -1)
{
    font_delete(fonte_interacao);
}

if (variable_global_exists("hud_escudo_sprite")
    && global.hud_escudo_sprite != -1
    && sprite_exists(global.hud_escudo_sprite))
{
    sprite_delete(global.hud_escudo_sprite);
    global.hud_escudo_sprite = -1;
}

if (variable_global_exists("sirene_ultimo_min_sound")
    && global.sirene_ultimo_min_sound != -1)
{
    audio_stop_sound(global.sirene_ultimo_min_sound);
    audio_destroy_stream(global.sirene_ultimo_min_sound);
    global.sirene_ultimo_min_sound = -1;
}
