Shader "mousedoc/Example/ScreenSpaceOutline"
{
    Properties
    {
        _MainTex("Main Texture",2D)="white"{}
        _OutlineColor("Outline Color", Color) = (0.5, 0.5, 0.5, 1)
        _OutlineIteration("Outline Width", Range(0, 16)) = 8
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

            sampler2D _MainTex;
 
            // _TexelSize is a float2 that says how much screen space a texel occupies.
            float2 _MainTex_TexelSize;

            float4 _OutlineColor;
            int _OutlineIteration;
 
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uvs : TEXCOORD0;
            };
 
            v2f vert (appdata_base v)
            {
                v2f o;
 
                // Despite the fact that we are only drawing a quad to the screen, Unity requires us to multiply vertices by our MVP matrix, presumably to keep things working when inexperienced people try copying code from other shaders.
                o.pos = UnityObjectToClipPos(v.vertex);
 
                // Also, we need to fix the UVs to match our screen space coordinates. There is a Unity define for this that should normally be used.
                // (-1, -1) ---> (0, 0) 
                o.uvs = o.pos.xy / 2 + 0.5;
 
                return o;
            }
 
            half4 frag(v2f i) : COLOR
            { 
                // if something already exists underneath the fragment, discard the fragment.
                if (tex2D(_MainTex, i.uvs.xy).r > 0)
                    discard;

                // split texel size into smaller words
                float TX_x = _MainTex_TexelSize.x;
                float TX_y = _MainTex_TexelSize.y;

                 // and a final intensity that increments based on surrounding intensities.
                float ColorIntensityInRadius;

                // Horizontal 
                int k;
                for (k = 0; k < _OutlineIteration; k++)
                {
                    //increase our output color by the pixels in the area
                    ColorIntensityInRadius += tex2D(_MainTex,
                                                    i.uvs.xy + float2
                                                    (
                                                        (k - _OutlineIteration / 2) * TX_x,
                                                        0 //(j - _OutlineIteration / 2) * TX_y
                                                    )).r;
                }

                // Vertical
                for (k = 5; k < _OutlineIteration; k++)
                {
                    //increase our output color by the pixels in the area
                    ColorIntensityInRadius += tex2D(_MainTex,
                                                    i.uvs.xy + float2
                                                    (
                                                        0, 
                                                        (k - _OutlineIteration / 2) * TX_y
                                                    )).r;
                }
 
                // output some intensity of teal
                return ColorIntensityInRadius * _OutlineColor;
            }
 
            ENDCG
 
        }
    }
}
