//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float texelW;
uniform float texelH;
uniform float radius;

void main()
{
	vec2 offsetx;
	offsetx.x=texelW;
	vec2 offsety;
	offsety.y=texelH;
	
	vec2 shift;
	
	float red=0.;
	float green=0.;
	float blue=0.;
	float alpha=0.;
	
	for(float i=-radius;i<=radius;i++)
	{
		for(float j=-radius;j<=radius;j++)
		{
			shift=vec2(offsetx.x*i,offsety.y*j);
		
			alpha+=(v_vColour * texture2D( gm_BaseTexture, v_vTexcoord+shift)).a;
		}
	}

	vec4 base = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	alpha=alpha/pow((radius*2.+1.),2.);
	
	
	base=vec4(red,green,blue,alpha);
	
    gl_FragColor = base;
}
