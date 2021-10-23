struct PixelShaderInput
{
    float4 pos : SV_POSITION;
	float2 info : TEXCOORD0;
};

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
	return float4(0 == INPUT.info.x, 1 == INPUT.info.x, 2 == INPUT.info.x, 3 == INPUT.info.x) * INPUT.info.y;
}