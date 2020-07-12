// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "new_trail"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Speed("Speed", Float) = -1
		_Speed1("Speed", Float) = -1
		_speed_y1("speed_y", Float) = -1
		_speed_y("speed_y", Float) = -1
		_nosie_x("nosie_x", Float) = 1
		_Tex_x("Tex_x", Float) = 1
		_nosie_y("nosie_y", Float) = 1
		_Tex_v("Tex_v", Float) = 1
		[HDR]_Color0("Color 0", Color) = (0.4292453,1,0.941732,1)
		_Float0("Float 0", Float) = 3.54
		_Float1("Float 1", Float) = 0.4
		_Float2("Float 2", Float) = 0.4
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 0
		_Float3("Float 3", Float) = 1.71
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
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _ToggleSwitch0;
		uniform sampler2D _TextureSample0;
		uniform float _Speed;
		uniform float _speed_y;
		uniform float _Tex_x;
		uniform float _Tex_v;
		uniform float _Float0;
		uniform sampler2D _TextureSample1;
		uniform float _nosie_x;
		uniform float _nosie_y;
		uniform float4 _Color0;
		uniform sampler2D _TextureSample2;
		uniform float _Speed1;
		uniform float _speed_y1;
		uniform float _Float3;
		uniform float _Float1;
		uniform float _Float2;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_4 = (_Float2).xxxx;
			return temp_cast_4;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 appendResult38 = (float2(_Speed , _speed_y));
			float2 appendResult78 = (float2(_Tex_x , _Tex_v));
			float2 uv_TexCoord40 = v.texcoord.xy * appendResult78;
			float2 panner39 = ( _Time.y * appendResult38 + uv_TexCoord40);
			float4 temp_cast_0 = (_Float0).xxxx;
			float4 temp_output_83_0 = pow( tex2Dlod( _TextureSample0, float4( panner39, 0, 0.0) ) , temp_cast_0 );
			float2 appendResult11 = (float2(_Speed , _speed_y));
			float2 appendResult48 = (float2(_nosie_x , _nosie_y));
			float2 uv_TexCoord5 = v.texcoord.xy * appendResult48;
			float2 panner9 = ( _Time.y * appendResult11 + uv_TexCoord5);
			float4 temp_cast_1 = (_Float0).xxxx;
			float4 temp_output_74_0 = saturate( pow( ( tex2Dlod( _TextureSample1, float4( panner9, 0, 0.0) ) - float4( 0,0,0,0 ) ) , temp_cast_1 ) );
			float2 appendResult119 = (float2(_Speed1 , _speed_y1));
			float2 uv_TexCoord118 = v.texcoord.xy * float2( 2,2 );
			float2 panner117 = ( _Time.y * appendResult119 + uv_TexCoord118);
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( lerp(( ( temp_output_83_0 * temp_output_74_0 ) * v.color.a * _Color0.a ),saturate( ( saturate( floor( ( ( max( temp_output_83_0 , temp_output_74_0 ) - saturate( pow( ( tex2Dlod( _TextureSample2, float4( panner117, 0, 0.0) ) * (0.18 + (( 1.0 - v.texcoord.xy.y ) - 0.3) * (0.68 - 0.18) / (0.98 - 0.3)) ) , 1.46 ) ) ) * _Float3 ) ) ) * v.color.a ) ),_ToggleSwitch0) * _Float1 * float4( ase_vertexNormal , 0.0 ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Emission = ( i.vertexColor * _Color0 ).rgb;
			float2 appendResult38 = (float2(_Speed , _speed_y));
			float2 appendResult78 = (float2(_Tex_x , _Tex_v));
			float2 uv_TexCoord40 = i.uv_texcoord * appendResult78;
			float2 panner39 = ( _Time.y * appendResult38 + uv_TexCoord40);
			float4 temp_cast_1 = (_Float0).xxxx;
			float4 temp_output_83_0 = pow( tex2D( _TextureSample0, panner39 ) , temp_cast_1 );
			float2 appendResult11 = (float2(_Speed , _speed_y));
			float2 appendResult48 = (float2(_nosie_x , _nosie_y));
			float2 uv_TexCoord5 = i.uv_texcoord * appendResult48;
			float2 panner9 = ( _Time.y * appendResult11 + uv_TexCoord5);
			float4 temp_cast_2 = (_Float0).xxxx;
			float4 temp_output_74_0 = saturate( pow( ( tex2D( _TextureSample1, panner9 ) - float4( 0,0,0,0 ) ) , temp_cast_2 ) );
			float2 appendResult119 = (float2(_Speed1 , _speed_y1));
			float2 uv_TexCoord118 = i.uv_texcoord * float2( 2,2 );
			float2 panner117 = ( _Time.y * appendResult119 + uv_TexCoord118);
			o.Alpha = saturate( lerp(( ( temp_output_83_0 * temp_output_74_0 ) * i.vertexColor.a * _Color0.a ),saturate( ( saturate( floor( ( ( max( temp_output_83_0 , temp_output_74_0 ) - saturate( pow( ( tex2D( _TextureSample2, panner117 ) * (0.18 + (( 1.0 - i.uv_texcoord.y ) - 0.3) * (0.68 - 0.18) / (0.98 - 0.3)) ) , 1.46 ) ) ) * _Float3 ) ) ) * i.vertexColor.a ) ),_ToggleSwitch0) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				vertexDataFunc( v );
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
-1913;32;1906;987;4037.724;1572.03;3.127708;True;True
Node;AmplifyShaderEditor.RangedFloatNode;49;-2269.72,157.4527;Float;False;Property;_nosie_x;nosie_x;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2251.861,227.8391;Float;False;Property;_nosie_y;nosie_y;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-2027.045,191.07;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-1654.256,116.1548;Float;False;Property;_speed_y;speed_y;5;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1650.386,38.11072;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-1641.224,476.0737;Float;False;Property;_Speed1;Speed;3;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-1644.094,573.118;Float;True;Property;_speed_y1;speed_y;4;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1296.281,74.1875;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-1834.042,-56.19025;Float;False;Property;_Tex_v;Tex_v;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;12;-1658.596,317.1433;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1865.384,208.2362;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-1851.901,-126.5767;Float;False;Property;_Tex_x;Tex_x;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;100;115.0801,1042.474;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;119;-1424.236,547.2732;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;116;-1302.297,886.6207;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;118;-1625.085,806.7136;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-1370.381,266.8674;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-1609.226,-92.95936;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;40;-1398.41,-100.6001;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;37;-879.0127,110.0595;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;38;-999.4019,38.80615;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1179.784,218.0247;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;df1a73877e6e817489bcdec99d204d81;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;109;359.3919,1130.187;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;117;-1087.082,702.3448;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;39;-659.7551,-7.56366;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-392.6396,400.5999;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;115;-413.2743,951.8809;Inherit;True;Property;_TextureSample2;Texture Sample 2;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;84;-296.8907,266.7982;Inherit;False;Property;_Float0;Float 0;11;0;Create;True;0;0;False;0;3.54;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;110;572.8305,1150.262;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.98;False;3;FLOAT;0.18;False;4;FLOAT;0.68;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;85;-188.545,501.9966;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-434.2642,6.450211;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;cff5877c8bbfe4c4cb67de9615782ce0;cff5877c8bbfe4c4cb67de9615782ce0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;794.9993,1107.73;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;74;-16.78611,500.6289;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;83;-149.7812,143.5313;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;123;1103.068,1125.603;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1.46;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;99;142.1118,546.4724;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;112;1182.802,1013.121;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;94;448.8307,801.8908;Inherit;False;Property;_Float3;Float 3;15;0;Create;True;0;0;False;0;1.71;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;247.9074,769.153;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;469.0511,621.5924;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FloorOpNode;93;763.3024,749.0828;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;96;963.0026,796.0235;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;8;126.1999,7.307702;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;1102.661,574.8172;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;181.7411,292.6035;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;81;105.8219,-173.1814;Inherit;False;Property;_Color0;Color 0;10;1;[HDR];Create;True;0;0;False;0;0.4292453,1,0.941732,1;0.4292453,1,0.941732,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;476.9986,142.0102;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;113;1234.629,466.2224;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;436.8835,366.5735;Inherit;True;Property;_Float1;Float 1;12;0;Create;True;0;0;False;0;0.4;0.015;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;89;731.0671,549.5969;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;91;675.6896,92.90893;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;14;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;429.7684,-103.4297;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;788.2648,287.6297;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;861.5895,449.6859;Inherit;False;Property;_Float2;Float 2;13;0;Create;True;0;0;False;0;0.4;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;124;1021.169,160.634;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1232.593,-18.75625;Float;False;True;6;ASEMaterialInspector;0;0;Standard;new_trail;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;0;49;0
WireConnection;48;1;50;0
WireConnection;11;0;10;0
WireConnection;11;1;80;0
WireConnection;5;0;48;0
WireConnection;119;0;120;0
WireConnection;119;1;121;0
WireConnection;9;0;5;0
WireConnection;9;2;11;0
WireConnection;9;1;12;2
WireConnection;78;0;77;0
WireConnection;78;1;76;0
WireConnection;40;0;78;0
WireConnection;38;0;10;0
WireConnection;38;1;80;0
WireConnection;2;1;9;0
WireConnection;109;0;100;2
WireConnection;117;0;118;0
WireConnection;117;2;119;0
WireConnection;117;1;116;2
WireConnection;39;0;40;0
WireConnection;39;2;38;0
WireConnection;39;1;37;2
WireConnection;61;0;2;0
WireConnection;115;1;117;0
WireConnection;110;0;109;0
WireConnection;85;0;61;0
WireConnection;85;1;84;0
WireConnection;1;1;39;0
WireConnection;108;0;115;0
WireConnection;108;1;110;0
WireConnection;74;0;85;0
WireConnection;83;0;1;0
WireConnection;83;1;84;0
WireConnection;123;0;108;0
WireConnection;99;0;83;0
WireConnection;99;1;74;0
WireConnection;112;0;123;0
WireConnection;111;0;99;0
WireConnection;111;1;112;0
WireConnection;95;0;111;0
WireConnection;95;1;94;0
WireConnection;93;0;95;0
WireConnection;96;0;93;0
WireConnection;97;0;96;0
WireConnection;97;1;8;4
WireConnection;62;0;83;0
WireConnection;62;1;74;0
WireConnection;23;0;62;0
WireConnection;23;1;8;4
WireConnection;23;2;81;4
WireConnection;113;0;97;0
WireConnection;91;0;23;0
WireConnection;91;1;113;0
WireConnection;24;0;8;0
WireConnection;24;1;81;0
WireConnection;86;0;91;0
WireConnection;86;1;87;0
WireConnection;86;2;89;0
WireConnection;124;0;91;0
WireConnection;0;2;24;0
WireConnection;0;9;124;0
WireConnection;0;11;86;0
WireConnection;0;14;88;0
ASEEND*/
//CHKSM=0B8076154E006C44D48E8208325674D4FB3423CC