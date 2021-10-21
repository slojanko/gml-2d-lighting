struct VertexShaderInput
{
    float4 pos : POSITION;
};

struct VertexShaderOutput
{
    float4 pos : SV_POSITION;
	float info : TEXCOORD0;
};

uniform float2 u_vLightPos[4];

VertexShaderOutput main(VertexShaderInput INPUT)
{
	float4 pos = float4(INPUT.pos.xy, 0.0, 1.0);
	pos.xy += (INPUT.pos.xy - u_vLightPos[INPUT.pos.z]) * INPUT.pos.w * 256.0;
	
	VertexShaderOutput OUTPUT;
    OUTPUT.pos = mul(gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION], pos);
	OUTPUT.info = INPUT.pos.z;

    return OUTPUT;
}