struct PixelShaderInput
{
    float4 pos : SV_POSITION;
	float4 color : COLOR0;
};

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
    return INPUT.color;
}