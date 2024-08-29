#version 300 es

in vec2 uv;
in vec2 position;

out vec2 v_uv;

void main()
{
	v_uv = uv;
	gl_Position = vec4(position, 0, 1);
}
