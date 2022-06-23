Shader "mousedoc/Example/CameraBasedOutline"
{
    Properties
    {
        _MainColor("Color", Color) = (1, 1, 1, 1)
        _LightStepFalloff("Light Step Falloff", Range(0, 1)) = 0.1
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
            "Queue" = "Transparent"
        }

        // Outline
        Pass
        {
            Name "Outline"
            
            Tags 
            { 
                "RenderType" = "Opaque" 
            }

            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            #pragma vertex vert
            #pragma fragment frag
            #pragma prefer_hlslcc gles
            // #pragma exclude_renderers d3d11_9x

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

                VertexPositionInputs vertex = GetVertexPositionInputs(input.vertex.xyz);
                output.vertex = vertex.positionCS; // clip space
                
                VertexNormalInputs normal = GetVertexNormalInputs(input.normal);
                output.normal = normal.normalWS;
                output.normal = input.normal;
                
                float distanceToCamera = distance(mul((float3x3)unity_ObjectToWorld, output.vertex.xyz), _WorldSpaceCameraPos);
                input.vertex.xyz += normalize(output.normal) * _OutlineWidth * 0.020 * distanceToCamera; // 0.020 = Magic 'feels-good' human number
                output.vertex = TransformObjectToHClip(input.vertex.xyz);
                
                return output;
            }

            half4 frag(VertexOutput input) : SV_Target
            {
                return _OutlineColor;
            }

            ENDHLSL
        }

        UsePass "mousedoc/Example/SpecularCellShade/SpecularCellShade"
    }
}