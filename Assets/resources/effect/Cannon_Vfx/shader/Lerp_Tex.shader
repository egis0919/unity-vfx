// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lerp_Tex"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (0.5254902,0.9100686,1,0)
		[HDR]_Color1("Color 1", Color) = (1,0.6547094,0.2877358,0)
		_MainTex("MainTex", 2D) = "white" {}
		_Gr_Min("Gr_Min", Range( 0 , 1)) = 0.1
		_Gr_Max("Gr_Max", Range( 0 , 3)) = 0.1
		_Tex_min("Tex_min", Range( 0 , 1)) = 0.1
		_Tex_max("Tex_max", Range( 0 , 1)) = 0.1
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
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Gr_Min;
		uniform float _Gr_Max;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Tex_min;
		uniform float _Tex_max;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_26_0 = (0.0 + (i.uv_texcoord.x - _Gr_Min) * (1.0 - 0.0) / (_Gr_Max - _Gr_Min));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult4 = lerp( _Color0 , _Color1 , saturate( max( temp_output_26_0 , (0.0 + (( temp_output_26_0 * tex2DNode1.r ) - _Tex_min) * (1.0 - 0.0) / (_Tex_max - _Tex_min)) ) ));
			o.Emission = ( lerpResult4 * tex2DNode1 ).rgb;
			o.Alpha = tex2DNode1.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
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
Version=16900
255;341;1033;678;238.0457;995.5302;2.052958;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2054.893,-362.573;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-1669.919,-498.6553;Float;False;Property;_Gr_Min;Gr_Min;3;0;Create;True;0;0;False;0;0.1;0.3844453;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1671.449,-416.4789;Float;False;Property;_Gr_Max;Gr_Max;4;0;Create;True;0;0;False;0;0.1;1.29;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;26;-1371.016,-482.0911;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1344.888,-43.0215;Float;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;None;302e31ee1835c0b4d80dfb193f0bea0b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-990.4907,-254.9084;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-775.1176,-278.0609;Float;False;Property;_Tex_min;Tex_min;5;0;Create;True;0;0;False;0;0.1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-768.1659,-181.6024;Float;False;Property;_Tex_max;Tex_max;6;0;Create;True;0;0;False;0;0.1;0.434;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;30;-413.8793,-246.4501;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;32;-73.4157,-216.7431;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-201.2406,-591.3029;Float;False;Property;_Color0;Color 0;0;1;[HDR];Create;True;0;0;False;0;0.5254902,0.9100686,1,0;0.07490596,1.243798,2.268579,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-201.8697,-406.1804;Float;False;Property;_Color1;Color 1;1;1;[HDR];Create;True;0;0;False;0;1,0.6547094,0.2877358,0;1.498039,0.6745098,0.6039216,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;33;179.3383,-233.0673;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;366.7583,-416.82;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;770.8013,-223.936;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1058.377,-197.1605;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Lerp_Tex;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;26;0;22;1
WireConnection;26;1;25;0
WireConnection;26;2;27;0
WireConnection;34;0;26;0
WireConnection;34;1;1;1
WireConnection;30;0;34;0
WireConnection;30;1;29;0
WireConnection;30;2;28;0
WireConnection;32;0;26;0
WireConnection;32;1;30;0
WireConnection;33;0;32;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;33;0
WireConnection;6;0;4;0
WireConnection;6;1;1;0
WireConnection;0;2;6;0
WireConnection;0;9;1;0
ASEEND*/
//CHKSM=3AD120C214EED7545B58D2ECF3945822BC43C31E