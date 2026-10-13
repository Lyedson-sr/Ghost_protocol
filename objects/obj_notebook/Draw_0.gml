// Desenha o sprite do notebook normalmente
draw_self();

// Se o jogador estiver perto, mostra o aviso
if (point_distance(x, y, obj_player.x, obj_player.y) < 40)
{
    draw_set_color(c_white);
    draw_text(x - 30, y - 40, "Pressione [ E ]");
}