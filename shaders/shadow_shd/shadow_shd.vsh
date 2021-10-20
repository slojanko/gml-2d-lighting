struct VertexShaderInput
{
    float3 pos : POSITION;
	float4 byte : TEXCOORD0;
};

struct VertexShaderOutput
{
    float4 pos : SV_POSITION;
};

uniform float2 u_vLightPos;

VertexShaderOutput main(VertexShaderInput INPUT)
{
    float4 pos = float4(INPUT.pos, 1.0);
	float dist = INPUT.byte.x * 1024.0;
	pos.xy += normalize(pos.xy - u_vLightPos) * dist;
	
    VertexShaderOutput OUTPUT;
    OUTPUT.pos = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], pos);

    return OUTPUT;
}