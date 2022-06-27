Shader "mousedoc/Example/ScrollingTexture"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _HorizontalSpeed("Horizontal Speed", Float) = 0.5
        _VerticalSpeed("Vertical Speed", Float) = 0.5
    }

    SubShader
    {
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
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            // The sampler state forces our texture to use filtering mode 'linear' an d wrap mode 'repeat' regardless of texture settings
            SamplerState sampler_linear_repeat;

            float _HorizontalSpeed;
            float _VerticalSpeed;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float uvX = i.uv.x + (_Time * _HorizontalSpeed * 10);
                float uvY = i.uv.y + (_Time * _VerticalSpeed * 10);

                return tex2D(_MainTex, float2(uvX, uvY));
                //return _MainTex.Sample(sampler_linear_repeat, float2(uvX, uvY));
            }

            ENDCG
        }
    }
}
