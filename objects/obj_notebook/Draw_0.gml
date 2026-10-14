draw_self();

// Verifica se o jogador existe na sala antes de calcular a distância
if (instance_exists(obj_player)) 
{
    // Se o jogador estiver a menos de 50 pixels, mostra o aviso centralizado em cima
    if (point_distance(x, y, obj_player.x, obj_player.y) < 50)
    {
        draw_set_color(c_white);
        draw_text(x - 10, y - 35, "Pressione [ E ]");
    }
}