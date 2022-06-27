Shader "mousedoc/Example/CullFrontOutline"
{
    Properties
    {
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _LightStepFalloff("Light Step Falloff", Range(-1, 1)) = 0.1
        _AmbientColor("Ambient Color", Color) = (0, 0.075, 0.15, 1)
        _Gloss("Gloss", float) = 15
        _GlossStepFalloff("Gloss Step Falloff", Range(0, 1)) = 0.1
        _OutlineColor("Outline Color", Color) = (0.5, 0.5, 0.5, 1)
        _OutlineWidth("Outline Width", Range(0, 1)) = 0.1
    }

    SubShader
    {
        Tags
        { 
            "RenderType" = "Opaque" 
            "Queue" = "Transparent" 
        }

        // First, draw itself
        UsePass "mousedoc/Example/SpecularCellShade/SpecularCellShade"

        // Outline with cull front, In SRP, multi pass not works
        Pass
        {
            Name "Outline"
            
            Tags 
            { 
                "RenderType" = "Opaque" 
            }

            //ZWrite Off
            Cull front

            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM

            #include "UnityCG.cginc"

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
            };

            uniform half4 _OutlineColor;
            uniform half _OutlineWidth;

            VertexOutput vert (VertexInput input)
            {
                VertexOutput output;

                output.vertex = input.vertex;                
                output.normal = input.normal;
                
                input.vertex.xyz += normalize(output.normal) * _OutlineWidth;
                output.vertex = UnityObjectToClipPos(input.vertex.xyz); // in SRP using TransformObjectToHClip(input.vertex.xyz);
                
                return output;
            }

            half4 frag(VertexOutput input) : SV_Target
            {
                return _OutlineColor;
            }

            ENDCG
        }
    }
}