struct PixelShaderInput
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

uniform float u_fChannel;

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
	float4 light_color = gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv);
	float4 output = light_color.aaaa * float4(0 == u_fChannel, 1 == u_fChannel, 2 == u_fChannel, 3 == u_fChannel);
	return output;
}