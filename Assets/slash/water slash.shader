// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "water slash"
{
	Properties
	{
		_Float0("Float 0", Range( -8 , 1)) = 0.04087261
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		[HDR]_Color1("Color 1", Color) = (0,0.6460881,1,0)
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 1
		[HDR]_Color0("Color 0", Color) = (0,0.6460881,1,0)
		[HDR]_Color3("Color 3", Color) = (0.7877358,0.9250833,1,0)
		_mask_Tex("mask_Tex", 2D) = "white" {}
		_Dark_Tex("Dark_Tex", 2D) = "white" {}
		_Float2("Float 2", Range( 0 , 15)) = 5.48
		_Float4("Float 4", Range( 0 , 15)) = 5.48
		_speed1("speed1", Float) = -0.6
		_v3("v3", Float) = 0.3
		_v2("v2", Float) = 0.1
		_speed3("speed3", Float) = -1
		_Float9("Float 9", Range( 0 , 15)) = 5.48
		_Scale("Scale", Float) = 1.2
		_Float1("Float 1", Float) = 0
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_Float14("Float 14", Float) = 4.9
		[Toggle]_particle("particle", Float) = 0
		_Float15("Float 15", Float) = 8.22
		[Toggle]_Particledis("Particle(dis)", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color3;
		uniform float4 _Color1;
		uniform float _ToggleSwitch0;
		uniform float _Float0;
		uniform sampler2D _mask_Tex;
		uniform float4 _mask_Tex_ST;
		uniform float _Float9;
		uniform float _speed1;
		uniform float _v2;
		uniform float _Float1;
		uniform float _Particledis;
		uniform float _Float2;
		uniform float _Scale;
		uniform float4 _Color0;
		uniform sampler2D _Dark_Tex;
		uniform float _speed3;
		uniform float _v3;
		uniform float _Float4;
		uniform sampler2D _TextureSample3;
		uniform float _particle;
		uniform float _Float15;
		uniform float _Float14;
		uniform float _Cutoff = 0.1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 lerpResult5 = lerp( _Color3 , _Color1 , saturate( ( pow( lerp(lerp(i.uv_texcoord.x,i.uv_texcoord.y,_ToggleSwitch0),( 1.0 - lerp(i.uv_texcoord.x,i.uv_texcoord.y,_ToggleSwitch0) ),_ToggleSwitch0) , ( 1.0 - _Float0 ) ) * -0.7 ) ));
			float2 uv_mask_Tex = i.uv_texcoord * _mask_Tex_ST.xy + _mask_Tex_ST.zw;
			float4 lerpResult143 = lerp( lerpResult5 , float4( 1,1,1,0 ) , saturate( floor( ( tex2D( _mask_Tex, uv_mask_Tex ) * _Float9 ) ) ));
			float2 appendResult138 = (float2(-0.6 , 0.0));
			float2 appendResult205 = (float2(1.0 , 1.0));
			float2 uv_TexCoord142 = i.uv_texcoord * appendResult205;
			float2 panner137 = ( _Time.y * appendResult138 + uv_TexCoord142);
			float2 appendResult181 = (float2(_speed1 , _v2));
			float2 uv_TexCoord131 = i.uv_texcoord * float2( 2,1.5 );
			float2 panner182 = ( _Time.y * appendResult181 + uv_TexCoord131);
			float4 temp_output_133_0 = ( tex2D( _mask_Tex, panner182 ) * _Float1 );
			float4 tex2DNode135 = tex2D( _mask_Tex, ( float4( panner137, 0.0 , 0.0 ) + temp_output_133_0 ).rg );
			float temp_output_84_0 = ( lerp(_Float2,i.uv2_tex4coord2.y,_Particledis) * 5.0 );
			float2 appendResult127 = (float2(_speed3 , _v3));
			float2 panner123 = ( _Time.y * appendResult127 + uv_TexCoord131);
			float4 lerpResult115 = lerp( max( lerpResult143 , saturate( floor( ( tex2DNode135 * ( temp_output_84_0 * _Scale ) ) ) ) ) , _Color0 , saturate( floor( ( tex2D( _Dark_Tex, ( float4( panner123, 0.0 , 0.0 ) + temp_output_133_0 ).rg ) * _Float4 ) ) ));
			o.Emission = lerpResult115.rgb;
			float2 appendResult166 = (float2(-0.5 , 0.0));
			float2 uv_TexCoord165 = i.uv_texcoord * float2( 2,1 );
			float2 panner167 = ( _Time.y * appendResult166 + uv_TexCoord165);
			float temp_output_174_0 = pow( ( ( 1.0 - i.uv_texcoord.x ) * i.uv_texcoord.x * lerp(_Float15,i.uv2_tex4coord2.x,_particle) ) , lerp(_Float15,i.uv2_tex4coord2.x,_particle) );
			float4 temp_cast_5 = (temp_output_174_0).xxxx;
			float4 temp_output_179_0 = saturate( ( ( saturate( ( 1.0 - floor( saturate( ( tex2DNode135 * temp_output_84_0 ) ) ) ) ) * tex2D( _TextureSample3, panner167 ) ) * max( max( temp_cast_5 , ( temp_output_174_0 * tex2DNode135 * _Float14 ) ) , float4( 0,0,0,0 ) ) ) );
			o.Alpha = ( temp_output_179_0 * i.vertexColor.a ).r;
			clip( temp_output_179_0.r - _Cutoff );
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
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
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
				o.customPack2.xyzw = customInputData.uv2_tex4coord2;
				o.customPack2.xyzw = v.texcoord1;
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
				surfIN.uv2_tex4coord2 = IN.customPack2.xyzw;
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
-1167;251;1920;965;3828.679;1525.977;4.439117;True;False
Node;AmplifyShaderEditor.RangedFloatNode;183;-3047.17,1002.169;Inherit;False;Property;_speed1;speed1;10;0;Create;True;0;0;False;0;-0.6;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-3063.486,1076.448;Inherit;False;Property;_v2;v2;12;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;131;-2825.26,461.6239;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,1.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;181;-2818.661,1041.917;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-3291.54,1389.045;Inherit;False;Constant;_v;v;25;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;206;-3281.23,1306.289;Inherit;False;Constant;_speed2;speed2;24;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;130;-2692.801,780.187;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;30;-2627.405,1155.236;Inherit;True;Property;_mask_Tex;mask_Tex;6;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;55190433fa6a8b942ad179dcc3ace216;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;140;-2899.28,1517.92;Inherit;False;Constant;_Float7;Float 7;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-2921.03,1436.523;Inherit;False;Constant;_Float8;Float 8;9;0;Create;True;0;0;False;0;-0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;205;-3048.677,1320.377;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;182;-2529.754,1015.757;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;56;-2292.17,932.6212;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;138;-2659.698,1458.203;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;139;-2761.607,1624.294;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;134;-2209.579,824.5167;Inherit;False;Property;_Float1;Float 1;16;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;142;-2863.933,1298.864;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;198;-1739.107,959.8962;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-1813.226,1200.932;Inherit;False;Property;_Float2;Float 2;8;0;Create;True;0;0;False;0;5.48;0;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;-1972.957,820.0426;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;137;-2480.437,1380.806;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1322.871,1316.487;Inherit;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;200;-1337.999,1212.932;Inherit;False;Property;_Particledis;Particle(dis);21;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-1955.181,1440.733;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1934.99,187.3104;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;821.0823,1289.18;Inherit;False;Property;_Float15;Float 15;20;0;Create;True;0;0;False;0;8.22;3.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;171;784.6448,1110.235;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;135;-1726.405,1362.77;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-1119.963,1215.099;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;21;-1592.916,194.4607;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;1;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-2816.474,679.8134;Inherit;False;Property;_v3;v3;11;0;Create;True;0;0;False;0;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;114;-1333.827,295.4951;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;173;1059.079,1071.151;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-2806.224,593.4162;Inherit;False;Property;_speed3;speed3;13;0;Create;True;0;0;False;0;-1;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1664.621,345.076;Inherit;False;Property;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.04087261;-3.28;-8;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-839.4316,1786.041;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;199;1050.601,1267.434;Inherit;False;Property;_particle;particle;19;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;1240.972,1074.374;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-594.2285,1821.32;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;127;-2593.892,627.0964;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;113;-1164.465,198.4951;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;4;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1327.321,358.7175;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;511.7989,852.8073;Inherit;False;Constant;_Float13;Float 13;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;522.0488,766.4103;Inherit;False;Constant;_Float12;Float 12;9;0;Create;True;0;0;False;0;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1584.189,1738.96;Inherit;False;Property;_Float9;Float 9;14;0;Create;True;0;0;False;0;5.48;0;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;1452.841,1217.468;Inherit;False;Property;_Float14;Float 14;18;0;Create;True;0;0;False;0;4.9;10.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-597.2349,325.4467;Inherit;False;Constant;_Float11;Float 11;11;0;Create;True;0;0;False;0;-0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;9;-880.1431,291.9615;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;68;-313.7394,1671.192;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1417.956,1065.078;Inherit;False;Property;_Scale;Scale;15;0;Create;True;0;0;False;0;1.2;1.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;164;635.4719,953.1813;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;166;734.3809,800.0902;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;174;1566.807,949.3052;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;123;-2439.631,524.6993;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;204;-1837.314,1576.065;Inherit;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;165;503.013,634.6183;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-333.3318,270.6324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-1020.078,1016.452;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;180;-2257.493,602.4336;Inherit;True;Property;_Dark_Tex;Dark_Tex;7;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;cdeac6f84093f7a4aad78514aa3d26ad;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;176;1930.462,1071.338;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;167;888.6419,697.6932;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-1335.288,1568.102;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;81;-55.31816,1661.605;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;-1932.762,519.248;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;119;-1732.479,573.5344;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;168;1260.95,637.0077;Inherit;True;Property;_TextureSample3;Texture Sample 3;17;0;Create;True;0;0;False;0;None;82a8e66f31a9e654792bee0ab05f9fc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;186;2171.558,1090.716;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;15;101.6185,168.8494;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-266.7565,102.7377;Inherit;False;Property;_Color1;Color 1;3;1;[HDR];Create;True;0;0;False;0;0,0.6460881,1,0;0,0.3704069,1.44383,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1031.226,796.4104;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1216.355,677.8738;Inherit;False;Property;_Float4;Float 4;9;0;Create;True;0;0;False;0;5.48;15;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-255.0212,-68.29507;Inherit;False;Property;_Color3;Color 3;5;1;[HDR];Create;True;0;0;False;0;0.7877358,0.9250833,1,0;0,0.3406706,0.735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;145;-617.1783,1493.318;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;82;235.4232,1653.227;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;5;301.9302,-43.65681;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;194;2391.794,1028.165;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-854.2659,577.7206;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;1881.604,553.2147;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;83;-366.1537,476.1082;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;217;81.94192,775.9478;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;122;737.2686,389.9416;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;143;636.7023,-18.71902;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;77;255.1863,350.5216;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;2544.743,547.67;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;117;886.4911,-125.8083;Inherit;False;Property;_Color0;Color 0;4;1;[HDR];Create;True;0;0;False;0;0,0.6460881,1,0;0.03671235,0.1276851,0.5188679,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;79;992.1918,72.82169;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;179;2781.56,490.9832;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;216;942.2354,303.7759;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;211;2466.965,317.824;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;115;1280.748,70.618;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;3041.339,364.9273;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3345.982,184.7247;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;water slash;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;181;0;183;0
WireConnection;181;1;184;0
WireConnection;205;0;206;0
WireConnection;205;1;207;0
WireConnection;182;0;131;0
WireConnection;182;2;181;0
WireConnection;182;1;130;2
WireConnection;56;0;30;0
WireConnection;56;1;182;0
WireConnection;138;0;141;0
WireConnection;138;1;140;0
WireConnection;142;0;205;0
WireConnection;133;0;56;0
WireConnection;133;1;134;0
WireConnection;137;0;142;0
WireConnection;137;2;138;0
WireConnection;137;1;139;2
WireConnection;200;0;70;0
WireConnection;200;1;198;2
WireConnection;136;0;137;0
WireConnection;136;1;133;0
WireConnection;135;0;30;0
WireConnection;135;1;136;0
WireConnection;84;0;200;0
WireConnection;84;1;85;0
WireConnection;21;0;7;1
WireConnection;21;1;7;2
WireConnection;114;0;21;0
WireConnection;173;0;171;1
WireConnection;69;0;135;0
WireConnection;69;1;84;0
WireConnection;199;0;178;0
WireConnection;199;1;198;1
WireConnection;218;0;173;0
WireConnection;218;1;171;1
WireConnection;218;2;199;0
WireConnection;71;0;69;0
WireConnection;127;0;128;0
WireConnection;127;1;129;0
WireConnection;113;0;21;0
WireConnection;113;1;114;0
WireConnection;19;0;18;0
WireConnection;9;0;113;0
WireConnection;9;1;19;0
WireConnection;68;0;71;0
WireConnection;166;0;162;0
WireConnection;166;1;163;0
WireConnection;174;0;218;0
WireConnection;174;1;199;0
WireConnection;123;0;131;0
WireConnection;123;2;127;0
WireConnection;123;1;130;2
WireConnection;204;0;30;0
WireConnection;158;0;9;0
WireConnection;158;1;159;0
WireConnection;80;0;84;0
WireConnection;80;1;75;0
WireConnection;176;0;174;0
WireConnection;176;1;135;0
WireConnection;176;2;177;0
WireConnection;167;0;165;0
WireConnection;167;2;166;0
WireConnection;167;1;164;2
WireConnection;144;0;204;0
WireConnection;144;1;146;0
WireConnection;81;0;68;0
WireConnection;132;0;123;0
WireConnection;132;1;133;0
WireConnection;119;0;180;0
WireConnection;119;1;132;0
WireConnection;168;1;167;0
WireConnection;186;0;174;0
WireConnection;186;1;176;0
WireConnection;15;0;158;0
WireConnection;74;0;135;0
WireConnection;74;1;80;0
WireConnection;145;0;144;0
WireConnection;82;0;81;0
WireConnection;5;0;20;0
WireConnection;5;1;2;0
WireConnection;5;2;15;0
WireConnection;194;0;186;0
WireConnection;120;0;119;0
WireConnection;120;1;121;0
WireConnection;169;0;82;0
WireConnection;169;1;168;0
WireConnection;83;0;74;0
WireConnection;217;0;145;0
WireConnection;122;0;120;0
WireConnection;143;0;5;0
WireConnection;143;2;217;0
WireConnection;77;0;83;0
WireConnection;219;0;169;0
WireConnection;219;1;194;0
WireConnection;79;0;143;0
WireConnection;79;1;77;0
WireConnection;179;0;219;0
WireConnection;216;0;122;0
WireConnection;115;0;79;0
WireConnection;115;1;117;0
WireConnection;115;2;216;0
WireConnection;208;0;179;0
WireConnection;208;1;211;4
WireConnection;0;2;115;0
WireConnection;0;9;208;0
WireConnection;0;10;179;0
ASEEND*/
//CHKSM=341BF907B7C92C89F276BF9007596E6B4771B575