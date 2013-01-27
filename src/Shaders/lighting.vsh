uniform mat4 transform;

attribute vec4 position;

varying vec2 uvVarying;

void main () {
    gl_Position = position * transform;
	uvVarying = position.xy;
}
