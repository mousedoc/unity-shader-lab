Shader "mousedoc/Example/SpecularCellShade"
{
    Properties
    {
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _LightStepFalloff("Light Step Falloff", Range(-1, 1)) = 0.1
        _AmbientColor("Ambient Color", Color) = (0, 0.075, 0.15, 1)
        _Gloss("Gloss", float) = 1
        _GlossStepFalloff("Gloss Step Falloff", Range(0, 1)) = 0.1
    } 

    SubShader
    {
        Pass
        {
            Name "SpecularCellShade"

            Tags { "RenderType" = "Geometry" }

            CGPROGRAM

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct VertexInput
            {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
            };
            
            struct VertexOutput
            {
                half4 vertex : SV_POSITION;
                half3 normal : NORMAL;
                half3 worldPosition : TEXCOORD0;
            };

            uniform half4 _MainColor;
            uniform half4 _AmbientColor;
            uniform half _Gloss;
            uniform half _LightStepFalloff;
            uniform half _GlossStepFalloff;

            VertexOutput vert(VertexInput input)
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.normal = input.normal;
                output.worldPosition = mul(unity_ObjectToWorld, input.vertex);

                return output;
            }

            fixed4 frag(VertexOutput input) : SV_Target
            {
                // Direction
                half3 normal = normalize(input.normal);
                half3 viewDirection = normalize(_WorldSpaceCameraPos - input.worldPosition);
                half3 lightDirection = _WorldSpaceLightPos0.xyz;

                // Diffuse  
                half3 vec = dot(lightDirection, normal);
                //half lightFalloff = saturate(dot(lightDirection, normal));            // if wanna light side only
                half lightFalloff = dot(lightDirection, normal);
                lightFalloff = step(_LightStepFalloff, lightFalloff);
                half3 directDiffuseLight = _LightColor0 * lightFalloff;
                half3 diffuseLight = _AmbientColor + directDiffuseLight;

                // Specular
                half3 viewReflect = reflect(-viewDirection, normal);
                half specularFalloff = saturate(dot(viewReflect, lightDirection));
                specularFalloff = pow(specularFalloff, _Gloss);
                specularFalloff =  step(_GlossStepFalloff, specularFalloff);
                half4 directSpecularLight = specularFalloff * _LightColor0;

                // Composite
                half3 result = _MainColor * diffuseLight + directSpecularLight;

                return half4(result, 1);
            }

            ENDCG
        }
    }

}