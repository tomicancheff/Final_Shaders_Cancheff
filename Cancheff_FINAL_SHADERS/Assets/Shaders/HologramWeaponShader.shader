// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HologramWeaponShader"
{
	Properties
	{
		_Hologramcolor("Hologram color", Color) = (0.3973832,0.7720588,0.7410512,0)
		_Speed("Speed", Range( 0 , 100)) = 26
		_ScanLines("Scan Lines", Range( 0 , 10)) = 3
		_Opacity("Opacity", Range( 0 , 1)) = 0.5
		_RimNormalMap("Rim Normal Map", 2D) = "bump" {}
		_RimPower("Rim Power", Range( 0 , 10)) = 5
		_Intensity("Intensity", Range( 1 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
			float3 worldPos;
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
		};

		uniform float4 _Hologramcolor;
		uniform float _ScanLines;
		uniform float _Speed;
		uniform sampler2D _RimNormalMap;
		uniform float _RimPower;
		uniform float _Intensity;
		uniform float _Opacity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 HologramColor53 = _Hologramcolor;
			float3 ase_worldPos = i.worldPos;
			float Speed5 = _Speed;
			float temp_output_28_0 = sin( ( ( ( _ScanLines * ase_worldPos.y ) + (( 1.0 - ( Speed5 * _Time ) )).x ) * UNITY_PI ) );
			float clampResult37 = clamp( (0.0 + (temp_output_28_0 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , 0.0 , 1.0 );
			float4 lerpResult41 = lerp( float4(1,1,1,0) , float4(0,0,0,0) , clampResult37);
			float2 temp_cast_0 = (( ( ase_worldPos.z / 100.0 ) * _Time.x )).xx;
			float simplePerlin2D31 = snoise( temp_cast_0 );
			float myVarName339 = ( simplePerlin2D31 * temp_output_28_0 );
			float4 temp_cast_1 = (myVarName339).xxxx;
			float4 ScanLines49 = ( lerpResult41 - temp_cast_1 );
			float3 normalizeResult60 = normalize( i.viewDir );
			float dotResult30 = dot( UnpackNormal( tex2D( _RimNormalMap, ( ( ( Speed5 / 1000.0 ) * _Time ) + float4( i.uv_texcoord, 0.0 , 0.0 ) ).xy ) ) , normalizeResult60 );
			float temp_output_44_0 = pow( ( 1.0 - saturate( dotResult30 ) ) , ( 10.0 - _RimPower ) );
			float Rim47 = temp_output_44_0;
			o.Emission = ( ( HologramColor53 * ( ScanLines49 + Rim47 ) ) * _Intensity ).rgb;
			o.Alpha = _Opacity;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
339;73;1052;551;1562.639;938.4255;3.949331;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-809.3503,-863.9785;Inherit;False;614.0698;167.2261;Hologram Speed;2;5;3;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-759.3503,-811.7524;Float;False;Property;_Speed;Speed;1;0;Create;True;0;0;0;False;0;False;26;64;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-429.2803,-813.9784;Float;False;Speed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2;-2282.158,139.4463;Inherit;False;2377.06;920.5361;Scanning lines;26;49;43;41;39;38;37;34;33;32;31;29;28;25;24;22;21;19;17;16;15;12;10;9;7;6;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;4;-2232.158,857.9831;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;6;-2227.885,754.1832;Inherit;False;5;Speed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;8;-2257.149,-546.1277;Inherit;False;2344.672;617.4507;Hologram Rim;18;60;59;56;47;44;42;40;36;35;30;27;26;23;20;18;14;13;11;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2004.12,820.1591;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-1988.951,634.4051;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;10;-2018.458,541.0588;Float;False;Property;_ScanLines;Scan Lines;2;0;Create;True;0;0;0;False;0;False;3;6;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-2207.149,-496.1277;Inherit;False;5;Speed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;-1846.023,790.6732;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ComponentMaskNode;16;-1669.34,794.1291;Inherit;False;True;False;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;14;-2203.586,-387.2886;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1635.583,677.7501;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6.06;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;13;-1955.431,-465.7001;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1998.498,-169.9707;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1442.922,658.9721;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1824.593,-412.2145;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;17;-1844.575,189.4463;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PiNode;19;-1428.089,789.7402;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-1654.052,-397.787;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-1597.011,241.5947;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;26;-1443.355,-226.7536;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1236.911,662.4232;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;25;-1932.064,334.2812;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-1462.738,-450.7459;Inherit;True;Property;_RimNormalMap;Rim Normal Map;4;0;Create;True;0;0;0;False;0;False;-1;None;f7f322ea849ea7d41adb6fa8a7d8a3e6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;60;-1263.667,-185.2336;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;28;-1082.398,746.6741;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1502.495,387.5004;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;31;-1298.572,347.1451;Inherit;False;Simplex2D;False;False;2;0;FLOAT2;100,100;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;30;-1110.229,-322.6078;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;-873.7323,707.0921;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;-869.0333,513.4066;Float;False;Constant;_Color1;Color 1;2;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1045.466,461.2931;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;-860.9325,336.6118;Float;False;Constant;_Color0;Color 0;2;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;35;-921.9583,-266.0538;Inherit;False;1;0;FLOAT;1.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1392.786,-67.15707;Float;False;Property;_RimPower;Rim Power;5;0;Create;True;0;0;0;False;0;False;5;3.96;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;-679.7853,697.0501;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;42;-976.9482,-138.4464;Inherit;False;2;0;FLOAT;10;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;-487.6173,525.9715;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;40;-752.9532,-223.7545;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-890.8423,244.6771;Float;False;myVarName3;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1516.156,-912.2535;Inherit;False;590.8936;257.7873;Hologram Color;2;53;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-302.4143,458.3799;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;44;-560.1553,-200.354;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-146.4778,-184.1998;Float;False;Rim;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;61;196.0931,-437.4125;Inherit;False;904.2496;382.7462;Intensity/ Getting Local variabbles.;7;50;48;51;52;54;55;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-139.0992,475.1554;Float;False;ScanLines;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;46;-1466.156,-862.2535;Float;False;Property;_Hologramcolor;Hologram color;0;0;Create;True;0;0;0;False;0;False;0.3973832,0.7720588,0.7410512,0;0,0.3472591,0.8901961,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1198.223,-823.1093;Float;False;HologramColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;246.0932,-323.8627;Inherit;False;49;ScanLines;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;252.7316,-231.6234;Inherit;False;47;Rim;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;560.7338,-280.6869;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;523.4278,-387.4126;Inherit;False;53;HologramColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;539.0034,-170.6667;Float;False;Property;_Intensity;Intensity;6;0;Create;True;0;0;0;False;0;False;1;3.78;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;778.795,-342.1055;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-317.7552,-185.1544;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;837.0435,147.1846;Float;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;0.5;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;62;1258.34,-181.1614;Inherit;False;305;521;Transparent Blend mode;1;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;938.3428,-234.5173;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-603.1782,-43.67697;Inherit;False;53;HologramColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1308.34,-131.1614;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HologramWeaponShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;7;0;6;0
WireConnection;7;1;4;0
WireConnection;9;0;7;0
WireConnection;16;0;9;0
WireConnection;15;0;10;0
WireConnection;15;1;12;2
WireConnection;13;0;11;0
WireConnection;21;0;15;0
WireConnection;21;1;16;0
WireConnection;20;0;13;0
WireConnection;20;1;14;0
WireConnection;23;0;20;0
WireConnection;23;1;18;0
WireConnection;22;0;17;3
WireConnection;24;0;21;0
WireConnection;24;1;19;0
WireConnection;27;1;23;0
WireConnection;60;0;26;0
WireConnection;28;0;24;0
WireConnection;29;0;22;0
WireConnection;29;1;25;1
WireConnection;31;0;29;0
WireConnection;30;0;27;0
WireConnection;30;1;60;0
WireConnection;32;0;28;0
WireConnection;34;0;31;0
WireConnection;34;1;28;0
WireConnection;35;0;30;0
WireConnection;37;0;32;0
WireConnection;42;1;36;0
WireConnection;41;0;33;0
WireConnection;41;1;38;0
WireConnection;41;2;37;0
WireConnection;40;0;35;0
WireConnection;39;0;34;0
WireConnection;43;0;41;0
WireConnection;43;1;39;0
WireConnection;44;0;40;0
WireConnection;44;1;42;0
WireConnection;47;0;44;0
WireConnection;49;0;43;0
WireConnection;53;0;46;0
WireConnection;51;0;50;0
WireConnection;51;1;48;0
WireConnection;54;0;52;0
WireConnection;54;1;51;0
WireConnection;56;0;44;0
WireConnection;56;1;59;0
WireConnection;58;0;54;0
WireConnection;58;1;55;0
WireConnection;0;2;58;0
WireConnection;0;9;57;0
ASEEND*/
//CHKSM=0A284796F8F7AFBD465D6C84250BC65752371F94