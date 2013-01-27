varying LOWP vec4 colorVarying;
varying MEDP vec2 uvVarying;

uniform sampler2D sampler;
varying vec2 vTexCoord;
 
void main() { 
	vec4 sum = vec4(0.0);
 
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.00000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.092024624;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 1.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.090202413;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -1.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.090202413;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 3.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.084949426;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -3.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.084949426;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 5.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.076865427;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -5.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.076865427;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 7.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.066823587;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -7.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.066823587;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 9.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.055815756;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -9.5000000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.055815756;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 11.500000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.044793192;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -11.500000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.044793192;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 13.500000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.034537863;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + -13.500000 / 1024.0, vTexCoord.y + 0.0 / 768.0)) * 0.034537863;

 	if (sum.a > 0.0) {
 		gl_FragColor = sum;
 	}
 	else {
		gl_FragColor = sum * colorVarying;
 	}
}