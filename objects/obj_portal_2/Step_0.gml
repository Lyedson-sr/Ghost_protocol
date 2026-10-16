if (place_meeting(x, y, obj_player)
    && global.incidente_001_confirmado
    && !instance_exists(obj_dist_2))
{
    var inst = instance_create_depth(0, 0, -9999, obj_dist_2);
    inst.target_x = target_x;
    inst.target_y = target_y;
    inst.target_rm = target_rm;
}