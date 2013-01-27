varying MEDP vec2 uvVarying;

uniform float lightr;
uniform vec4 color;

const float haloSize = 0.0;

void main() {
	float invDist = 1.0 - length(uvVarying) / lightr;
	float halo = (invDist < haloSize) ? 0.0 : ((invDist - haloSize) / (1.0 - haloSize));
	vec4 colorAdj = vec4(color.xyz, .25);

	gl_FragColor = colorAdj * (invDist + halo) + vec4(halo / 3.0);
	//gl_FragColor = vec4(1, 1, 1, 1);
}
