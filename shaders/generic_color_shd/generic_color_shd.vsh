struct VertexShaderInput
{
    float2 pos : POSITION;
	float4 color : COLOR0;
};

struct VertexShaderOutput
{
    float4 pos : SV_POSITION;
	float4 color : COLOR0;
};

VertexShaderOutput main(VertexShaderInput INPUT)
{
    VertexShaderOutput OUTPUT;
    OUTPUT.pos = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], INPUT.pos);
	OUTPUT.color = INPUT.color;

    return OUTPUT;
}