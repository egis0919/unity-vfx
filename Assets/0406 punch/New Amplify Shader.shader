// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fade_Out_final"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Tex_Power("Tex_Power", Float) = 1
		_Mask_Tex("Mask_Tex", 2D) = "white" {}
		_mask_basev("mask_base (v)", Float) = 0.5
		_Mask_Powerw("Mask_Power (w)", Range( 0 , 10)) = 0
		_Mask_hilightu("Mask_hilight (u)", Float) = 1.3
		[Toggle(_USECUSTOM_ON)] _UseCustom("Use Custom?", Float) = 0
		[Toggle(_VERTEX_OFFSET_ON)] _vertex_offset("vertex_offset", Float) = 0
		_Tessellation("Tessellation", Float) = 0
		_v_offset("v_offset", Float) = 0
		[HideInInspector] _tex3coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _VERTEX_OFFSET_ON
		#pragma shader_feature _USECUSTOM_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 uv2_tex3coord2;
		};

		uniform float _v_offset;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _mask_basev;
		uniform sampler2D _Mask_Tex;
		uniform float4 _Mask_Tex_ST;
		uniform float _Mask_Powerw;
		uniform float _Mask_hilightu;
		uniform float _Tex_Power;
		uniform float _Tessellation;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_6 = (_Tessellation).xxxx;
			return temp_cast_6;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float4 temp_cast_0 = (0.0).xxxx;
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_MainTex = v.texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2Dlod( _MainTex, float4( uv_MainTex, 0, 0.0) );
			float4 temp_cast_2 = (tex2DNode1.a).xxxx;
			#ifdef _USECUSTOM_ON
				float staticSwitch31 = v.texcoord1.xyz.y;
			#else
				float staticSwitch31 = _mask_basev;
			#endif
			float2 uv_Mask_Tex = v.texcoord * _Mask_Tex_ST.xy + _Mask_Tex_ST.zw;
			#ifdef _USECUSTOM_ON
				float staticSwitch30 = v.texcoord1.xyz.z;
			#else
				float staticSwitch30 = _Mask_Powerw;
			#endif
			float4 temp_output_11_0 = ( temp_cast_2 - ( ( staticSwitch31 + tex2Dlod( _Mask_Tex, float4( uv_Mask_Tex, 0, 0.0) ) ) * staticSwitch30 ) );
			#ifdef _USECUSTOM_ON
				float staticSwitch32 = v.texcoord1.xyz.x;
			#else
				float staticSwitch32 = _Mask_hilightu;
			#endif
			float4 temp_cast_3 = (5.0).xxxx;
			float4 temp_cast_4 = (tex2DNode1.a).xxxx;
			float4 temp_output_25_0 = saturate( ( v.color.a * max( saturate( pow( ( temp_output_11_0 * staticSwitch32 ) , temp_cast_3 ) ) , temp_output_11_0 ) ) );
			#ifdef _VERTEX_OFFSET_ON
				float4 staticSwitch36 = ( float4( ( ase_vertexNormal * _v_offset ) , 0.0 ) * temp_output_25_0 );
			#else
				float4 staticSwitch36 = temp_cast_0;
			#endif
			v.vertex.xyz += staticSwitch36.rgb;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color4 = IsGammaSpace() ? float4(1.498039,1.498039,1.498039,0) : float4(2.433049,2.433049,2.433049,0);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			o.Emission = ( ( color4 * ( _Tex_Power * tex2DNode1 ) ) * i.vertexColor ).rgb;
			float4 temp_cast_1 = (tex2DNode1.a).xxxx;
			#ifdef _USECUSTOM_ON
				float staticSwitch31 = i.uv2_tex3coord2.y;
			#else
				float staticSwitch31 = _mask_basev;
			#endif
			float2 uv_Mask_Tex = i.uv_texcoord * _Mask_Tex_ST.xy + _Mask_Tex_ST.zw;
			#ifdef _USECUSTOM_ON
				float staticSwitch30 = i.uv2_tex3coord2.z;
			#else
				float staticSwitch30 = _Mask_Powerw;
			#endif
			float4 temp_output_11_0 = ( temp_cast_1 - ( ( staticSwitch31 + tex2D( _Mask_Tex, uv_Mask_Tex ) ) * staticSwitch30 ) );
			#ifdef _USECUSTOM_ON
				float staticSwitch32 = i.uv2_tex3coord2.x;
			#else
				float staticSwitch32 = _Mask_hilightu;
			#endif
			float4 temp_cast_2 = (5.0).xxxx;
			float4 temp_cast_3 = (tex2DNode1.a).xxxx;
			float4 temp_output_25_0 = saturate( ( i.vertexColor.a * max( saturate( pow( ( temp_output_11_0 * staticSwitch32 ) , temp_cast_2 ) ) , temp_output_11_0 ) ) );
			o.Alpha = temp_output_25_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
				float3 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
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
				o.customPack2.xyz = customInputData.uv2_tex3coord2;
				o.customPack2.xyz = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.uv2_tex3coord2 = IN.customPack2.xyz;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
