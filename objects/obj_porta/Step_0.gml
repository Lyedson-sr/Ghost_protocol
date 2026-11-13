if (!variable_global_exists("incidente_001_confirmado"))
{
    global.incidente_001_confirmado = false;
}

if (!variable_global_exists("incidente_002_confirmado"))
{
    global.incidente_002_confirmado = false;
}

if (!variable_global_exists("incidente_003_concluido"))
{
    global.incidente_003_concluido = false;
}
if (!variable_global_exists("incidente_003_confirmado"))
{
    global.incidente_003_confirmado = false;
}

var _porta_liberada = false;
if (room == Room1)
{
    _porta_liberada = global.incidente_001_confirmado;
}
else if (room == Room2)
{
    _porta_liberada = global.incidente_002_confirmado;
}
else if (room == Room3)
{
    _porta_liberada = global.incidente_003_confirmado;
}

if (_porta_liberada)
{
    if (image_index < image_number - 1)
    {
        image_speed = 1;
    }
    else
    {
        image_speed = 0;
        image_index = image_number - 1;
    }
}
else
{
    image_speed = 0;
    image_index = 0;
}
