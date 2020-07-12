// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ice"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_Float1("Float 1", Float) = 0
		_Float0("Float 0", Float) = 0
		_Float2("Float 2", Float) = 0
		_Float3("Float 3", Float) = 0
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 1
		_Float4("Float 4", Float) = 3
		_Power("Power", Float) = 3
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv2_texcoord2;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float _ToggleSwitch0;
		uniform float _Float1;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _Power;
		uniform float _Float0;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Float3;
		uniform float _Float2;
		uniform float _Float4;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (10.0).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_TextureSample0 = v.texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_cast_0 = (_Power).xxxx;
			float4 temp_output_6_0 = ( lerp(_Float1,v.texcoord1.xy.x,_ToggleSwitch0) * pow( tex2Dlod( _TextureSample0, float4( uv_TextureSample0, 0, 0.0) ) , temp_cast_0 ) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( temp_output_6_0 * _Float0 * float4( ase_worldNormal , 0.0 ) ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_cast_0 = (_Power).xxxx;
			float4 temp_output_6_0 = ( lerp(_Float1,i.uv2_texcoord2.x,_ToggleSwitch0) * pow( tex2D( _TextureSample0, uv_TextureSample0 ) , temp_cast_0 ) );
			float4 lerpResult11 = lerp( _Color0 , _Color1 , saturate( temp_output_6_0 ));
			o.Albedo = lerpResult11.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV38 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode38 = ( -0.61 + 1.01 * pow( 1.0 - fresnelNdotV38, 0.38 ) );
			float4 temp_cast_2 = (fresnelNode38).xxxx;
			o.Emission = max( temp_cast_2 , lerpResult11 ).rgb;
			o.Metallic = _Float3;
			o.Smoothness = _Float2;
			o.Alpha = ( i.vertexColor.a * saturate( ( temp_output_6_0 * _Float4 ) ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

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
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv2_texcoord2;
				o.customPack1.xy = v.texcoord1;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
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
				surfIN.uv2_texcoord2 = IN.customPack1.xy;
				surfIN.uv_texcoord = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
-1518;363;1508;656;2114.329;474.8195;2.257389;True;True
Node;AmplifyShaderEditor.RangedFloatNode;49;-1035.297,179.8234;Inherit;False;Property;_Power;Power;9;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;27;-1346.681,391.1745;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1276.005,294.0978;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;0;3.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1294.577,10.56651;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;28;-894.9537,292.5273;Inherit;False;Property;_ToggleSwitch0;Toggle Switch0;7;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;-762.1526,105.3296;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-461.1644,266.5567;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-277.7897,282.322;Inherit;False;Property;_Float4;Float 4;8;0;Create;True;0;0;False;0;3;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-620.0471,-7.517659;Inherit;False;Property;_Color1;Color 1;2;0;Create;True;0;0;False;0;0,0,0,0;0.5424526,1,0.9526544,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-14.14133,279.6188;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-853.459,-158.7756;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;0,0,0,0;0.2594339,0.4935672,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;37;-350.8839,11.72659;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;16;159.022,217.4263;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;41;-792.709,430.5461;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;29;-176.571,120.7376;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-319.2607,-52.42474;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-754.2607,653.5753;Inherit;False;Property;_Float0;Float 0;4;0;Create;True;0;0;False;0;0;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;38;-115.2102,-269.5941;Inherit;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;-0.61;False;2;FLOAT;1.01;False;3;FLOAT;0.38;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;139.1799,500.4554;Inherit;False;Constant;_Float5;Float 5;7;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;413.6422,168.7376;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;40;340.8438,-158.227;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-19.92017,23.39063;Inherit;False;Property;_Float3;Float 3;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-6.92017,102.3906;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-238.1643,431.5567;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-519.7252,536.4033;Inherit;False;Constant;_Float6;Float 6;9;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;-333.9942,358.7466;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;898.8946,-38.45541;Float;False;True;6;ASEMaterialInspector;0;0;Standard;ice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;7;0
WireConnection;28;1;27;1
WireConnection;48;0;1;0
WireConnection;48;1;49;0
WireConnection;6;0;28;0
WireConnection;6;1;48;0
WireConnection;19;0;6;0
WireConnection;19;1;20;0
WireConnection;37;0;6;0
WireConnection;16;0;19;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;11;2;37;0
WireConnection;30;0;29;4
WireConnection;30;1;16;0
WireConnection;40;0;38;0
WireConnection;40;1;11;0
WireConnection;3;0;6;0
WireConnection;3;1;5;0
WireConnection;3;2;41;0
WireConnection;47;0;41;3
WireConnection;47;1;46;0
WireConnection;0;0;11;0
WireConnection;0;2;40;0
WireConnection;0;3;13;0
WireConnection;0;4;12;0
WireConnection;0;9;30;0
WireConnection;0;11;3;0
WireConnection;0;14;21;0
ASEEND*/
//CHKSM=3556FB0D9F441E65E6CB1DF8B84EC4E759B97686