#version 300 es
precision highp float;

in vec3 position;
in vec3 normal;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;

out vec3 v_pos;
out vec3 v_normal;

void main()
{
	vec4 vertPos = modelViewMatrix * vec4(position, 1.0);

	v_pos = vertPos.xyz / vertPos.w;
	v_normal = normalize(normalMatrix * normal);

	gl_Position = projectionMatrix * vertPos;
}
