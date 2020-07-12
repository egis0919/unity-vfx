// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Range"
{
	Properties
	{
		_Texture0("Texture 0", 2D) = "white" {}
		_power("power", Float) = -0.09
		_Float0("Float 0", Float) = -0.09
		_speed_x("speed_x", Float) = 0
		_tile_x("tile_x", Float) = 0
		_speed_y("speed_y", Float) = 0
		_tile_y("tile_y", Float) = 0
		_opacity("opacity", Float) = 0
		_Opacity2("Opacity2", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		_Mask_power("Mask_power", Float) = 2.07
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
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _Texture0;
		uniform sampler2D _Sampler602;
		uniform float _tile_x;
		uniform float _tile_y;
		uniform float _speed_x;
		uniform float _speed_y;
		uniform float _power;
		uniform float _Mask_power;
		uniform float _Float0;
		uniform float4 _MainTex_ST;
		uniform float _Opacity2;
		uniform float _opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_1_0_g4 = float2( 1,1 );
			float2 appendResult10_g4 = (float2(( (temp_output_1_0_g4).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g4).y )));
			float2 temp_output_11_0_g4 = float2( 1,0 );
			float2 panner18_g4 = ( ( (temp_output_11_0_g4).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g4 = ( ( _Time.y * (temp_output_11_0_g4).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g4 = (float2((panner18_g4).x , (panner19_g4).y));
			float2 appendResult44 = (float2(_tile_x , _tile_y));
			float2 appendResult40 = (float2(_speed_x , _speed_y));
			float2 temp_output_47_0_g4 = appendResult40;
			float2 temp_output_31_0_g4 = ( ( i.uv_texcoord / float2( 0.5,0.5 ) ) - float2( 1,1 ) );
			float2 appendResult39_g4 = (float2(frac( ( atan2( (temp_output_31_0_g4).x , (temp_output_31_0_g4).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g4 )));
			float2 panner54_g4 = ( ( (temp_output_47_0_g4).x * _Time.y ) * float2( 1,0 ) + appendResult39_g4);
			float2 panner55_g4 = ( ( _Time.y * (temp_output_47_0_g4).y ) * float2( 0,1 ) + appendResult39_g4);
			float2 appendResult58_g4 = (float2((panner54_g4).x , (panner55_g4).y));
			float2 temp_cast_1 = (ddx( i.uv_texcoord.x )).xx;
			float2 temp_cast_2 = (ddy( i.uv_texcoord.y )).xx;
			float4 tex2DNode15 = tex2D( _Texture0, ( ( (tex2D( _Sampler602, ( appendResult10_g4 + appendResult24_g4 ) )).rg * 1.0 ) + ( appendResult44 * appendResult58_g4 ) ), temp_cast_1, temp_cast_2 );
			float temp_output_84_0 = distance( i.uv_texcoord , float2( 0.5,0.5 ) );
			float temp_output_85_0 = pow( temp_output_84_0 , _Mask_power );
			float4 tex2DNode1 = tex2D( _MainTex, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( tex2DNode15 * _power * temp_output_85_0 ) ).rg );
			float4 tex2DNode95 = tex2D( _MainTex, ( float4( i.uv_texcoord, 0.0 , 0.0 ) + ( tex2DNode15 * _Float0 * temp_output_85_0 ) ).rg );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode54 = tex2D( _MainTex, uv_MainTex );
			float4 temp_output_56_0 = ( i.vertexColor * saturate( ( max( tex2DNode1 , tex2DNode95 ) + tex2DNode54 ) ) * _Opacity2 );
			o.Albedo = temp_output_56_0.rgb;
			o.Emission = temp_output_56_0.rgb;
			o.Alpha = saturate( ( saturate( max( ( saturate( ( max( tex2DNode1 , tex2DNode95 ) + tex2DNode1 ) ) * _opacity ) , tex2DNode54 ) ) * pow( ( 1.0 - temp_output_84_0 ) , 3.01 ) ) ).r;
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
Version=17101
-1971;160;1906;987;430.5426;380.3787;1.675332;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-2161.194,313.8842;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;-1734.578,-189.4376;Float;False;Property;_tile_x;tile_x;4;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1715.911,0.2290344;Float;False;Property;_speed_x;speed_x;3;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1715.911,83.22903;Float;False;Property;_speed_y;speed_y;5;0;Create;True;0;0;False;0;0;-0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1734.578,-106.4376;Float;False;Property;_tile_y;tile_y;6;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-1533.911,30.22903;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;38;-1614.386,472.1251;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;-1565.578,-106.4376;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-901.3058,-74.20357;Float;True;Property;_Texture0;Texture 0;0;0;Create;True;0;0;False;0;e28dc97a9541e3642a48c0e3886688c5;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1303.868,699.8148;Float;False;Property;_Mask_power;Mask_power;10;0;Create;True;0;0;False;0;2.07;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2;-1369.044,-142.0084;Inherit;True;RadialUVDistortion;-1;;4;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler602;False;1;FLOAT2;1,1;False;11;FLOAT2;1,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdxOpNode;5;-958,164;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DdyOpNode;6;-996,249;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;84;-1623.282,624.9336;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-634.6468,126.1126;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;e28dc97a9541e3642a48c0e3886688c5;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-475.6255,522.9755;Float;False;Property;_power;power;1;0;Create;True;0;0;False;0;-0.09;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;85;-1040.803,590.6552;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-306.2032,740.0852;Float;False;Property;_Float0;Float 0;2;0;Create;True;0;0;False;0;-0.09;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;30.34778,786.6021;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;17.06744,510.8968;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;52;276.8093,535.0786;Float;True;Property;_MainTex;Main Tex;9;0;Create;True;0;0;False;0;None;6b58f139fc5d29740817d6afe34ac117;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;229.6297,299.2718;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;266.2997,725.2211;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;95;669.0984,772.3334;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;cccc116a6334dc1428687697c5a11d58;cccc116a6334dc1428687697c5a11d58;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;461.5972,279.6516;Inherit;True;Property;_Tex;Tex;0;0;Create;True;0;0;False;0;cccc116a6334dc1428687697c5a11d58;cccc116a6334dc1428687697c5a11d58;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;99;939.267,245.5162;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;1092.946,232.9376;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;51;1106.663,463.962;Float;False;Property;_opacity;opacity;7;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;105;1334.644,224.2715;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;54;584.1199,505.8708;Inherit;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;1462.018,218.6409;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;62;1521.791,241.4924;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;97;773.1331,-5.24696;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;100;-852.7239,1072.266;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;102;-500.1578,1086.033;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;3.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;1110.431,-7.418842;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;59;1680.806,208.5971;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1764.707,267.1206;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;29;1276.102,-225.5612;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;55;1404.064,-1.007019;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;63;1453.286,86.93354;Float;False;Property;_Opacity2;Opacity2;8;0;Create;True;0;0;False;0;0;2.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;101;2045.016,211.8565;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1947.827,-19.25676;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2269.935,-23.74761;Float;False;True;2;ASEMaterialInspector;0;0;Standard;Range;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;41;0
WireConnection;40;1;42;0
WireConnection;38;0;35;0
WireConnection;44;0;45;0
WireConnection;44;1;43;0
WireConnection;2;68;44;0
WireConnection;2;47;40;0
WireConnection;2;29;38;0
WireConnection;5;0;35;1
WireConnection;6;0;35;2
WireConnection;84;0;35;0
WireConnection;15;0;23;0
WireConnection;15;1;2;0
WireConnection;15;3;5;0
WireConnection;15;4;6;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;90;0;15;0
WireConnection;90;1;94;0
WireConnection;90;2;85;0
WireConnection;36;0;15;0
WireConnection;36;1;37;0
WireConnection;36;2;85;0
WireConnection;31;0;35;0
WireConnection;31;1;36;0
WireConnection;96;0;35;0
WireConnection;96;1;90;0
WireConnection;95;0;52;0
WireConnection;95;1;96;0
WireConnection;1;0;52;0
WireConnection;1;1;31;0
WireConnection;99;0;1;0
WireConnection;99;1;95;0
WireConnection;106;0;99;0
WireConnection;106;1;1;0
WireConnection;105;0;106;0
WireConnection;54;0;52;0
WireConnection;50;0;105;0
WireConnection;50;1;51;0
WireConnection;62;0;50;0
WireConnection;62;1;54;0
WireConnection;97;0;1;0
WireConnection;97;1;95;0
WireConnection;100;0;84;0
WireConnection;102;0;100;0
WireConnection;53;0;97;0
WireConnection;53;1;54;0
WireConnection;59;0;62;0
WireConnection;64;0;59;0
WireConnection;64;1;102;0
WireConnection;55;0;53;0
WireConnection;101;0;64;0
WireConnection;56;0;29;0
WireConnection;56;1;55;0
WireConnection;56;2;63;0
WireConnection;0;0;56;0
WireConnection;0;2;56;0
WireConnection;0;9;101;0
ASEEND*/
//CHKSM=7ED8A9050AF36D00660CCD198FD89FD5D8217139