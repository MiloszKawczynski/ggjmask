varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texel;     // 1.0 / texture size
uniform float u_strength;

void main()
{
    vec4 sum = vec4(0.0);

    sum += texture2D(gm_BaseTexture, v_vTexcoord + u_texel * vec2(-2,-2));
    sum += texture2D(gm_BaseTexture, v_vTexcoord + u_texel * vec2( 2,-2));
    sum += texture2D(gm_BaseTexture, v_vTexcoord + u_texel * vec2(-2, 2));
    sum += texture2D(gm_BaseTexture, v_vTexcoord + u_texel * vec2( 2, 2));
    sum += texture2D(gm_BaseTexture, v_vTexcoord);

    vec4 base = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
    gl_FragColor = base + sum * 0.25 * u_strength;
}
