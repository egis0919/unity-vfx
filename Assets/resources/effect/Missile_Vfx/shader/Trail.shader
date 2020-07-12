// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Trail"
{
	Properties
	{
		_trail_color1("trail_color1", Color) = (0.5424528,1,0.9571615,0)
		[HDR]_trail_color2("trail_color2", Color) = (0.7286931,0.6839622,1,0)
		_Trail_Tex("Trail_Tex", 2D) = "gray" {}
		_Tex_tilie("Tex_tilie", Vector) = (1,1,0,0)
		_trail_speed("trail_speed", Vector) = (-1,0,0,0)
		_Dis_Tex("Dis_Tex", 2D) = "white" {}
		_dis_speed("dis_speed", Vector) = (-0.5,0,0,0)
		_dis_power("dis_power", Float) = 0.15
		[Toggle]_disTex_filp("disTex_filp", Float) = 1
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_lerp_power("lerp_power", Range( 0 , 2)) = 0.7745354
		_Emission("Emission", Float) = 0
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
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _trail_color1;
		uniform float4 _trail_color2;
		uniform float _disTex_filp;
		uniform float _lerp_power;
		uniform float _Emission;
		uniform sampler2D _Trail_Tex;
		uniform float2 _trail_speed;
		uniform float2 _Tex_tilie;
		uniform float _dis_power;
		uniform sampler2D _Dis_Tex;
		uniform float2 _dis_speed;
		uniform sampler2D _TextureSample3;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult32 = lerp( _trail_color1 , _trail_color2 , saturate( ( lerp(( 1.0 - i.uv_texcoord ).x,i.uv_texcoord.x,_disTex_filp).x * _lerp_power ) ).x);
			o.Emission = ( lerpResult32 * _Emission * i.vertexColor ).rgb;
			float2 uv_TexCoord2 = i.uv_texcoord * _Tex_tilie;
			float2 panner7 = ( _Time.y * _trail_speed + uv_TexCoord2);
			float2 panner12 = ( _Time.y * _dis_speed + i.uv_texcoord);
			float temp_output_103_0 = pow( lerp(( 1.0 - i.uv_texcoord ).x,i.uv_texcoord.x,_disTex_filp).x , 1.5 );
			o.Alpha = ( i.vertexColor.a * saturate( ( tex2D( _Trail_Tex, ( float4( panner7, 0.0 , 0.0 ) + ( ( lerp(( 1.0 - i.uv_texcoord ).x,i.uv_texcoord.x,_disTex_filp).x * _dis_power ).x * tex2D( _Dis_Tex, panner12 ) ) ).rg ) - saturate( ( temp_output_103_0.x + ( temp_output_103_0.x * tex2D( _TextureSample3, panner12 ) ) ) ) ) ) ).r;
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
-1913;32;1906;987;3911.249;826.6058;2.106347;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;110;-3040.776,42.18371;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;48;-2525.11,137.2066;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-2870.254,326.9818;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;94;-2436.755,731.5111;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;14;-2554.281,553.5449;Float;False;Property;_dis_speed;dis_speed;6;0;Create;True;0;0;False;0;-0.5,0;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;28;-1972.622,131.3143;Float;False;Property;_dis_power;dis_power;7;0;Create;True;0;0;False;0;0.15;0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;47;-2907.171,-181.0687;Float;False;Property;_Tex_tilie;Tex_tilie;3;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ToggleSwitchNode;89;-2202.506,10.59265;Float;False;Property;_disTex_filp;disTex_filp;8;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;12;-2304.543,545.7563;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-2224.486,291.814;Float;True;Property;_Dis_Tex;Dis_Tex;5;0;Create;True;0;0;False;0;None;578b893799655a044b7a654d2445e849;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1744.938,49.71815;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;97;-852.3934,378.7557;Inherit;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-1886.28,462.3752;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;103;-877.4845,185.8566;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;16;-1963.848,-104.6079;Float;False;Property;_trail_speed;trail_speed;4;0;Create;True;0;0;False;0;-1,0;-1.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2658.361,-200.9455;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;43;-684.3229,-883.1247;Inherit;False;1112.999;818.915;컬러 lerp,mask;5;33;30;31;107;108;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-465.5888,345.2018;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;7;-1701.325,-168.3241;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1517.54,255.4532;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-671.7956,-132.4766;Float;False;Property;_lerp_power;lerp_power;10;0;Create;True;0;0;False;0;0.7745354;0.1647059;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1340.866,12.87288;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-239.3866,268.8506;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1419.254,-271.2008;Float;True;Property;_Trail_Tex;Trail_Tex;2;0;Create;True;0;0;False;0;None;8150f6f43f753a142bcf05fc6eb8f621;False;gray;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;1;-732.6082,11.65009;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;6e6cba53deb4f4e41a81667b73a1ca42;120ede8c4897abf488ebbcd0d0b46ede;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;102;-19.03979,260.9212;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-216.0194,-194.1881;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-502.4373,-667.9046;Float;False;Property;_trail_color1;trail_color1;0;0;Create;True;0;0;False;0;0.5424528,1,0.9571615,0;0.1556604,0.5955684,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;108;196.8256,-219.6964;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-458.2463,-420.8875;Float;False;Property;_trail_color2;trail_color2;1;1;[HDR];Create;True;0;0;False;0;0.7286931,0.6839622,1,0;1.498039,0.3529412,1.160784,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;96;100.6836,146.0766;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;600.3439,-343.0555;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;105;586.9489,22.65002;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;109;744.4585,-137.4512;Inherit;False;Property;_Emission;Emission;11;0;Create;True;0;0;False;0;0;3.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;93;904.7894,160.2121;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;1109.3,103.6144;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;918.2482,-290.9084;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1265.144,-252.4081;Float;False;True;3;ASEMaterialInspector;0;0;Unlit;Trail;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;0;110;0
WireConnection;89;0;48;0
WireConnection;89;1;110;1
WireConnection;12;0;59;0
WireConnection;12;2;14;0
WireConnection;12;1;94;2
WireConnection;49;0;89;0
WireConnection;49;1;28;0
WireConnection;97;1;12;0
WireConnection;9;0;15;0
WireConnection;9;1;12;0
WireConnection;103;0;89;0
WireConnection;2;0;47;0
WireConnection;104;0;103;0
WireConnection;104;1;97;0
WireConnection;7;0;2;0
WireConnection;7;2;16;0
WireConnection;7;1;94;2
WireConnection;10;0;49;0
WireConnection;10;1;9;0
WireConnection;3;0;7;0
WireConnection;3;1;10;0
WireConnection;101;0;103;0
WireConnection;101;1;104;0
WireConnection;1;0;18;0
WireConnection;1;1;3;0
WireConnection;102;0;101;0
WireConnection;107;0;89;0
WireConnection;107;1;33;0
WireConnection;108;0;107;0
WireConnection;96;0;1;0
WireConnection;96;1;102;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;32;2;108;0
WireConnection;93;0;96;0
WireConnection;106;0;105;4
WireConnection;106;1;93;0
WireConnection;29;0;32;0
WireConnection;29;1;109;0
WireConnection;29;2;105;0
WireConnection;0;2;29;0
WireConnection;0;9;106;0
ASEEND*/
//CHKSM=B11D028537391DC78D3B11D97D779710B390D7D1