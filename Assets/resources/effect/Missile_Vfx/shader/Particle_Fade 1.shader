// Upgrade NOTE: upgraded instancing buffer 'particle_fade_cv' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "particle_fade_cv"
{
	Properties
	{
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[HDR]_em_2("em_2", Color) = (1,0.3157295,0.2862746,0)
		[HDR]_em_1("em_1", Color) = (0.6320754,0.1202124,0.08646317,0)
		_height_power("height_power", Float) = 1.45
		_dark_size("dark_size", Range( -0.3 , 1)) = 0.1
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_sub_height_power("sub_height_power", Float) = 0.5
		_sub_dark_size("sub_dark_size", Range( 0 , 1)) = 0.69
		_Opacity("Opacity", Float) = 0
		_Lerp_Power("Lerp_Power", Float) = 0
		[Toggle]_Wihtoutcustom("Wiht out custom", Float) = 0
		[Toggle]_Vertex_Alpha("Vertex_Alpha?", Float) = 0
		[Toggle]_Vertex_Color("Vertex_Color?", Float) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float4 vertexColor : COLOR;
		};

		uniform float _Opacity;
		uniform sampler2D _Main_Tex;
		uniform float _sub_dark_size;
		uniform float _sub_height_power;
		uniform float _dark_size;
		uniform float _height_power;
		uniform float4 _em_1;
		uniform float _Wihtoutcustom;
		uniform float _Lerp_Power;
		uniform float _Vertex_Color;
		uniform float _Vertex_Alpha;
		uniform float _Cutoff = 0.5;

		UNITY_INSTANCING_BUFFER_START(particle_fade_cv)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Main_Tex_ST)
#define _Main_Tex_ST_arr particle_fade_cv
			UNITY_DEFINE_INSTANCED_PROP(float4, _em_2)
