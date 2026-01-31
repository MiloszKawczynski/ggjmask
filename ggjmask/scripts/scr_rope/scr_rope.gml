function addRopeNodes(numberOfNodes)
{
    for (var i = 0; i < numberOfNodes; i++)
    {
    	array_push(rope,
        {
            px: o_bed.x,
            py: o_bed.y,
            xx: o_bed.x,
            yy: o_bed.y,
            connectsForward: undefined,
            connectsBackward: undefined,
            isLock: false
        })
    }
    
    ropeArrayLength = array_length(rope);
    
    for (var i = 0; i < ropeArrayLength; i++)
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
}

function updatePreviousPosisiton()
{
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        var ropePoint = rope[i];
        ropePoint.px = ropePoint.xx;
        ropePoint.py = ropePoint.yy;
    }
}

function constrain(ropePoint, ropeConnection)
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

function pullTo(xx, yy)
{
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        pullNode(i, xx, yy);
    }
}

function pullNode(i, xx, yy)
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
        constrain(ropePoint, ropeConnection);
    }
}

function pullBackTo(xx, yy)
{
    for (var i = ropeArrayLength - 1; i >= 0; i--)
    {
        pullBackNode(i, xx, yy);
    }
}

function pullBackNode(i, xx, yy)
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
        constrain(ropePoint, ropeConnection);
    }
}

function solveRopeCollisions()
{
    for (var i = 0; i < ropeArrayLength; i++)
    {
        var ropePoint = rope[i];
        
        if (!collision_point(ropePoint.xx, ropePoint.yy, o_collision, true, true))
        {
            continue;
        }
        
        if (instance_place(ropePoint.xx, ropePoint.yy, o_lever))
        {
            instance_nearest(ropePoint.xx, ropePoint.yy, o_lever).isPulled = true;
        }
        
        var tnx = 0;
        var tny = 0;
        
        if (ropePoint.connectsForward != undefined)
        {
            tnx = sign(ropePoint.connectsForward.xx - ropePoint.xx) * 2;
            tny = sign(ropePoint.connectsForward.yy - ropePoint.yy) * 2;
        }
        
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
                
                if (!collision_point(ropePoint.px + dx + tnx, ropePoint.py, o_collision, true, true))
                {
                    ropePoint.xx = ropePoint.px + dx + tnx;
                    ropePoint.yy = ropePoint.py;
                }
                else if (!collision_point(ropePoint.px, ropePoint.py + dy + tny, o_collision, true, true))
                {
                    ropePoint.xx = ropePoint.px;
                    ropePoint.yy = ropePoint.py + dy + tny;
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
    
    debugX = ropePoint.xx;
    debugY = ropePoint.yy;
    
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

function getRopeLength()
{
    var totalRopeLength = 0;
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        totalRopeLength += point_distance(rope[i].xx, rope[i].yy, rope[i + 1].xx, rope[i + 1].yy);
    }
    
    totalRopeLength += point_distance(rope[0].xx, rope[0].yy, x, y);
    
    return totalRopeLength;
}

function fixRopeClipping()
{
    var isAnyClipped = false;
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        var p1 = rope[i];
        var p2 = rope[i + 1];
        
        if (collision_line(p1.xx, p1.yy, p2.xx, p2.yy, o_collision, true, true))
        {
            //isAnyClipped = true;
            //pullNode(i, p2.xx, p2.yy);
            //pullNode(i + 1, p1.xx, p1.yy);
            
            
            
            break;
        }
    }
    
    //if (isAnyClipped)
    //{
        //var is
        //for (var i = 0; i < ropeArrayLength - 1; i++)
        //{
            //var p1 = rope[i];
            //var p2 = rope[i + 1];
            //
            //if (collision_line(p1.xx, p1.yy, p2.xx, p2.yy, o_collision, true, true))
            //{
                //isAnyClipped = true;
                //break;
            //}
        //}
    //}
}

