Shader "Legacy/Example/UV"
{
    SubShader
    {
        Tags { "RenderType" = "Geometry" }

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag


            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
                return output;
            }

            fixed4 frag (VertexOutput input) : SV_Target
            {
                return float4(input.uv.r, input.uv.g, 0, 1);
            }

            ENDCG
        }
    }
}