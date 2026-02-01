varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float softness;

void main() {
    float d = distance(v_vTexcoord, vec2(0.5));
    float alpha = smoothstep(0.5, 0.5 - softness, d);

    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    gl_FragColor = vec4(0.0, 0.0, 0.0, tex.a * alpha * v_vColour.a);
}
