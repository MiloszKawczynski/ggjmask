

if (isPulled xor inverse)
{
    image_xscale = -1;
    for (var i = 0; i < array_length(myConnections); i++)
    {
        instance_deactivate_object(myConnections[i]);
    }
}
else 
{
	image_xscale = 1;
    for (var i = 0; i < array_length(myConnections); i++)
    {
        instance_activate_object(myConnections[i]);
    }
}