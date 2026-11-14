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
if (!variable_global_exists("incidente_004_concluido"))
{
    global.incidente_004_concluido = false;
}
if (!variable_global_exists("incidente_004_confirmado"))
{
    global.incidente_004_confirmado = false;
}
if (!variable_global_exists("incidente_005_concluido"))
{
    global.incidente_005_concluido = false;
}
if (!variable_global_exists("incidente_005_confirmado"))
{
    global.incidente_005_confirmado = false;
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
else if (room == Room4)
{
    _porta_liberada = global.incidente_004_confirmado;
}
else if (room == Room5)
{
    _porta_liberada = global.incidente_005_confirmado;
}

if (room == Room5
    && _porta_liberada
    && place_meeting(x, y, obj_player)
    && !instance_exists(obj_dist_1)
    && !instance_exists(obj_dist_2))
{
    var _transicao = instance_create_depth(0, 0, -9999, obj_dist_1);
    _transicao.target_x = 912;
    _transicao.target_y = 222;
    _transicao.target_rm = Room4;
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
