//VARYING VAR
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec4 PositionFromLight_V;
varying vec2 Texcoord_V;
varying vec4 ShadowCoords;



//UNIFORM VAR
// Inverse world matrix used to render the scene from the light POV
uniform mat4 lightViewMatrixUniform;

// Projection matrix used to render the scene from the light POV
uniform mat4 lightProjectMatrixUniform;

mat4 lightSpaceMatrix =lightProjectMatrixUniform * lightViewMatrixUniform;

void main() {
	Normal_V = normalMatrix * normal;
	Position_V = vec3(modelViewMatrix * vec4(position, 1.0));
	Texcoord_V = uv;
	ShadowCoords = lightSpaceMatrix * modelMatrix * vec4(position, 1.0);

   
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

}