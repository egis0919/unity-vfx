// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Slime"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_Color1("Color 1", Color) = (0.2862746,0.9430392,1,0)
		[HDR]_Color2("Color 2", Color) = (1,0.5527574,0.2862746,0)
		_dis_Tex1("dis_Tex1", 2D) = "white" {}
		_Tex_Tile1("Tex_Tile1", Vector) = (1,3,0,0)
		_Tex_Speed("Tex_Speed", Vector) = (-0.3,0,0,0)
		_dis_Tex2("dis_Tex2", 2D) = "white" {}
		_cos_power("cos_power", Float) = 1.2
		_Tex_Speed2("Tex_Speed2", Vector) = (-0.3,0,0,0)
		_dis_Tex3("dis_Tex3", 2D) = "white" {}
		_Tex_Tile2("Tex_Tile2", Vector) = (1,3,0,0)
		_Tex_Speed3("Tex_Speed3", Vector) = (-0.3,0,0,0)
		_dis_Tex4("dis_Tex4", 2D) = "white" {}
		_Tex_Speed4("Tex_Speed4", Vector) = (-0.3,0,0,0)
		_cos_power2("cos_power2", Float) = 1.2
		_ColorTex("ColorTex", 2D) = "white" {}
		_Color_dis_Tile("Color_dis_Tile", Vector) = (1,3,0,0)
		_Color_dis_Speed("Color_dis_Speed", Vector) = (-0.3,0,0,0)
		_lerp_power("lerp_power", Float) = -0.36
		_Mask_Power("Mask_Power", Float) = 0.45
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
		};

		uniform float4 _Color2;
		uniform float4 _Color1;
		uniform sampler2D _ColorTex;
		uniform float2 _Color_dis_Speed;
		uniform float2 _Color_dis_Tile;
		uniform sampler2D _dis_Tex1;
		uniform float _cos_power;
		uniform float2 _Tex_Speed;
		uniform float2 _Tex_Tile1;
		uniform sampler2D _dis_Tex2;
		uniform float2 _Tex_Speed2;
		uniform sampler2D _dis_Tex3;
		uniform float _cos_power2;
		uniform float2 _Tex_Speed3;
		uniform float2 _Tex_Tile2;
		uniform sampler2D _dis_Tex4;
		uniform float2 _Tex_Speed4;
		uniform float _Mask_Power;
		uniform float _lerp_power;
		uniform sampler2D _MainTex;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord116 = i.uv_texcoord * _Color_dis_Tile;
			float2 panner118 = ( 1.0 * _Time.y * _Color_dis_Speed + uv_TexCoord116);
			float2 uv_TexCoord93 = i.uv_texcoord * _Tex_Tile1;
			float2 panner96 = ( ( _CosTime.w * _cos_power ) * _Tex_Speed + uv_TexCoord93);
			float2 panner131 = ( 1.0 * _Time.y * _Tex_Speed2 + uv_TexCoord93);
			float temp_output_148_0 = ( _CosTime.w * _cos_power2 );
			float2 uv_TexCoord104 = i.uv_texcoord * _Tex_Tile2;
			float2 panner126 = ( temp_output_148_0 * _Tex_Speed3 + uv_TexCoord104);
			float2 panner105 = ( temp_output_148_0 * _Tex_Speed4 + uv_TexCoord104);
			// * tex2D( _dis_Tex3, panner126 ) * tex2D( _dis_Tex4, panner105 )
			float4 temp_output_100_0 = ( tex2D( _dis_Tex1, panner96 ) * tex2D( _dis_Tex2, panner131 ) * _Mask_Power );
			float4 temp_output_147_0 = ( 1.0 - temp_output_100_0 );
			float4 lerpResult108 = lerp( _Color2 , _Color1 , ( ( ( ( tex2D( _ColorTex, ( ( panner118 + float2( 0,0 ) ) * 0.52 ) ) * uv_TexCoord116.x * temp_output_147_0 ) + 0.0 ) * 2.0 ) * _lerp_power ));
			o.Emission = lerpResult108.rgb;
			o.Alpha = max( tex2D( _MainTex, ( float4( uv_TexCoord93, 0.0 , 0.0 ) + temp_output_100_0 ).rg ) , temp_output_147_0 ).r;
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
290;335;1157;475;3994.953;1298.416;4.981531;True;False
Node;AmplifyShaderEditor.Vector2Node;117;-1655.372,-461.7686;Float;False;Property;_Color_dis_Tile;Color_dis_Tile;16;0;Create;True;0;0;False;0;1,3;0.75,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CosTime;122;-2186.326,433.9983;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;149;-2185.467,659.4656;Float;False;Property;_cos_power2;cos_power2;14;0;Create;True;0;0;False;0;1.2;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;102;-2346.763,50.19056;Float;False;Property;_Tex_Tile1;Tex_Tile1;4;0;Create;True;0;0;False;0;1,3;0.86,1.7;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;129;-2112.51,322.1977;Float;False;Property;_cos_power;cos_power;7;0;Create;True;0;0;False;0;1.2;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;136;-2438.498,791.6934;Float;False;Property;_Tex_Tile2;Tex_Tile2;10;0;Create;True;0;0;False;0;1,3;0.8,3.4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;132;-1749.872,373.5996;Float;False;Property;_Tex_Speed2;Tex_Speed2;8;0;Create;True;0;0;False;0;-0.3,0;0,0.19;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-1941.771,256.6914;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-2010.002,795.2864;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;121;-1852.62,915.912;Float;False;Property;_Tex_Speed4;Tex_Speed4;13;0;Create;True;0;0;False;0;-0.3,0;0,-0.15;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;125;-1845.682,601.9208;Float;False;Property;_Tex_Speed3;Tex_Speed3;11;0;Create;True;0;0;False;0;-0.3,0;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;99;-1706.229,122.359;Float;False;Property;_Tex_Speed;Tex_Speed;5;0;Create;True;0;0;False;0;-0.3,0;0,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;119;-1385.708,-285.0157;Float;False;Property;_Color_dis_Speed;Color_dis_Speed;17;0;Create;True;0;0;False;0;-0.3,0;-0.12,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-1982.474,40.47556;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;-1992.629,662.5265;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-1360.437,-471.5327;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;131;-1469.177,269.0463;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;96;-1468.204,69.95615;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;126;-1604.681,598.8088;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.3,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;105;-1606.323,877.9579;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.3,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;118;-1034.592,-508.897;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-849.3054,587.0917;Float;False;Property;_Mask_Power;Mask_Power;19;0;Create;True;0;0;False;0;0.45;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;-1248.464,780.3362;Float;True;Property;_dis_Tex4;dis_Tex4;12;0;Create;True;0;0;False;0;None;853d27a7602f44b43a34cd757272f5f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;130;-1229,315.8164;Float;True;Property;_dis_Tex2;dis_Tex2;6;0;Create;True;0;0;False;0;None;bf79b7c730c5ec448a366d524be72180;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;113;-763.7951,-545.0269;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-681.8826,-251.9447;Float;False;Constant;_dis_Power;dis_Power;9;0;Create;True;0;0;False;0;0.52;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;127;-1249.573,543.5704;Float;True;Property;_dis_Tex3;dis_Tex3;9;0;Create;True;0;0;False;0;None;853d27a7602f44b43a34cd757272f5f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;97;-1199.586,94.10495;Float;True;Property;_dis_Tex1;dis_Tex1;3;0;Create;True;0;0;False;0;None;bf79b7c730c5ec448a366d524be72180;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-522.5042,-507.5895;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-787.7279,254.7486;Float;True;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;147;-456.203,246.3879;Float;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;110;-385.3319,-435.0048;Float;True;Property;_ColorTex;ColorTex;15;0;Create;True;0;0;False;0;None;55190433fa6a8b942ad179dcc3ace216;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-8.515915,-432.3297;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-834.6037,-43.94898;Float;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;112;325.4995,-165.3456;Float;False;Property;_lerp_power;lerp_power;18;0;Create;True;0;0;False;0;-0.36;1.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;120;225.4673,-385.3122;Float;True;ConstantBiasScale;-1;;5;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;89;-475.8854,-75.38925;Float;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;None;0777ecfa8cc97cc4ab643f6491b61798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;553.9638,-335.1796;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;92;425.307,-547.2633;Float;False;Property;_Color1;Color 1;1;1;[HDR];Create;True;0;0;False;0;0.2862746,0.9430392,1,0;0.003826994,0.4230469,0.8113208,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;106;431.2059,-720.8236;Float;False;Property;_Color2;Color 2;2;1;[HDR];Create;True;0;0;False;0;1,0.5527574,0.2862746,0;0.08490568,0.0004004995,0.07515509,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;146;106.304,-12.63564;Float;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;108;772.0057,-463.5038;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;88;1076.624,-230.7213;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Slime;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;128;0;122;4
WireConnection;128;1;129;0
WireConnection;104;0;136;0
WireConnection;93;0;102;0
WireConnection;148;0;122;4
WireConnection;148;1;149;0
WireConnection;116;0;117;0
WireConnection;131;0;93;0
WireConnection;131;2;132;0
WireConnection;96;0;93;0
WireConnection;96;2;99;0
WireConnection;96;1;128;0
WireConnection;126;0;104;0
WireConnection;126;2;125;0
WireConnection;126;1;148;0
WireConnection;105;0;104;0
WireConnection;105;2;121;0
WireConnection;105;1;148;0
WireConnection;118;0;116;0
WireConnection;118;2;119;0
WireConnection;103;1;105;0
WireConnection;130;1;131;0
WireConnection;113;0;118;0
WireConnection;127;1;126;0
WireConnection;97;1;96;0
WireConnection;115;0;113;0
WireConnection;115;1;114;0
WireConnection;100;0;97;0
WireConnection;100;1;130;0
WireConnection;100;2;127;0
WireConnection;100;3;103;0
WireConnection;100;4;101;0
WireConnection;147;0;100;0
WireConnection;110;1;115;0
WireConnection;138;0;110;0
WireConnection;138;1;116;1
WireConnection;138;2;147;0
WireConnection;95;0;93;0
WireConnection;95;1;100;0
WireConnection;120;3;138;0
WireConnection;89;1;95;0
WireConnection;111;0;120;0
WireConnection;111;1;112;0
WireConnection;146;0;89;0
WireConnection;146;1;147;0
WireConnection;108;0;106;0
WireConnection;108;1;92;0
WireConnection;108;2;111;0
WireConnection;88;2;108;0
WireConnection;88;9;146;0
ASEEND*/
//CHKSM=376AA8251646019A4712A4DBA8A366C112D6844C