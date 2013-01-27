attribute vec4 position;
attribute vec2 uv;
attribute vec4 color;

varying vec4 colorVarying;
varying vec2 uvVarying;
varying vec2 vTexCoord;
uniform int vertical;

void main () {
    gl_Position = position; 
	uvVarying = uv;
    colorVarying = color;
    vTexCoord = uvVarying;
}
