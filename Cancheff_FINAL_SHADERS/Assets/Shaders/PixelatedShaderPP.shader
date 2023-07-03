// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PixelatedShaderPP"
{
	Properties
	{
		_PixelX("Pixel X", Range( 0 , 5000)) = 0
		_PixelY("Pixel Y", Range( 0 , 5000)) = 0

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			
		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _PixelX;
			uniform float _PixelY;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 texCoord4 = i.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float pixelWidth3 =  1.0f / _PixelX;
				float pixelHeight3 = 1.0f / _PixelY;
				half2 pixelateduv3 = half2((int)(texCoord4.x / pixelWidth3) * pixelWidth3, (int)(texCoord4.y / pixelHeight3) * pixelHeight3);
				

				float4 color = tex2D( _MainTex, pixelateduv3 );
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
364;73;1140;557;1260.56;366.4022;1.70076;True;False
Node;AmplifyShaderEditor.CommentaryNode;7;-1079.801,-52.60215;Inherit;False;1085.329;518.3731;Pixelated Screen / PS1 Shader Style PP;6;4;1;3;2;5;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1029.801,134.6539;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1016.043,271.7709;Inherit;False;Property;_PixelX;Pixel X;0;0;Create;True;0;0;0;False;0;False;0;0;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1003.263,349.771;Inherit;False;Property;_PixelY;Pixel Y;1;0;Create;True;0;0;0;False;0;False;0;0;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-520.6854,-2.602145;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCPixelate;3;-706.0992,118.4755;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;8;67.43806,-37.39605;Inherit;False;257;192;Post Processing Stack Shader;1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-314.4727,4.985422;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;117.4381,12.60395;Float;False;True;-1;2;ASEMaterialInspector;0;2;PixelatedShaderPP;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;3;0;4;0
WireConnection;3;1;5;0
WireConnection;3;2;6;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;0;0;2;0
ASEEND*/
//CHKSM=A4D7318EFF1D9EEF8390CE279B0DC250C89C18D3