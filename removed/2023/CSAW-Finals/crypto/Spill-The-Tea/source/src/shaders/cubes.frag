#version 300 es
precision highp float;

in vec3 v_pos;
in vec3 v_normal;
in vec4 v_colour;

out vec4 outColour;

const vec3 lightDirection = vec3(0.9, 0.0, -1.0);
const vec4 diffuseColor = vec4(0.25, 0.0, 0.0, 1.0);
const vec4 specularColor = vec4(vec3(0.5), 1.0);
const float shininess = 50.0;
const vec4 lightColor = vec4(1.0, 1.0, 1.0, 1.0);
const float irradiPerp = 1.0;

vec3 blinnPhongBRDF(vec3 lightDir, vec3 viewDir, vec3 normal, vec3 phongDiffuseCol, vec3 phongSpecularCol,
					float phongShininess)
{
	vec3 color = phongDiffuseCol;
	vec3 halfDir = normalize(viewDir + lightDir);
	float specDot = max(dot(halfDir, normal), 0.0);
	color += pow(specDot, phongShininess) * phongSpecularCol;
	return color;
}

void main()
{

	vec3 ambientColor = v_colour.rgb * 0.01;
	vec3 lightDir = normalize(-lightDirection);
	vec3 viewDir = normalize(-v_pos);
	vec3 normal = normalize(v_normal);

	vec3 radiance = ambientColor;

	float irradiance = max(dot(lightDir, normal), 0.0) * irradiPerp;
	if (irradiance > 0.0)
	{
		vec3 brdf = blinnPhongBRDF(lightDir, viewDir, normal, v_colour.rgb, specularColor.rgb, shininess);
		radiance += brdf * irradiance * lightColor.rgb;
	}

	radiance = pow(radiance, vec3(1.0 / 2.2)); // gamma correction
	outColour.rgb = radiance;
	outColour.a = v_colour.a;
}
