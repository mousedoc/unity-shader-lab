Shader "mousedoc/Example/Normal"
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

            uniform half _Multiply;
            
            struct VertexInput
            {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                half3 normal : NORMAL;
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
                half3 normal = input.normal * _Multiply;
                return half4(normal, 1);
            }

            ENDCG
        }
    } 
}