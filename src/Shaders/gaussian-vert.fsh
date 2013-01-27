varying LOWP vec4 colorVarying;
varying MEDP vec2 uvVarying;

uniform sampler2D sampler;
varying vec2 vTexCoord;
 
void main() { 
	vec4 sum = vec4(0.0);
 
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   0.0    / 768.0)) * 0.092024624;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   1.5    / 768.0)) * 0.090202413;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -1.5    / 768.0)) * 0.090202413;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   3.5    / 768.0)) * 0.084949426;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -3.5    / 768.0)) * 0.084949426;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   5.5    / 768.0)) * 0.076865427;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -5.5    / 768.0)) * 0.076865427;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   7.5    / 768.0)) * 0.066823587;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -7.5    / 768.0)) * 0.066823587;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   9.5    / 768.0)) * 0.055815756;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -9.5    / 768.0)) * 0.055815756;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   11.5    / 768.0)) * 0.044793192;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -11.5    / 768.0)) * 0.044793192;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0 / 1024.0, vTexCoord.y +   13.5    / 768.0)) * 0.034537863;
	sum = sum + texture2D(sampler, vec2(vTexCoord.x + 0.0  / 1024.0, vTexCoord.y +   -13.5    / 768.0)) * 0.034537863;

 	if (sum.a > 0.0) {
 		gl_FragColor = sum;
 	}
 	else {
		gl_FragColor = sum * colorVarying;
 	}
}
