Shader "Legacy/Example/Normal"
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
                float3 normal : NORMAL;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };


            VertexOutput vert (VertexInput input)
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = input.normal;

                return output;
            }

            fixed4 frag (VertexOutput input) : SV_Target
            {
                float3 normal = input.normal * _Multiply;
                return float4(normal, 1);
            }

            ENDCG
        }
    } 
}