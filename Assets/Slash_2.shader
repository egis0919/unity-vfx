// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Slash_2"
{
	Properties
	{
		_Clamp("Clamp", Range( -1 , 1)) = -1
		_Noise_Y("Noise_Y", Float) = 0
		_Noise_X("Noise_X", Float) = -0.5
		_Noise_Power("Noise_Power", Range( 0 , 1)) = 0.3146538
		[HDR]_Color0("Color 0", Color) = (1,0.7783019,0.7783019,0)
		_Opacity("Opacity", Float) = 1.19
		_Power("Power", Float) = 2.7
		_Mask_Power("Mask_Power", Float) = 4
		_Dissolve("Dissolve", Float) = 1
		_Emission("Emission", Float) = 1.39
		[Toggle(_PARTICLE_ON)] _Particle("Particle", Float) = 0
		_Texture0("Texture 0", 2D) = "white" {}
		_Texture1("Texture 1", 2D) = "white" {}
		[Toggle]_use_v("use_v", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
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
		#pragma shader_feature _PARTICLE_ON
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;
		uniform sampler2D _Texture1;
		uniform float _use_v;
		uniform float _Clamp;
		uniform float _Noise_Power;
		uniform sampler2D _Texture0;
		uniform float _Noise_X;
		uniform float _Noise_Y;
		uniform float4 _Texture0_ST;
		uniform float _Power;
		uniform float _Emission;
		uniform float _Opacity;
		uniform float _Dissolve;
		uniform float _Mask_Power;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float W53 = i.uv2_tex4coord2.z;
			#ifdef _PARTICLE_ON
				float staticSwitch46 = W53;
			#else
				float staticSwitch46 = _Clamp;
			#endif
			float temp_output_3_0 = ( lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_v) + staticSwitch46 );
			float clampResult1 = clamp( temp_output_3_0 , 0.0 , 1.0 );
			float2 appendResult5 = (float2(clampResult1 , i.uv_texcoord.y));
			float clampResult78 = clamp( temp_output_3_0 , 0.0 , 1.0 );
			float2 appendResult70 = (float2(i.uv_texcoord.x , clampResult78));
			float2 appendResult13 = (float2(_Noise_X , _Noise_Y));
			float2 uv0_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 panner11 = ( _Time.y * appendResult13 + uv0_Texture0);
			float4 tex2DNode7 = tex2D( _Texture0, panner11 );
			float4 tex2DNode6 = tex2D( _Texture1, ( lerp(appendResult5,appendResult70,_use_v) + ( _Noise_Power * tex2DNode7.r ) ) );
			float4 temp_cast_0 = (_Power).xxxx;
			float T54 = i.uv2_tex4coord2.w;
			#ifdef _PARTICLE_ON
				float staticSwitch48 = T54;
			#else
				float staticSwitch48 = _Emission;
			#endif
			o.Emission = ( ( pow( ( _Color0 * tex2DNode6 ) , temp_cast_0 ) * staticSwitch48 ) * i.vertexColor ).rgb;
			float V52 = i.uv2_tex4coord2.y;
			#ifdef _PARTICLE_ON
				float staticSwitch47 = V52;
			#else
				float staticSwitch47 = _Opacity;
			#endif
			float U51 = i.uv2_tex4coord2.x;
			#ifdef _PARTICLE_ON
				float staticSwitch49 = ( 1.0 - U51 );
			#else
				float staticSwitch49 = ( 1.0 - _Dissolve );
			#endif
			float temp_output_24_0 = pow( ( lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_v) * ( 1.0 - lerp(i.uv_texcoord.x,i.uv_texcoord.y,_use_v) ) * _Mask_Power ) , _Mask_Power );
			o.Alpha = saturate( ( ( saturate( ( tex2DNode6.r * staticSwitch47 ) ) * saturate( ( ( ( tex2DNode7.r + staticSwitch49 ) + temp_output_24_0 ) * temp_output_24_0 ) ) ) * i.vertexColor.a ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
-1993;492;1906;993;1175.455;426.6153;1.125964;True;True
Node;AmplifyShaderEditor.TexCoordVertexDataNode;50;-885.6338,-515.4507;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-434.0732,-390.0846;Inherit;False;W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-886.0732,155.9154;Inherit;False;53;W;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1046.99,-172.4906;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-703.4956,-54.36492;Inherit;False;Property;_Clamp;Clamp;0;0;Create;True;0;0;False;0;-1;0.017;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;67;-630.7712,-247.2051;Inherit;False;Property;_use_v;use_v;13;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1627.486,460.9591;Inherit;False;Property;_Noise_X;Noise_X;2;0;Create;True;0;0;False;0;-0.5;-0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1622.486,551.9591;Inherit;False;Property;_Noise_Y;Noise_Y;1;0;Create;True;0;0;False;0;0;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;46;-629.5587,40.90285;Inherit;False;Property;_Particle;Particle;10;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-381.0029,-190.8383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;51;-432.0732,-535.0846;Inherit;False;U;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-947.2781,604.9579;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1643.486,315.9591;Inherit;False;0;62;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1416.486,443.9591;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;16;-1461.486,678.9591;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;1;-196,-224.5;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1189.486,346.9591;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;78;-329.0896,59.409;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-565.4212,433.7251;Inherit;False;Property;_Dissolve;Dissolve;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;62;-1149.846,168.3626;Inherit;True;Property;_Texture0;Texture 0;11;0;Create;True;0;0;False;0;None;8150f6f43f753a142bcf05fc6eb8f621;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-600.0732,539.9154;Inherit;False;51;U;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;71;-616.5041,632.2847;Inherit;False;Property;_use_v;use_v;12;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-253.278,961.9581;Inherit;False;Property;_Mask_Power;Mask_Power;7;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-43.661,103.608;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;38,-8.5;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-503.9769,256.3649;Inherit;False;Property;_Noise_Power;Noise_Power;3;0;Create;True;0;0;False;0;0.3146538;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;-414.278,705.9579;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;-410.1621,440.0562;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-430.1899,553.2967;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-848.3054,340.8919;Inherit;True;Property;_Noise;Noise;2;0;Create;True;0;0;False;0;55190433fa6a8b942ad179dcc3ace216;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;68;166.2288,80.79492;Inherit;False;Property;_use_v;use_v;15;0;Create;True;0;0;False;0;1;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;49;-259.1979,455.6618;Inherit;False;Property;_Particle;Particle;13;0;Create;False;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-69.75562,234.3071;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-439.0732,-463.0846;Inherit;False;V;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-152.278,618.9579;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;383.3137,293.6853;Inherit;False;Property;_Opacity;Opacity;5;0;Create;True;0;0;False;0;1.19;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;66;187.0937,-171.6039;Inherit;True;Property;_Texture1;Texture 1;12;0;Create;True;0;0;False;0;None;3168448258718da4883d5171842babf0;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;374.2444,72.30707;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-44.975,405.109;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;24;104.722,665.9579;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;379.3121,379.4501;Inherit;False;52;V;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;509,-24.60808;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;3168448258718da4883d5171842babf0;3168448258718da4883d5171842babf0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;47;645.286,337.0393;Inherit;False;Property;_Particle;Particle;11;0;Create;False;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;368.7222,488.1377;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-442.0732,-315.0846;Inherit;False;T;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;588.7219,582.9579;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;404.7437,-345.0204;Inherit;False;Property;_Color0;Color 0;4;1;[HDR];Create;True;0;0;False;0;1,0.7783019,0.7783019,0;1.414214,1.414214,1.414214,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;904.314,217.6853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;802.5082,-109.562;Inherit;False;Property;_Power;Power;6;0;Create;True;0;0;False;0;2.7;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;720.9437,-271.1204;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;958.7433,-22.22041;Inherit;False;Property;_Emission;Emission;9;0;Create;True;0;0;False;0;1.39;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;30;898.827,432.3003;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;927.7245,60.93477;Inherit;False;54;T;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;76;1057.434,209.7318;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;48;1129.568,-25.14333;Inherit;False;Property;_Particle;Particle;12;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;1195.415,216.4851;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;60;1358.816,-0.2467098;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;43;899.4436,-313.5204;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1627.918,194.0115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;1200.344,-372.3204;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;77;1785.983,196.4063;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;1528.918,-116.9885;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2024.38,-15.1195;Float;False;True;2;ASEMaterialInspector;0;0;Unlit;Slash_2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;50;3
WireConnection;67;0;2;1
WireConnection;67;1;2;2
WireConnection;46;1;4;0
WireConnection;46;0;57;0
WireConnection;3;0;67;0
WireConnection;3;1;46;0
WireConnection;51;0;50;1
WireConnection;13;0;14;0
WireConnection;13;1;15;0
WireConnection;1;0;3;0
WireConnection;11;0;12;0
WireConnection;11;2;13;0
WireConnection;11;1;16;2
WireConnection;78;0;3;0
WireConnection;71;0;20;1
WireConnection;71;1;20;2
WireConnection;70;0;2;1
WireConnection;70;1;78;0
WireConnection;5;0;1;0
WireConnection;5;1;2;2
WireConnection;21;0;71;0
WireConnection;63;0;29;0
WireConnection;64;0;55;0
WireConnection;7;0;62;0
WireConnection;7;1;11;0
WireConnection;68;0;5;0
WireConnection;68;1;70;0
WireConnection;49;1;63;0
WireConnection;49;0;64;0
WireConnection;18;0;19;0
WireConnection;18;1;7;1
WireConnection;52;0;50;2
WireConnection;22;0;71;0
WireConnection;22;1;21;0
WireConnection;22;2;23;0
WireConnection;17;0;68;0
WireConnection;17;1;18;0
WireConnection;31;0;7;1
WireConnection;31;1;49;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;6;0;66;0
WireConnection;6;1;17;0
WireConnection;47;1;37;0
WireConnection;47;0;56;0
WireConnection;34;0;31;0
WireConnection;34;1;24;0
WireConnection;54;0;50;4
WireConnection;25;0;34;0
WireConnection;25;1;24;0
WireConnection;36;0;6;1
WireConnection;36;1;47;0
WireConnection;39;0;40;0
WireConnection;39;1;6;0
WireConnection;30;0;25;0
WireConnection;76;0;36;0
WireConnection;48;1;44;0
WireConnection;48;0;58;0
WireConnection;38;0;76;0
WireConnection;38;1;30;0
WireConnection;43;0;39;0
WireConnection;43;1;45;0
WireConnection;61;0;38;0
WireConnection;61;1;60;4
WireConnection;42;0;43;0
WireConnection;42;1;48;0
WireConnection;77;0;61;0
WireConnection;59;0;42;0
WireConnection;59;1;60;0
WireConnection;0;2;59;0
WireConnection;0;9;77;0
ASEEND*/
//CHKSM=11AE4C983CA6179A2A31B1073534C59DD37C3C1A