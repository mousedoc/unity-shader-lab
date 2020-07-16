Shader "Legacy/Example/GradientSlerp"
{
    Properties
    {
        _TopColor ("Top Color", Color) = (1,1,1,1)
        _BottomColor ("Bottom Color", Color) = (0,0,0,1)
    }

    SubShader
    {
        Tags { "RenderType" = "Geometry" }

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"
            
            #pragma vertex vert
            #pragma fragment frag

            uniform half3 _TopColor;
            uniform half3 _BottomColor;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float3 uv : TEXCOORD0;
            };


            VertexOutput vert (VertexInput input)
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;

                return output;
            }

            fixed4 frag (VertexOutput input) : SV_Target
            {
                half3 blend = lerp(_BottomColor, _TopColor, input.uv.y);
                return half4(blend, 1);
            }

            ENDCG
        }
    }
}