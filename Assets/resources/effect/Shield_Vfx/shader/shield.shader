// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "shield_camera"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Float2("Float 2", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float4 vertexColor : COLOR;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _Texture0;
		uniform float _Float2;
		uniform float4 _Color0;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult45 = (float2(10.0 , 5.0));
			float2 uv_TexCoord49 = i.uv_texcoord * appendResult45;
			float temp_output_39_0 = pow( distance( i.uv_texcoord , float2( 0.5,0.5 ) ) , i.uv2_texcoord2.y );
			float temp_output_52_0 = pow( temp_output_39_0 , 5.0 );
			float4 tex2DNode34 = tex2D( _Texture0, ( uv_TexCoord49 + ( temp_output_52_0 * _Float2 ) ) );
			float4 screenColor1 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + ( tex2DNode34 * temp_output_52_0 ) ).xy);
			o.Emission = ( max( screenColor1 , ( tex2DNode34 * _Color0 * temp_output_39_0 ) ) * i.vertexColor ).rgb;
			o.Alpha = i.vertexColor.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float4 screenPos : TEXCOORD3;
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
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
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
87;781;1906;975;2728.351;563.4064;3.438808;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1916.2,730.1922;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;38;-1448.095,811.3611;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1878.302,1021.697;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;47;-1941.906,270.2101;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1896.845,149.5124;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;39;-1332.866,804.7632;Float;True;2;0;FLOAT;0;False;1;FLOAT;3.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1170.077,497.502;Float;False;Property;_Float2;Float 2;2;0;Create;True;0;0;False;0;0.1;1.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;52;-1138.841,604.9391;Float;True;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-1632.92,146.2937;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1007.136,374.8088;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;49;-1362.282,363.4248;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;28;-1342.931,-272.7032;Float;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;None;5798ded558355430c8a9b13ee12a847c;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1045.611,110.6283;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;34;-856.1626,-20.31033;Float;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;df1a73877e6e817489bcdec99d204d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;15;-1028.789,-274.4823;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-510.3198,-6.319458;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-644.8179,-154.6279;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;36;-677.9736,185.5948;Float;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.043137,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;1;-514,-218;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-294.2782,78.71924;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;41;-127.0645,145.8259;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;44;-83.54368,13.99382;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;67.93555,0.8258972;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;238,-38;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;New Amplify Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;24;0
WireConnection;39;0;38;0
WireConnection;39;1;43;2
WireConnection;52;0;39;0
WireConnection;45;0;46;0
WireConnection;45;1;47;0
WireConnection;53;0;52;0
WireConnection;53;1;54;0
WireConnection;49;0;45;0
WireConnection;48;0;49;0
WireConnection;48;1;53;0
WireConnection;34;0;28;0
WireConnection;34;1;48;0
WireConnection;57;0;34;0
WireConnection;57;1;52;0
WireConnection;56;0;15;0
WireConnection;56;1;57;0
WireConnection;1;0;56;0
WireConnection;16;0;34;0
WireConnection;16;1;36;0
WireConnection;16;2;39;0
WireConnection;44;0;1;0
WireConnection;44;1;16;0
WireConnection;42;0;44;0
WireConnection;42;1;41;0
WireConnection;0;2;42;0
WireConnection;0;9;41;4
ASEEND*/
//CHKSM=09CCD0A0AF64C1951235A80C0DBF5E185F75C8D4