// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "particle_fade"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_height_power("height_power", Float) = 1.45
		_dark_size("dark_size", Range( -0.3 , 1)) = 0.1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Toggle]_dontusecustom("dont use custom", Float) = 0
		[HideInInspector] _tex3coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 uv2_tex3coord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _dontusecustom;
		uniform sampler2D _Main_Tex;
		uniform float4 _Main_Tex_ST;
		uniform float _dark_size;
		uniform float _height_power;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_cast_0 = (( i.uv2_tex3coord2.y / 20.0 )).xxxx;
			float4 temp_cast_1 = (i.uv2_tex3coord2.y).xxxx;
			float2 uv_Main_Tex = i.uv_texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float4 tex2DNode3 = tex2D( _Main_Tex, uv_Main_Tex );
			float4 temp_cast_2 = (( 1.0 - _dark_size )).xxxx;
			float4 smoothstepResult72 = smoothstep( temp_cast_0 , temp_cast_1 , saturate( ( ( ( tex2DNode3 * ( ( 1.0 - ( i.uv2_tex3coord2.x + 0.0 ) ) + 1.0 ) ) - temp_cast_2 ) * _height_power ) ));
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_88_0 = ( lerp(smoothstepResult72,tex2DNode3,_dontusecustom) - saturate( ( tex2D( _TextureSample0, uv_TextureSample0 ) * i.uv2_tex3coord2.z ) ) );
			o.Emission = ( saturate( temp_output_88_0 ) * i.vertexColor ).rgb;
			o.Alpha = saturate( ( temp_output_88_0 * i.vertexColor.a ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
				float3 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xyz = customInputData.uv2_tex3coord2;
				o.customPack1.xyz = v.texcoord1;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
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
				surfIN.uv2_tex3coord2 = IN.customPack1.xyz;
				surfIN.uv_texcoord = IN.customPack2.xy;
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
-1518;363;1508;656;-636.9814;662.1185;1.748858;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;13;-1620.819,568.8422;Inherit;False;1;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1237.35,81.47139;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-978.7476,-1.929779;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-969.338,72.3772;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-781.6273,-14.28702;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-547.6608,96.51114;Float;False;Property;_dark_size;dark_size;2;0;Create;True;0;0;False;0;0.1;0.759;-0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1832.641,-165.0234;Inherit;True;Property;_Main_Tex;Main_Tex;0;0;Create;True;0;0;False;0;None;48f53f9d673ea1f49a58f2a7dab98f22;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;60;-232.6723,12.40983;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-553.3857,-146.3403;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;13.58552,-178.616;Float;False;Property;_height_power;height_power;1;0;Create;True;0;0;False;0;1.45;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-54.42225,-66.2821;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;259.229,-158.7905;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;87;1116.412,420.0128;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;863.1725,-163.494;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;75;1141.335,-64.81804;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;72;1366.691,-92.13457;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;1591.009,261.1625;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;92;1715.266,171.7271;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;93;1667.401,-45.92911;Inherit;False;Property;_dontusecustom;dont use custom;4;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;69;1860.445,233.4128;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;1971.782,2.346901;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;2197.74,-50.62527;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;86;2124.551,-227.1216;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;71;2458.544,-80.40277;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;2507.555,-262.149;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2678.844,-192.3586;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;particle_fade;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;13;1
WireConnection;16;0;15;0
WireConnection;18;0;16;0
WireConnection;18;1;66;0
WireConnection;60;0;8;0
WireConnection;61;0;3;0
WireConnection;61;1;18;0
WireConnection;7;0;61;0
WireConnection;7;1;60;0
WireConnection;9;0;7;0
WireConnection;9;1;10;0
WireConnection;11;0;9;0
WireConnection;75;0;13;2
WireConnection;72;0;11;0
WireConnection;72;1;75;0
WireConnection;72;2;13;2
WireConnection;89;0;87;0
WireConnection;89;1;13;3
WireConnection;92;0;89;0
WireConnection;93;0;72;0
WireConnection;93;1;3;0
WireConnection;88;0;93;0
WireConnection;88;1;92;0
WireConnection;70;0;88;0
WireConnection;70;1;69;4
WireConnection;86;0;88;0
WireConnection;71;0;70;0
WireConnection;67;0;86;0
WireConnection;67;1;69;0
WireConnection;0;2;67;0
WireConnection;0;9;71;0
ASEEND*/
//CHKSM=7D9F7189089A84ED021AF1D0F9B919E9D3BC1F37