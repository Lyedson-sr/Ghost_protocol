if (!variable_global_exists("incidente_001_confirmado"))
{
    global.incidente_001_confirmado = false;
}

if (!variable_global_exists("incidente_002_confirmado"))
{
    global.incidente_002_confirmado = false;
}

var _porta_liberada = room == Room2
    ? global.incidente_002_confirmado
    : global.incidente_001_confirmado;

if (_porta_liberada)
{
    image_speed = 1;
}
else
{
    image_speed = 0;
    image_index = 0;
}
