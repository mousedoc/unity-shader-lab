Shader "mousedoc/Example/VertexDisplacement"
{
	Properties
	{
		_Color("Color", Color) = (0, 1, 1, 1)
		_Frequency("Frequency", float) = 20
		_Amplitude("Amplitude", float) = 0.1
		_Axis("Axis", Vector) = (0.1, 1, 0.1)
		_Speed("Speed", float) = 0.5
	}

	SubShader
	{
		Tags
		{
			"RenderType" = "Opaque"
		}

		Pass
		{
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
	
			float4 _Color;
			float _Frequency;
			float _Amplitude;
			float _Speed;
			half3 _Axis;

			v2f vert(appdata v)
			{
				float4 originVert = v.vertex;

				float time = _Speed * _Time * 200;	// 200 is magic number
				float4 sinWave = sin(time + originVert * _Frequency) * _Amplitude;

				float newX = originVert.x + sinWave * _Axis.r;
				float newY = originVert.y + sinWave * _Axis.g;
				float newZ = originVert.z + sinWave * _Axis.b;
				float4 newVert = float4(newX, newY, newZ, 1);

				v2f o;
				o.vertex = UnityObjectToClipPos(newVert);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_TARGET0
			{
				return _Color;
			}

			ENDCG
		}
	}
}