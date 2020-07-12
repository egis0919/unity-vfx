// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "particle_fade_new"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_height_power("height_power", Float) = 1.45
		_dark_size("dark_size", Range( -0.3 , 1)) = 0.1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		[Toggle]_dontuseuvcustom("dont use u,v custom", Float) = 1
		_Emission("Emission", Float) = 0
		_Float1("Float 1", Float) = 1
		[HDR]_Color0("Color 0", Color) = (1,0.2657566,0,0)
		[Toggle(_USE_LERP_ON)] _Use_Lerp("Use_Lerp", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		[HideInInspector] _tex3coord2( "", 2D ) = "white" {}
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
		#pragma shader_feature _USE_LERP_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 uv2_tex3coord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _dontuseuvcustom;
		uniform sampler2D _Main_Tex;
		uniform float4 _Main_Tex_ST;
		uniform float _dark_size;
		uniform float _height_power;
		uniform float _Float1;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Emission;
		uniform float4 _Color0;
		uniform sampler2D _TextureSample2;
		uniform sampler2D _TextureSample1;

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
			float4 temp_output_88_0 = ( lerp(smoothstepResult72,saturate( ( tex2DNode3 * _Float1 ) ),_dontuseuvcustom) - saturate( ( tex2D( _TextureSample0, uv_TextureSample0 ) * i.uv2_tex3coord2.z ) ) );
			float4 temp_output_67_0 = ( saturate( temp_output_88_0 ) * i.vertexColor * _Emission );
			float temp_output_122_0 = ( 0.05 * _Time.x );
			float2 temp_cast_4 = (temp_output_122_0).xx;
			float2 panner109 = ( temp_output_122_0 * temp_cast_4 + i.uv_texcoord);
			float4 lerpResult106 = lerp( temp_output_67_0 , _Color0 , tex2D( _TextureSample2, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( tex2D( _TextureSample1, panner109 ) * 0.05 ) ).rg ).a);
			#ifdef _USE_LERP_ON
				float4 staticSwitch107 = lerpResult106;
			#else
				float4 staticSwitch107 = temp_output_67_0;
			#endif
			o.Emission = staticSwitch107.rgb;
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
1920;-2.400002;1908;990;453.5871;1135.661;1.161402;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;13;-1394.783,239.2605;Inherit;False;1;3;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1237.35,81.47139;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-1019.338,83.3772;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-978.7476,-1.929779;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-547.6608,96.51114;Float;False;Property;_dark_size;dark_size;3;0;Create;True;0;0;False;0;0.1;1;-0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1238.361,-477.0772;Inherit;True;Property;_Main_Tex;Main_Tex;0;0;Create;True;0;0;False;0;None;2bdc2643848827c40a904c29a06224a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-781.6273,-14.28702;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-553.3857,-146.3403;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;60;-232.6723,12.40983;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-54.42225,-66.2821;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;13.58552,-178.616;Float;False;Property;_height_power;height_power;2;0;Create;True;0;0;False;0;1.45;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;259.229,-158.7905;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;121;-66.36102,-491.1572;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;997.3113,-287.5524;Inherit;False;Property;_Float1;Float 1;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-104.952,-586.395;Inherit;False;Constant;_Float3;Float 3;11;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;191.048,-560.395;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;863.1725,-163.494;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;268.482,-843.1298;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;1234.653,-359.9356;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;87;1116.412,420.0128;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;75;1336.335,-47.81804;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;1591.009,261.1625;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;72;1537.691,-86.13457;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;99;1522.897,-340.8116;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;109;463.6821,-609.5298;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;112;670.082,-636.7299;Inherit;True;Property;_TextureSample1;Texture Sample 1;10;0;Create;True;0;0;False;0;None;0df58e308f423a3469472cc0b69a5254;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;93;1715.234,-308.9971;Inherit;True;Property;_dontuseuvcustom;dont use u,v custom;5;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;114;986.121,-459.1759;Inherit;False;Constant;_Float2;Float 2;11;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;92;1715.266,171.7271;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;1161.121,-574.1759;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;1905.782,16.3469;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;86;2124.551,-227.1216;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;1219.082,-765.9299;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;95;2165.35,-115.2976;Inherit;False;Property;_Emission;Emission;6;0;Create;True;0;0;False;0;0;5.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;69;1860.445,233.4128;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;2370.89,-247.8546;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;108;1422.943,-769.7971;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;2bdc2643848827c40a904c29a06224a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;104;1892.774,-611.7786;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;False;0;1,0.2657566,0,0;2.996078,0.3137255,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;2197.74,-50.62527;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;106;2457.159,-551.1171;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;107;2668.08,-304.3254;Inherit;False;Property;_Use_Lerp;Use_Lerp;9;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;71;2458.544,-80.40277;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2978.664,-230.2029;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;particle_fade_new;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;13;1
WireConnection;16;0;15;0
WireConnection;18;0;16;0
WireConnection;18;1;66;0
WireConnection;61;0;3;0
WireConnection;61;1;18;0
WireConnection;60;0;8;0
WireConnection;7;0;61;0
WireConnection;7;1;60;0
WireConnection;9;0;7;0
WireConnection;9;1;10;0
WireConnection;122;0;125;0
WireConnection;122;1;121;1
WireConnection;11;0;9;0
WireConnection;96;0;3;0
WireConnection;96;1;97;0
WireConnection;75;0;13;2
WireConnection;89;0;87;0
WireConnection;89;1;13;3
WireConnection;72;0;11;0
WireConnection;72;1;75;0
WireConnection;72;2;13;2
WireConnection;99;0;96;0
WireConnection;109;0;110;0
WireConnection;109;2;122;0
WireConnection;109;1;122;0
WireConnection;112;1;109;0
WireConnection;93;0;72;0
WireConnection;93;1;99;0
WireConnection;92;0;89;0
WireConnection;113;0;112;0
WireConnection;113;1;114;0
WireConnection;88;0;93;0
WireConnection;88;1;92;0
WireConnection;86;0;88;0
WireConnection;111;0;110;0
WireConnection;111;1;113;0
WireConnection;67;0;86;0
WireConnection;67;1;69;0
WireConnection;67;2;95;0
WireConnection;108;1;111;0
WireConnection;70;0;88;0
WireConnection;70;1;69;4
WireConnection;106;0;67;0
WireConnection;106;1;104;0
WireConnection;106;2;108;4
WireConnection;107;1;67;0
WireConnection;107;0;106;0
WireConnection;71;0;70;0
WireConnection;0;2;107;0
WireConnection;0;9;71;0
ASEEND*/
//CHKSM=3E2924B315A9C8F147CF388EA744497E7F39E98E