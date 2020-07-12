// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "vertex_offset"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Color0("Color 0", Color) = (0.5235849,0.905601,1,0)
		_Color1("Color 1", Color) = (1,1,1,0)
		_Float2("Float 2", Float) = 0.2
		_Float3("Float 3", Float) = -4
		_Float9("Float 9", Float) = 0.2
		_Float10("Float 10", Float) = -2
		_Color2("Color 2", Color) = (1,1,1,0)
		_Float4("Float 4", Float) = 0
		_Float5("Float 5", Float) = 50
		_Float6("Float 6", Float) = 1.69
		_Float7("Float 7", Float) = 0.5
		_Float8("Float 8", Float) = 0
		_Float1("Float 1", Float) = 1
		[Toggle]_ToggleSwitch0("Toggle Switch0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _TextureSample0;
		uniform float _Float2;
		uniform float _Float3;
		uniform float _Float1;
		uniform float _Float7;
		uniform float _ToggleSwitch0;
		uniform sampler2D _TextureSample1;
		uniform float _Float9;
		uniform float _Float10;
		uniform float _Float8;
		uniform float _Float6;
		uniform float _Float4;
		uniform float4 _Color2;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Float5;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_4 = (_Float5).xxxx;
			return temp_cast_4;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 appendResult27 = (float2(_Float2 , _Float3));
			float2 uv_TexCoord23 = v.texcoord.xy * float2( 3,2 );
			float2 panner25 = ( _Time.y * appendResult27 + uv_TexCoord23);
			float4 temp_cast_0 = (_Float1).xxxx;
			float4 temp_output_68_0 = saturate( ( pow( tex2Dlod( _TextureSample0, float4( ( panner25 + float2( 0,0 ) ), 0, 0.0) ) , temp_cast_0 ) * _Float7 ) );
			float2 appendResult78 = (float2(_Float9 , _Float10));
			float2 panner75 = ( _Time.y * appendResult78 + v.texcoord.xy);
			float temp_output_47_0 = frac( _Time.z );
			float4 temp_cast_1 = (min( (0.0 + (v.texcoord.xy.y - temp_output_47_0) * (1.0 - 0.0) / (( temp_output_47_0 - _Float8 ) - temp_output_47_0)) , (0.0 + (v.texcoord.xy.y - ( temp_output_47_0 - _Float8 )) * (1.0 - 0.0) / (temp_output_47_0 - ( temp_output_47_0 - _Float8 ))) )).xxxx;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( temp_output_68_0 + 0.0 + saturate( ( lerp(tex2Dlod( _TextureSample1, float4( ( panner75 + float2( 0,0 ) ), 0, 0.0) ),temp_cast_1,_ToggleSwitch0) * _Float6 ) ) ) * float4( ase_vertexNormal , 0.0 ) * _Float4 ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult27 = (float2(_Float2 , _Float3));
			float2 uv_TexCoord23 = i.uv_texcoord * float2( 3,2 );
			float2 panner25 = ( _Time.y * appendResult27 + uv_TexCoord23);
			float4 temp_cast_0 = (_Float1).xxxx;
			float4 temp_output_68_0 = saturate( ( pow( tex2D( _TextureSample0, ( panner25 + float2( 0,0 ) ) ) , temp_cast_0 ) * _Float7 ) );
			float4 lerpResult13 = lerp( _Color0 , _Color1 , temp_output_68_0);
			float temp_output_17_0 = ( 1.0 - i.uv_texcoord.y );
			float4 lerpResult84 = lerp( _Color2 , lerpResult13 , saturate( pow( temp_output_17_0 , 0.15 ) ));
			o.Albedo = lerpResult84.rgb;
			o.Emission = lerpResult84.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
-1508;199;1508;734;403.5704;-13.38867;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;80;-1952.614,-305.0871;Inherit;False;Property;_Float9;Float 9;6;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1958.531,-231.57;Inherit;False;Property;_Float10;Float 10;7;0;Create;True;0;0;False;0;-2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1773.654,262.3734;Inherit;False;Property;_Float3;Float 3;5;0;Create;True;0;0;False;0;-4;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1774.354,169.1913;Inherit;False;Property;_Float2;Float 2;4;0;Create;True;0;0;False;0;0.2;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;35;-2840.66,908.1672;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;47;-2424.802,912.666;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-1674.187,-498.8424;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;31;-1568,336;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;78;-1658.187,-290.8424;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-1440,240;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-1456,32;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;3,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;77;-1786.187,-194.8424;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-2157.619,1085.096;Inherit;True;Property;_Float8;Float 8;13;0;Create;True;0;0;False;0;0;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-2003.583,798.3454;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;75;-1402.187,-434.8424;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1994.418,470.1861;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-1860.141,1066.068;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;25;-1184,96;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-903.5007,142.669;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-711.8177,778.6063;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.69;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;50;-661.9664,1102.984;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.69;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-1121.687,-388.1734;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-627.0005,132.6815;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;9fbef4b79ca3b784ba023cb1331520d5;2ea9d207a8146e9458bef3b5a0428d32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-927.0621,-251.3082;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;9fbef4b79ca3b784ba023cb1331520d5;f30239e57841800439c13f685e0ded66;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;51;-312.5691,960.6509;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-569.3642,396.4538;Inherit;False;Property;_Float1;Float 1;14;0;Create;True;0;0;False;0;1;6.96;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;71;-461.3389,140.1706;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.66;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-297.7958,337.994;Inherit;False;Property;_Float7;Float 7;12;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-246.7198,753.0908;Inherit;False;Property;_Float6;Float 6;11;0;Create;True;0;0;False;0;1.69;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;82;-210.229,916.5173;Inherit;True;Property;_ToggleSwitch0;Toggle Switch0;15;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;17;-1036.668,453.2213;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-36.03365,742.951;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-208.0528,145.977;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-178.1972,400.8394;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-534.1602,-86.71907;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;90;-198.1434,41.02167;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;22;-299.4289,445.3327;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;68;-10.76026,141.2565;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-490.8607,-284.519;Inherit;False;Property;_Color0;Color 0;2;0;Create;True;0;0;False;0;0.5235849,0.905601,1,0;0,0.4533175,0.6705883,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;88;-32.26691,3.354023;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;89;-189.0562,-119.4694;Inherit;False;Property;_Color2;Color 2;8;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;64;141.4684,426.3739;Inherit;False;Property;_Float4;Float 4;9;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;41.69489,229.9404;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;13;63.43884,-194.2024;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;62;176.4684,534.3739;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;84;218.9326,-58.414;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;453.9645,419.6323;Inherit;False;Property;_Float5;Float 5;10;0;Create;True;0;0;False;0;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-852.1786,371.2259;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;408.5684,245.074;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;787.0053,-19.99605;Float;False;True;6;ASEMaterialInspector;0;0;Standard;vertex_offset;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;35;3
WireConnection;78;0;80;0
WireConnection;78;1;81;0
WireConnection;27;0;29;0
WireConnection;27;1;30;0
WireConnection;48;0;47;0
WireConnection;48;1;72;0
WireConnection;75;0;76;0
WireConnection;75;2;78;0
WireConnection;75;1;77;2
WireConnection;49;0;47;0
WireConnection;49;1;72;0
WireConnection;25;0;23;0
WireConnection;25;2;27;0
WireConnection;25;1;31;2
WireConnection;24;0;25;0
WireConnection;20;0;15;2
WireConnection;20;1;47;0
WireConnection;20;2;48;0
WireConnection;50;0;15;2
WireConnection;50;1;49;0
WireConnection;50;2;47;0
WireConnection;79;0;75;0
WireConnection;1;1;24;0
WireConnection;74;1;79;0
WireConnection;51;0;20;0
WireConnection;51;1;50;0
WireConnection;71;0;1;0
WireConnection;71;1;73;0
WireConnection;82;0;74;0
WireConnection;82;1;51;0
WireConnection;17;0;15;2
WireConnection;66;0;82;0
WireConnection;66;1;67;0
WireConnection;69;0;71;0
WireConnection;69;1;70;0
WireConnection;90;0;17;0
WireConnection;22;0;66;0
WireConnection;68;0;69;0
WireConnection;88;0;90;0
WireConnection;14;0;68;0
WireConnection;14;1;11;0
WireConnection;14;2;22;0
WireConnection;13;0;3;0
WireConnection;13;1;5;0
WireConnection;13;2;68;0
WireConnection;84;0;89;0
WireConnection;84;1;13;0
WireConnection;84;2;88;0
WireConnection;18;0;15;1
WireConnection;18;1;17;0
WireConnection;63;0;14;0
WireConnection;63;1;62;0
WireConnection;63;2;64;0
WireConnection;0;0;84;0
WireConnection;0;2;84;0
WireConnection;0;11;63;0
WireConnection;0;14;65;0
ASEEND*/
//CHKSM=2AE046551E102FC22F8BBBE0C4536D898632E143