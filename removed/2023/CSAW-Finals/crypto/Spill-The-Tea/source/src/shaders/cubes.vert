#version 300 es
precision highp float;
precision lowp usampler2D; // Usually 8 bits PER channel, so total 32 with RGBA
precision highp int;

in vec3 position;
in vec3 normal;
in vec2 texCoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;

uniform usampler2D t_sampler;
uniform ivec2 u_texRes;
uniform int[4] u_key;

out vec3 v_pos;
out vec3 v_normal;
out vec4 v_colour;

const vec3 cubeScale = vec3(0.92, 0.92, 2.0);
const float scale = 0.1;
const vec2 imgSize = vec2(40, 25);

mat4 translationMatrix(vec3 delta)
{
	mat4 m;
	m[0][0] = 1.;
	m[1][1] = 1.;
	m[2][2] = 1.;
	m[3] = vec4(delta, 1.0);
	return m;
}

vec4 srgbToLinear(uvec4 srgb)
{
	vec4 colorFloat;
	colorFloat.rgb = vec3(srgb) / 255.0;
	colorFloat.rgb = pow(colorFloat.rgb, vec3(2.2));
	colorFloat.a = float(srgb.a) / 255.0; // Alpha is typically linear

	return colorFloat;
}

vec3 decodeLocation(uvec4 srgb)
{
	vec3 offset = vec3(127., 127., 127.);
	return (vec4(srgb).xyz - offset) * scale;
}

uvec4 tea_cbc(uvec4 x, uvec4 p)
{
	const uint delta = 0x9e37u;
	const uint FF = 0xFFFFu;
	uint v1 = x.g + (x.r << 8);
	uint v2 = x.a + (x.b << 8);

	uint v2p1 = (((v1 << 4) & FF) + (uint(u_key[2]) & 0xFFu)) & FF;
	uint v2p2 = (v1 + delta) & FF;
	uint v2p3 = (((v1 >> 5) & 0x07ffu) + uint(u_key[3])) & FF;
	v2 = (v2 - (v2p1 ^ v2p2 ^ v2p3)) & FF;

	uint v1p1 = (((v2 << 4) & FF) + (uint(u_key[0]) & 0xFFu)) & FF;
	uint v1p2 = (v2 + delta) & FF;
	uint v1p3 = (((v2 >> 5) & 0x07ffu) + uint(u_key[1])) & FF;
	v1 = (v1 - (v1p1 ^ v1p2 ^ v1p3)) & FF;

	uvec4 y;
	y.g = (v1 & 0xFFu) ^ p.g;
	y.r = (v1 >> 8) ^ p.r;
	y.a = (v2 & 0xFFu) ^ p.a;
	y.b = (v2 >> 8) ^ p.b;
	return y;
}

void main()
{
	ivec2 coord = ivec2(texCoord);
	uvec4 colourData = texelFetch(t_sampler, coord, 0);
	uvec4 locData = texelFetch(t_sampler, coord + ivec2(1, 0), 0);

	ivec2 texsize = textureSize(t_sampler, 0);
	int pos = coord.x + (coord.y * texsize.x);
	ivec2 colCoord = ivec2((pos - 1) % texsize.x, floor(float(pos - 1) / float(texsize.y)));

	uvec4 prevColour;
	uvec4 prevLoc;

	if (pos == 0)
	{
		prevColour = uvec4(0x12u, 0x34u, 0x56u, 0x78u);
	}
	else
	{
		prevColour = texelFetch(t_sampler, colCoord, 0);
	}

	locData = tea_cbc(locData, colourData);
	colourData = tea_cbc(colourData, prevColour);

	v_colour = srgbToLinear(colourData);
	v_colour.a = 1.;

	vec3 cube = position * cubeScale * scale;
	mat4 offset = translationMatrix(decodeLocation(locData));
	vec4 vertPos = modelViewMatrix * offset * vec4(cube, 1.0);

	v_pos = vertPos.xyz / vertPos.w;
	v_normal = normalize(normalMatrix * normal);
	gl_Position = projectionMatrix * vertPos;
}
