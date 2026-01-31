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
        
        if (!collision_point(ropePoint.xx, ropePoint.yy, o_collisionParent, true, true))
        {
            continue;
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
            if (collision_point(cx, cy, o_collisionParent, true, true))
            {
                ropePoint.xx = cx - sx;
                ropePoint.yy = cy - sy;
                
                if (!collision_point(ropePoint.px + dx + tnx, ropePoint.py, o_collisionParent, true, true))
                {
                    ropePoint.xx = ropePoint.px + dx + tnx;
                    ropePoint.yy = ropePoint.py;
                }
                else if (!collision_point(ropePoint.px, ropePoint.py + dy + tny, o_collisionParent, true, true))
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

function ropeInteraction(force)
{
    for (var i = 0; i < ropeArrayLength; i++)
    {
        var ropePoint = rope[i];
        if (instance_place(ropePoint.xx, ropePoint.yy, o_lever))
        {
            with(instance_nearest(ropePoint.xx, ropePoint.yy, o_lever))
            {
                hspeed += sign(x - ropePoint.xx);
                vspeed += sign(y - ropePoint.yy);
                //hspeed += force.xf;
                //vspeed += force.yf;
            }
        }
        
        if (collision_circle(ropePoint.xx, ropePoint.yy, 2, o_crate, true, true))
        {
            with(instance_nearest(ropePoint.xx, ropePoint.yy, o_crate))
            {
                //hspeed = force.xf;
                //vspeed = force.yf;
                
                hspeed += sign(x - ropePoint.xx);
                vspeed += sign(y - ropePoint.yy);
                scr_topDownCollision();
            }
        }
    }
}

function solveKidRopeCollisions()
{
    var ropePoint = rope[0];
    
    if (!place_meeting(ropePoint.xx, ropePoint.yy, o_collisionParent))
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
        if (!place_meeting(x + xStep, y, o_collisionParent))
        {
            x += xStep;
        }
        
        if (!place_meeting(x, y + yStep, o_collisionParent))
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

function getRopeForce()
{
    var xForce = 0;
    var yForce = 0;
    for (var i = 0; i < ropeArrayLength; i++)
    {
        xForce += rope[i].xx - rope[i].px;
        yForce += rope[i].yy - rope[i].py;
    }
    
    xForce += x - xprevious;
    yForce += y - yprevious;
    
    return {xf: xForce, yf: yForce};
}



function drawRope(from = 0, to = ropeArrayLength, shader = false)
{
    for (var i = 0; i < ropeArrayLength; i++)
    {
        var ropePoint = rope[i];
        var halfPoint = (to - from) / 2;
        
        draw_set_alpha(1 - shader);
        if (i >= from and i <= to and shader)
        {
            if (i < halfPoint)
            {
                draw_set_alpha(lerp(0, 1, (i - from) / (halfPoint - from)))
            }
            else 
            {
            	draw_set_alpha(lerp(1, 0, (i - halfPoint) / (to - halfPoint)))
            }
        }
        
        if (i > 0)
        {
            var ropeConnection = rope[i].connectsForward;
            var ropeConnection2 = rope[i].connectsForward.connectsForward;
            draw_set_color(ropeOutlineColor)
            if (ropeConnection2 != undefined)
            {
                draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection2.xx, ropeConnection2.yy, lerp(30, 12, i / ropeArrayLength));
            }
            draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy, lerp(30, 17, i / ropeArrayLength));
            draw_set_color(ropeColor)
            if (ropeConnection2 != undefined)
            {
                draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection2.xx, ropeConnection2.yy, lerp(25, 12, i / ropeArrayLength));
            }
            draw_line_width(ropePoint.xx, ropePoint.yy, ropeConnection.xx, ropeConnection.yy, lerp(25, 12, i / ropeArrayLength));
        }
    }
    draw_set_alpha(1);
}