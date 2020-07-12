// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "world_trail"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_nosie_x("nosie_x", Float) = 1
		_Tex_x("Tex_x", Float) = 1
		[Toggle]_Flip("Flip", Float) = 1
		[Toggle]_useV("use V", Float) = 1
		_nosie_y("nosie_y", Float) = 1
		_Tex_v("Tex_v", Float) = 1
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv2_tex4coord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _TextureSample0;
		uniform float _Tex_x;
		uniform float _Tex_v;
		uniform sampler2D _TextureSample1;
		uniform float _nosie_x;
		uniform float _nosie_y;
		uniform float _Flip;
		uniform float _useV;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult98 = (float2(_Tex_x , _Tex_v));
			float2 appendResult129 = (float2(i.uv2_tex4coord2.x , i.uv2_tex4coord2.y));
			float2 uv_TexCoord99 = i.uv_texcoord * appendResult98 + appendResult129;
			float2 appendResult89 = (float2(_nosie_x , _nosie_y));
			float2 appendResult128 = (float2(i.uv2_tex4coord2.x , i.uv2_tex4coord2.y));
			float2 uv_TexCoord95 = i.uv_texcoord * appendResult89 + appendResult128;
			float temp_output_114_0 = ( tex2D( _TextureSample0, uv_TexCoord99 ).r * tex2D( _TextureSample1, uv_TexCoord95 ).r );
			o.Emission = ( temp_output_114_0 * i.vertexColor ).rgb;
			o.Alpha = saturate( ( ( temp_output_114_0 - saturate( pow( (0.18 + (lerp(lerp(i.uv_texcoord.x,i.uv_texcoord.y,_useV),( 1.0 - lerp(i.uv_texcoord.x,i.uv_texcoord.y,_useV) ),_Flip) - 0.3) * (0.68 - 0.18) / (0.98 - 0.3)) , 3.22 ) ) ) * i.vertexColor.a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
-1913;32;1906;987;38.62177;198.2112;1;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-1262.514,395.1545;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;119;-921.845,375.1719;Inherit;True;Property;_useV;use V;5;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;123;-613.8364,437.0267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-806.4017,-387.7644;Float;False;Property;_Tex_x;Tex_x;3;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-790.4017,-323.7644;Float;False;Property;_Tex_v;Tex_v;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1042.04,-4.960461;Float;False;Property;_nosie_y;nosie_y;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;105;-1301.447,-326.6338;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-1071.511,-104.8365;Float;False;Property;_nosie_x;nosie_x;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-566.4016,-355.7644;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-568.274,-243.4441;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-721.7008,117.9324;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;118;-483.1451,367.4719;Inherit;True;Property;_Flip;Flip;4;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;89;-750.3528,-119.5684;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-191.5751,430.0629;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;3.22;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;99;-342.4015,-355.7644;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;95;-451.0126,84.20865;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;106;-190.9343,497.0858;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.98;False;3;FLOAT;0.18;False;4;FLOAT;0.68;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;109;118.3343,482.1277;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;103;615.3339,-253.3142;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;cff5877c8bbfe4c4cb67de9615782ce0;8150f6f43f753a142bcf05fc6eb8f621;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;104;182.055,139.9102;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;df1a73877e6e817489bcdec99d204d81;0df58e308f423a3469472cc0b69a5254;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;1290.138,-70.62272;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;113;648.1247,409.5628;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;112;1159.125,132.3628;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;124;1729.448,127.5305;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;1925.824,274.9717;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;127;2046.448,272.5305;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;1962.448,-8.469482;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2311.255,-83.06251;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;world_trail;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.05;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;119;0;108;1
WireConnection;119;1;108;2
WireConnection;123;0;119;0
WireConnection;98;0;96;0
WireConnection;98;1;93;0
WireConnection;129;0;105;1
WireConnection;129;1;105;2
WireConnection;128;0;105;1
WireConnection;128;1;105;2
WireConnection;118;0;119;0
WireConnection;118;1;123;0
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;99;0;98;0
WireConnection;99;1;129;0
WireConnection;95;0;89;0
WireConnection;95;1;128;0
WireConnection;106;0;118;0
WireConnection;109;0;106;0
WireConnection;109;1;110;0
WireConnection;103;1;99;0
WireConnection;104;1;95;0
WireConnection;114;0;103;1
WireConnection;114;1;104;1
WireConnection;113;0;109;0
WireConnection;112;0;114;0
WireConnection;112;1;113;0
WireConnection;126;0;112;0
WireConnection;126;1;124;4
WireConnection;127;0;126;0
WireConnection;125;0;114;0
WireConnection;125;1;124;0
WireConnection;0;2;125;0
WireConnection;0;9;127;0
ASEEND*/
//CHKSM=E2816BC145C0CF453C0F9F462FCB802966272D06