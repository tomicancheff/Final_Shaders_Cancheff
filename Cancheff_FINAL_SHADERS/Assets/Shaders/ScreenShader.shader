// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ScreenShader"
{
	Properties
	{
		_MainScreentext("MainScreentext", 2D) = "white" {}
		_Intensity("Intensity", Range( 0 , 1)) = 0.5707583
		_RGBtexture("RGB texture", 2D) = "white" {}
		_TilingRGB("Tiling RGB", Float) = 15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MainScreentext;
			uniform float4 _MainScreentext_ST;
			uniform sampler2D _RGBtexture;
			uniform float _TilingRGB;
			uniform float _Intensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainScreentext = i.ase_texcoord1.xy * _MainScreentext_ST.xy + _MainScreentext_ST.zw;
				float2 temp_cast_0 = (_TilingRGB).xx;
				float2 texCoord19 = i.ase_texcoord1.xy * temp_cast_0 + float2( 0,0 );
				float4 temp_output_20_0 = ( tex2D( _MainScreentext, uv_MainScreentext ) * saturate( tex2D( _RGBtexture, texCoord19 ) ) );
				float4 color13 = IsGammaSpace() ? float4(0.4493592,0.9622642,0.9622642,0) : float4(0.1701257,0.9162945,0.9162945,0);
				float4 lerpResult14 = lerp( temp_output_20_0 , ( temp_output_20_0 * color13 ) , _Intensity);
				
				
				finalColor = lerpResult14;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
373;73;1053;443;1654.823;577.9727;2.709956;True;False
Node;AmplifyShaderEditor.CommentaryNode;26;-968.1377,-244.1057;Inherit;False;1559.577;853.9216;Screen RGB and Color Tiling;10;23;25;19;17;20;21;16;14;13;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-918.1377,443.0459;Inherit;False;Property;_TilingRGB;Tiling RGB;3;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-748.9935,429.9349;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;25;-461.11,-194.1057;Inherit;False;370;280;Using renderTexture;1;1;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;17;-390.869,379.8159;Inherit;True;Property;_RGBtexture;RGB texture;2;0;Create;True;0;0;0;False;0;False;-1;5c363a0713751ec4f97e142fa8ae063b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-411.11,-144.1056;Inherit;True;Property;_MainScreentext;MainScreentext;0;0;Create;True;0;0;0;False;0;False;-1;8212c8ce2172daf45b689d6b9346f544;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;28;-20.97107,292.236;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;37.68352,-47.50302;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-394.0314,156.3545;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;0;False;0;False;0.4493592,0.9622642,0.9622642,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;239.9649,93.76009;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;16;176.9521,221.9017;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;0;False;0;False;0.5707583;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;409.4389,51.69747;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;24;686.7311,-33.58796;Inherit;False;276;192;Unlit Shader;1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;736.7311,16.41204;Float;False;True;-1;2;ASEMaterialInspector;100;1;ScreenShader;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;False;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;0;False;-1;False;True;True;True;True;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;19;0;23;0
WireConnection;17;1;19;0
WireConnection;28;0;17;0
WireConnection;20;0;1;0
WireConnection;20;1;28;0
WireConnection;21;0;20;0
WireConnection;21;1;13;0
WireConnection;14;0;20;0
WireConnection;14;1;21;0
WireConnection;14;2;16;0
WireConnection;0;0;14;0
ASEEND*/
//CHKSM=70056045902A24E6964A8639E52548B770778955