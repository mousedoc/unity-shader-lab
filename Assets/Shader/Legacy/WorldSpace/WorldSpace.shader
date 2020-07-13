Shader "Legacy/Example/World Space"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXTCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.worldPosition = mul(unity_ObjectToWorld, v.vertex);
                return output;
            }

            fixed4 frag (v2f input) : SV_Target
            {
                return float4(input.worldPosition, 1);
            }

            ENDCG
        }
    }
}