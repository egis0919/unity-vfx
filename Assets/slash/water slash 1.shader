// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "water"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_LerpTex("LerpTex", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.002402996,0.3482848,0.509434,0)
		_Color3("Color 0", Color) = (0.002402996,0.3482848,0.509434,0)
		_Color2("Color 2", Color) = (0.002402996,0.3482848,0.509434,0)
		_Float2("Float 2", Float) = 8.96
		_Float18("Float 18", Float) = 8.96
		_Float11("Float 11", Float) = 0.18
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float14("Float 14", Float) = 2.86
		_Float17("Float 17", Float) = 2.86
		_Float28("Float 28", Float) = 2
		_Float34("Float 34", Float) = 0
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
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
			float2 uv_texcoord;
		};

		uniform float _Float28;
		uniform sampler2D _MainTex;
		uniform float _Float11;
		uniform sampler2D _TextureSample0;
		uniform float _Float2;
		uniform float4 _Color0;
		uniform float4 _Color3;
		uniform float4 _Color2;
		uniform sampler2D _TextureSample1;
		uniform sampler2D _LerpTex;
		uniform float _Float18;
		uniform float _Float17;
		uniform float _Float14;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float _Float34;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult309 = (float2(0.5 , 0.0));
			float2 uv_TexCoord357 = i.uv_texcoord * float2( 1.5,1 );
			float2 panner308 = ( _Time.y * appendResult309 + uv_TexCoord357);
			float2 appendResult301 = (float2(0.2 , 0.1));
			float2 panner304 = ( _Time.y * appendResult301 + i.uv_texcoord);
			float4 temp_output_297_0 = ( _Float11 * tex2D( _TextureSample0, panner304 ) );
			float4 tex2DNode220 = tex2D( _MainTex, ( float4( panner308, 0.0 , 0.0 ) + temp_output_297_0 ).rg );
			float temp_output_228_0 = saturate( pow( ( tex2DNode220.r * 2.08 ) , 3.07 ) );
			float temp_output_260_0 = saturate( ( ( saturate( pow( ( tex2DNode220.r * 6.78 ) , 4.94 ) ) - temp_output_228_0 ) * _Float2 ) );
			float4 lerpResult408 = lerp( _Color0 , _Color3 , saturate( max( pow( ( tex2DNode220.r * 1.0 ) , 4.42 ) , ( temp_output_228_0 * 0.4 ) ) ));
			float2 appendResult332 = (float2(0.8 , 0.0));
			float2 uv_TexCoord379 = i.uv_texcoord * float2( 1.5,1.15 );
			float2 panner333 = ( _Time.y * appendResult332 + uv_TexCoord379);
			float4 tex2DNode335 = tex2D( _TextureSample1, ( float4( panner333, 0.0 , 0.0 ) + temp_output_297_0 ).rg );
			float temp_output_328_0 = saturate( pow( ( tex2DNode335.r * 4.9 ) , 13.26 ) );
			float4 lerpResult349 = lerp( ( ( 1.0 - temp_output_260_0 ) * lerpResult408 ) , _Color2 , max( ( temp_output_328_0 * 0.55 ) , ( tex2DNode335.r * 1.88 ) ));
			float2 appendResult289 = (float2(1.0 , 0.1));
			float2 panner286 = ( _Time.y * appendResult289 + uv_TexCoord357);
			float4 tex2DNode243 = tex2D( _LerpTex, ( float4( panner286, 0.0 , 0.0 ) + temp_output_297_0 ).rg );
			float temp_output_269_0 = saturate( pow( ( tex2DNode243.r * 2.49 ) , 59.03 ) );
			float temp_output_317_0 = saturate( ( ( saturate( pow( ( tex2DNode335.r * 6.63 ) , 10.36 ) ) - temp_output_328_0 ) * _Float18 ) );
			float4 color314 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 temp_cast_6 = (max( saturate( pow( max( temp_output_317_0 , temp_output_328_0 ) , _Float17 ) ) , pow( max( temp_output_260_0 , temp_output_228_0 ) , _Float14 ) )).xxxx;
			float temp_output_368_0 = ( 1.0 - saturate( pow( ( i.uv_texcoord.x * ( 1.0 - i.uv_texcoord.x ) * 5.16 ) , 1.75 ) ) );
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 temp_cast_7 = (( ( tex2D( _TextureSample2, uv_TextureSample2 ).r + 0.05 ) * _Float34 )).xxxx;
			float4 temp_output_418_0 = ( ( temp_cast_6 - saturate( ( ( ( tex2DNode220 * temp_output_368_0 * tex2DNode335.r * 10.0 ) * temp_output_368_0 ) + temp_output_368_0 ) ) ) - temp_cast_7 );
			float4 temp_cast_8 = (19.01).xxxx;
			float4 temp_cast_9 = (max( saturate( pow( max( temp_output_317_0 , temp_output_328_0 ) , _Float17 ) ) , pow( max( temp_output_260_0 , temp_output_228_0 ) , _Float14 ) )).xxxx;
			float4 temp_cast_10 = (( ( tex2D( _TextureSample2, uv_TextureSample2 ).r + 0.05 ) * _Float34 )).xxxx;
			float4 temp_cast_11 = (1.27).xxxx;
			float4 temp_cast_12 = (20.42).xxxx;
			o.Emission = max( ( _Float28 * ( ( lerpResult349 * ( 1.0 - saturate( ( saturate( pow( ( tex2DNode243.r * 4.4 ) , 30.0 ) ) - temp_output_269_0 ) ) ) * ( 1.0 - temp_output_317_0 ) ) + ( color314 * temp_output_269_0 ) ) ) , saturate( pow( ( saturate( ( saturate( pow( ( temp_output_418_0 * 14.25 ) , temp_cast_8 ) ) - saturate( pow( ( 2.63 * temp_output_418_0 ) , temp_cast_11 ) ) ) ) * 10.0 ) , temp_cast_12 ) ) ).rgb;
			float4 temp_cast_14 = (max( saturate( pow( max( temp_output_317_0 , temp_output_328_0 ) , _Float17 ) ) , pow( max( temp_output_260_0 , temp_output_228_0 ) , _Float14 ) )).xxxx;
			float4 temp_cast_15 = (( ( tex2D( _TextureSample2, uv_TextureSample2 ).r + 0.05 ) * _Float34 )).xxxx;
			o.Alpha = saturate( temp_output_418_0 ).r;
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
Version=17101
0;54;1920;929;-5190.223;252.4226;1.834751;True;False
Node;AmplifyShaderEditor.RangedFloatNode;302;1689.345,1284.741;Inherit;False;Constant;_Float12;Float 12;6;0;Create;True;0;0;False;0;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;1692.346,1383.384;Inherit;False;Constant;_Float13;Float 13;6;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;294;2042.074,1052.651;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;359;1842.723,1231.174;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;301;2067.465,1307.164;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;330;1190.857,-899.1729;Inherit;False;Constant;_Float22;Float 22;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;304;2291.852,1188.95;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;329;1174.857,-995.1729;Inherit;False;Constant;_Float21;Float 21;6;0;Create;True;0;0;False;0;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;298;2575.618,1037.705;Inherit;False;Property;_Float11;Float 11;8;0;Create;True;0;0;False;0;0.18;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;379;1273.481,-1282.062;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1.15;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;296;2477.825,1159.972;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;False;0;None;55190433fa6a8b942ad179dcc3ace216;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;311;1046.784,93.16454;Inherit;False;Constant;_Float16;Float 16;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;1030.784,-2.83552;Inherit;False;Constant;_Float15;Float 15;6;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;332;1533.857,-979.1729;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;2743.003,1021.266;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;333;1785.857,-1058.173;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;309;1414.784,13.16448;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;357;807.0907,610.981;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;308;1638.784,-98.83552;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;334;2054.857,-1027.173;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;1910.784,-34.83552;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;336;2502.856,-963.1729;Inherit;False;Constant;_Float23;Float 23;3;0;Create;True;0;0;False;0;6.63;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;335;2182.857,-1075.173;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;8150f6f43f753a142bcf05fc6eb8f621;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;324;2393.256,-783.6954;Inherit;False;Constant;_Float19;Float 19;3;0;Create;True;0;0;False;0;4.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;220;2038.784,-82.83552;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;8150f6f43f753a142bcf05fc6eb8f621;82a8e66f31a9e654792bee0ab05f9fc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;226;2358.783,29.16449;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;6.78;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;249;2249.183,208.642;Inherit;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;2.08;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;338;2662.856,-1075.173;Inherit;False;Constant;_Float24;Float 24;3;0;Create;True;0;0;False;0;10.36;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;2678.856,-979.1729;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;361;2394.841,1452.159;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;2620.256,-797.6954;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;2651.135,-651.0823;Inherit;False;Constant;_Float20;Float 20;3;0;Create;True;0;0;False;0;13.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;2565.516,-49.45549;Inherit;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;4.94;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;2534.783,13.16448;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;364;2613.368,1581.976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;2476.183,194.642;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;2507.062,341.255;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;3.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;327;2859.134,-745.0823;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;339;2854.856,-1043.173;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;367;3379.904,1717.501;Inherit;False;Constant;_Float26;Float 26;11;0;Create;True;0;0;False;0;5.16;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;328;3223.696,-600.7707;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;363;3692.33,1459.61;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;340;3142.856,-1027.173;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;366;4126.954,1600.038;Inherit;False;Constant;_Float25;Float 25;11;0;Create;True;0;0;False;0;1.75;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;225;2715.061,247.2551;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;233;2710.783,-50.8355;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;235;2998.783,-34.83552;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;228;3100.074,309.7615;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;341;3302.856,-1043.173;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;323;3575.013,-913.908;Inherit;True;Property;_Float18;Float 18;7;0;Create;True;0;0;False;0;8.96;6.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;365;4499.64,1451.335;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;224;3158.783,-50.8355;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;230;3366.783,-2.83552;Inherit;True;Property;_Float2;Float 2;6;0;Create;True;0;0;False;0;8.96;6.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;316;3840.073,-976.3373;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;369;4934.892,1382.971;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;5192.824,1061.259;Inherit;False;Constant;_Float27;Float 27;11;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;231;3696,16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;5146.108,1216.842;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;317;4048.073,-960.3373;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;4086.982,-589.0049;Inherit;False;Property;_Float17;Float 17;11;0;Create;True;0;0;False;0;2.86;12.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;346;4151.459,-727.1894;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;260;3904,32;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;290;1681.889,901.6998;Inherit;False;Constant;_Float9;Float 9;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;5454.268,1011.658;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;291;1684.89,1000.343;Inherit;False;Constant;_Float10;Float 10;6;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;305;4301.65,431.4428;Inherit;False;Property;_Float14;Float 14;10;0;Create;True;0;0;False;0;2.86;12.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;307;4277.976,331.1372;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;374;5723.844,1075.286;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;289;2060.01,924.1229;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;344;4487.6,-709.0877;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;376;5831.892,960.9563;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;278;4693.608,368.3684;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;345;4755.779,-538.3179;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;286;2284.397,805.9097;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;440;6060.289,669.343;Inherit;True;Property;_TextureSample2;Texture Sample 2;14;0;Create;True;0;0;False;0;None;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;442;6242.88,610.203;Inherit;False;Constant;_Float41;Float 41;15;0;Create;True;0;0;False;0;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;441;6443.989,692.2881;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;2849.113,779.1556;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;420;6466.831,820.3782;Inherit;False;Property;_Float34;Float 34;13;0;Create;True;0;0;False;0;0;0.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;375;5804.359,512.5465;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;413;2836.46,-263.7422;Inherit;False;Constant;_Float32;Float 32;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;348;5211.557,350.6254;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;411;3163.754,475.8191;Inherit;False;Constant;_Float31;Float 31;13;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;6731.701,684.467;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;417;3244.897,-119.7622;Inherit;False;Constant;_Float33;Float 33;13;0;Create;True;0;0;False;0;4.42;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;412;3089.031,-327.5841;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;263;3435.109,800.3363;Inherit;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;4.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;360;5881.36,396.8028;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;261;3317.582,1031.499;Inherit;False;Constant;_Float6;Float 6;4;0;Create;True;0;0;False;0;2.49;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;243;3023.762,733.1459;Inherit;True;Property;_LerpTex;LerpTex;2;0;Create;True;0;0;False;0;cdeac6f84093f7a4aad78514aa3d26ad;61c0b9c0523734e0e91bc6043c72a490;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;416;3434.697,-196.4622;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;3554.714,864.3623;Inherit;False;Constant;_Float8;Float 8;4;0;Create;True;0;0;False;0;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;262;3534.531,950.354;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;418;7210.63,610.333;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;265;3656.568,675.5901;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;422;6151.848,156.1217;Inherit;False;Constant;_Float35;Float 35;14;0;Create;True;0;0;False;0;14.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;3437.187,1095.525;Inherit;False;Constant;_Float5;Float 5;4;0;Create;True;0;0;False;0;59.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;424;6136.93,382.6217;Inherit;False;Constant;_Float36;Float 35;14;0;Create;True;0;0;False;0;2.63;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;3440.809,442.4391;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;426;6471.43,153.1217;Inherit;False;Constant;_Float37;Float 37;14;0;Create;True;0;0;False;0;19.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;266;3802.435,713.0945;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;258;3732.933,941.2557;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;414;3694.498,307.2498;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;421;6282.43,5.121735;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;423;6329.93,249.6217;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;428;6523.43,355.1217;Inherit;False;Constant;_Float38;Float 37;14;0;Create;True;0;0;False;0;1.27;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;407;3563.189,-287.7083;Inherit;False;Constant;_Float30;Float 29;12;0;Create;True;0;0;False;0;1.88;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;415;3918.143,215.4547;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;268;4052.938,717.0674;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;269;3994.908,944.1906;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;238;4023.5,-385.9;Inherit;False;Property;_Color0;Color 0;3;0;Create;True;0;0;False;0;0.002402996,0.3482848,0.509434,0;0.09518511,0.1051684,0.2169811,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;425;6606.43,3.121735;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;402;3782.898,-468.6465;Inherit;False;Constant;_Float29;Float 29;12;0;Create;True;0;0;False;0;0.55;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;427;6644.43,278.1217;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;409;4013.467,-198.2166;Inherit;False;Property;_Color3;Color 0;4;0;Create;True;0;0;False;0;0.002402996,0.3482848,0.509434,0;0,0.2351234,0.4528302,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;280;4147.036,-72.87843;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;401;3942.95,-533.8886;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;431;6815.43,21.12173;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;430;6914.43,294.1217;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;3793.289,-354.0083;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;408;4282.577,-262.4126;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;267;4164.498,825.6285;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;429;6944.43,-3.878265;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;405;4624.3,-332.2999;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;244;4460.192,716.4765;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;281;4536.013,-144.621;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;318;4614.885,-1295.019;Inherit;False;Property;_Color2;Color 2;5;0;Create;True;0;0;False;0;0.002402996,0.3482848,0.509434,0;0,0.7489877,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;319;4224.073,-1072.338;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;282;4660.974,710.7781;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;436;7141.43,152.1217;Inherit;False;Constant;_Float40;Float 40;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;349;5087.604,-357.2213;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;314;4385.658,168.5811;Inherit;False;Constant;_Color1;Color 1;8;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;439;7142.558,-40.60104;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;435;7250.43,26.12173;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;5347.169,-245.5366;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;434;7280.43,193.1217;Inherit;False;Constant;_Float39;Float 39;14;0;Create;True;0;0;False;0;20.42;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;313;4674.05,187.3414;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;378;5901.417,-284.2914;Inherit;False;Property;_Float28;Float 28;12;0;Create;True;0;0;False;0;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;5489.079,-155.234;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;433;7463.43,21.12173;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;437;7713.458,-33.22229;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;377;6146.587,-112.4197;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;283;7401.372,385.1426;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;432;7909.594,-153.9983;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;8307.043,-111.6741;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;water;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.1;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;301;0;302;0
WireConnection;301;1;303;0
WireConnection;304;0;359;0
WireConnection;304;2;301;0
WireConnection;304;1;294;2
WireConnection;296;1;304;0
WireConnection;332;0;329;0
WireConnection;332;1;330;0
WireConnection;297;0;298;0
WireConnection;297;1;296;0
WireConnection;333;0;379;0
WireConnection;333;2;332;0
WireConnection;333;1;294;2
WireConnection;309;0;310;0
WireConnection;309;1;311;0
WireConnection;308;0;357;0
WireConnection;308;2;309;0
WireConnection;308;1;294;2
WireConnection;334;0;333;0
WireConnection;334;1;297;0
WireConnection;300;0;308;0
WireConnection;300;1;297;0
WireConnection;335;1;334;0
WireConnection;220;1;300;0
WireConnection;337;0;335;1
WireConnection;337;1;336;0
WireConnection;326;0;335;1
WireConnection;326;1;324;0
WireConnection;222;0;220;1
WireConnection;222;1;226;0
WireConnection;364;0;361;1
WireConnection;248;0;220;1
WireConnection;248;1;249;0
WireConnection;327;0;326;0
WireConnection;327;1;325;0
WireConnection;339;0;337;0
WireConnection;339;1;338;0
WireConnection;328;0;327;0
WireConnection;363;0;361;1
WireConnection;363;1;364;0
WireConnection;363;2;367;0
WireConnection;340;0;339;0
WireConnection;225;0;248;0
WireConnection;225;1;227;0
WireConnection;233;0;222;0
WireConnection;233;1;234;0
WireConnection;235;0;233;0
WireConnection;228;0;225;0
WireConnection;341;0;340;0
WireConnection;341;1;328;0
WireConnection;365;0;363;0
WireConnection;365;1;366;0
WireConnection;224;0;235;0
WireConnection;224;1;228;0
WireConnection;316;0;341;0
WireConnection;316;1;323;0
WireConnection;369;0;365;0
WireConnection;231;0;224;0
WireConnection;231;1;230;0
WireConnection;368;0;369;0
WireConnection;317;0;316;0
WireConnection;346;0;317;0
WireConnection;346;1;328;0
WireConnection;260;0;231;0
WireConnection;372;0;220;0
WireConnection;372;1;368;0
WireConnection;372;2;335;1
WireConnection;372;3;373;0
WireConnection;307;0;260;0
WireConnection;307;1;228;0
WireConnection;374;0;372;0
WireConnection;374;1;368;0
WireConnection;289;0;290;0
WireConnection;289;1;291;0
WireConnection;344;0;346;0
WireConnection;344;1;315;0
WireConnection;376;0;374;0
WireConnection;376;1;368;0
WireConnection;278;0;307;0
WireConnection;278;1;305;0
WireConnection;345;0;344;0
WireConnection;286;0;357;0
WireConnection;286;2;289;0
WireConnection;286;1;294;2
WireConnection;441;0;440;1
WireConnection;441;1;442;0
WireConnection;295;0;286;0
WireConnection;295;1;297;0
WireConnection;375;0;376;0
WireConnection;348;0;345;0
WireConnection;348;1;278;0
WireConnection;419;0;441;0
WireConnection;419;1;420;0
WireConnection;412;0;220;1
WireConnection;412;1;413;0
WireConnection;360;0;348;0
WireConnection;360;1;375;0
WireConnection;243;1;295;0
WireConnection;416;0;412;0
WireConnection;416;1;417;0
WireConnection;262;0;243;1
WireConnection;262;1;261;0
WireConnection;418;0;360;0
WireConnection;418;1;419;0
WireConnection;265;0;243;1
WireConnection;265;1;263;0
WireConnection;410;0;228;0
WireConnection;410;1;411;0
WireConnection;266;0;265;0
WireConnection;266;1;264;0
WireConnection;258;0;262;0
WireConnection;258;1;259;0
WireConnection;414;0;416;0
WireConnection;414;1;410;0
WireConnection;421;0;418;0
WireConnection;421;1;422;0
WireConnection;423;0;424;0
WireConnection;423;1;418;0
WireConnection;415;0;414;0
WireConnection;268;0;266;0
WireConnection;269;0;258;0
WireConnection;425;0;421;0
WireConnection;425;1;426;0
WireConnection;427;0;423;0
WireConnection;427;1;428;0
WireConnection;280;0;260;0
WireConnection;401;0;328;0
WireConnection;401;1;402;0
WireConnection;431;0;425;0
WireConnection;430;0;427;0
WireConnection;406;0;335;1
WireConnection;406;1;407;0
WireConnection;408;0;238;0
WireConnection;408;1;409;0
WireConnection;408;2;415;0
WireConnection;267;0;268;0
WireConnection;267;1;269;0
WireConnection;429;0;431;0
WireConnection;429;1;430;0
WireConnection;405;0;401;0
WireConnection;405;1;406;0
WireConnection;244;0;267;0
WireConnection;281;0;280;0
WireConnection;281;1;408;0
WireConnection;319;0;317;0
WireConnection;282;0;244;0
WireConnection;349;0;281;0
WireConnection;349;1;318;0
WireConnection;349;2;405;0
WireConnection;439;0;429;0
WireConnection;435;0;439;0
WireConnection;435;1;436;0
WireConnection;358;0;349;0
WireConnection;358;1;282;0
WireConnection;358;2;319;0
WireConnection;313;0;314;0
WireConnection;313;1;269;0
WireConnection;285;0;358;0
WireConnection;285;1;313;0
WireConnection;433;0;435;0
WireConnection;433;1;434;0
WireConnection;437;0;433;0
WireConnection;377;0;378;0
WireConnection;377;1;285;0
WireConnection;283;0;418;0
WireConnection;432;0;377;0
WireConnection;432;1;437;0
WireConnection;0;2;432;0
WireConnection;0;9;283;0
ASEEND*/
//CHKSM=A262A77F4D2C2947EB6F568C80492F02C17AD9D2