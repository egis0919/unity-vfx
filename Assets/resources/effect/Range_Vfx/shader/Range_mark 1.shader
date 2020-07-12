// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "rage_mark"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		_Mask_tex("Mask_tex", 2D) = "white" {}
		_Speed("Speed", Float) = 2
		_Power("Power", Float) = 3.88
		_HDR("HDR", Float) = 0
		_Bias("Bias", Float) = 0
		_Scale("Scale", Float) = 1.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _HDR;
		uniform sampler2D _Mask_tex;
		uniform float _Speed;
		uniform float _Power;
		uniform float _Bias;
		uniform float _Scale;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 temp_output_2_0 = ( i.vertexColor * tex2DNode1 * _HDR );
			o.Albedo = temp_output_2_0.rgb;
			o.Emission = temp_output_2_0.rgb;
			float cos11 = cos( ( _Speed * _Time.y ) );
			float sin11 = sin( ( _Speed * _Time.y ) );
			float2 rotator11 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos11 , -sin11 , sin11 , cos11 )) + float2( 0.5,0.5 );
			float4 temp_cast_2 = (_Power).xxxx;
			o.Alpha = ( tex2DNode1 * pow( tex2D( _Mask_tex, rotator11 ) , temp_cast_2 ) * ( ( distance( i.uv_texcoord , float2( 0.5,0.5 ) ) + _Bias ) * _Scale ) * i.vertexColor.a ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
-1913;32;1906;987;1185.7;523.9185;1.3;True;True
Node;AmplifyShaderEditor.TimeNode;12;-1178.826,472.6434;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-1073.409,368.5835;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-979.9568,222.3284;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-771.4092,387.5835;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;11;-583.8821,295.758;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-281.1964,251.5703;Float;False;Property;_Scale;Scale;6;0;Create;True;0;0;False;0;1.5;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-270.7962,163.1702;Float;False;Property;_Bias;Bias;5;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-318.8522,352.6923;Inherit;True;Property;_Mask_tex;Mask_tex;1;0;Create;True;0;0;False;0;0777ecfa8cc97cc4ab643f6491b61798;0777ecfa8cc97cc4ab643f6491b61798;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;22;-473.5966,105.9702;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-167.4092,583.8831;Float;False;Property;_Power;Power;3;0;Create;True;0;0;False;0;3.88;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;16;41.79081,318.0835;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;3;-124,-278;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;25;-117.3963,131.9702;Inherit;True;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-591.0358,-96.79778;Inherit;True;Property;_MainTex;Main Tex;0;0;Create;True;0;0;False;0;None;6b58f139fc5d29740817d6afe34ac117;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;1.703739,-53.52972;Float;False;Property;_HDR;HDR;4;0;Create;True;0;0;False;0;0;15.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;334.2435,84.81997;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;183,-130;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;663.2999,-90.5;Float;False;True;2;ASEMaterialInspector;0;0;Standard;rage_mark;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;20;0
WireConnection;19;1;12;2
WireConnection;11;0;10;0
WireConnection;11;2;19;0
WireConnection;9;1;11;0
WireConnection;22;0;10;0
WireConnection;16;0;9;0
WireConnection;16;1;18;0
WireConnection;25;3;22;0
WireConnection;25;1;26;0
WireConnection;25;2;27;0
WireConnection;4;0;1;0
WireConnection;4;1;16;0
WireConnection;4;2;25;0
WireConnection;4;3;3;4
WireConnection;2;0;3;0
WireConnection;2;1;1;0
WireConnection;2;2;28;0
WireConnection;0;0;2;0
WireConnection;0;2;2;0
WireConnection;0;9;4;0
ASEEND*/
//CHKSM=2441505764BC5B7DCE986431407970579162152A