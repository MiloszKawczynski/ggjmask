myConnections = array_create();

for(var i = 0; i < instance_number(o_leverDool); i++)
{
    var inst = instance_find(o_leverDool, i);
    if (inst.connection == connection)
    {
        array_push(myConnections, instance_find(o_leverDool, i));
    }
}

ratio = 0;