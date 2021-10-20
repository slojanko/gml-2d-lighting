struct PixelShaderInput
{
    float4 pos : SV_POSITION;
};

uniform float2 u_vLightPos;

#define Pi2 6.28318530718

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
	float directions = 8.0; // Blur directions, how many samples are made in a circle
    float quality = 3.0; // Blur quality, how many samples are made in a single direction
    float size = 48.0; // Blur size, maximum sample distance
	
	float2 uv = INPUT.pos.xy / float2(1280.0, 720.0);
	float dist = distance(u_vLightPos / float2(1280.0, 720.0), uv);
	
    float2 radius = size / float2(1280.0, 720.0) * dist;
    float4 color = gm_BaseTextureObject.Sample(gm_BaseTexture, uv);
	
	// Blur calculations
    for(float d = 0.0; d < Pi2; d += Pi2/directions)
    {
		for(float i = 1.0; i <= quality; i++)
        {
			color += gm_BaseTextureObject.Sample(gm_BaseTexture, uv + float2(cos(d),sin(d)) * radius * (i / quality));
        }
    }
		
    color /= quality * directions + 1.0;
	return color;
}