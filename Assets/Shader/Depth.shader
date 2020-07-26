Shader "mousedoc/Example/Depth"
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
                half4 vertex : POSITION;
            };

            struct VertexOutput
            {
                half4 vertex : SV_POSITION;
                half depth : DEPTH;
            };

            VertexOutput vert(VertexInput input) 
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.depth = -UnityObjectToViewPos(input.vertex).z * _ProjectionParams.w;

                return output;
            }

            fixed4 frag(VertexOutput input) : SV_Target
            {
                return half4(1 - input.depth.xxx, 1);
            }
            
            ENDCG
        }
    }
}