// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "radial uv2"
{
	Properties
	{
		_Emission("Emission", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		_Float1("Float 1", Range( 0 , 1)) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float0("Float 0", Float) = 3.9
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _KEYWORD0_ON
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform float _Emission;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Float0;
		uniform float _Float1;
		uniform sampler2D _TextureSample1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Emission = ( _Emission * i.vertexColor ).rgb;
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			#ifdef _KEYWORD0_ON
				float staticSwitch82 = i.uv2_texcoord2.x;
			#else
				float staticSwitch82 = _Float1;
			#endif
			float2 appendResult104 = (float2(-0.5 , 0.0));
			float2 panner102 = ( _Time.y * appendResult104 + i.uv_texcoord);
			#ifdef _KEYWORD0_ON
				float staticSwitch95 = i.uv2_texcoord2.x;
			#else
				float staticSwitch95 = _Float1;
			#endif
			o.Alpha = ( i.vertexColor.a * saturate( ( saturate( ( tex2D( _TextureSample0, uv_TextureSample0 ) * _Float0 ) ) - saturate( ( ( ( staticSwitch82 / 2.0 ) * 1.0 ) + ( tex2D( _TextureSample1, panner102 ) * staticSwitch95 * 2.0 ) ) ) ) ) ).r;
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
				float4 customPack1 : TEXCOORD1;
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
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
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
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
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
-1913;32;1906;987;532.394;-81.79757;1.163049;True;True
Node;AmplifyShaderEditor.RangedFloatNode;103;-51.42685,775.5878;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;101;-88.62317,528.9262;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;229.3669,327.6046;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;106;-11.02319,660.9262;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;319.267,150.2046;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;1;1.55;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;143.4309,788.9169;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;102;327.3768,583.9262;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;82;759.3669,130.6046;Inherit;False;Property;_Keyword0;Keyword 0;2;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;667.2669,332.8046;Inherit;False;Constant;_Float3;Float 3;2;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;95;764.6418,466.657;Inherit;False;Property;_Keyword0;Keyword 0;3;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;689.834,655.5344;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;d6a4142c9b03091438fc6311a7d20457;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;99;918.051,660.6348;Inherit;False;Constant;_Float2;Float 2;6;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;1005.409,144.3079;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;1082.008,515.4254;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;856.3669,276.6046;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;72;855.8522,-72.92246;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;8c4a7fca2884fab419769ccc0355c0c1;82a8e66f31a9e654792bee0ab05f9fc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;1129.634,102.1752;Inherit;False;Property;_Float0;Float 0;5;0;Create;True;0;0;False;0;3.9;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;1204.284,-28.55279;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;94;1143.008,293.4254;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;98;1417.294,108.2185;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;84;1337.535,292.382;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;74;1553.8,251.4393;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;86;1521.535,43.38202;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;1547.367,-47.39539;Inherit;False;Property;_Emission;Emission;0;0;Create;True;0;0;False;0;1;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;85;1732.298,253.9647;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;1776.535,36.382;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;1786.535,177.382;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;28.83264,891.5918;Inherit;False;FLOAT2;4;0;FLOAT;1;False;1;FLOAT;11;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-192.1674,856.5918;Inherit;False;Property;_x;x;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;107;220.7081,882.493;Inherit;False;RadialUVDistortion;-1;;1;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler60107;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-192.1674,932.5918;Inherit;False;Property;_y;y;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1964.802,-4.22196;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;radial uv2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;104;0;103;0
WireConnection;102;0;101;0
WireConnection;102;2;104;0
WireConnection;102;1;106;2
WireConnection;82;1;83;0
WireConnection;82;0;81;1
WireConnection;95;1;83;0
WireConnection;95;0;81;1
WireConnection;89;1;102;0
WireConnection;100;0;82;0
WireConnection;93;0;89;0
WireConnection;93;1;95;0
WireConnection;93;2;99;0
WireConnection;75;0;100;0
WireConnection;75;1;80;0
WireConnection;96;0;72;0
WireConnection;96;1;97;0
WireConnection;94;0;75;0
WireConnection;94;1;93;0
WireConnection;98;0;96;0
WireConnection;84;0;94;0
WireConnection;74;0;98;0
WireConnection;74;1;84;0
WireConnection;85;0;74;0
WireConnection;87;0;71;0
WireConnection;87;1;86;0
WireConnection;88;0;86;4
WireConnection;88;1;85;0
WireConnection;108;0;109;0
WireConnection;108;1;110;0
WireConnection;107;68;108;0
WireConnection;107;47;104;0
WireConnection;0;2;87;0
WireConnection;0;9;88;0
ASEEND*/
//CHKSM=9012D5680CBF87958816FFA122BDFD43906EDD92