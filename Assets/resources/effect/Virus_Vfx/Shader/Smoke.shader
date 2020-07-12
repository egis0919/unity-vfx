// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Smoke"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "gray" {}
		_Tex_tile("Tex_tile", Vector) = (1,1,0,0)
		_Tex_Speed("Tex_Speed", Vector) = (-1,0,0,0)
		_Tex_Bias("Tex_Bias", Float) = -0.1
		_Tex_Scale("Tex_Scale", Float) = 5
		_Mask_Scale("Mask_Scale", Float) = 2.1
		_dis_tex("dis_tex", 2D) = "white" {}
		_Main_dis_Speed("Main_dis_Speed", Vector) = (-0.5,0,0,0)
		_dis_Power("dis_Power", Float) = 0.15
		_Color_dis("Color_dis", 2D) = "white" {}
		_Color_tile("Color_tile", Vector) = (1,1,0,0)
		_Color_dis_Speed("Color_dis_Speed", Vector) = (-0.5,0,0,0)
		_Color_Mask_Power("Color_Mask_Power", Float) = 1.03
		_Color_dis_Bias("Color_dis_Bias", Float) = -0.25
		_Color_dis_Scale("Color_dis_Scale", Float) = 1
		_color_mask("color_mask", 2D) = "white" {}
		_Mix_Power("Mix_Power", Range( 0 , 1)) = 0.7745354
		[HDR]_Tex_Color1("Tex_Color1", Color) = (0.5424528,1,0.9571615,0)
		[HDR]_Tex_Color2("Tex_Color2", Color) = (0.7286931,0.6839622,1,0)
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
		};

		uniform sampler2D _MainTex;
		uniform float2 _Tex_Speed;
		uniform float2 _Tex_tile;
		uniform float _dis_Power;
		uniform sampler2D _dis_tex;
		uniform float2 _Main_dis_Speed;
		uniform float _Tex_Bias;
		uniform float _Tex_Scale;
		uniform sampler2D _color_mask;
		uniform float2 _Color_tile;
		uniform sampler2D _Color_dis;
		uniform float2 _Color_dis_Speed;
		uniform float _Color_Mask_Power;
		uniform float _Color_dis_Bias;
		uniform float _Color_dis_Scale;
		uniform float _Mask_Scale;
		uniform float4 _Tex_Color2;
		uniform float4 _Tex_Color1;
		uniform float _Mix_Power;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord2 = i.uv_texcoord * _Tex_tile;
			float2 panner7 = ( 1.0 * _Time.y * _Tex_Speed + uv_TexCoord2);
			float2 panner12 = ( 1.0 * _Time.y * _Main_dis_Speed + i.uv_texcoord);
			float2 uv_TexCoord66 = i.uv_texcoord * _Color_tile;
			float2 panner62 = ( 1.0 * _Time.y * _Color_dis_Speed + uv_TexCoord66);
			float4 tex2DNode36 = tex2D( _color_mask, ( float4( uv_TexCoord66, 0.0 , 0.0 ) + ( ( ( tex2D( _Color_dis, panner62 ) * ( uv_TexCoord66.x * _Color_Mask_Power ) ) + _Color_dis_Bias ) * _Color_dis_Scale ) ).rg );
			float4 temp_output_19_0 = ( ( ( tex2D( _MainTex, ( float4( panner7, 0.0 , 0.0 ) + ( ( ( 1.0 - uv_TexCoord2.x ) * _dis_Power ) * tex2D( _dis_tex, panner12 ) ) ).rg ) + _Tex_Bias ) * _Tex_Scale ) * ( ( ( 1.0 - tex2DNode36 ) + -0.07 ) * _Mask_Scale ) );
			float4 lerpResult32 = lerp( _Tex_Color1 , _Tex_Color2 , _Mix_Power);
			float4 temp_output_29_0 = ( temp_output_19_0 * ( ( tex2DNode36 * _Tex_Color2 ) + ( ( 1.0 - ( ( tex2DNode36 + -0.3 ) * 2.0 ) ) * _Tex_Color1 ) ) * lerpResult32 );
			o.Albedo = temp_output_29_0.rgb;
			o.Emission = temp_output_29_0.rgb;
			o.Alpha = temp_output_19_0.r;
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
290;335;1157;475;706.7648;-11.52551;1;True;False
Node;AmplifyShaderEditor.Vector2Node;71;-2834.651,-1132.949;Float;False;Property;_Color_tile;Color_tile;10;0;Create;True;0;0;False;0;1,1;1,2.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;63;-2239.902,-1246.8;Float;False;Property;_Color_dis_Speed;Color_dis_Speed;11;0;Create;True;0;0;False;0;-0.5,0;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-2553.055,-1135.61;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;60;-2074.369,-1499.486;Float;True;Property;_Color_dis;Color_dis;9;0;Create;True;0;0;False;0;None;cdeac6f84093f7a4aad78514aa3d26ad;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-2205.157,-908.4682;Float;False;Property;_Color_Mask_Power;Color_Mask_Power;12;0;Create;True;0;0;False;0;1.03;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;42;-2745.804,-321.2008;Float;False;1978.558;940.9442;uv스크롤;16;16;7;15;9;12;28;10;3;18;2;1;59;49;48;47;14;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;62;-2004,-1278.542;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;47;-2712.906,-190.7007;Float;False;Property;_Tex_tile;Tex_tile;1;0;Create;True;0;0;False;0;1,1;1,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;61;-1774.813,-1330.885;Float;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;d52fdb9362ac68b4f9a4bafc3919f1c4;d52fdb9362ac68b4f9a4bafc3919f1c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1835.75,-1027.167;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1488.594,-845.0787;Float;False;Property;_Color_dis_Bias;Color_dis_Bias;13;0;Create;True;0;0;False;0;-0.25;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2483.096,-200.9455;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1457.156,-1135.885;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;14;-2621.808,484.3011;Float;False;Property;_Main_dis_Speed;Main_dis_Speed;7;0;Create;True;0;0;False;0;-0.5,0;0.3,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;59;-2699.006,191.4594;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-1480.239,-744.5481;Float;False;Property;_Color_dis_Scale;Color_dis_Scale;14;0;Create;True;0;0;False;0;1;1.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;78;-1163.95,-1027.824;Float;True;ConstantBiasScale;-1;;6;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;48;-2169.562,-26.74982;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-2333.435,259.0012;Float;True;Property;_dis_tex;dis_tex;6;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;12;-2295.473,484.4763;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1972.622,131.3143;Float;False;Property;_dis_Power;dis_Power;8;0;Create;True;0;0;False;0;0.15;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-763.4247,-1104.628;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1722.782,40.22281;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;43;-678.0001,-829.4278;Float;False;1112.999;818.915;컬러 lerp,mask;9;33;32;39;30;31;36;37;86;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;16;-1967.085,-132.1184;Float;False;Property;_Tex_Speed;Tex_Speed;2;0;Create;True;0;0;False;0;-1,0;0.25,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;9;-1933.649,356.1466;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;d52fdb9362ac68b4f9a4bafc3919f1c4;d52fdb9362ac68b4f9a4bafc3919f1c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1515.278,293.0965;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;36;-421.6443,-753.8026;Float;True;Property;_color_mask;color_mask;15;0;Create;True;0;0;False;0;None;0777ecfa8cc97cc4ab643f6491b61798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-1701.325,-168.3241;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;86;10.30486,-762.1559;Float;True;ConstantBiasScale;-1;;11;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;-0.3;False;2;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1419.254,-271.2008;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;578b893799655a044b7a654d2445e849;False;gray;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1365.866,0.8728828;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;30;-640.3832,-362.0953;Float;False;Property;_Tex_Color2;Tex_Color2;18;1;[HDR];Create;True;0;0;False;0;0.7286931,0.6839622,1,0;0,0.9404348,1.498039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1137.82,-35.21118;Float;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;6e6cba53deb4f4e41a81667b73a1ca42;120ede8c4897abf488ebbcd0d0b46ede;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;37;290.0331,-715.9108;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-211.1157,403.1765;Float;False;Property;_Mask_Scale;Mask_Scale;5;0;Create;True;0;0;False;0;2.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-688.4277,387.4808;Float;False;Property;_Tex_Scale;Tex_Scale;4;0;Create;True;0;0;False;0;5;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-683.9742,70.77136;Float;False;Property;_Tex_Bias;Tex_Bias;3;0;Create;True;0;0;False;0;-0.1;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;77;-83.71828,-383.0909;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;31;-472.3948,-535.373;Float;False;Property;_Tex_Color1;Tex_Color1;17;1;[HDR];Create;True;0;0;False;0;0.5424528,1,0.9571615,0;0,0.04937766,0.08490568,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;120.1539,-352.4965;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;485.3684,-362.5356;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;73;102.5965,152.8468;Float;True;ConstantBiasScale;-1;;12;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;-0.07;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;56;-446.6275,-31.08548;Float;True;ConstantBiasScale;-1;;13;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-612.2687,-127.3868;Float;False;Property;_Mix_Power;Mix_Power;16;0;Create;True;0;0;False;0;0.7745354;0.74;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;397.2142,95.72961;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;811.0846,-356.8442;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;-228.7919,-151.0228;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;1161.928,-253.5561;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1696.463,-211.3179;Float;False;True;3;Float;ASEMaterialInspector;0;0;Standard;Smoke;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;66;0;71;0
WireConnection;62;0;66;0
WireConnection;62;2;63;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;64;0;66;1
WireConnection;64;1;68;0
WireConnection;2;0;47;0
WireConnection;67;0;61;0
WireConnection;67;1;64;0
WireConnection;78;3;67;0
WireConnection;78;1;79;0
WireConnection;78;2;80;0
WireConnection;48;0;2;1
WireConnection;12;0;59;0
WireConnection;12;2;14;0
WireConnection;70;0;66;0
WireConnection;70;1;78;0
WireConnection;49;0;48;0
WireConnection;49;1;28;0
WireConnection;9;0;15;0
WireConnection;9;1;12;0
WireConnection;10;0;49;0
WireConnection;10;1;9;0
WireConnection;36;1;70;0
WireConnection;7;0;2;0
WireConnection;7;2;16;0
WireConnection;86;3;36;0
WireConnection;3;0;7;0
WireConnection;3;1;10;0
WireConnection;1;0;18;0
WireConnection;1;1;3;0
WireConnection;37;0;86;0
WireConnection;77;0;36;0
WireConnection;39;0;36;0
WireConnection;39;1;30;0
WireConnection;38;0;37;0
WireConnection;38;1;31;0
WireConnection;73;3;77;0
WireConnection;73;2;75;0
WireConnection;56;3;1;0
WireConnection;56;1;58;0
WireConnection;56;2;57;0
WireConnection;19;0;56;0
WireConnection;19;1;73;0
WireConnection;40;0;39;0
WireConnection;40;1;38;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;32;2;33;0
WireConnection;29;0;19;0
WireConnection;29;1;40;0
WireConnection;29;2;32;0
WireConnection;0;0;29;0
WireConnection;0;2;29;0
WireConnection;0;9;19;0
ASEEND*/
//CHKSM=6DD0135D99E52BCEA1075627E36001C8BA48364E