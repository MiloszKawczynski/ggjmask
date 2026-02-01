function addRopeNodes(numberOfNodes)
{
    for (var i = 0; i < numberOfNodes; i++)
    {
    	array_push(rope,
        {
            px: homeBed.x,
            py: homeBed.y,
            xx: homeBed.x,
            yy: homeBed.y,
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
    
    pullBackTo(homeBed.x, homeBed.y);
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

function ropeInteraction(centers)
{
    var force = getRopeForce();
    for (var i = 0; i < ropeArrayLength; i++)
    {
        var ropePoint = rope[i];
        if (collision_circle(ropePoint.xx, ropePoint.yy, 5, o_lever, true, true))
        {
            var inst = instance_nearest(ropePoint.xx, ropePoint.yy, o_lever);
            var ifAny = false;
            
            for (var j = 0; j < array_length(centers); j++)
            {
                if (collision_point(centers[j].x, centers[j].y, inst, true, true))
                {
                    ifAny = true;
                    break;
                }
            }
            
            if (ifAny)
            {
                with(inst)
                {
                    //hspeed = 0;
                    //vspeed = 0;
                    //
                    //var p1 = centers[j].p1;
                    //var p2 = centers[j].p2;
                    //
                    //var p12 = centers[j].p1.connectsForward;
                    //var p22 = centers[j].p2.connectsBackward;
                    //
                    //var v1x = p12.xx - p1.xx;
                    //var v2x = p22.xx - p2.xx;
                    //
                    //var v1y = p12.yy - p1.yy;
                    //var v2y = p22.yy - p2.yy;
                    //
                    //hspeed = v1x + v2x;
                    //vspeed = v1y + v2y;
                    
                    hspeed = other.x - centers[j].x;
                    vspeed = other.y - centers[j].y;
                }
            }
            else 
            {
                with(inst)
                {
                    hspeed += sign(x - ropePoint.xx);
                    vspeed += sign(y - ropePoint.yy);
                }
            }
        }
        
        if (collision_circle(ropePoint.xx, ropePoint.yy, 5, o_crate, true, true))
        {
            var inst = instance_nearest(ropePoint.xx, ropePoint.yy, o_crate);
            var ifAny = false;
            
            for (var j = 0; j < array_length(centers); j++)
            {
                if (collision_point(centers[j].x, centers[j].y, inst, true, true))
                {
                    ifAny = true;
                    break;
                }
            }
            
            if (ifAny)
            {
                with(inst)
                {
                    hspeed = 0;
                    vspeed = 0;
                    
                    var p1 = centers[j].p1;
                    var p2 = centers[j].p2;
                    
                    var p12 = centers[j].p1.connectsForward;
                    var p22 = centers[j].p2.connectsBackward;
                    
                    var v1x = p12.xx - p1.xx;
                    var v2x = p22.xx - p2.xx;
                    
                    var v1y = p12.yy - p1.yy;
                    var v2y = p22.yy - p2.yy;
                    
                    hspeed = v1x + v2x;
                    vspeed = v1y + v2y;
                    scr_topDownCollision();
                }
            }
            else 
            {
                with(inst)
                {
                    hspeed += sign(x - ropePoint.xx);
                    vspeed += sign(y - ropePoint.yy);
                    scr_topDownCollision();
                }
            }
        }
        
        var inst = instance_nearest(ropePoint.xx, ropePoint.yy, o_bed);
        var ifAny = false;
        
        for (var j = 0; j < array_length(centers); j++)
        {
            if (collision_point(centers[j].x, centers[j].y, inst, true, true) and centers[j].count > 15)
            {
                ifAny = true;
                break;
            }
        }
        
        if (ifAny)
        {
            if (homeBed != inst)
            {
                for (var j = 0; j < ropeArrayLength; j++)
                {
                    rope[j].xx = inst.x;
                    rope[j].yy = inst.y;
                }
                homeBed = inst;
                pullBackTo(homeBed.x, homeBed.y);
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

function segment_intersection_point_fast(p1, p2, p3, p4)
{
    var x1 = p1.xx, y1 = p1.yy;
    var x2 = p2.xx, y2 = p2.yy;
    var x3 = p3.xx, y3 = p3.yy;
    var x4 = p4.xx, y4 = p4.yy;

    // bounding box early-out
    if (max(x1,x2) < min(x3,x4)) return undefined;
    if (max(x3,x4) < min(x1,x2)) return undefined;
    if (max(y1,y2) < min(y3,y4)) return undefined;
    if (max(y3,y4) < min(y1,y2)) return undefined;

    var den = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4);
    if (den == 0) return undefined;

    var t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / den;
    var u = ((x1-x3)*(y1-y2) - (y1-y3)*(x1-x2)) / den;

    // przecięcie tylko wewnątrz odcinków
    if (t <= 0 || t >= 1 || u <= 0 || u >= 1) return undefined;

    return {
        x: x1 + t * (x2 - x1),
        y: y1 + t * (y2 - y1)
    };
}

function loop_center(rope, from_idx, to_idx)
{
    var sx = 0, sy = 0;
    var cnt = to_idx - from_idx + 1;

    for (var k = from_idx; k <= to_idx; k++)
    {
        sx += rope[k].xx;
        sy += rope[k].yy;
    }

    return { x: sx / cnt, y: sy / cnt, count: to_idx - from_idx, p1: rope[from_idx], p2: rope[to_idx]};
}

function getLoopsCenters()
{
    centers = [];
    for (var i = 0; i < ropeArrayLength - 1; i++)
    {
        var a1 = rope[i];
        var a2 = rope[i + 1];
    
        for (var j = i + 2; j < ropeArrayLength - 1; j++)
        {
            var cross = segment_intersection_point_fast(a1, a2, rope[j], rope[j+1]);
            if (cross != undefined)
            {
                var center = loop_center(rope, i + 1, j);
                array_push(centers, center);
            }
        }
    }
    
    return centers;
}