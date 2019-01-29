varying vec3 position_V;


void main() {
	position_V = position;

	gl_Position = projectionMatrix * viewMatrix * vec4(position, 1.0);
}