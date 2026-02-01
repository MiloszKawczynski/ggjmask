if (!instance_exists(o_kid))
{
    instance_create_depth((bbox_right + bbox_left) / 2, (bbox_bottom + bbox_top) / 2, depth, o_kid);
}