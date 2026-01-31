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
            var dx = ropeConnection.xx - ropePoint.xx;
            var dy = ropeConnection.yy - ropePoint.yy;
            var distance = point_distance(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy);
            
            if (distance > ropePointLength)
            {
                var k = (distance - ropePointLength) / distance;
                ropePoint.xx += dx * k;
                ropePoint.yy += dy * k;
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
            var dx = ropeConnection.xx - ropePoint.xx;
            var dy = ropeConnection.yy - ropePoint.yy;
            var distance = point_distance(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy);
            
            if (distance > ropePointLength)
            {
                var k = (distance - ropePointLength) / distance;
                ropePoint.xx += dx * k;
                ropePoint.yy += dy * k;
            }
        }
    }
}

function solveRopeCollisions()
{
    for (var i = 0; i < ropeArrayLength; i++)
    {
        var ropePoint = rope[i];
        var dx = ropePoint.xx - ropePoint.px;
        var dy = ropePoint.yy - ropePoint.py;
        var steps = ceil(max(abs(dx), abs(dy)));
        if (steps == 0) continue;
        
        var sx = dx / steps;
        var sy = dy / steps;
        var cx = ropePoint.px;
        var cy = ropePoint.py;
        
        for (var s = 0; s <= steps; s++)
        {
            if (collision_point(cx, cy, o_collision, true, true))
            {
                ropePoint.xx = cx - sx;
                ropePoint.yy = cy - sy;
                
                if (!collision_point(ropePoint.px + dx, ropePoint.py, o_collision, true, true))
                {
                    ropePoint.xx = ropePoint.px + dx;
                    ropePoint.yy = ropePoint.py;
                }
                else if (!collision_point(ropePoint.px, ropePoint.py + dy, o_collision, true, true))
                {
                    ropePoint.xx = ropePoint.px;
                    ropePoint.yy = ropePoint.py + dy;
                }
                
                break;
            }
            cx += sx;
            cy += sy;
        }
    }
}

function solveKidRopeCollisions()
{
    var ropePoint = rope[0];
    
    if (!place_meeting(ropePoint.xx, ropePoint.yy, o_collision))
    {
        x = ropePoint.xx;
        y = ropePoint.yy;
        return;
    }
    
    var dx = ropePoint.xx - x;
    var dy = ropePoint.yy - y;
    
    var distance = point_distance(ropePoint.xx, ropePoint.yy, x, y);
    
    if (distance == 0)
    {
        return;
    }
    
    var steps = ceil(max(abs(dx), abs(dy)));
    var xStep = dx / distance;
    var yStep = dy / distance;
    
    for (var i = 0; i < steps; i++)
    {
        if (!place_meeting(x + xStep, y, o_collision))
        {
            x += xStep;
        }
        
        if (!place_meeting(x, y + yStep, o_collision))
        {
            y += yStep;
        }
    }
}