-1920;48;1920;971;2137.844;93.40454;1;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;29;-1915.069,106.0476;Inherit;False;1;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-1673.119,401.5167;Inherit;False;Property;_mask_basev;mask_base (v);3;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1507.066,531.528;Inherit;True;Property;_Mask_Tex;Mask_Tex;2;0;Create;True;0;0;False;0;cd460ee4ac5c1e746b7a734cc7cc64dd;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;31;-1368.276,333.4839;Inherit;False;Property;_UseCustom;Use Custom?;6;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1513.286,125.3001;Inherit;False;Property;_Mask_Powerw;Mask_Power (w);4;0;Create;True;0;0;False;0;0;0.69;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;30;-1234.489,220.4739;Inherit;False;Property;_UseCustom;Use Custom?;6;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1115.119,438.5167;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1229.703,533.0384;Inherit;False;Property;_Mask_hilightu;Mask_hilight (u);5;0;Create;True;0;0;False;0;1.3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1074,-51.89993;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;e8705b74601e8e14f840b79db5249bca;08dcec18a6ea9c14b95759f823d99f6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-957.286,365.3001;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;32;-1007.806,549.1152;Inherit;False;Property;_UseCustom;Use Custom?;9;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-785.286,211.3001;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-770.9203,523.1185;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-770.8837,643.1072;Inherit;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;16;-590.8076,505.1808;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;24;-414.8076,369.1808;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;6;-327.9542,-36.37516;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;23;-292.8076,187.1808;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;33;87.61646,353.5473;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-924.5613,-261.0333;Inherit;False;Property;_Tex_Power;Tex_Power;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;180.6165,524.5474;Inherit;False;Property;_v_offset;v_offset;9;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;160.8533,129.9411;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;315.6165,402.5473;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;4;-616.5613,-461.0333;Inherit;False;Constant;_Tex_Color;Tex_Color;3;1;[HDR];Create;True;0;0;False;0;1.498039,1.498039,1.498039,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-695.5613,-232.0333;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;25;378.143,117.1808;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-342.5613,-288.0333;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;304.6165,330.5473;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;553.265,358.7863;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-34.37134,-279.8596;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;37;372.6165,535.5474;Inherit;False;Property;_Tessellation;Tessellation;8;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;36;724.1913,287.1147;Inherit;True;Property;_vertex_offset;vertex_offset;7;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1056.968,-13.42606;Float;False;True;6;ASEMaterialInspector;0;0;Unlit;Fade_Out_final;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;1;27;0
WireConnection;31;0;29;2
WireConnection;30;1;13;0
WireConnection;30;0;29;3
WireConnection;28;0;31;0
WireConnection;28;1;12;0
WireConnection;10;0;28;0
WireConnection;10;1;30;0
WireConnection;32;1;19;0
WireConnection;32;0;29;1
WireConnection;11;0;1;4
WireConnection;11;1;10;0
WireConnection;18;0;11;0
WireConnection;18;1;32;0
WireConnection;16;0;18;0
WireConnection;16;1;17;0
WireConnection;24;0;16;0
WireConnection;23;0;24;0
WireConnection;23;1;11;0
WireConnection;7;0;6;4
WireConnection;7;1;23;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;2;0;3;0
WireConnection;2;1;1;0
WireConnection;25;0;7;0
WireConnection;5;0;4;0
WireConnection;5;1;2;0
WireConnection;39;0;34;0
WireConnection;39;1;25;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;36;1;38;0
WireConnection;36;0;39;0
WireConnection;0;2;9;0
WireConnection;0;9;25;0
WireConnection;0;11;36;0
WireConnection;0;14;37;0
ASEEND*/
//CHKSM=6F566414AA9F4A1973D5A4CEC47EB4E5594F33B6