#define _em_2_arr particle_fade_cv
		UNITY_INSTANCING_BUFFER_END(particle_fade_cv)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Main_Tex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Main_Tex_ST_arr, _Main_Tex_ST);
			float2 uv_Main_Tex = i.uv_texcoord * _Main_Tex_ST_Instance.xy + _Main_Tex_ST_Instance.zw;
			float4 tex2DNode3 = tex2D( _Main_Tex, uv_Main_Tex );
			float temp_output_18_0 = ( ( 1.0 - ( i.uv2_texcoord2.x + 0.0 ) ) + 1.0 );
			float temp_output_11_0 = saturate( ( ( ( tex2DNode3.g * temp_output_18_0 ) - ( 1.0 - _dark_size ) ) * _height_power ) );
			float temp_output_49_0 = saturate( max( ( ( ( tex2DNode3.r * temp_output_18_0 ) - ( 1.0 - _sub_dark_size ) ) * _sub_height_power ) , temp_output_11_0 ) );
			float temp_output_64_0 = ( _Opacity * temp_output_49_0 );
			float4 _em_2_Instance = UNITY_ACCESS_INSTANCED_PROP(_em_2_arr, _em_2);
			float4 lerpResult53 = lerp( _em_1 , _em_2_Instance , lerp(i.uv2_texcoord2.y,( ( 1.0 - pow( distance( i.uv_texcoord , float2( 0.5,0.5 ) ) , 2.5 ) ) * _Lerp_Power ),_Wihtoutcustom));
			float4 temp_output_52_0 = ( temp_output_64_0 * temp_output_11_0 * lerpResult53 * lerp(float4( 1,1,1,0 ),i.vertexColor,_Vertex_Color) );
			o.Albedo = temp_output_52_0.rgb;
			o.Emission = temp_output_52_0.rgb;
			o.Alpha = lerp(temp_output_64_0,( temp_output_64_0 * i.vertexColor.a ),_Vertex_Alpha);
			clip( floor( ( temp_output_49_0 * 1.25 ) ) - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
Version=17000
0;86;1906;933;-159.3988;752.5755;1.6;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;13;-1493.252,199.8815;Float;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-1237.35,81.47139;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-978.7476,-1.929779;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-1019.338,83.3772;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1253.284,-416.0412;Float;True;Property;_Main_Tex;Main_Tex;0;0;Create;True;0;0;False;0;None;c2229faa17afb464ca354e3b6fa2054a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-781.6273,-14.28702;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-547.6608,96.51114;Float;False;Property;_dark_size;dark_size;4;0;Create;True;0;0;False;0;0.1;0.75;-0.3;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-595.6625,-805.6283;Float;False;Property;_sub_dark_size;sub_dark_size;7;0;Create;True;0;0;False;0;0.69;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;60;-232.6723,12.40983;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-553.3857,-146.3403;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;73;-1402.084,567.4562;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;13.58552,-178.616;Float;False;Property;_height_power;height_power;3;0;Create;True;0;0;False;0;1.45;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-282.8908,-746.09;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-459.4632,-565.8049;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-54.42225,-66.2821;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;259.229,-158.7905;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;89.07537,-514.9825;Float;False;Property;_sub_height_power;sub_height_power;6;0;Create;True;0;0;False;0;0.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;70;-958.7964,531.9135;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;41;-91.57729,-749.7069;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;74;-700.5716,471.0275;Float;True;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;352.5961,-580.2547;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;524.3393,-158.172;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;29.86133,783.3524;Float;False;Property;_Lerp_Power;Lerp_Power;9;0;Create;True;0;0;False;0;0;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;55;-162.197,478.3613;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;43;692.8248,-525.6805;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;374.3914,624.0074;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;1204.891,-552.5221;Float;False;Property;_Opacity;Opacity;8;0;Create;True;0;0;False;0;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;929.5528,-530.6436;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;54;824.3564,86.98721;Float;False;Property;_em_1;em_1;2;1;[HDR];Create;True;0;0;False;0;0.6320754,0.1202124,0.08646317,0;0,0.8484955,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;802.8864,289.0752;Float;False;InstancedProperty;_em_2;em_2;1;1;[HDR];Create;True;0;0;False;0;1,0.3157295,0.2862746,0;0.4173813,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;75;633.9243,478.4949;Float;False;Property;_Wihtoutcustom;Wiht out custom;10;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1470.342,-412.9924;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;76;1599.34,441.8649;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;1130.787,-279.5201;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;53;1328.304,401.2056;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;1865.54,263.4648;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;79;1830.951,17.54871;Float;False;Property;_Vertex_Color;Vertex_Color?;12;0;Create;True;0;0;False;0;0;2;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;67;1412.919,-133.2582;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;1980.57,-313.1885;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;78;2079.34,53.06488;Float;False;Property;_Vertex_Alpha;Vertex_Alpha?;11;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2432.828,-186.0505;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;particle_fade_cv;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;5;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;13;1
WireConnection;16;0;15;0
WireConnection;18;0;16;0
WireConnection;18;1;66;0
WireConnection;60;0;8;0
WireConnection;61;0;3;2
WireConnection;61;1;18;0
WireConnection;62;0;42;0
WireConnection;5;0;3;1
WireConnection;5;1;18;0
WireConnection;7;0;61;0
WireConnection;7;1;60;0
WireConnection;9;0;7;0
WireConnection;9;1;10;0
WireConnection;70;0;73;0
WireConnection;41;0;5;0
WireConnection;41;1;62;0
WireConnection;74;0;70;0
WireConnection;44;0;41;0
WireConnection;44;1;45;0
WireConnection;11;0;9;0
WireConnection;55;0;74;0
WireConnection;43;0;44;0
WireConnection;43;1;11;0
WireConnection;71;0;55;0
WireConnection;71;1;72;0
WireConnection;49;0;43;0
WireConnection;75;0;13;2
WireConnection;75;1;71;0
WireConnection;64;0;65;0
WireConnection;64;1;49;0
WireConnection;68;0;49;0
WireConnection;53;0;54;0
WireConnection;53;1;20;0
WireConnection;53;2;75;0
WireConnection;77;0;64;0
WireConnection;77;1;76;4
WireConnection;79;1;76;0
WireConnection;67;0;68;0
WireConnection;52;0;64;0
WireConnection;52;1;11;0
WireConnection;52;2;53;0
WireConnection;52;3;79;0
WireConnection;78;0;64;0
WireConnection;78;1;77;0
WireConnection;0;0;52;0
WireConnection;0;2;52;0
WireConnection;0;9;78;0
WireConnection;0;10;67;0
ASEEND*/
//CHKSM=54246094B2FC2732669BD40E91C39F9EF88F6071