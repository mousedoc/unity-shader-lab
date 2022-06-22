Shader "mousedoc/Example/Depth"
{
    SubShader
    {
        Pass
        {
            Tags { "RenderType" = "Opaque" }

            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float depth : DEPTH;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.depth = -UnityObjectToViewPos(v.vertex).z;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // If the camera's far clipping plane is large, the difference may not be noticeable.
                float depth = i.depth;
                depth  = 1 - (depth / _ProjectionParams.z);

                return float4(depth.xxx, 1);
            }
            ENDCG
        }
    }
}

