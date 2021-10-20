struct PixelShaderInput
{
    float4 pos : SV_POSITION;
};

float4 main(PixelShaderInput INPUT) : SV_TARGET
{
    return float4(0.0, 0.0, 0.0, 1.0);
}