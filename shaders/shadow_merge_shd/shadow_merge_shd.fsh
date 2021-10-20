struct PixelShaderInput
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

static const float4x4 white = {	1.0, 1.0, 1.0, 1.0,
								1.0, 1.0, 1.0, 1.0,
								1.0, 1.0, 1.0, 1.0,
								1.0, 1.0, 1.0, 1.0};

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
	float4 channels = gm_BaseTextureObject.Sample(gm_BaseTexture, INPUT.uv);
	return mul(white, channels);
}