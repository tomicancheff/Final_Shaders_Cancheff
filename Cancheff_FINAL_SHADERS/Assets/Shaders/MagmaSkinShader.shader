// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MagmaSkinShader"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_Normals("Normals", 2D) = "bump" {}
		_Mask("Mask", 2D) = "white" {}
		_Specular("Specular", 2D) = "white" {}
		_TileableFire("TileableFire", 2D) = "white" {}
		_FireIntensity("FireIntensity", Range( 0 , 2)) = 0
		_Smoothness("Smoothness", Float) = 1
		_TileSpeed("TileSpeed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normals;
		uniform sampler2D _Albedo;
		uniform sampler2D _Mask;
		uniform sampler2D _TileableFire;
		uniform float2 _TileSpeed;
		uniform float _FireIntensity;
		uniform sampler2D _Specular;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			o.Normal = UnpackNormal( tex2D( _Normals, i.uv_texcoord ) );
			o.Albedo = tex2D( _Albedo, i.uv_texcoord ).rgb;
			float2 panner37 = ( _Time.x * _TileSpeed + i.uv_texcoord);
			o.Emission = ( ( tex2D( _Mask, i.uv_texcoord ) * tex2D( _TileableFire, panner37 ) ) * ( _FireIntensity * ( _SinTime.w + 1.5 ) ) ).rgb;
			o.Specular = tex2D( _Specular, i.uv_texcoord ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
339;73;1052;551;2628.258;1683.865;3.003306;True;False
Node;AmplifyShaderEditor.CommentaryNode;53;-1829.237,-823.0332;Inherit;False;292;209;UV Coordinates for texture;1;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;33;-1937.512,-301.7756;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;35;-1830.715,-440.4922;Float;False;Property;_TileSpeed;TileSpeed;7;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1779.237,-773.0332;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;52;-923.407,-86.59041;Inherit;False;582;363;Fire Intensity;4;36;40;41;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1448.97,-440.4501;Inherit;False;1005.175;280;Moving Fire;4;42;47;39;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1006.2,-1475.786;Inherit;False;415.9274;985.2457;Magma Shader PBR Albedo, Normal, etc;4;46;48;38;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;36;-873.407,93.4096;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;37;-1398.97,-376.7776;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;39;-1141.462,-390.4501;Inherit;True;Property;_TileableFire;TileableFire;4;0;Create;True;0;0;0;False;0;False;-1;f7e96904e8667e1439548f0f86389447;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-818.407,-36.5904;Float;False;Property;_FireIntensity;FireIntensity;5;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-931.3544,-950.1237;Inherit;True;Property;_Mask;Mask;2;0;Create;True;0;0;0;False;0;False;-1;36be8d528a4fa024faa4680d7658642c;36be8d528a4fa024faa4680d7658642c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-671.407,109.4096;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-503.407,2.409572;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-792.795,-383.5904;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;-956.2002,-720.5405;Inherit;True;Property;_Normals;Normals;1;0;Create;True;0;0;0;False;0;False;-1;11f03d9db1a617e40b7ece71f0a84f6f;11f03d9db1a617e40b7ece71f0a84f6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;48;-920.9842,-1181.983;Inherit;True;Property;_Specular;Specular;3;0;Create;True;0;0;0;False;0;False;-1;6618005f6bafebf40b3d09f498401fba;6618005f6bafebf40b3d09f498401fba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;-910.2728,-1425.786;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;7130c16fd8005b546b111d341310a9a4;7130c16fd8005b546b111d341310a9a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-101.2776,-420.7938;Float;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;92.00687,-774.4699;Inherit;False;305;521;Standard Specular ;1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-605.7949,-383.5904;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;142.0069,-724.4699;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;MagmaSkinShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;37;0;34;0
WireConnection;37;2;35;0
WireConnection;37;1;33;1
WireConnection;39;1;37;0
WireConnection;38;1;34;0
WireConnection;40;0;36;4
WireConnection;43;0;41;0
WireConnection;43;1;40;0
WireConnection;42;0;38;0
WireConnection;42;1;39;0
WireConnection;45;1;34;0
WireConnection;48;1;34;0
WireConnection;46;1;34;0
WireConnection;47;0;42;0
WireConnection;47;1;43;0
WireConnection;0;0;46;0
WireConnection;0;1;45;0
WireConnection;0;2;47;0
WireConnection;0;3;48;0
WireConnection;0;4;44;0
ASEEND*/
//CHKSM=42B028490E15180EB74433E0578AA5D8E13DFC01