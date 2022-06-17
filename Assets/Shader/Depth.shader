Shader "mousedoc/Example/Depth"
{
    SubShader
    {
        Tags { "RenderType" = "Geometry" }

        Pass
        {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            sampler2D _CameraDepthTexture;

            struct VertexInput
            {
                half4 vertex : POSITION;
            };

            struct VertexOutput
            {
                half4 vertex : SV_POSITION;
                half4 screenPos : TEXCOORD0;
            };

            VertexOutput vert(VertexInput input) 
            {
                VertexOutput output;
                output.vertex = UnityObjectToClipPos(input.vertex);
                output.screenPos = ComputeScreenPos(output.vertex);
                //COMPUTE_EYEDEPTH(output.screenPos.z);

                return output;
            }

            fixed4 frag(VertexOutput input) : SV_Target
            {
                //sampler2D sampler_CameraDepthTexture;
                //half depth = LinearEyeDepth (_CameraDepthTexture.Sample (sampler_CameraDepthTexture, input.screenPos.xy / input.screenPos.w).r);




              half sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(input.screenPos)));
              half depth = sceneZ - input.screenPos.z;

              return half4(depth.xxx, 1);
            }
             
            ENDCG
        }
    }
}