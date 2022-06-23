Shader "mousedoc/Example/White"
{
    SubShader
    {
        //ZWrite Off
        //ZTest Always
        Lighting Off
        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
 
            struct v2f
			{
				float4 vertex : POSITION;
			};
 
            v2f vert(v2f i)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(i.vertex);
                return o;
            }
 
            half4 frag() : SV_Target 
            {
                return half4(1, 1, 1, 1);
            }
 
            ENDCG
        }
    }
}