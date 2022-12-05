Shader "Maoh/SimplePass/InvertColor"
{   
    SubShader
    {
        // Draw it after opaque geometry layers have been rendered
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100

        // Grab the rendered screen behind current layer
        GrabPass
        {
            "_BackTex"
        }

        // Render
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
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (appdata_base v)
            {
                v2f o;

                // calculate clip space
                o.pos = UnityObjectToClipPos(v.vertex);

                // get correct texture coordinate
                o.grabPos = ComputeGrabScreenPos(o.pos);

                return o;
            }

            sampler2D _BackTex;

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 bgcolor = tex2Dproj(_BackTex, i.grabPos);

                // return inverted
                return 1 - bgcolor;
            }
            ENDCG
        }
    }
}
