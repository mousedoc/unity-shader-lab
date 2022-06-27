Shader "mousedoc/Example/Transparency"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        { 
            "Queue" = "Transparent"
            "RenderType" = "Transparent" 
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
        
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD0;
            };

            sampler2D _MainTex;

            // x, y = Texture Scale
            // z, w = Texture Translation Offset
            float4 _MainTex_ST; 
            float4 _Color;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //#define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);   
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Color;
            }

            ENDCG
        }
    }
}
