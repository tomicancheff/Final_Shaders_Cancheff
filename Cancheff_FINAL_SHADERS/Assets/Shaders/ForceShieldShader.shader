// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ForceShieldShader"
{
	Properties
	{
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 17.1
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		_Color("Color", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_ShieldPatternColor("Shield Pattern Color", Color) = (0.2470588,0.7764706,0.9098039,1)
		_ShieldPattern("Shield Pattern", 2D) = "white" {}
		[IntRange]_ShieldPatternSize("Shield Pattern Size", Range( 1 , 20)) = 5
		_ShieldPatternPower("Shield Pattern Power", Range( 0 , 100)) = 5
		_ShieldRimPower("Shield Rim Power", Range( 0 , 10)) = 7
		_ShieldAnimSpeed("Shield Anim Speed", Range( -10 , 10)) = 3
		_ShieldPatternWaves("Shield Pattern Waves", 2D) = "white" {}
		_ShieldDistortion("Shield Distortion", Range( 0 , 0.03)) = 0.01
		_IntersectIntensity("Intersect Intensity", Range( 0 , 1)) = 0.2
		_IntersectColor("Intersect Color", Color) = (0.03137255,0.2588235,0.3176471,1)
		_HitPosition("Hit Position", Vector) = (0,0,0,0)
		_HitTime("Hit Time", Float) = 0
		_HitColor("Hit Color", Color) = (1,1,1,1)
		_HitSize("Hit Size", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform float _ShieldAnimSpeed;
		uniform float _ShieldDistortion;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _IntersectColor;
		uniform float _ShieldRimPower;
		uniform sampler2D _ShieldPattern;
		uniform float _ShieldPatternSize;
		uniform sampler2D _ShieldPatternWaves;
		uniform float _HitTime;
		uniform float3 _HitPosition;
		uniform float _HitSize;
		uniform float4 _ShieldPatternColor;
		uniform float4 _HitColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _IntersectIntensity;
		uniform float _ShieldPatternPower;
		uniform float _Opacity;
		uniform float _TessValue;
		uniform float _TessMin;
		uniform float _TessMax;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _TessMin, _TessMax, _TessValue );
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float4 ShieldSpeed10 = ( _Time * _ShieldAnimSpeed );
			float simplePerlin3D85 = snoise( ( float4( ase_vertexNormal , 0.0 ) + ( ShieldSpeed10 / 5.0 ) ).xyz );
			float VertexOffset98 = (( _ShieldDistortion * -1.0 ) + (simplePerlin3D85 - 0.0) * (_ShieldDistortion - ( _ShieldDistortion * -1.0 )) / (1.0 - 0.0));
			float3 temp_cast_2 = (VertexOffset98).xxx;
			v.vertex.xyz += temp_cast_2;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 Normal97 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			o.Normal = Normal97;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 Albedo99 = ( _Color * tex2D( _Albedo, uv_Albedo ) );
			o.Albedo = Albedo99.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float ShieldRimPower32 = _ShieldRimPower;
			float fresnelNdotV52 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode52 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV52, (10.0 + (ShieldRimPower32 - 0.0) * (0.0 - 10.0) / (10.0 - 0.0)) ) );
			float ShieldRim57 = fresnelNode52;
			float2 appendResult43 = (float2(_ShieldPatternSize , _ShieldPatternSize));
			float4 ShieldSpeed10 = ( _Time * _ShieldAnimSpeed );
			float2 appendResult38 = (float2(1 , ShieldSpeed10.x));
			float2 uv_TexCoord49 = i.uv_texcoord * appendResult43 + appendResult38;
			float4 ShieldPattern59 = tex2D( _ShieldPattern, uv_TexCoord49 );
			float2 appendResult42 = (float2(1 , ( 1.0 - ( ShieldSpeed10 / 5.0 ) ).x));
			float2 uv_TexCoord46 = i.uv_texcoord * float2( 1,1 ) + appendResult42;
			float4 waves58 = tex2D( _ShieldPatternWaves, uv_TexCoord46 );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_17_0 = distance( ase_vertex3Pos , _HitPosition );
			float HitSize19 = _HitSize;
			float4 ShieldPatternColor33 = _ShieldPatternColor;
			float4 HitColor25 = _HitColor;
			float4 lerpResult44 = lerp( ShieldPatternColor33 , ( HitColor25 * ( HitSize19 / temp_output_17_0 ) ) , (0.0 + (_HitTime - 0.0) * (1.0 - 0.0) / (100.0 - 0.0)));
			float4 hit64 = ( _HitTime > 0.0 ? ( temp_output_17_0 < HitSize19 ? lerpResult44 : ShieldPatternColor33 ) : ShieldPatternColor33 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth73 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth73 = abs( ( screenDepth73 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _IntersectIntensity ) );
			float clampResult80 = clamp( distanceDepth73 , 0.0 , 1.0 );
			float4 lerpResult88 = lerp( _IntersectColor , ( ( ( ShieldRim57 + ShieldPattern59 ) * waves58 ) * ( hit64 * ShieldPatternColor33 ) ) , clampResult80);
			float ShieldPower81 = _ShieldPatternPower;
			float4 Emission96 = ( lerpResult88 * ShieldPower81 );
			o.Emission = Emission96.rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
364;73;1140;557;3927.089;990.788;3.700208;True;False
Node;AmplifyShaderEditor.CommentaryNode;3;-2574.382,-1302.132;Inherit;False;830.728;358.1541;Force SHield Animation;4;10;7;5;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2524.382,-1058.978;Float;False;Property;_ShieldAnimSpeed;Shield Anim Speed;14;0;Create;True;0;0;0;False;0;False;3;-1.7;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;4;-2450.791,-1252.133;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2208.254,-1128.719;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;6;-2533.607,167.2224;Inherit;False;1858.993;1001.87;Impact;22;64;56;54;51;47;45;44;39;37;36;34;31;26;25;21;20;19;18;17;12;11;9;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;12;-2483.607,578.8228;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;11;-2475,763.1227;Float;False;Property;_HitPosition;Hit Position;19;0;Create;True;0;0;0;False;0;False;0,0,0;1,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-1991.654,-1117.583;Float;False;ShieldSpeed;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2403.702,217.2224;Float;False;Property;_HitSize;Hit Size;22;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;8;-2551.814,-529.2864;Inherit;False;1608.543;477.595;Force Shield Waving;10;58;50;46;42;40;35;30;22;16;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;18;-2445.39,324.1231;Float;False;Property;_HitColor;Hit Color;21;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;17;-2243.402,662.4229;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-2190.502,221.1225;Float;False;HitSize;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;-2501.814,-253.288;Inherit;False;10;ShieldSpeed;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;15;-856.7872,-470.6349;Inherit;False;1030.896;385.0003;Shield RIM;6;57;52;48;41;32;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;14;-1630.405,-1321.434;Inherit;False;1504.24;684.7161;Force Shield Pattern;12;81;77;59;53;49;43;38;33;29;28;27;23;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2474.949,-166.6909;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-2164.219,326.6758;Float;False;HitColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-803.0361,-418.89;Float;False;Property;_ShieldRimPower;Shield Rim Power;13;0;Create;True;0;0;0;False;0;False;7;5.36;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;23;-1567.266,-1270.534;Float;False;Property;_ShieldPatternColor;Shield Pattern Color;9;0;Create;True;0;0;0;False;0;False;0.2470588,0.7764706,0.9098039,1;0.2470588,0.7764706,0.9098039,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-2293.982,-239.4324;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2023.414,831.6897;Inherit;False;19;HitSize;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;20;-2066.505,902.1907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;29;-1493.264,-953.7343;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;27;-1580.405,-1071.877;Float;False;Property;_ShieldPatternSize;Shield Pattern Size;11;1;[IntRange];Create;True;0;0;0;False;0;False;5;7;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;-2160.623,-249.824;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;30;-2153.694,-407.4305;Float;False;Constant;_Vector2;Vector 2;7;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1458.332,-751.7183;Inherit;False;10;ShieldSpeed;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-449.1282,-420.6346;Float;False;ShieldRimPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1811.617,946.7908;Inherit;False;25;HitColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1262.165,-1271.434;Float;False;ShieldPatternColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-2008.318,692.937;Float;False;Property;_HitTime;Hit Time;20;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;31;-1828.711,1036.092;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-1957.985,-355.4724;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;37;-1775.215,771.4908;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-806.7872,-287.5339;Inherit;False;32;ShieldRimPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-1240.405,-1047.877;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-1625.314,495.0907;Inherit;False;33;ShieldPatternColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1585.517,953.4907;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;40;-1961.294,-479.2859;Float;False;Constant;_Vector3;Vector 3;7;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;38;-1214.664,-839.1353;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;44;-1445.415,760.3909;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;45;-1714.49,561.0288;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1762.275,-364.1321;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;47;-1644.184,621.1838;Inherit;False;19;HitSize;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;48;-511.3281,-287.634;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;10;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1030.762,-906.8354;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;54;-1753.867,458.4963;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;52;-299.7291,-285.9343;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;51;-1255.301,639.4557;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;53;-771.3663,-923.9344;Inherit;True;Property;_ShieldPattern;Shield Pattern;10;0;Create;True;0;0;0;False;0;False;-1;5798ded558355430c8a9b13ee12a847c;5798ded558355430c8a9b13ee12a847c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;50;-1520.375,-379.5043;Inherit;True;Property;_ShieldPatternWaves;Shield Pattern Waves;15;0;Create;True;0;0;0;False;0;False;-1;61c0b9c0523734e0e91bc6043c72a490;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-382.1654,-922.1343;Float;False;ShieldPattern;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-68.89123,-290.0032;Float;False;ShieldRim;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;56;-1113.913,391.6562;Inherit;False;2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1186.27,-389.1495;Float;False;waves;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2494.301,1278.22;Inherit;False;1652.997;650.1895;Force Shield Emission, Intensity and power.;18;96;92;88;86;82;80;79;74;73;72;71;69;68;67;66;63;62;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-2444.301,1557.823;Inherit;False;59;ShieldPattern;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;-917.6134,395.4635;Float;False;hit;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;60;-568.0803,179.917;Inherit;False;1223.975;464.9008;Force Shield Distortion;11;98;95;91;89;85;84;78;76;75;70;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-2434.366,1466.966;Inherit;False;57;ShieldRim;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2425.425,1636.11;Inherit;False;58;waves;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2273.688,1726.712;Inherit;False;33;ShieldPatternColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2281.089,1807.089;Float;False;Property;_IntersectIntensity;Intersect Intensity;17;0;Create;True;0;0;0;False;0;False;0.2;0.393;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;67;-2227.005,1624.29;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-518.0803,388.5341;Inherit;False;10;ShieldSpeed;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-2206.977,1506.962;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-478.9524,486.7503;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-2193.938,1643.787;Inherit;False;64;hit;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-1949.811,1711.092;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;73;-1914.949,1809.982;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2030.841,1530.596;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;75;-388.9324,229.9171;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;76;-294.1654,417.1931;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-873.5653,-1225.134;Float;False;Property;_ShieldPatternPower;Shield Pattern Power;12;0;Create;True;0;0;0;False;0;False;5;27;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-481.4064,822.9221;Inherit;False;837.0001;689.9695;Force Shield textures;6;99;97;94;93;90;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-1788.494,1525.415;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;78;-125.5643,259.7843;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;80;-1698.796,1772.41;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-283.3024,529.8179;Float;False;Property;_ShieldDistortion;Shield Distortion;16;0;Create;True;0;0;0;False;0;False;0.01;0.0037;0;0.03;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-1811.402,1328.22;Float;False;Property;_IntersectColor;Intersect Color;18;0;Create;True;0;0;0;False;0;False;0.03137255,0.2588235,0.3176471,1;0.03137255,0.2588235,0.3176471,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-553.5643,-1215.234;Float;False;ShieldPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1493.203,1676.724;Inherit;False;81;ShieldPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;87;-403.9023,872.9222;Float;False;Property;_Color;Color;5;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;88;-1510.202,1536.32;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;89;132.0947,522.2907;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-425.0063,1063.692;Inherit;True;Property;_Albedo;Albedo;6;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;40.19763,372.7198;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;85;20.22864,275.1219;Inherit;False;Simplex3D;False;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;94;-431.4064,1282.892;Inherit;True;Property;_Normal;Normal;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;95;209.5977,320.359;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.01;False;4;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-50.60632,1031.692;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1267.604,1566.323;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;-1084.303,1541.321;Float;False;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;99;112.5936,1025.292;Float;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;405.8945,328.3905;Float;False;VertexOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;97;-44.2063,1290.892;Float;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;102;757.7683,254.9825;Float;False;Property;_Opacity;Opacity;8;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;855.8416,-20.08756;Inherit;False;99;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;103;853.6646,166.8564;Inherit;False;96;Emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;828.6417,72.71227;Inherit;False;97;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;804.8424,353.7115;Inherit;False;98;VertexOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1163.25,-13.7209;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;ForceShieldShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;0;17.1;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;0
WireConnection;7;1;5;0
WireConnection;10;0;7;0
WireConnection;17;0;12;0
WireConnection;17;1;11;0
WireConnection;19;0;9;0
WireConnection;25;0;18;0
WireConnection;22;0;13;0
WireConnection;22;1;16;0
WireConnection;20;0;17;0
WireConnection;35;0;22;0
WireConnection;32;0;24;0
WireConnection;33;0;23;0
WireConnection;31;0;21;0
WireConnection;31;1;20;0
WireConnection;42;0;30;1
WireConnection;42;1;35;0
WireConnection;37;0;34;0
WireConnection;43;0;27;0
WireConnection;43;1;27;0
WireConnection;36;0;26;0
WireConnection;36;1;31;0
WireConnection;38;0;29;1
WireConnection;38;1;28;0
WireConnection;44;0;39;0
WireConnection;44;1;36;0
WireConnection;44;2;37;0
WireConnection;45;0;17;0
WireConnection;46;0;40;0
WireConnection;46;1;42;0
WireConnection;48;0;41;0
WireConnection;49;0;43;0
WireConnection;49;1;38;0
WireConnection;54;0;34;0
WireConnection;52;3;48;0
WireConnection;51;0;45;0
WireConnection;51;1;47;0
WireConnection;51;2;44;0
WireConnection;51;3;39;0
WireConnection;53;1;49;0
WireConnection;50;1;46;0
WireConnection;59;0;53;0
WireConnection;57;0;52;0
WireConnection;56;0;54;0
WireConnection;56;2;51;0
WireConnection;56;3;39;0
WireConnection;58;0;50;0
WireConnection;64;0;56;0
WireConnection;67;0;62;0
WireConnection;71;0;61;0
WireConnection;71;1;63;0
WireConnection;72;0;66;0
WireConnection;72;1;69;0
WireConnection;73;0;68;0
WireConnection;74;0;71;0
WireConnection;74;1;67;0
WireConnection;76;0;65;0
WireConnection;76;1;70;0
WireConnection;82;0;74;0
WireConnection;82;1;72;0
WireConnection;78;0;75;0
WireConnection;78;1;76;0
WireConnection;80;0;73;0
WireConnection;81;0;77;0
WireConnection;88;0;79;0
WireConnection;88;1;82;0
WireConnection;88;2;80;0
WireConnection;89;0;84;0
WireConnection;91;0;84;0
WireConnection;85;0;78;0
WireConnection;95;0;85;0
WireConnection;95;3;91;0
WireConnection;95;4;89;0
WireConnection;93;0;87;0
WireConnection;93;1;90;0
WireConnection;92;0;88;0
WireConnection;92;1;86;0
WireConnection;96;0;92;0
WireConnection;99;0;93;0
WireConnection;98;0;95;0
WireConnection;97;0;94;0
WireConnection;0;0;104;0
WireConnection;0;1;100;0
WireConnection;0;2;103;0
WireConnection;0;9;102;0
WireConnection;0;11;101;0
ASEEND*/
//CHKSM=3870CCAA3486E4F40C42F7964ED3D9DDD4B7355A