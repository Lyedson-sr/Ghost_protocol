// Verifica se o jogador esta perto (ex: a menos de 40 pixels) e aperta a tecla E
if (point_distance(x, y, obj_player.x, obj_player.y) < 50)
{
    if (keyboard_check_pressed(ord("E")))
    {
        // Evita abrir varios terminais ao mesmo tempo
        if (!instance_exists(obj_Terminal))
        {
            if (room == Room1)
            {
                global.incidente_atual = 1;
            }
            else if (room == Room2)
            {
                global.incidente_atual = 2;
            }
            else if (room == Room3)
            {
                global.incidente_atual = 3;
            }
            else if (room == Room4)
            {
                global.incidente_atual = 4;
            }
            else if (room == Room5)
            {
                global.incidente_atual = 5;
            }

            // Cria o terminal numa posicao fixa na tela (ex: x=100, y=100 da camara)
            var _term = instance_create_depth(x - 250, y - 320, -10000, obj_Terminal);

            // Limpa a string do teclado ao abrir
            keyboard_string = "";
        }
    }
}
