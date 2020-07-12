// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "water"
{
	Properties
	{
		_Side_Mask_Power("Side_Mask_Power", Float) = 1.2
		_Emission("Emission", Float) = 2
		_MainTex("MainTex", 2D) = "white" {}
		_Main_outline("Main_outline", Float) = 6.78
		_Main_inside("Main_inside", Float) = 2.08
		_Main_Color("Main_Color", Color) = (0.002402996,0.3482848,0.509434,0)
		_Main_U("Main_U", Float) = 0.5
		_Main_V("Main_V", Float) = 0
		_Main_Opacity("Main_Opacity", Float) = 2.86
		_MidTex("MidTex", 2D) = "white" {}
		_Mid_U("Mid_U", Float) = 0.8
		_Mid_V("Mid_V", Float) = 0
		_Mid_outline("Mid_outline", Float) = 6.63
		_Mid_inside("Mid_inside", Float) = 4.9
		_Mid_Color("Mid_Color", Color) = (0.002402996,0.3482848,0.509434,0)
		_LightTex("LightTex", 2D) = "white" {}
		_Light_outline("Light_outline", Float) = 4.4
		_Light_inside("Light_inside", Float) = 2.49
		_Light_Color("Light_Color", Color) = (1,1,1,0)
		_Light_U("Light_U", Float) = 1
		_Light_V("Light_V", Float) = 0.1
		_DissolveTex("DissolveTex", 2D) = "white" {}
		_Disolve_Add("Disolve_Add", Float) = 0.1
		_Disolve_outline("Disolve_outline", Float) = 5
		_Disolve_inside("Disolve_inside", Float) = 2.63
		_Disolve_Powert("Disolve_Power (t)", Float) = 0
		_Disolve_Outline_Power("Disolve_Outline_Power", Float) = 5
		_Disolve_U("Disolve_U", Float) = 0.2
		_Disolve_V("Disolve_V", Float) = 0.1
		_DistosionTex("DistosionTex", 2D) = "white" {}
		_Distosion_Power("Distosion_Power", Float) = 0.18
		_Dis_U("Dis_U", Float) = 0.2
		_Dis_V("Dis_V", Float) = 0.1
		[Toggle(_ISPARTICLE_ON)] _isParticle("is Particle", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskTex_Power("MaskTex_Power", Float) = 0
		_Mask_Uu("Mask_U (u)", Float) = 0.22
		_Mask_Vv("Mask_V (v)", Float) = 0
		_Tessellation("Tessellation", Float) = 0
		_Vertex_Offset("Vertex_Offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _ISPARTICLE_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 vertexColor : COLOR;
			float4 screenPos;
		};

		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform sampler2D _MidTex;
		uniform float _Mid_U;
		uniform float _Mid_V;
		uniform float _Distosion_Power;
		uniform sampler2D _DistosionTex;
		uniform float _Dis_U;
		uniform float _Dis_V;
		uniform float _Mid_outline;
		uniform float _Mid_inside;
		uniform sampler2D _MainTex;
		uniform float _Main_U;
		uniform float _Main_V;
		uniform float _Main_outline;
		uniform float _Main_inside;
		uniform float _Main_Opacity;
		uniform float _Side_Mask_Power;
		uniform sampler2D _MaskTex;
		uniform float _Mask_Uu;
		uniform float _Mask_Vv;
		uniform float _MaskTex_Power;
		uniform sampler2D _DissolveTex;
		uniform float _Disolve_U;
		uniform float _Disolve_V;
		uniform float _Disolve_Add;
		uniform float _Disolve_Powert;
		uniform float _Disolve_outline;
		uniform float _Disolve_inside;
		uniform float _Disolve_Outline_Power;
		uniform float _Vertex_Offset;
		uniform float _Emission;
		uniform float4 _Main_Color;
		uniform float4 _Mid_Color;
		uniform sampler2D _LightTex;
		uniform float _Light_U;
		uniform float _Light_V;
		uniform float _Light_outline;
		uniform float _Light_inside;
		uniform float4 _Light_Color;
		uniform float _Tessellation;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_0 = (_Tessellation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth487 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_LOD( _CameraDepthTexture, float4( ase_screenPosNorm.xy, 0, 0 ) ));
			float distanceDepth487 = abs( ( screenDepth487 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float2 appendResult332 = (float2(_Mid_U , _Mid_V));
			float2 uv_TexCoord379 = v.texcoord.xy * float2( 1.5,1.15 );
			float2 panner333 = ( _Time.y * appendResult332 + uv_TexCoord379);
			float2 appendResult301 = (float2(_Dis_U , _Dis_V));
			float2 panner304 = ( _Time.y * appendResult301 + v.texcoord.xy);
			float temp_output_297_0 = ( _Distosion_Power * tex2Dlod( _DistosionTex, float4( panner304, 0, 0.0) ).r );
			float4 tex2DNode335 = tex2Dlod( _MidTex, float4( ( panner333 + temp_output_297_0 ), 0, 0.0) );
			float temp_output_328_0 = saturate( pow( ( tex2DNode335.r * _Mid_inside ) , 13.26 ) );
			float temp_output_317_0 = saturate( ( ( saturate( pow( ( tex2DNode335.r * _Mid_outline ) , 10.36 ) ) - temp_output_328_0 ) * 8.96 ) );
			float2 appendResult309 = (float2(_Main_U , _Main_V));
			float2 uv_TexCoord357 = v.texcoord.xy * float2( 1.5,1 );
			float2 panner308 = ( _Time.y * appendResult309 + uv_TexCoord357);
			float4 tex2DNode220 = tex2Dlod( _MainTex, float4( ( panner308 + temp_output_297_0 ), 0, 0.0) );
			float temp_output_228_0 = saturate( pow( ( tex2DNode220.r * _Main_inside ) , 3.07 ) );
			float temp_output_260_0 = saturate( ( ( saturate( pow( ( tex2DNode220.r * _Main_outline ) , 4.94 ) ) - temp_output_228_0 ) * 8.96 ) );
			float temp_output_368_0 = ( 1.0 - saturate( pow( ( v.texcoord.xy.x * ( 1.0 - v.texcoord.xy.x ) * 5.16 ) , _Side_Mask_Power ) ) );
			#ifdef _ISPARTICLE_ON
				float staticSwitch483 = v.texcoord1.x;
			#else
				float staticSwitch483 = _Mask_Uu;
			#endif
			#ifdef _ISPARTICLE_ON
				float staticSwitch482 = v.texcoord1.y;
			#else
				float staticSwitch482 = _Mask_Vv;
			#endif
			float2 appendResult476 = (float2(( v.texcoord.xy.x + staticSwitch483 ) , ( v.texcoord.xy.y + staticSwitch482 )));
			float2 appendResult457 = (float2(_Disolve_U , _Disolve_V));
			float2 uv_TexCoord466 = v.texcoord.xy * float2( 1.5,2 );
			float2 panner455 = ( _Time.y * appendResult457 + uv_TexCoord466);
			#ifdef _ISPARTICLE_ON
				float staticSwitch468 = v.texcoord1.w;
			#else
				float staticSwitch468 = _Disolve_Powert;
			#endif
			float temp_output_418_0 = ( saturate( ( ( saturate( max( saturate( pow( max( temp_output_317_0 , temp_output_328_0 ) , 2.86 ) ) , saturate( pow( max( temp_output_260_0 , temp_output_228_0 ) , _Main_Opacity ) ) ) ) - saturate( ( ( ( tex2DNode220.r * temp_output_368_0 * tex2DNode335.r * 10.0 ) * temp_output_368_0 ) + temp_output_368_0 ) ) ) * ( tex2Dlod( _MaskTex, float4( ( appendResult476 + temp_output_297_0 ), 0, 0.0) ).r * _MaskTex_Power ) ) ) - saturate( ( ( tex2Dlod( _DissolveTex, float4( panner455, 0, 0.0) ).r + _Disolve_Add ) * staticSwitch468 ) ) );
			float temp_output_437_0 = saturate( pow( ( saturate( ( saturate( pow( ( temp_output_418_0 * _Disolve_outline ) , 3.2 ) ) - saturate( pow( ( _Disolve_inside * temp_output_418_0 ) , 1.27 ) ) ) ) * _Disolve_Outline_Power ) , 1.0 ) );
			float temp_output_445_0 = saturate( ( v.color.a * ( distanceDepth487 * max( temp_output_437_0 , saturate( temp_output_418_0 ) ) ) ) );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( temp_output_445_0 * _Vertex_Offset ) * ase_vertexNormal );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult309 = (float2(_Main_U , _Main_V));
			float2 uv_TexCoord357 = i.uv_texcoord * float2( 1.5,1 );
			float2 panner308 = ( _Time.y * appendResult309 + uv_TexCoord357);
			float2 appendResult301 = (float2(_Dis_U , _Dis_V));
			float2 panner304 = ( _Time.y * appendResult301 + i.uv_texcoord);
			float temp_output_297_0 = ( _Distosion_Power * tex2D( _DistosionTex, panner304 ).r );
			float4 tex2DNode220 = tex2D( _MainTex, ( panner308 + temp_output_297_0 ) );
			float temp_output_228_0 = saturate( pow( ( tex2DNode220.r * _Main_inside ) , 3.07 ) );
			float temp_output_260_0 = saturate( ( ( saturate( pow( ( tex2DNode220.r * _Main_outline ) , 4.94 ) ) - temp_output_228_0 ) * 8.96 ) );
			float4 color238 = IsGammaSpace() ? float4(0.0499288,0.1574515,0.2075472,0) : float4(0.003929537,0.0213608,0.03550519,0);
			float4 lerpResult408 = lerp( color238 , _Main_Color , saturate( max( pow( ( tex2DNode220.r * 1.0 ) , 4.42 ) , ( temp_output_228_0 * 0.4 ) ) ));
			float2 appendResult332 = (float2(_Mid_U , _Mid_V));
			float2 uv_TexCoord379 = i.uv_texcoord * float2( 1.5,1.15 );
			float2 panner333 = ( _Time.y * appendResult332 + uv_TexCoord379);
			float4 tex2DNode335 = tex2D( _MidTex, ( panner333 + temp_output_297_0 ) );
			float temp_output_328_0 = saturate( pow( ( tex2DNode335.r * _Mid_inside ) , 13.26 ) );
			float4 lerpResult349 = lerp( ( ( 1.0 - temp_output_260_0 ) * lerpResult408 ) , _Mid_Color , max( ( temp_output_328_0 * 0.55 ) , ( tex2DNode335.r * 1.88 ) ));
			float2 appendResult289 = (float2(_Light_U , _Light_V));
			float2 panner286 = ( _Time.y * appendResult289 + uv_TexCoord357);
			float4 tex2DNode243 = tex2D( _LightTex, ( panner286 + temp_output_297_0 ) );
			float temp_output_269_0 = saturate( pow( ( tex2DNode243.r * _Light_inside ) , 59.03 ) );
			float temp_output_317_0 = saturate( ( ( saturate( pow( ( tex2DNode335.r * _Mid_outline ) , 10.36 ) ) - temp_output_328_0 ) * 8.96 ) );
			float temp_output_368_0 = ( 1.0 - saturate( pow( ( i.uv_texcoord.x * ( 1.0 - i.uv_texcoord.x ) * 5.16 ) , _Side_Mask_Power ) ) );
			#ifdef _ISPARTICLE_ON
				float staticSwitch483 = i.uv2_tex4coord2.x;
			#else
				float staticSwitch483 = _Mask_Uu;
			#endif
			#ifdef _ISPARTICLE_ON
				float staticSwitch482 = i.uv2_tex4coord2.y;
			#else
				float staticSwitch482 = _Mask_Vv;
			#endif
			float2 appendResult476 = (float2(( i.uv_texcoord.x + staticSwitch483 ) , ( i.uv_texcoord.y + staticSwitch482 )));
			float2 appendResult457 = (float2(_Disolve_U , _Disolve_V));
			float2 uv_TexCoord466 = i.uv_texcoord * float2( 1.5,2 );
			float2 panner455 = ( _Time.y * appendResult457 + uv_TexCoord466);
			#ifdef _ISPARTICLE_ON
				float staticSwitch468 = i.uv2_tex4coord2.w;
			#else
				float staticSwitch468 = _Disolve_Powert;
			#endif
			float temp_output_418_0 = ( saturate( ( ( saturate( max( saturate( pow( max( temp_output_317_0 , temp_output_328_0 ) , 2.86 ) ) , saturate( pow( max( temp_output_260_0 , temp_output_228_0 ) , _Main_Opacity ) ) ) ) - saturate( ( ( ( tex2DNode220.r * temp_output_368_0 * tex2DNode335.r * 10.0 ) * temp_output_368_0 ) + temp_output_368_0 ) ) ) * ( tex2D( _MaskTex, ( appendResult476 + temp_output_297_0 ) ).r * _MaskTex_Power ) ) ) - saturate( ( ( tex2D( _DissolveTex, panner455 ).r + _Disolve_Add ) * staticSwitch468 ) ) );
			float temp_output_437_0 = saturate( pow( ( saturate( ( saturate( pow( ( temp_output_418_0 * _Disolve_outline ) , 3.2 ) ) - saturate( pow( ( _Disolve_inside * temp_output_418_0 ) , 1.27 ) ) ) ) * _Disolve_Outline_Power ) , 1.0 ) );
			float4 temp_cast_0 = (temp_output_437_0).xxxx;
			o.Emission = ( _Emission * ( max( ( ( lerpResult349 * ( 1.0 - saturate( ( saturate( pow( ( tex2DNode243.r * _Light_outline ) , 30.0 ) ) - temp_output_269_0 ) ) ) * ( 1.0 - temp_output_317_0 ) ) + ( _Light_Color * temp_output_269_0 ) ) , temp_cast_0 ) * i.vertexColor ) ).rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth487 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth487 = abs( ( screenDepth487 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			float temp_output_445_0 = saturate( ( i.vertexColor.a * ( distanceDepth487 * max( temp_output_437_0 , saturate( temp_output_418_0 ) ) ) ) );
			o.Alpha = temp_output_445_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc tessellate:tessFunction 

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
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float4 screenPos : TEXCOORD4;
				half4 color : COLOR0;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.uv2_tex4coord2;
				o.customPack2.xyzw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
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
				surfIN.uv2_tex4coord2 = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Version=17101
1920;37.60001;1907;948;-8230.665;-7.932678;1.773966;True;True
Node;AmplifyShaderEditor.CommentaryNode;462;787.0421,1375.685;Inherit;False;1298.971;601.626;디스토션;9;303;302;294;301;359;304;296;298;297;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;303;849.0255,1861.311;Inherit;False;Property;_Dis_V;Dis_V;33;0;Create;True;0;0;False;0;0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;302;837.0421,1744.704;Inherit;False;Property;_Dis_U;Dis_U;32;0;Create;True;0;0;False;0;0.2;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;461;1023.318,-827.7093;Inherit;False;4648.892;1336.094;메인;43;309;308;300;226;220;234;222;233;228;235;224;230;231;260;307;413;411;417;412;416;410;414;415;238;409;280;408;281;244;282;314;310;311;313;278;305;446;348;447;225;227;248;249;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;460;1542.318,-1967.64;Inherit;False;5196.157;1076.865;중간색 ;34;407;406;318;405;349;358;330;329;332;379;333;334;324;336;335;337;325;326;338;327;339;340;328;323;341;316;317;346;315;344;345;402;401;319;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;294;1086.2,1450.954;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;301;1138.813,1787.337;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;359;1044.314,1648.471;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;304;1356.463,1639.93;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;311;1110.7,-71.89597;Inherit;False;Property;_Main_V;Main_V;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;329;1592.938,-1751.246;Inherit;False;Property;_Mid_U;Mid_U;11;0;Create;True;0;0;False;0;0.8;-1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;330;1592.318,-1660.786;Inherit;False;Property;_Mid_V;Mid_V;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;1073.318,-201.5069;Inherit;False;Property;_Main_U;Main_U;7;0;Create;True;0;0;False;0;0.5;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;332;1895.153,-1749.097;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;379;1619.542,-1917.64;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1.15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;357;609.8167,672.6455;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;296;1566.435,1500.952;Inherit;True;Property;_DistosionTex;DistosionTex;30;0;Create;True;0;0;False;0;None;55190433fa6a8b942ad179dcc3ace216;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;309;1260.395,-107.8197;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;298;1744.228,1425.685;Inherit;False;Property;_Distosion_Power;Distosion_Power;31;0;Create;True;0;0;False;0;0.18;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;333;2118.068,-1781.006;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;1923.613,1438.246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;308;1568.395,-130.8197;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;1791.563,-130.1035;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;334;2387.067,-1750.006;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;324;2784.466,-1631.529;Inherit;False;Property;_Mid_inside;Mid_inside;14;0;Create;True;0;0;False;0;4.9;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;226;2126.393,-297.8196;Inherit;False;Property;_Main_outline;Main_outline;4;0;Create;True;0;0;False;0;6.78;6.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;249;2112.507,152.5185;Inherit;False;Property;_Main_inside;Main_inside;5;0;Create;True;0;0;False;0;2.08;2.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;220;1977.882,-161.239;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;8150f6f43f753a142bcf05fc6eb8f621;82a8e66f31a9e654792bee0ab05f9fc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;336;2783.066,-1882.006;Inherit;False;Property;_Mid_outline;Mid_outline;13;0;Create;True;0;0;False;0;6.63;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;335;2515.067,-1798.006;Inherit;True;Property;_MidTex;MidTex;10;0;Create;True;0;0;False;0;8150f6f43f753a142bcf05fc6eb8f621;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;463;2438.969,1163.539;Inherit;False;3276.844;909.3418;사이드 마스크;25;368;369;365;366;363;364;367;361;373;372;374;360;375;376;475;473;472;476;471;474;469;479;480;482;483;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;2325.907,138.8024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;3055.345,-1562.916;Inherit;False;Constant;_Mid_inpower;Mid_inpower;3;0;Create;True;0;0;False;0;13.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2324.393,-339.8196;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2942.066,-1858.006;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;2939.466,-1627.529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;2317.32,271.7324;Inherit;False;Constant;_Main_inpower;Main_inpower;3;0;Create;True;0;0;False;0;3.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;3070.066,-1818.006;Inherit;False;Constant;_Mid_outpower;Mid_outpower;3;0;Create;True;0;0;False;0;10.36;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;2354.126,-247.4397;Inherit;False;Constant;_Main_outpower;Main_outpower;3;0;Create;True;0;0;False;0;4.94;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;339;3215.066,-1848.006;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;327;3210.344,-1614.916;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;225;2526.217,124.6864;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;233;2540.393,-369.8196;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;361;2488.969,1860.88;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;364;2840.969,1812.88;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;228;2797.628,-107.5606;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;328;3485.135,-1555.111;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;235;2858.393,-209.8197;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;367;2808.969,1956.881;Inherit;False;Constant;_Side_Mask;Side_Mask;0;0;Create;True;0;0;False;0;5.16;5.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;340;3475.066,-1750.006;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;224;3105.598,-121.5228;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;366;3368.969,1844.88;Inherit;False;Property;_Side_Mask_Power;Side_Mask_Power;1;0;Create;True;0;0;False;0;1.2;1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;3437.668,-98.04515;Inherit;False;Constant;_Main_outlinepower;Main_outlinepower;6;0;Create;True;0;0;False;0;8.96;6.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;363;3160.969,1732.88;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;323;3995.223,-1650.741;Inherit;False;Constant;_Mid_power;Mid_power;7;0;Create;True;0;0;False;0;8.96;10.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;341;3635.066,-1766.006;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;4172.283,-1699.171;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;3695.665,-141.8183;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;365;3656.969,1716.88;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;369;3960.971,1732.88;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;475;4473.177,1975.323;Inherit;False;Property;_Mask_Vv;Mask_V (v);37;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;467;3619.302,2330.101;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;317;4392.285,-1711.171;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;260;4067.411,-142.6855;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;474;4526.108,1714.958;Inherit;False;Property;_Mask_Uu;Mask_U (u);36;0;Create;True;0;0;False;0;0.22;-0.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;346;4595.241,-1531.412;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;3841.471,1470.607;Inherit;False;Constant;_Mask_Power;Mask_Power;11;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;4637.997,-1422.624;Inherit;False;Constant;_Mid_Opacity;Mid_Opacity;11;0;Create;True;0;0;False;0;2.86;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;483;4690.606,1716.139;Inherit;False;Property;_isParticle;is Particle;34;0;Create;False;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;464;3961.146,2131.196;Inherit;False;4950.925;1224.27;디졸브;34;459;457;454;420;441;419;424;423;428;427;430;418;421;422;426;425;431;429;436;439;435;434;433;437;444;283;440;442;455;458;466;468;489;491;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;368;4312.97,1636.88;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;471;4511.402,1820.775;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;482;4651.829,1982.878;Inherit;False;Property;_isParticle;is Particle;0;0;Create;False;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;307;4321.387,-46.95824;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;305;4439.529,266.0056;Inherit;False;Property;_Main_Opacity;Main_Opacity;9;0;Create;True;0;0;False;0;2.86;12.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;4262.08,1361.523;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;473;4936.108,1889.958;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;344;4853.398,-1515.887;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;459;4027.146,3094.866;Inherit;False;Property;_Disolve_V;Disolve_V;29;0;Create;True;0;0;False;0;0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;458;4024.213,2771.32;Inherit;False;Property;_Disolve_U;Disolve_U;28;0;Create;True;0;0;False;0;0.2;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;472;4934.108,1772.958;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;278;4727.671,176.0109;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;446;4979.617,256.9407;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;457;4315.145,3030.866;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;4601.117,1334.285;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;466;4256.03,2634.333;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;476;5139.108,1818.958;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;345;5161.839,-1496.036;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;454;4267.145,3174.866;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;455;4610.204,2839.749;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;376;4923.982,1373.902;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;479;5272.15,1869.525;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;348;5181.909,243.9372;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;447;5450.968,256.3026;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;440;4876.365,2775.305;Inherit;True;Property;_DissolveTex;DissolveTex;22;0;Create;True;0;0;False;0;None;55190433fa6a8b942ad179dcc3ace216;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;442;5227.967,2777.287;Inherit;False;Property;_Disolve_Add;Disolve_Add;23;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;469;5294.93,1685.469;Inherit;True;Property;_MaskTex;MaskTex;34;0;Create;True;0;0;False;0;None;eaf369e23b39b844a9c25b922967372b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;480;5433.567,1880.871;Inherit;False;Property;_MaskTex_Power;MaskTex_Power;35;0;Create;True;0;0;False;0;0;12.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;375;5090.586,1294.647;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;420;5382.173,3078.799;Inherit;False;Property;_Disolve_Powert;Disolve_Power (t);26;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;441;5473.146,2754.967;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;481;5590.567,1697.871;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;468;5579.574,2984.429;Inherit;False;Property;_isParticle;is Particle;0;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;360;5480.815,1213.539;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;5785.145,2760.567;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;470;5820.158,1695.681;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;465;1107.572,517.8293;Inherit;False;3250.999;644.1888;밝은색;17;290;291;289;286;295;263;243;261;265;262;259;264;258;267;268;269;266;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;291;1157.572,819.8754;Inherit;False;Property;_Light_V;Light_V;21;0;Create;True;0;0;False;0;0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;491;6052.15,2261.35;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;489;6013.684,2707.712;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;290;1171.909,669.217;Inherit;False;Property;_Light_U;Light_U;20;0;Create;True;0;0;False;0;1;-1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;424;6507.145,2918.867;Inherit;False;Property;_Disolve_inside;Disolve_inside;25;0;Create;True;0;0;False;0;2.63;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;418;6203.145,2662.867;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;422;6491.145,2678.867;Inherit;False;Property;_Disolve_outline;Disolve_outline;24;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;289;1475.603,717.5862;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;286;1797.735,682.2513;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;428;6923.145,2918.867;Inherit;False;Constant;_Disolve_inpower;Disolve_inpower;14;0;Create;True;0;0;False;0;1.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;423;6731.145,2806.867;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;6683.145,2566.867;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;426;6875.144,2693.867;Inherit;False;Constant;_Disolve_outpower;Disolve_outpower;14;0;Create;True;0;0;False;0;3.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;2250.529,729.6486;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;413;2706.614,-557.2816;Inherit;False;Constant;_Main_Light;Main_Light;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;427;7067.143,2854.867;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;425;7035.143,2550.867;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;430;7339.141,2838.867;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;431;7307.141,2582.867;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;243;2428.178,686.3662;Inherit;True;Property;_LightTex;LightTex;16;0;Create;True;0;0;False;0;cdeac6f84093f7a4aad78514aa3d26ad;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;411;3070.49,-310.3362;Inherit;False;Constant;_Main_dark;Main_dark;13;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;417;3207.436,-510.111;Inherit;False;Constant;_Main_Lightpower;Main_Lightpower;13;0;Create;True;0;0;False;0;4.42;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;2551.998,929.9921;Inherit;False;Property;_Light_inside;Light_inside;18;0;Create;True;0;0;False;0;2.49;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;412;3005.177,-607.223;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;263;2594.525,567.8293;Inherit;False;Property;_Light_outline;Light_outline;17;0;Create;True;0;0;False;0;4.4;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;429;7531.142,2534.866;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;3288.239,-381.5385;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;2838.603,1046.018;Inherit;False;Constant;_Light_inpower;Light_inpower;4;0;Create;True;0;0;False;0;59.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;2765.947,876.847;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;416;3391.453,-630.3347;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;2956.13,814.8554;Inherit;False;Constant;_Light_outpower;Light_outpower;4;0;Create;True;0;0;False;0;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;2774.984,588.0831;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;258;3134.349,891.7486;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;414;3705.663,-372.2941;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;436;7763.588,2499.583;Inherit;False;Property;_Disolve_Outline_Power;Disolve_Outline_Power;27;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;439;7771.142,2374.867;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;266;3424.947,648.2334;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;409;3954.272,-624.5237;Inherit;False;Property;_Main_Color;Main_Color;6;0;Create;True;0;0;False;0;0.002402996,0.3482848,0.509434,0;0,0.2351226,0.4528298,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;434;8024.141,2423.867;Inherit;False;Constant;_Disolve_OutLinePower;Disolve_OutLinePower;14;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;435;7931.141,2342.867;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;407;4002.289,-1112.858;Inherit;False;Constant;_Mid_light;Mid_light;12;0;Create;True;0;0;False;0;1.88;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;238;3960.636,-777.7093;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;False;0;0.0499288,0.1574515,0.2075472,0;0.09518486,0.1051681,0.2169808,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;268;3835.13,765.825;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;269;3868.382,957.0674;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;415;4058.613,-389.4565;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;3997.376,-1345.767;Inherit;False;Constant;_Mid_dark;Mid_dark;12;0;Create;True;0;0;False;0;0.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;4232.011,-1144.774;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;408;4330.188,-541.3967;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;267;4123.571,800.428;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;401;4234.333,-1379.045;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;280;4418.647,-266.8626;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;433;8235.144,2262.867;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;437;8466.45,2181.196;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;283;7911.788,2830.922;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;405;4739.739,-1172.971;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;318;5282.371,-1170.918;Inherit;False;Property;_Mid_Color;Mid_Color;15;0;Create;True;0;0;False;0;0.002402996,0.3482848,0.509434,0;0,0.7489877,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;244;4624.824,-141.6209;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;4719.087,-534.564;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;282;5474.21,-616.8771;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;314;4614.269,-49.40304;Inherit;False;Property;_Light_Color;Light_Color;19;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;319;5049.336,-1730.86;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;487;8683.038,1816.31;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;349;5617.313,-1208.111;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;444;8677.068,2398.005;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;484;8123.633,485.7602;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;486;9181.395,1849.156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;6502.275,-1259.391;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;313;4900.661,2.357244;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;488;9129.72,977.9796;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;6164.344,-313.4231;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;432;8206.745,-99.20564;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;445;9213.776,525.265;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;9398.446,653.8796;Inherit;False;Property;_Vertex_Offset;Vertex_Offset;43;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;485;8696.994,-86.0134;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;378;6854.04,-338.9013;Inherit;False;Property;_Emission;Emission;2;0;Create;True;0;0;False;0;2;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;493;9428.327,820.9631;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;9576.465,597.9846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;497;9736.373,745.8322;Inherit;False;Property;_Tessellation;Tessellation;42;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;9121.174,-153.3914;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;494;9727.889,616.5927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;9970.854,95.98942;Float;False;True;6;ASEMaterialInspector;0;0;Unlit;water;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.1;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;38;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;301;0;302;0
WireConnection;301;1;303;0
WireConnection;304;0;359;0
WireConnection;304;2;301;0
WireConnection;304;1;294;2
WireConnection;332;0;329;0
WireConnection;332;1;330;0
WireConnection;296;1;304;0
WireConnection;309;0;310;0
WireConnection;309;1;311;0
WireConnection;333;0;379;0
WireConnection;333;2;332;0
WireConnection;333;1;294;2
WireConnection;297;0;298;0
WireConnection;297;1;296;1
WireConnection;308;0;357;0
WireConnection;308;2;309;0
WireConnection;308;1;294;2
WireConnection;300;0;308;0
WireConnection;300;1;297;0
WireConnection;334;0;333;0
WireConnection;334;1;297;0
WireConnection;220;1;300;0
WireConnection;335;1;334;0
WireConnection;248;0;220;1
WireConnection;248;1;249;0
WireConnection;222;0;220;1
WireConnection;222;1;226;0
WireConnection;337;0;335;1
WireConnection;337;1;336;0
WireConnection;326;0;335;1
WireConnection;326;1;324;0
WireConnection;339;0;337;0
WireConnection;339;1;338;0
WireConnection;327;0;326;0
WireConnection;327;1;325;0
WireConnection;225;0;248;0
WireConnection;225;1;227;0
WireConnection;233;0;222;0
WireConnection;233;1;234;0
WireConnection;364;0;361;1
WireConnection;228;0;225;0
WireConnection;328;0;327;0
WireConnection;235;0;233;0
WireConnection;340;0;339;0
WireConnection;224;0;235;0
WireConnection;224;1;228;0
WireConnection;363;0;361;1
WireConnection;363;1;364;0
WireConnection;363;2;367;0
WireConnection;341;0;340;0
WireConnection;341;1;328;0
WireConnection;316;0;341;0
WireConnection;316;1;323;0
WireConnection;231;0;224;0
WireConnection;231;1;230;0
WireConnection;365;0;363;0
WireConnection;365;1;366;0
WireConnection;369;0;365;0
WireConnection;317;0;316;0
WireConnection;260;0;231;0
WireConnection;346;0;317;0
WireConnection;346;1;328;0
WireConnection;483;1;474;0
WireConnection;483;0;467;1
WireConnection;368;0;369;0
WireConnection;482;1;475;0
WireConnection;482;0;467;2
WireConnection;307;0;260;0
WireConnection;307;1;228;0
WireConnection;372;0;220;1
WireConnection;372;1;368;0
WireConnection;372;2;335;1
WireConnection;372;3;373;0
WireConnection;473;0;471;2
WireConnection;473;1;482;0
WireConnection;344;0;346;0
WireConnection;344;1;315;0
WireConnection;472;0;471;1
WireConnection;472;1;483;0
WireConnection;278;0;307;0
WireConnection;278;1;305;0
WireConnection;446;0;278;0
WireConnection;457;0;458;0
WireConnection;457;1;459;0
WireConnection;374;0;372;0
WireConnection;374;1;368;0
WireConnection;476;0;472;0
WireConnection;476;1;473;0
WireConnection;345;0;344;0
WireConnection;455;0;466;0
WireConnection;455;2;457;0
WireConnection;455;1;454;2
WireConnection;376;0;374;0
WireConnection;376;1;368;0
WireConnection;479;0;476;0
WireConnection;479;1;297;0
WireConnection;348;0;345;0
WireConnection;348;1;446;0
WireConnection;447;0;348;0
WireConnection;440;1;455;0
WireConnection;469;1;479;0
WireConnection;375;0;376;0
WireConnection;441;0;440;1
WireConnection;441;1;442;0
WireConnection;481;0;469;1
WireConnection;481;1;480;0
WireConnection;468;1;420;0
WireConnection;468;0;467;4
WireConnection;360;0;447;0
WireConnection;360;1;375;0
WireConnection;419;0;441;0
WireConnection;419;1;468;0
WireConnection;470;0;360;0
WireConnection;470;1;481;0
WireConnection;491;0;470;0
WireConnection;489;0;419;0
WireConnection;418;0;491;0
WireConnection;418;1;489;0
WireConnection;289;0;290;0
WireConnection;289;1;291;0
WireConnection;286;0;357;0
WireConnection;286;2;289;0
WireConnection;286;1;294;2
WireConnection;423;0;424;0
WireConnection;423;1;418;0
WireConnection;421;0;418;0
WireConnection;421;1;422;0
WireConnection;295;0;286;0
WireConnection;295;1;297;0
WireConnection;427;0;423;0
WireConnection;427;1;428;0
WireConnection;425;0;421;0
WireConnection;425;1;426;0
WireConnection;430;0;427;0
WireConnection;431;0;425;0
WireConnection;243;1;295;0
WireConnection;412;0;220;1
WireConnection;412;1;413;0
WireConnection;429;0;431;0
WireConnection;429;1;430;0
WireConnection;410;0;228;0
WireConnection;410;1;411;0
WireConnection;262;0;243;1
WireConnection;262;1;261;0
WireConnection;416;0;412;0
WireConnection;416;1;417;0
WireConnection;265;0;243;1
WireConnection;265;1;263;0
WireConnection;258;0;262;0
WireConnection;258;1;259;0
WireConnection;414;0;416;0
WireConnection;414;1;410;0
WireConnection;439;0;429;0
WireConnection;266;0;265;0
WireConnection;266;1;264;0
WireConnection;435;0;439;0
WireConnection;435;1;436;0
WireConnection;268;0;266;0
WireConnection;269;0;258;0
WireConnection;415;0;414;0
WireConnection;406;0;335;1
WireConnection;406;1;407;0
WireConnection;408;0;238;0
WireConnection;408;1;409;0
WireConnection;408;2;415;0
WireConnection;267;0;268;0
WireConnection;267;1;269;0
WireConnection;401;0;328;0
WireConnection;401;1;402;0
WireConnection;280;0;260;0
WireConnection;433;0;435;0
WireConnection;433;1;434;0
WireConnection;437;0;433;0
WireConnection;283;0;418;0
WireConnection;405;0;401;0
WireConnection;405;1;406;0
WireConnection;244;0;267;0
WireConnection;281;0;280;0
WireConnection;281;1;408;0
WireConnection;282;0;244;0
WireConnection;319;0;317;0
WireConnection;349;0;281;0
WireConnection;349;1;318;0
WireConnection;349;2;405;0
WireConnection;444;0;437;0
WireConnection;444;1;283;0
WireConnection;486;0;487;0
WireConnection;486;1;444;0
WireConnection;358;0;349;0
WireConnection;358;1;282;0
WireConnection;358;2;319;0
WireConnection;313;0;314;0
WireConnection;313;1;269;0
WireConnection;488;0;484;4
WireConnection;488;1;486;0
WireConnection;285;0;358;0
WireConnection;285;1;313;0
WireConnection;432;0;285;0
WireConnection;432;1;437;0
WireConnection;445;0;488;0
WireConnection;485;0;432;0
WireConnection;485;1;484;0
WireConnection;495;0;445;0
WireConnection;495;1;496;0
WireConnection;377;0;378;0
WireConnection;377;1;485;0
WireConnection;494;0;495;0
WireConnection;494;1;493;0
WireConnection;0;2;377;0
WireConnection;0;9;445;0
WireConnection;0;11;494;0
WireConnection;0;14;497;0
ASEEND*/
//CHKSM=FA16386C924CE3AEEAB34C2A70CD1B62E7EE7B3A