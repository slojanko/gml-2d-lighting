struct PixelShaderInput
{
    float4 pos : SV_POSITION;
	float2 uv : TEXCOORD0;
};

uniform float2 u_vLightPos[4];

#define Pi2 6.28318530718

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
	float directions = 8.0;
    float quality = 3.0;
    float size = 0.035;
	
	float4 color = gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv);
	
	// RED
	float distR = distance(INPUT.uv, u_vLightPos[0]);
	float2 radiusR = size * distR;
	float distG = distance(INPUT.uv, u_vLightPos[1]);
	float2 radiusG = size * distG;
	float distB = distance(INPUT.uv, u_vLightPos[2]);
	float2 radiusB = size * distB;
	float distA = distance(INPUT.uv, u_vLightPos[3]);
	float2 radiusA = size * distA;
	
	for(float d = 0.0; d < Pi2; d += Pi2/directions)
	{
		for(float i = 1.0; i <= quality; i++)
	    {
			color.r += gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv + float2(cos(d),sin(d)) * radiusR * (i / quality)).r;
			color.g += gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv + float2(cos(d),sin(d)) * radiusG * (i / quality)).g;
			color.b += gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv + float2(cos(d),sin(d)) * radiusB * (i / quality)).b;
			color.a += gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv + float2(cos(d),sin(d)) * radiusA * (i / quality)).a;
	    }
	}
	
	color /= quality * directions + 1.0;
	
	return color;
}