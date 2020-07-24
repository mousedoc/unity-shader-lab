Shader "mousedoc/Example/GradientPosterize"
{
	Properties
	{
		_TopColor("Top Color", Color) = (1, 1, 1, 1)
		_BottomColor("Bottom Color", Color) = (0, 0, 0, 1)
		_BlendOffset("Blend Offset", Range(0, 1)) = 0.75
		_Band("Band", Range(1, 100)) = 10

	}

	SubShader
	{
		Tags { "RenderType" = "Geometry" }

		Pass
		{
			CGPROGRAM

			#include "UnityCG.cginc"
			
			#pragma vertex vert
			#pragma fragment frag

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 uv : TEXCOORD0;
			};

			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 uv : TEXCOORD0;
			};

			uniform half4 _TopColor;
			uniform half4 _BottomColor;
			uniform half _BlendOffset;
			uniform half _Band;

			half Posterize(half bandNumber, half target)
			{
				return round(bandNumber * target) / bandNumber;
			}

			VertexOutput vert(VertexInput input)
			{
				VertexOutput output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.uv = input.uv;

				return output;
			}

			fixed4 frag(VertexOutput input) : SV_Target
			{
				half t = smoothstep(1 - _BlendOffset, _BlendOffset, input.uv.y);
				t = Posterize(_Band, t);

				half3 blend = lerp(_BottomColor, _TopColor, t);
				return half4(blend , 1);
			}

			ENDCG
		}
	}
}