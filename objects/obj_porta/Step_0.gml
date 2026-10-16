if (!variable_global_exists("incidente_001_confirmado"))
{
    global.incidente_001_confirmado = false;
}

if (global.incidente_001_confirmado)
{
    image_speed = 1;
}
else
{
    image_speed = 0;
    image_index = 0;
}
