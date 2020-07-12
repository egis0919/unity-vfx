// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Light"
{
	Properties
	{
		[HDR]_Color0("Color 0", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Overlay+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord1 = i.uv_texcoord + float2( 0.49,0 );
			float2 uv_TexCoord35 = i.uv_texcoord + float2( -0.34,0 );
			float4 temp_output_20_0 = ( ( ( 1.0 - uv_TexCoord1.x ) + 0.73 ) * i.vertexColor * saturate( ( ( ( ( (0.0 + (( uv_TexCoord1.x * uv_TexCoord1.y ) - 0.1) * (1.0 - 0.0) / (1.0 - 0.1)) * (0.0 + (( uv_TexCoord1.x * ( 1.0 - uv_TexCoord1.y ) ) - 0.1) * (1.0 - 0.0) / (1.0 - 0.1)) * ( (0.0 + (( uv_TexCoord35.y * ( 1.0 - uv_TexCoord35.x ) ) - 0.05) * (1.0 - 0.0) / (1.0 - 0.05)) * (0.0 + (( ( 1.0 - uv_TexCoord35.x ) * ( 1.0 - uv_TexCoord35.y ) ) - 0.05) * (1.0 - 0.0) / (1.0 - 0.05)) ) ) + -0.01 ) * 38.64 ) * 1.5 ) ) );
			o.Emission = ( _Color0 * temp_output_20_0 ).rgb;
			o.Alpha = temp_output_20_0.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 

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
Version=16900
256;50;1031;969;2461.012;1003.425;3.306652;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-2575.396,-493.6659;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.34,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;31;-2015.271,-106.4347;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2531.428,137.3974;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0.49,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;-2042.905,-254.97;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-2182.804,-372.4165;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1849.866,-516.0111;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2;-2121.565,350.4908;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1832.809,-189.8268;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1808.731,293.9738;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1817.861,40.57764;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;27;-1573.118,-546.8592;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;-1567.938,-337.8734;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;5;-1474.74,338.7448;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1203.164,-276.4429;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;6;-1539.503,-105.3145;Float;True;5;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1133.242,143.8697;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-861.1837,129.5104;Float;True;ConstantBiasScale;-1;;14;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-0.01;False;2;FLOAT;38.64;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-823.5114,402.2899;Float;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;1.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-614.0299,210.2899;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;38;-1540.709,888.0442;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1346.422,995.3369;Float;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;0.73;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;19;-531.0992,-267.5331;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1094.14,856.1463;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;9;-355.7896,197.9222;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-74.42459,162.7472;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-560.9667,-85.43895;Float;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;False;0;1,1,1,0;5.992157,5.992157,5.992157,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;120.4481,-16.25064;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;317.0022,-43.70959;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Light;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Overlay;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;5;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;35;1
WireConnection;30;0;35;2
WireConnection;29;0;35;1
WireConnection;26;0;35;2
WireConnection;26;1;29;0
WireConnection;2;0;1;2
WireConnection;25;0;31;0
WireConnection;25;1;30;0
WireConnection;3;0;1;1
WireConnection;3;1;2;0
WireConnection;4;0;1;1
WireConnection;4;1;1;2
WireConnection;27;0;26;0
WireConnection;33;0;25;0
WireConnection;5;0;3;0
WireConnection;34;0;27;0
WireConnection;34;1;33;0
WireConnection;6;0;4;0
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;7;2;34;0
WireConnection;8;3;7;0
WireConnection;36;0;8;0
WireConnection;36;1;37;0
WireConnection;38;0;1;1
WireConnection;43;0;38;0
WireConnection;43;1;44;0
WireConnection;9;0;36;0
WireConnection;20;0;43;0
WireConnection;20;1;19;0
WireConnection;20;2;9;0
WireConnection;46;0;18;0
WireConnection;46;1;20;0
WireConnection;11;2;46;0
WireConnection;11;9;20;0
ASEEND*/
//CHKSM=BB9892963AF89D516B80233D83765DE1CE2C705D