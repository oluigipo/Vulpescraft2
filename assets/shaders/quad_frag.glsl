#version 330 core
out vec4 FragColor;
  
in vec2 TexCoords;

uniform sampler2D screenTexture;
uniform sampler2D depthTexture;

uniform float viewWidth, viewHeight;

uniform mat4 view;
uniform mat4 projectionInverse;

vec3 skyColor = vec3(0.4666, 0.6588, 1.0);
vec3 fogColor = vec3(0.6666, 0.8156, 0.9921);

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 calcSkyColor(vec3 pos) {
	float upDot = dot(pos, view[1].xyz);
	return mix(skyColor, fogColor, fogify(max(upDot, 0.0), 0.25));
}

void main()
{ 
    if (texture(depthTexture, TexCoords).r >= 1) {
		vec4 pos = vec4(gl_FragCoord.xy / vec2(viewWidth, viewHeight) * 2.0 - 1.0, 1.0, 1.0);
		pos = projectionInverse * pos;
		FragColor = vec4(calcSkyColor(normalize(pos.xyz)), 1.0);
    } else {
        FragColor = texture(screenTexture, TexCoords);
    }
}