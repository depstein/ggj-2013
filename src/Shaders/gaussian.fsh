varying LOWP vec4 colorVarying;
varying MEDP vec2 uvVarying;

uniform sampler2D sampler;

#define SAMPLE_COUNT 15

uniform float xoffs[SAMPLE_COUNT];
uniform float yoffs[SAMPLE_COUNT];
uniform float weights[SAMPLE_COUNT];

varying vec2 vTexCoord;
 
void main() { 
	vec4 sum = vec4(0.0);
 
 	for (int i = 0; i < SAMPLE_COUNT; i++) {
 		sum += texture2D(sampler, vec2(vTexCoord.x + xoffs[i] / 1024.0, vTexCoord.y + yoffs[i] / 768.0)) * weights[i];
 	}

 	if (sum.a > 0.0) {
 		gl_FragColor = sum;
 	}
 	else {
		gl_FragColor = sum * colorVarying;
 	}
}