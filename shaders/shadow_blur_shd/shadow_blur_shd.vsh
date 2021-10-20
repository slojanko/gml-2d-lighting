struct VertexShaderInput
{
    float3 pos : POSITION;
	float4 color : COLOR0;
	float2 uv : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 pos : SV_POSITION;
};

VertexShaderOutput main(VertexShaderInput INPUT)
{
    VertexShaderOutput OUTPUT;
    OUTPUT.pos = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], float4(INPUT.pos, 1.0));

    return OUTPUT;
}