Shader "Example/World Space"
{
    Properties
    {
        _Multiply ("Multiply", Float ) = 1
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

            uniform float _Multiply;

            struct VertexInput
            {
                float4 vertex : POSITION;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXTCOORD0;
            };


            VertexOutput vert (VertexInput input)
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.worldPosition = mul(unity_ObjectToWorld, input.vertex);

                return output;
            }

            fixed4 frag (VertexOutput input) : SV_Target
            {
                return float4(input.worldPosition * _Multiply, 0);
            }

            ENDCG
        }
    }
}