//VARYING VAR
varying vec3 Normal_V;
varying vec3 Position_V;
varying vec4 PositionFromLight_V;
varying vec2 Texcoord_V;
varying vec4 ShadowCoords;

//UNIFORM VAR
uniform vec3 lightColorUniform;
uniform vec3 ambientColorUniform;
uniform vec3 lightDirectionUniform;

uniform float kAmbientUniform;
uniform float kDiffuseUniform;
uniform float kSpecularUniform;

uniform float shininessUniform;

uniform sampler2D colorMap;
uniform sampler2D normalMap;
uniform sampler2D aoMap;
uniform sampler2D shadowMap;

// PART D)
// Use this instead of directly sampling the shadowmap, as the float
// value is packed into 4 bytes as WebGL 1.0 (OpenGL ES 2.0) doesn't
// support floating point bufffers for the packing see depth.fs.glsl
float getShadowMapDepth(vec2 texCoord)
{
	vec4 v = texture2D(shadowMap, texCoord);
	const vec4 bitShift = vec4(1.0, 1.0/256.0, 1.0/(256.0 * 256.0), 1.0/(256.0*256.0*256.0));
	return dot(v, bitShift);
}



void main() {
	
	
	
	
	// PART B) TANGENT SPACE NORMAL
	vec3 N_1 = normalize(texture2D(normalMap, Texcoord_V).xyz * 2.0 - 1.0);

	// PRE-CALCS
	vec3 N = normalize(Normal_V);


	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 T = normalize(cross(N,up));
	vec3 B = cross(N, T);

	mat3 TBN_matrix = mat3(
		vec3(T.x, B.x, N.x),
		vec3(T.y, B.y, N.y),
		vec3(T.z, B.z, N.z)
	);

	vec3 L = normalize(vec3(viewMatrix * vec4(lightDirectionUniform, 0.0))) * TBN_matrix;
	
	vec3 V = normalize(-Position_V) *TBN_matrix;
	
	vec3 H = normalize(V + L);

	
	//texturemap 
	vec4 textColor = texture2D(colorMap,Texcoord_V);
	vec4 textAmbient = texture2D(aoMap,Texcoord_V);

	// AMBIENT
	vec3 light_AMB = ambientColorUniform * kAmbientUniform * textAmbient.xyz;

	// DIFFUSE
	vec3 diffuse = kDiffuseUniform * lightColorUniform;
	vec3 light_DFF =diffuse * max(0.0, dot(N_1, L))* textColor.xyz;

	// SPECULAR
	vec3 specular = kSpecularUniform * lightColorUniform;
	vec3 light_SPC = specular * pow(max(0.0, dot(N_1, H)), shininessUniform);
	// TOTAL
	vec3 TOTAL = light_AMB + light_DFF  + light_SPC;

	// SHADOW
	// Fill in attenuation for shadow here
	vec3 ShadowCoords2;
	ShadowCoords2.x = (ShadowCoords.x/ShadowCoords.w)/2.0 + 0.5;
	ShadowCoords2.y = (ShadowCoords.y/ShadowCoords.w)/2.0 + 0.5;
	ShadowCoords2.z = (ShadowCoords.z/ShadowCoords.w)/2.0 + 0.5;

	float visibility = 1.0;
	float depth = getShadowMapDepth(ShadowCoords2.xy);

	if (depth < ShadowCoords2.z + 0.00001) {
		visibility = 0.0;
	}
	gl_FragColor = vec4(TOTAL*visibility, 1.0);
	
}
