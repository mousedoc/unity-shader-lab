Shader "mousedoc/Example/Specular"
{
	Properties
	{
		_MainColor("Color", Color) = (1, 1, 1, 1)
		_AmbientColor("Ambient Color", Color) = (0, 0.075, 0.15, 1)
		_Gloss("Gloss", float) = 1
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
			uniform half _Gloss;

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORAML;
				float3 worldPosition : TEXCOORD0;
			};

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
				half3 viewDirection = normalize(_WorldSpaceLightPos0.xyz - input.worldPosition);
				half3 lightDirection = _WorldSpaceLightPos0.xyz;

				// Diffuse
				half lightFallOff = saturate(dot(lightDirection, input.normal));
				half3 directDiffuseLight = _LightColor0 * lightFallOff + _AmbientColor;

				// Specular
				half3 viewReflect = reflect(-viewDirection, normal);
				half specularFallOff = saturate(dot(viewReflect, lightDirection));
				specularFallOff = pow(specularFallOff, _Gloss);
				half4 directSpecularLight = specularFallOff * _LightColor0;

				// Composite
				half3 result = _MainColor * directDiffuseLight + directSpecularLight;
				return half4(result, 1);
			}

			ENDCG
		}
	}
}