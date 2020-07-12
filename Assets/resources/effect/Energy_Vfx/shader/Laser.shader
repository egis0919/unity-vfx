// Upgrade NOTE: upgraded instancing buffer 'Laser' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Laser"
{
	Properties
	{
		[HDR]_Mask_power("Mask_power", Color) = (1.888086,1.888086,1.888086,0)
		_Mask_Bias("Mask_Bias", Float) = 0.015
		_Mask_Scale("Mask_Scale", Float) = 1.5
		_trail_tex("trail_tex", 2D) = "gray" {}
		_Trail_tile("Trail_tile", Vector) = (1,1,0,0)
		_trail_speed("trail_speed", Vector) = (-1,0,0,0)
		_Main_Scale("Main_Scale", Float) = 5
		_dis_tex("dis_tex", 2D) = "white" {}
		_dis_power("dis_power", Float) = 0.15
		_dis_speed("dis_speed", Vector) = (-0.5,0,0,0)
		[HDR]_trail_color1("trail_color1", Color) = (0.5424528,1,0.9571615,0)
		[HDR]_trail_color2("trail_color2", Color) = (0.7286931,0.6839622,1,0)
		_color_mask("color_mask", 2D) = "white" {}
		[HDR]_mix_power("mix_power", Range( 0 , 1)) = 0.7745354
		_Color_dis_tex("Color_dis_tex", 2D) = "white" {}
		_color_mask_power("color_mask_power", Float) = 1.03
		_Color_Bias("Color_Bias", Float) = -0.25
		_Color_Scale("Color_Scale", Float) = 1
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
		#pragma target 3.5
		#pragma multi_compile_instancing
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _trail_tex;
		uniform float2 _trail_speed;
		uniform float2 _Trail_tile;
		uniform float _dis_power;
		uniform sampler2D _dis_tex;
		uniform float2 _dis_speed;
		uniform float _Main_Scale;
		uniform float _Mask_Bias;
		uniform float _Mask_Scale;
		uniform sampler2D _color_mask;
		uniform sampler2D _Color_dis_tex;
		uniform float _color_mask_power;
		uniform float _Color_Bias;
		uniform float _Color_Scale;
		uniform float4 _trail_color2;
		uniform float4 _trail_color1;
		uniform float _mix_power;

		UNITY_INSTANCING_BUFFER_START(Laser)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Mask_power)
#define _Mask_power_arr Laser
		UNITY_INSTANCING_BUFFER_END(Laser)

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord2 = i.uv_texcoord * _Trail_tile;
			float2 panner7 = ( 1.0 * _Time.y * _trail_speed + uv_TexCoord2);
			float2 panner12 = ( 1.0 * _Time.y * _dis_speed + i.uv_texcoord);
			float4 tex2DNode9 = tex2D( _dis_tex, panner12 );
			float4 temp_cast_2 = (0.4).xxxx;
			float4 temp_cast_3 = (0.7).xxxx;
			float4 temp_output_56_0 = ( ( ( tex2D( _trail_tex, ( float4( panner7, 0.0 , 0.0 ) + ( ( i.uv_texcoord.y * _dis_power ) * tex2DNode9 ) ).rg ) * saturate( ( 1.0 - (float4( 0,0,0,0 ) + (( tex2DNode9 * i.uv_texcoord.x ) - temp_cast_2) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_3 - temp_cast_2)) ) ) ) + 0.1 ) * _Main_Scale );
			float4 _Mask_power_Instance = UNITY_ACCESS_INSTANCED_PROP(_Mask_power_arr, _Mask_power);
			float2 uv_TexCoord118 = i.uv_texcoord + float2( 0.3,0 );
			float4 temp_output_19_0 = ( temp_output_56_0 * ( ( ( ( 1.0 - i.uv_texcoord.x ) * _Mask_power_Instance ) + _Mask_Bias ) * _Mask_Scale ) * ( temp_output_56_0 * saturate( ( ( ( (0.0 + (( uv_TexCoord118.x * uv_TexCoord118.y ) - 0.1) * (1.0 - 0.0) / (1.0 - 0.1)) * (0.0 + (( uv_TexCoord118.x * ( 1.0 - uv_TexCoord118.y ) ) - 0.1) * (1.0 - 0.0) / (1.0 - 0.1)) ) + -0.002 ) * 100.0 ) ) ) );
			float2 panner62 = ( 1.0 * _Time.y * float2( -0.5,0 ) + i.uv_texcoord);
			float4 tex2DNode36 = tex2D( _color_mask, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( ( ( tex2D( _Color_dis_tex, panner62 ) * ( i.uv_texcoord.x * _color_mask_power ) ) + _Color_Bias ) * _Color_Scale ) ).rg );
			float4 lerpResult32 = lerp( _trail_color1 , _trail_color2 , _mix_power);
			o.Emission = ( temp_output_19_0 * ( ( tex2DNode36 * _trail_color2 ) + ( ( 1.0 - tex2DNode36 ) * _trail_color1 ) ) * lerpResult32 ).rgb;
			o.Alpha = saturate( temp_output_19_0 ).r;
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
			#pragma target 3.5
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
Version=17000
0;116;1906;903;3858.358;850.6616;2.217391;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-2930.346,173.5418;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-2751.737,555.8406;Float;False;Property;_dis_speed;dis_speed;9;0;Create;True;0;0;False;0;-0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-2134.839,-1230.009;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;12;-2532.378,509.8517;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-2384.955,312.6992;Float;True;Property;_dis_tex;dis_tex;7;0;Create;True;0;0;False;0;None;578b893799655a044b7a654d2445e849;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;63;-1941.301,-663.2906;Float;False;Constant;_Color_speed;Color_speed;5;0;Create;True;0;0;False;0;-0.5,0;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;68;-1795.923,-1068.143;Float;False;Property;_color_mask_power;color_mask_power;15;0;Create;True;0;0;False;0;1.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;60;-1719.6,-927.6915;Float;True;Property;_Color_dis_tex;Color_dis_tex;14;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;62;-1693.23,-702.7473;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-2362.675,151.9667;Float;False;Property;_dis_power;dis_power;8;0;Create;True;0;0;False;0;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1875.533,546.4873;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;47;-3015.681,-222.1811;Float;False;Property;_Trail_tile;Trail_tile;4;0;Create;True;0;0;False;0;1,1;5,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;118;-3118.009,800.4139;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.3,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;16;-2206.566,-176.2294;Float;False;Property;_trail_speed;trail_speed;5;0;Create;True;0;0;False;0;-1,0;-1.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;86;-1615.557,350.9694;Float;False;Constant;_Main_Mask_Max;Main_Mask_Max;21;0;Create;True;0;0;False;0;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;61;-1495.747,-766.4803;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;85;-1615.524,270.3676;Float;False;Constant;_Main_mask_Min;Main_mask_Min;21;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1591.882,172.4539;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;110;-2725.832,994.0782;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1481.74,-1086.087;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2722.9,-248.6649;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-2080.383,168.0519;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1008.979,-758.9104;Float;False;Property;_Color_Bias;Color_Bias;16;0;Create;True;0;0;False;0;-0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-993.0994,-674.3964;Float;False;Property;_Color_Scale;Color_Scale;17;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1822.644,54.7962;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-2428.418,888.6406;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1208.956,-902.1555;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-2419.288,1142.037;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-1944.042,-239.9456;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;84;-1382.124,198.4081;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1608.583,-70.74861;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;87;-1021.852,201.6794;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;78;-860.7904,-881.9944;Float;True;ConstantBiasScale;-1;;6;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1702.237,-357.3818;Float;True;Property;_trail_tex;trail_tex;3;0;Create;True;0;0;False;0;None;9a903c709cc7a34469301a4b8243ab44;False;gray;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TFHCRemapNode;116;-2085.298,1186.808;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;117;-2150.061,742.7485;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1380.537,-106.8327;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;6e6cba53deb4f4e41a81667b73a1ca42;120ede8c4897abf488ebbcd0d0b46ede;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;88;-838.5925,157.3722;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1865.8,992.9327;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-555.7368,-907.7485;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-392.6368,201.897;Float;False;Property;_Main_Scale;Main_Scale;6;0;Create;True;0;0;False;0;5;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-255.0632,-692.4239;Float;True;Property;_color_mask;color_mask;12;0;Create;True;0;0;False;0;0777ecfa8cc97cc4ab643f6491b61798;0777ecfa8cc97cc4ab643f6491b61798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;112;-1538.53,991.3897;Float;True;ConstantBiasScale;-1;;14;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.002;False;2;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;94;-566.6371,541.0082;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-601.2432,23.42965;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-370.6003,126.6965;Float;False;Constant;_Main_Bias;Main_Bias;13;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;25;-566.7845,788.0343;Float;False;InstancedProperty;_Mask_power;Mask_power;0;1;[HDR];Create;True;0;0;False;0;1.888086,1.888086,1.888086,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;96;-160.9687,467.7352;Float;False;Property;_Mask_Bias;Mask_Bias;1;0;Create;True;0;0;False;0;0.015;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-621.9717,-596.1599;Float;False;Property;_trail_color1;trail_color1;10;1;[HDR];Create;True;0;0;False;0;0.5424528,1,0.9571615,0;2.670157,0.5667787,1.223975,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;97;-161.4479,551.6172;Float;False;Property;_Mask_Scale;Mask_Scale;2;0;Create;True;0;0;False;0;1.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;56;-121.0782,126.9521;Float;True;ConstantBiasScale;-1;;17;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;37;156.3266,-741.8918;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;30;-623.3055,-344.419;Float;False;Property;_trail_color2;trail_color2;11;1;[HDR];Create;True;0;0;False;0;0.7286931,0.6839622,1,0;0.765799,1.04509,1.720795,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-300.0122,724.3534;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;113;-1123.522,1013.703;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-595.0323,-103.3212;Float;False;Property;_mix_power;mix_power;13;1;[HDR];Create;True;0;0;False;0;0.7745354;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;181.479,863.4551;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-155.1314,-386.6331;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;188.893,-604.5117;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;95;126.0886,489.3649;Float;True;ConstantBiasScale;-1;;18;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;358.4271,120.6062;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;-276.477,-148.4653;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;174.6994,-307.7325;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;569.6295,-137.3063;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;93;860.037,51.54581;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1265.144,-252.4081;Float;False;True;3;Float;ASEMaterialInspector;0;0;Unlit;Laser;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;59;0
WireConnection;12;2;14;0
WireConnection;62;0;66;0
WireConnection;62;2;63;0
WireConnection;9;0;15;0
WireConnection;9;1;12;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;91;0;9;0
WireConnection;91;1;59;1
WireConnection;110;0;118;2
WireConnection;64;0;66;1
WireConnection;64;1;68;0
WireConnection;2;0;47;0
WireConnection;49;0;59;2
WireConnection;49;1;28;0
WireConnection;10;0;49;0
WireConnection;10;1;9;0
WireConnection;108;0;118;1
WireConnection;108;1;118;2
WireConnection;67;0;61;0
WireConnection;67;1;64;0
WireConnection;109;0;118;1
WireConnection;109;1;110;0
WireConnection;7;0;2;0
WireConnection;7;2;16;0
WireConnection;84;0;91;0
WireConnection;84;1;85;0
WireConnection;84;2;86;0
WireConnection;3;0;7;0
WireConnection;3;1;10;0
WireConnection;87;0;84;0
WireConnection;78;3;67;0
WireConnection;78;1;79;0
WireConnection;78;2;80;0
WireConnection;116;0;109;0
WireConnection;117;0;108;0
WireConnection;1;0;18;0
WireConnection;1;1;3;0
WireConnection;88;0;87;0
WireConnection;111;0;117;0
WireConnection;111;1;116;0
WireConnection;70;0;66;0
WireConnection;70;1;78;0
WireConnection;36;1;70;0
WireConnection;112;3;111;0
WireConnection;94;0;59;1
WireConnection;89;0;1;0
WireConnection;89;1;88;0
WireConnection;56;3;89;0
WireConnection;56;1;58;0
WireConnection;56;2;57;0
WireConnection;37;0;36;0
WireConnection;22;0;94;0
WireConnection;22;1;25;0
WireConnection;113;0;112;0
WireConnection;114;0;56;0
WireConnection;114;1;113;0
WireConnection;39;0;36;0
WireConnection;39;1;30;0
WireConnection;38;0;37;0
WireConnection;38;1;31;0
WireConnection;95;3;22;0
WireConnection;95;1;96;0
WireConnection;95;2;97;0
WireConnection;19;0;56;0
WireConnection;19;1;95;0
WireConnection;19;2;114;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;32;2;33;0
WireConnection;40;0;39;0
WireConnection;40;1;38;0
WireConnection;29;0;19;0
WireConnection;29;1;40;0
WireConnection;29;2;32;0
WireConnection;93;0;19;0
WireConnection;0;2;29;0
WireConnection;0;9;93;0
ASEEND*/
//CHKSM=372E369DE6CA328240D5862AC17BEBD52DE0C1E6