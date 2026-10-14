// Verifica se o jogador está perto (ex: a menos de 40 pixels) e aperta a tecla E
if (point_distance(x, y, obj_player.x, obj_player.y) < 50)
{
    if (keyboard_check_pressed(ord("E")))
    {
        // Evita abrir vários terminais ao mesmo tempo
        if (!instance_exists(obj_Terminal))
        {
            // Cria o terminal numa posição fixa na tela (ex: x=100, y=100 da câmara)
            var _term = instance_create_depth(x - 250, y - 320, -10000, obj_Terminal);

            // Limpa a string do teclado ao abrir
            keyboard_string = "";
        }
    }
}
