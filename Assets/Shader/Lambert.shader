Shader "mousedoc/Example/Lambert"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        _AmbientColor ("Ambient Color", Color) = (0, 0.075, 0.15, 1)
    }
    
    SubShader
    {
        Tags { "RenderType" = "Geometry" }

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment frag

            uniform half4 _MainColor;
            uniform half4 _AmbientColor;

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

            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = input.normal;

                return output;
		    }

            fixed4 frag(VertexOutput input) : SV_Target
            {
                // Direct light 
                half3 lightSource = _WorldSpaceLightPos0.xyz;
                half lightFallOff = max(0, dot(lightSource, input.normal));
                half3 directDiffUseLight = _LightColor0 * lightFallOff;

                // Add ambient
                half3 diffUseLight = directDiffUseLight + _AmbientColor;
                return float4(diffUseLight * _MainColor, 1);
            }
            
            ENDCG
		}
    }
}
