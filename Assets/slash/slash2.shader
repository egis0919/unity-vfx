// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "slash2"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Emission("Emission", Float) = 0
		[Toggle]_is_cartoon("is_cartoon?", Float) = 0
		_Screen_dis_power("Screen_dis_power", Float) = 0
		[Toggle]_screen("screen", Float) = 0
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
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
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float4 uv2_tex4coord2;
			float2 uv_texcoord;
			float2 uv3_texcoord3;
			float4 screenPos;
		};

		uniform float _screen;
		uniform sampler2D _TextureSample0;
		uniform float _is_cartoon;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _Color0;
		uniform float _Emission;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Screen_dis_power;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 temp_cast_0 = (i.uv2_tex4coord2.z).xxxx;
			float4 temp_cast_1 = (( i.uv2_tex4coord2.z + i.uv2_tex4coord2.w )).xxxx;
			float temp_output_50_0 = (2.5 + (( 1.0 + i.uv2_tex4coord2.x ) - 0.0) * (1.0 - 2.5) / (1.0 - 0.0));
			float temp_output_55_0 = (1.0 + (saturate( i.uv2_tex4coord2.y ) - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
			float2 appendResult63 = (float2(( saturate( ( ( ( temp_output_50_0 * temp_output_50_0 * temp_output_50_0 * temp_output_50_0 * temp_output_50_0 ) * i.uv_texcoord.x ) - temp_output_55_0 ) ) * ( 1.0 / (1.0 + (temp_output_55_0 - 0.0) * (0.001 - 1.0) / (1.0 - 0.0)) ) ) , i.uv_texcoord.y));
			float4 smoothstepResult66 = smoothstep( temp_cast_0 , temp_cast_1 , tex2D( _TextureSample0, saturate( appendResult63 ) ));
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 tex2DNode84 = tex2D( _TextureSample1, uv_TextureSample1 );
			float4 temp_output_83_0 = ( i.uv3_texcoord3.x * tex2DNode84 );
			float4 temp_output_82_0 = floor( temp_output_83_0 );
			float4 temp_output_73_0 = saturate( ( smoothstepResult66 - saturate( lerp(temp_output_82_0,max( temp_output_82_0 , ( temp_output_83_0 / 2.0 ) ),_is_cartoon) ) ) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 screenColor92 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_screenPosNorm + ( tex2DNode84 * _Screen_dis_power ) ).xy);
			o.Emission = lerp(( i.vertexColor * temp_output_73_0 * _Color0 * _Emission ),screenColor92,_screen).rgb;
			o.Alpha = ( _Color0.a * i.vertexColor.a * temp_output_73_0 ).r;
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
				float4 customPack1 : TEXCOORD1;
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
				float4 screenPos : TEXCOORD4;
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
				o.customPack1.xyzw = customInputData.uv2_tex4coord2;
				o.customPack1.xyzw = v.texcoord1;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				o.customPack2.zw = customInputData.uv3_texcoord3;
				o.customPack2.zw = v.texcoord2;
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
				surfIN.uv2_tex4coord2 = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				surfIN.uv3_texcoord3 = IN.customPack2.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
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
975;164;1508;776;16.98139;785.9975;4.51352;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-1584.337,231.3118;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-1171.086,-300.0259;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-931.5752,-347.2499;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;2.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;-1075.815,71.10767;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-997.6583,136.1696;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-603.1627,-342.7176;Inherit;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-252.0633,-354.5823;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;55;-604.9964,34.23506;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;70.69386,-331.6141;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;-237.6232,24.59397;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;60;80.52588,-28.23712;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;84;-1239.93,692.1984;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;61;370.7842,-288.6313;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;77;-1559.229,548.9661;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;657.1843,-351.0313;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-677.3994,749.2507;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-577.4061,1015.98;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;990.7446,-114.3712;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;82;-396.8859,489.2658;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;87;-394.4061,845.9796;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;86;-165.8129,812.6978;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;64;1179.169,-123.3111;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;85;60.34229,724.4073;Inherit;False;Property;_is_cartoon;is_cartoon?;4;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;65;1440.01,-212.899;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;88fd7e38e0e3b8b4cbbe14a7d072dee2;8150f6f43f753a142bcf05fc6eb8f621;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;67;1440.468,185.47;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;81;869.0671,501.1239;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;66;1665.457,77.72979;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;95;99.02832,1121.86;Inherit;False;Property;_Screen_dis_power;Screen_dis_power;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;278.748,1003.116;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;91;314.4779,880.942;Inherit;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;79;1775.206,595.7994;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;74;1901.183,-353.7818;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;73;1960.244,-142.9429;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;72;2018.43,171.4436;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;93;866.1074,1162.952;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1993.602,-41.50915;Inherit;False;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;2213.183,-160.7818;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;92;1832.235,989.6542;Inherit;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;96;2635.182,-144.9417;Inherit;False;Property;_screen;screen;6;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;2554.402,213.313;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;103;2752.359,1339.741;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;2610.369,1579.87;Inherit;False;Property;_Float2;Float 2;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;1295.359,1530.636;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;2335.322,1521.789;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;2103.322,1704.789;Inherit;False;Property;_Float1;Float 1;7;0;Create;True;0;0;False;0;4;1.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;104;2035.322,1495.789;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;15.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;97;749.8703,1531.375;Inherit;False;6;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;100;1591.811,1504.024;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.04;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;99;1051.057,1635.309;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;110;2842.927,1512.99;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-0.14;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2905.387,-116.9533;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;slash2;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;1;46;1
WireConnection;50;0;48;0
WireConnection;56;0;46;2
WireConnection;52;0;50;0
WireConnection;52;1;50;0
WireConnection;52;2;50;0
WireConnection;52;3;50;0
WireConnection;52;4;50;0
WireConnection;53;0;52;0
WireConnection;53;1;47;1
WireConnection;55;0;56;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;58;0;55;0
WireConnection;60;1;58;0
WireConnection;61;0;54;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;83;0;77;1
WireConnection;83;1;84;0
WireConnection;63;0;62;0
WireConnection;63;1;47;2
WireConnection;82;0;83;0
WireConnection;87;0;83;0
WireConnection;87;1;90;0
WireConnection;86;0;82;0
WireConnection;86;1;87;0
WireConnection;64;0;63;0
WireConnection;85;0;82;0
WireConnection;85;1;86;0
WireConnection;65;1;64;0
WireConnection;67;0;46;3
WireConnection;67;1;46;4
WireConnection;81;0;85;0
WireConnection;66;0;65;0
WireConnection;66;1;46;3
WireConnection;66;2;67;0
WireConnection;94;0;84;0
WireConnection;94;1;95;0
WireConnection;79;0;66;0
WireConnection;79;1;81;0
WireConnection;73;0;79;0
WireConnection;93;0;91;0
WireConnection;93;1;94;0
WireConnection;71;0;72;0
WireConnection;71;1;73;0
WireConnection;71;2;74;0
WireConnection;71;3;76;0
WireConnection;92;0;93;0
WireConnection;96;0;71;0
WireConnection;96;1;92;0
WireConnection;75;0;74;4
WireConnection;75;1;72;4
WireConnection;75;2;73;0
WireConnection;103;0;110;0
WireConnection;98;0;97;2
WireConnection;98;1;99;0
WireConnection;105;0;104;0
WireConnection;105;1;106;0
WireConnection;104;0;100;0
WireConnection;100;0;98;0
WireConnection;99;0;97;2
WireConnection;110;0;105;0
WireConnection;110;1;111;0
WireConnection;0;2;96;0
WireConnection;0;9;75;0
ASEEND*/
//CHKSM=6F36484862517D222DF943221A97B664094C0804