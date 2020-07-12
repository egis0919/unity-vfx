// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Crack"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_height_power("height_power", Float) = 1.45
		_dark_size("dark_size", Range( -0.3 , 1)) = 0.1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Emission("Emission", Float) = 0
		_VertexOffsetPower("Vertex Offset Power", Float) = 0
		_tessellation("tessellation", Float) = 0
		[Toggle(_DEPTH_FADE_ON)] _Depth_Fade("Depth_Fade", Float) = 0
		[HideInInspector] _tex3coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature _DEPTH_FADE_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 uv2_tex3coord2;
			float4 screenPos;
		};

		uniform float _VertexOffsetPower;
		uniform sampler2D _Main_Tex;
		uniform float4 _Main_Tex_ST;
		uniform float _dark_size;
		uniform float _height_power;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Emission;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _tessellation;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (_tessellation).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_Main_Tex = v.texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float4 tex2DNode7 = tex2Dlod( _Main_Tex, float4( uv_Main_Tex, 0, 0.0) );
			float smoothstepResult20 = smoothstep( ( v.texcoord1.xyz.y / 20.0 ) , v.texcoord1.xyz.y , saturate( ( ( ( tex2DNode7.a * ( ( 1.0 - ( v.texcoord1.xyz.x + 0.0 ) ) + 1.0 ) ) - ( 1.0 - _dark_size ) ) * _height_power ) ));
			float4 temp_cast_1 = (smoothstepResult20).xxxx;
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_28_0 = saturate( ( ( temp_cast_1 - saturate( ( tex2Dlod( _TextureSample0, float4( uv_TextureSample0, 0, 0.0) ) * v.texcoord1.xyz.z ) ) ) * v.color.a ) );
			v.vertex.xyz += ( float4( ase_vertexNormal , 0.0 ) * _VertexOffsetPower * temp_output_28_0 ).rgb;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Main_Tex = i.uv_texcoord * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
			float4 tex2DNode7 = tex2D( _Main_Tex, uv_Main_Tex );
			o.Emission = ( tex2DNode7 * i.vertexColor * _Emission ).rgb;
			float smoothstepResult20 = smoothstep( ( i.uv2_tex3coord2.y / 20.0 ) , i.uv2_tex3coord2.y , saturate( ( ( ( tex2DNode7.a * ( ( 1.0 - ( i.uv2_tex3coord2.x + 0.0 ) ) + 1.0 ) ) - ( 1.0 - _dark_size ) ) * _height_power ) ));
			float4 temp_cast_1 = (smoothstepResult20).xxxx;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_28_0 = saturate( ( ( temp_cast_1 - saturate( ( tex2D( _TextureSample0, uv_TextureSample0 ) * i.uv2_tex3coord2.z ) ) ) * i.vertexColor.a ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth39 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth39 = abs( ( screenDepth39 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( 1.0 ) );
			#ifdef _DEPTH_FADE_ON
				float4 staticSwitch41 = ( temp_output_28_0 * distanceDepth39 );
			#else
				float4 staticSwitch41 = temp_output_28_0;
			#endif
			o.Alpha = saturate( staticSwitch41 ).r;
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
				o.customPack2.xyz = customInputData.uv2_tex3coord2;
				o.customPack2.xyz = v.texcoord1;
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
				surfIN.uv2_tex3coord2 = IN.customPack2.xyz;
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
-2015;49;1920;983;4558.6;386.1442;1;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;1;-4407.481,586.1541;Inherit;False;1;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-4134.044,406.509;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3855.267,282.7581;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;3;-3877.363,363.0214;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-3658.147,270.4008;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-4001.893,-125.1641;Inherit;True;Property;_Main_Tex;Main_Tex;0;0;Create;True;0;0;False;0;None;cff5877c8bbfe4c4cb67de9615782ce0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-3397.967,381.199;Float;False;Property;_dark_size;dark_size;2;0;Create;True;0;0;False;0;0.1;0.248;-0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;8;-3118.724,292.3316;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-3429.905,138.3475;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-2935.708,135;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2703.271,213.3077;Float;False;Property;_height_power;height_power;1;0;Create;True;0;0;False;0;1.45;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1839.536,696.4485;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;13313f77a45ccc844a1106f4da0a8bb5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2502.905,106.8331;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1285.511,545.8504;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;-2161.095,173.6202;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;15;-1629.614,348.9688;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-1161.254,456.415;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;-1389.044,151.8536;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-938.7599,301.0348;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;23;-885.3116,53.3649;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-678.7793,234.0626;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;28;-339.9753,191.2851;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;39;-554.8964,332.6014;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-115.8232,229.9675;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-535.5888,127.3925;Inherit;False;Property;_Emission;Emission;4;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-211.9482,487.5709;Inherit;False;Property;_VertexOffsetPower;Vertex Offset Power;7;0;Create;True;0;0;False;0;0;1.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;35;-130.9482,333.5709;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;41;72.177,134.9675;Inherit;False;Property;_Depth_Fade;Depth_Fade;9;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-419.75,-44.1203;Inherit;False;Property;_normalPower;normal Power;6;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;82.05176,444.5709;Inherit;False;Property;_tessellation;tessellation;8;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-653.75,-228.1203;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;9e3f3fd4045338844b2823d5c292ff86;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;43;455.097,170.3992;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-198.75,-121.1203;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;189.0518,273.5709;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-313.1375,23.97444;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;668.1014,-35.53354;Float;False;True;6;ASEMaterialInspector;0;0;Unlit;Crack;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;3;0;2;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;8;0;6;0
WireConnection;9;0;7;4
WireConnection;9;1;5;0
WireConnection;11;0;9;0
WireConnection;11;1;8;0
WireConnection;13;0;11;0
WireConnection;13;1;10;0
WireConnection;18;0;16;0
WireConnection;18;1;1;3
WireConnection;14;0;13;0
WireConnection;15;0;1;2
WireConnection;21;0;18;0
WireConnection;20;0;14;0
WireConnection;20;1;15;0
WireConnection;20;2;1;2
WireConnection;24;0;20;0
WireConnection;24;1;21;0
WireConnection;27;0;24;0
WireConnection;27;1;23;4
WireConnection;28;0;27;0
WireConnection;40;0;28;0
WireConnection;40;1;39;0
WireConnection;41;1;28;0
WireConnection;41;0;40;0
WireConnection;43;0;41;0
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;36;2;28;0
WireConnection;29;0;7;0
WireConnection;29;1;23;0
WireConnection;29;2;26;0
WireConnection;0;2;29;0
WireConnection;0;9;43;0
WireConnection;0;11;36;0
WireConnection;0;14;38;0
ASEEND*/
//CHKSM=271249C557F7CEBAB3816B8C2FEF1DFA306E3A58