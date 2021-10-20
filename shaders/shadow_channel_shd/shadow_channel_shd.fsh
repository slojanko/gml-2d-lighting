struct PixelShaderInput
{
    float4 pos : SV_POSITION;
	float info : TEXCOORD0;
};

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
    return float4(0 != INPUT.info, 1 != INPUT.info, 2 != INPUT.info, 3 != INPUT.info);
}