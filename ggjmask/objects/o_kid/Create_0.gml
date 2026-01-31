acceleration = 1;
deceleration = 0.5;
maximumSpeed = 12;
desiredHorizontalDirection = 0;
desiredVerticalDirection = 0;

rope = array_create();
ropePointLength = 25;
ropeArrayLength = 8 * 12;
ropeMaxStrength = 5;
ropeAnchor = undefined;
ropeStrength = ropeMaxStrength;
maxRopeLength = ropePointLength * (ropeArrayLength - 1);

addRopeNodes(ropeArrayLength);

debugX = 0;
debugY = 0;

ropeColor = make_color_rgb(141, 171, 229);
ropeOutlineColor = make_color_rgb(36, 133, 153);