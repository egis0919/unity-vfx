// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "heal"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_X("X", Float) = 0
		_tex_x("tex_x", Float) = 1
		_noise_x("noise_x", Float) = 1
		_Y("Y", Float) = 0
		_tex_y("tex_y", Float) = 1
		_noise_y("noise_y", Float) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_Noise_power("Noise_power", Float) = 1
		_Color1("Color 1", Color) = (0.5518868,0.9196348,1,0)
		_Opacity("Opacity", Float) = 0
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
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _Texture0;
		uniform float _noise_x;
		uniform float _noise_y;
		uniform float _Noise_power;
		uniform float _tex_x;
		uniform float _tex_y;
		uniform float _X;
		uniform float _Y;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Opacity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float2 appendResult32 = (float2(_noise_x , _noise_y));
			float2 temp_output_1_0_g1 = appendResult32;
			float2 appendResult10_g1 = (float2(( (temp_output_1_0_g1).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g1).y )));
			float2 temp_output_11_0_g1 = float2( 0,0 );
			float2 panner18_g1 = ( ( (temp_output_11_0_g1).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g1 = ( ( _Time.y * (temp_output_11_0_g1).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g1 = (float2((panner18_g1).x , (panner19_g1).y));
			float2 appendResult24 = (float2(_tex_x , _tex_y));
			float2 appendResult13 = (float2(_X , _Y));
			float2 temp_output_47_0_g1 = appendResult13;
			float2 uv_TexCoord78_g1 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g1 = ( uv_TexCoord78_g1 - float2( 1,1 ) );
			float2 appendResult39_g1 = (float2(frac( ( atan2( (temp_output_31_0_g1).x , (temp_output_31_0_g1).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g1 )));
			float2 panner54_g1 = ( ( (temp_output_47_0_g1).x * _Time.y ) * float2( 1,0 ) + appendResult39_g1);
			float2 panner55_g1 = ( ( _Time.y * (temp_output_47_0_g1).y ) * float2( 0,1 ) + appendResult39_g1);
			float2 appendResult58_g1 = (float2((panner54_g1).x , (panner55_g1).y));
			float2 temp_cast_0 = (ddx( i.uv_texcoord.x )).xx;
			float2 temp_cast_1 = (ddy( i.uv_texcoord.y )).xx;
			o.Emission = ( ( tex2DNode1 * i.vertexColor ) * ( tex2DNode1.r + ( tex2D( _TextureSample1, ( ( (tex2D( _Texture0, ( appendResult10_g1 + appendResult24_g1 ) )).rg * _Noise_power ) + ( appendResult24 * appendResult58_g1 ) ), temp_cast_0, temp_cast_1 ) * _Color0 ) ) * _Color1 ).rgb;
			o.Alpha = saturate( ( tex2DNode1.a * i.vertexColor.a * _Opacity ) );
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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
-1913;32;1906;987;381.1216;468.8816;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;14;-1603.692,212.9107;Float;False;Property;_X;X;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1622.217,-59.72955;Float;False;Property;_noise_x;noise_x;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1599.496,50.03992;Float;False;Property;_noise_y;noise_y;8;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1597.115,297.31;Float;False;Property;_Y;Y;6;0;Create;True;0;0;False;0;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1843.391,69.39694;Float;False;Property;_tex_x;tex_x;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1853.17,145.7664;Float;False;Property;_tex_y;tex_y;7;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1672.188,480.6175;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1203.505,71.0024;Float;False;Property;_Noise_power;Noise_power;10;0;Create;True;0;0;False;0;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-1318.962,-197.8912;Float;True;Property;_Texture0;Texture 0;9;0;Create;True;0;0;False;0;None;2ea9d207a8146e9458bef3b5a0428d32;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-1333.894,-17.00862;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1202.356,232.5679;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1343.868,127.8179;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdxOpNode;8;-908.7231,341.5746;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2;-898.1925,36.44301;Inherit;False;RadialUVDistortion;-1;;1;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler602;False;1;FLOAT2;0.3,0.3;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdyOpNode;9;-892.7231,444.5746;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-145.4705,303.3091;Float;False;Property;_Color0;Color 0;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.572549,0.800944,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-326.555,95.55037;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;bbb61adf8daec6a48a41639a0fee3b09;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-376,-225;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;c5c0dba241e28fe48b3e28309b90d707;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;33.58299,-6.80405;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;22;249.3553,-313.2565;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;360.5713,124.8934;Float;False;Property;_Opacity;Opacity;12;0;Create;True;0;0;False;0;0;1.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;28;413.9689,-500.524;Float;False;Property;_Color1;Color 1;11;0;Create;True;0;0;False;0;0.5518868,0.9196348,1,0;0.3915094,0.4920862,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;502.3553,-302.2565;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;234.2769,-147.4254;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;500.3553,-58.2565;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;33;-1826.705,350.4706;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;715.9689,-349.524;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;34;811.8784,-32.88162;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1032.89,-254.3234;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;heal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;24;0;26;0
WireConnection;24;1;25;0
WireConnection;8;0;6;1
WireConnection;2;60;17;0
WireConnection;2;1;32;0
WireConnection;2;65;23;0
WireConnection;2;68;24;0
WireConnection;2;47;13;0
WireConnection;9;0;6;2
WireConnection;3;1;2;0
WireConnection;3;3;8;0
WireConnection;3;4;9;0
WireConnection;11;0;3;0
WireConnection;11;1;12;0
WireConnection;20;0;1;0
WireConnection;20;1;22;0
WireConnection;5;0;1;1
WireConnection;5;1;11;0
WireConnection;18;0;1;4
WireConnection;18;1;22;4
WireConnection;18;2;29;0
WireConnection;27;0;20;0
WireConnection;27;1;5;0
WireConnection;27;2;28;0
WireConnection;34;0;18;0
WireConnection;0;2;27;0
WireConnection;0;9;34;0
ASEEND*/
//CHKSM=963ADDBC5551133B1B4620BDE7D67E2F718D2079