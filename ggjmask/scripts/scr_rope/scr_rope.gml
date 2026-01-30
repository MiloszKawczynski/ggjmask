function updatePreviousPosisiton()
{
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        var ropePoint = rope[i];
        ropePoint.px = ropePoint.xx;
        ropePoint.py = ropePoint.yy;
    }
}

function pullTo(xx, yy)
{
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        var ropePoint = rope[i];
        var ropeConnection = rope[i].connectsForward;
        
        if (ropeConnection == undefined)
        {
            ropePoint.xx = xx;
            ropePoint.yy = yy;
        }
        else
        {
            var distance = point_distance(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy);
            if (distance > ropePointLength)
            {
                var xStep = (ropeConnection.xx - ropePoint.xx) / distance;
                var yStep = (ropeConnection.yy - ropePoint.yy) / distance;
                while(point_distance(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy) > ropePointLength)
                {
                    ropePoint.xx += xStep;
                    ropePoint.yy += yStep;
                }
            }
        }
    }
}

function pullBackTo(xx, yy)
{
    for (var i = ropeArrayLength - 1; i >= 0; i--)
    {
        var ropePoint = rope[i];
        var ropeConnection = rope[i].connectsBackward;
        
        if (ropeConnection == undefined)
        {
            ropePoint.xx = xx;
            ropePoint.yy = yy;
        }
        else
        {
            var distance = point_distance(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy);
            if (distance > ropePointLength)
            {
                var xStep = (ropeConnection.xx - ropePoint.xx) / distance;
                var yStep = (ropeConnection.yy - ropePoint.yy) / distance;
                while(point_distance(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy) > ropePointLength)
                {
                    ropePoint.xx += xStep;
                    ropePoint.yy += yStep;
                }
            }
        }
    }
}

function solveRopeCollisions()
{
    for (var i = 0; i < ropeArrayLength; i++)
    {
        var ropePoint = rope[i];

        if (collision_point(ropePoint.xx, ropePoint.yy, o_collision, true, true))
        {
            var distance = point_distance(ropePoint.px, ropePoint.py, ropePoint.xx, ropePoint.yy);
            var xStep = (ropePoint.px - ropePoint.xx) / distance;
            var yStep = (ropePoint.py - ropePoint.yy) / distance;
            
            while (collision_point(ropePoint.xx, ropePoint.yy, o_collision, true, true))
            {
                ropePoint.xx += xStep;
                ropePoint.yy += yStep;
            }
        }
    }
}
