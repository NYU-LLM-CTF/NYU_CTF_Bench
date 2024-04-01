#version 300 es

precision highp float;

uniform sampler2D t_color;
uniform sampler2D t_depth;
uniform float u_resolution[2];

in vec2 v_uv;

out vec4 outColour;

// Sobel filter edge 'width'
const float stepSize = 1.25;
const vec3 edgeColour = vec3(0.);

float intensity(in vec4 color)
{
	float rawDepth = color.r;
	float depth = (1.0 - rawDepth) * 20.;
	return depth;
}

// https://www.shadertoy.com/view/Xdf3Rf
vec3 sobel(sampler2D tex, float stepx, float stepy, vec2 center)
{
	// get samples around pixel
	float tleft = intensity(texture(tex, center + vec2(-stepx, stepy)));
	float left = intensity(texture(tex, center + vec2(-stepx, 0)));
	float bleft = intensity(texture(tex, center + vec2(-stepx, -stepy)));
	float top = intensity(texture(tex, center + vec2(0, stepy)));
	float bottom = intensity(texture(tex, center + vec2(0, -stepy)));
	float tright = intensity(texture(tex, center + vec2(stepx, stepy)));
	float right = intensity(texture(tex, center + vec2(stepx, 0)));
	float bright = intensity(texture(tex, center + vec2(stepx, -stepy)));

	// Sobel masks (see http://en.wikipedia.org/wiki/Sobel_operator)
	//        1 0 -1     -1 -2 -1
	//    X = 2 0 -2  Y = 0  0  0
	//        1 0 -1      1  2  1

	// Could also use Scharr operator:
	//        3 0 -3        3 10   3
	//    X = 10 0 -10  Y = 0  0   0
	//        3 0 -3        -3 -10 -3

	float x = tleft + 2.0 * left + bleft - tright - 2.0 * right - bright;
	float y = -tleft - 2.0 * top - tright + bleft + 2.0 * bottom + bright;
	float color = sqrt((x * x) + (y * y));
	return vec3(color);
}

void main()
{
	vec3 edges = sobel(t_depth, stepSize / u_resolution[0], stepSize / u_resolution[1], v_uv);
	outColour = texture(t_color, v_uv);
	outColour.rgb = mix(outColour.rgb, edgeColour, step(0.5, edges));
}
