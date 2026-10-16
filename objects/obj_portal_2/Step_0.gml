if (place_meeting(x, y, obj_player) && !instance_exists(obj_dist_2))
{
    var inst = instance_create_depth(0, 0, -9999, obj_dist_2);
    global.portal_target_x = target_x;
    global.portal_target_y = target_y;
    global.portal_target_rm = target_rm;
}