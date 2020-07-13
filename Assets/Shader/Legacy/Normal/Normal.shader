Shader "Legacy/Example/Normal"
{
    Properties
    {
        _MainText ("Texture", 2D) = "white" {}
        _MainColor ("Color", Color) = (1,1,1,1)
    }

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainColor;

            v2f vert (appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.normal = v.normal;
                return output;
            }

            fixed4 frag (v2f input) : SV_Target
            {
                float3 normal = input.normal;
                return float4(normal, 1);
            }

            ENDCG
        }
    } 
}