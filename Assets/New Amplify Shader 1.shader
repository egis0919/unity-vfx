// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Simple uv scroll"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[Toggle(_PARTICLE_ON)] _particle("particle", Float) = 0
		_Emission("Emission", Float) = 0
		_ofs_x("ofs_x", Float) = 0
		_ofs_y("ofs_y", Float) = 0.05
		_fade("fade", Range( 0 , 1)) = 0
		_Mask_Tex("Mask_Tex", 2D) = "white" {}
		_x("x", Float) = 0
		_Mask_Power1("Mask_Power", Float) = 4
		_y("y", Float) = 0
		[Toggle]_use_v1("use_v", Float) = 1
		[HideInInspector] _tex3coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _PARTICLE_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float3 uv2_tex3coord2;
			float2 uv_texcoord;
		};

		uniform float _Emission;
		uniform sampler2D _Main_Tex;
		uniform float _x;
		uniform float _y;
		uniform float _ofs_x;
		uniform float _ofs_y;
		uniform float _fade;
		uniform sampler2D _Mask_Tex;
		uniform float4 _Mask_Tex_ST;
		uniform float _use_v1;
		uniform float _Mask_Power1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( _Emission * i.vertexColor ).rgb;
			float2 appendResult22 = (float2(_x , _y));
			#ifdef _PARTICLE_ON
				float staticSwitch5 = i.uv2_tex3coord2.x;
			#else
				float staticSwitch5 = _ofs_x;
			#endif
			#ifdef _PARTICLE_ON
				float staticSwitch6 = i.uv2_tex3coord2.y;
			#else
				float staticSwitch6 = _ofs_y;
			#endif
			float2 appendResult4 = (float2(staticSwitch5 , staticSwitch6));
			float2 uv_TexCoord2 = i.uv_texcoord * appendResult22 + appendResult4;
			#ifdef _PARTICLE_ON
				float staticSwitch38 = i.uv2_tex3coord2.z;
			#else
				float staticSwitch38 = _fade;
			#endif
			float2 uv_Mask_Tex = i.uv_texcoord * _Mask_Tex_ST.xy + _Mask_Tex_ST.zw;
			o.Alpha = saturate( ( ( ( tex2D( _Main_Tex, uv_TexCoord2 ) - saturate( ( staticSwitch38 + ( staticSwitch38 * tex2D( _Mask_Tex, uv_Mask_Tex ) ) ) ) ) * saturate( pow( ( lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_v1) * ( 1.0 - lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_v1) ) * _Mask_Power1 ) , ( _Mask_Power1 / 2.0 ) ) ) ) * i.vertexColor.a ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
-1913;26;1906;993;1868.813;346.5525;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;8;-1606.351,292.3112;Inherit;False;Property;_ofs_y;ofs_y;4;0;Create;True;0;0;False;0;0.05;-0.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1593.351,162.3112;Inherit;False;Property;_ofs_x;ofs_x;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-1865.096,209.0886;Inherit;False;1;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-947.1697,919.4885;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-1311.654,427.1392;Inherit;False;Property;_fade;fade;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;6;-1448.351,295.3112;Inherit;False;Property;_particle;particle;1;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1374.019,38.1319;Inherit;False;Property;_x;x;7;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;38;-978.174,467.305;Inherit;False;Property;_particle;particle;1;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;26;-570.9185,869.7856;Inherit;False;Property;_use_v1;use_v;10;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-1042.654,696.1392;Inherit;True;Property;_Mask_Tex;Mask_Tex;6;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;df1a73877e6e817489bcdec99d204d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-1362.019,105.1319;Inherit;False;Property;_y;y;9;0;Create;True;0;0;False;0;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;5;-1436.615,163.2978;Inherit;False;Property;_particle;particle;1;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;4;-1099.487,190.856;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-707.9905,637.7752;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1118.019,87.1319;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;28;-338.6924,919.4587;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-176.6924,1163.459;Inherit;False;Property;_Mask_Power1;Mask_Power;8;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-567.9905,526.7752;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;60.14941,1082.247;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-947.9346,153.5538;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-66.69245,810.4587;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;-440.8379,475.5488;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;30;145.3076,861.4587;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-669.5048,179.6177;Inherit;True;Property;_Main_Tex;Main_Tex;0;0;Create;True;0;0;False;0;302e31ee1835c0b4d80dfb193f0bea0b;302e31ee1835c0b4d80dfb193f0bea0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-317.9905,376.801;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;35;326.1494,667.2473;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-65.85059,333.2473;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;11;-368.6785,124.2026;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-350.6785,-10.79739;Inherit;False;Property;_Emission;Emission;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;179.3215,220.2026;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;37;301.1621,302.5488;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-153.6785,12.20261;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;427,34;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;Simple uv scroll;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;1;8;0
WireConnection;6;0;3;2
WireConnection;38;1;15;0
WireConnection;38;0;3;3
WireConnection;26;0;31;1
WireConnection;26;1;31;2
WireConnection;5;1;7;0
WireConnection;5;0;3;1
WireConnection;4;0;5;0
WireConnection;4;1;6;0
WireConnection;21;0;38;0
WireConnection;21;1;16;0
WireConnection;22;0;23;0
WireConnection;22;1;24;0
WireConnection;28;0;26;0
WireConnection;20;0;38;0
WireConnection;20;1;21;0
WireConnection;34;0;27;0
WireConnection;2;0;22;0
WireConnection;2;1;4;0
WireConnection;29;0;26;0
WireConnection;29;1;28;0
WireConnection;29;2;27;0
WireConnection;36;0;20;0
WireConnection;30;0;29;0
WireConnection;30;1;34;0
WireConnection;1;1;2;0
WireConnection;19;0;1;0
WireConnection;19;1;36;0
WireConnection;35;0;30;0
WireConnection;32;0;19;0
WireConnection;32;1;35;0
WireConnection;13;0;32;0
WireConnection;13;1;11;4
WireConnection;37;0;13;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;0;2;12;0
WireConnection;0;9;37;0
ASEEND*/
//CHKSM=9DED63245F64B29E80E2484B8606F1B13FA28378