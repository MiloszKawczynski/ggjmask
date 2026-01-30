acceleration = 1;
deceleration = 0.5;
maximumSpeed = 12;

rope = array_create();
ropePointLength = 25;
ropeArrayLength = 70;
maxRopeLength = ropePointLength * (ropeArrayLength - 1);

for (var i = 0; i < ropeArrayLength ; i++)
{
	array_push(rope,
    {
        px: o_bed.x,
        py: o_bed.y,
        xx: o_bed.x,
        yy: o_bed.y,
        connectsForward: undefined,
        connectsBackward: undefined,
    })
}

for (var i = 0; i < ropeArrayLength ; i++)
{
    var forwardConnection = undefined;
    var backwardConnection = undefined;
    
    if (i > 0)
    {
       forwardConnection = rope[i - 1];
    }
    
    if (i < ropeArrayLength - 1)
    {
       backwardConnection = rope[i + 1];
    }
    
	rope[i].connectsForward = forwardConnection;
    rope[i].connectsBackward = backwardConnection;
}

ropeAnchor = rope[ropeArrayLength - 1];

pullBackTo(o_bed.x, o_bed.y);