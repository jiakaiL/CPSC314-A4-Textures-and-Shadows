// UNIFORMS
uniform samplerCube skybox;

//Varying 
varying vec3 position_V;

void main() {
	
	vec3 P = normalize(position_V);
	
	vec4 texColor = textureCube(skybox,P);

	gl_FragColor = vec4(texColor.x, texColor.y, texColor.z, 1.0);
}