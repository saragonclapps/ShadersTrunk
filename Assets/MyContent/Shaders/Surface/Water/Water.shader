// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/Water/Water OptimaseT"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		[HideInInspector] _DummyTex( "", 2D ) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (0.5294118,0.4941176,0.8392157,1)
		_Normal("Normal", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_Alpha("Alpha", Range( 0 , 1)) = 0.3402344
		_Force("Force", Range( 0 , 1)) = 0
		_Speed("Speed", Range( 0 , 1)) = 1
		_MaxTilling("MaxTilling", Range( 0 , 20)) = 0
		_MinTilling("MinTilling", Range( 0 , 20)) = 0
		_MaxDisplacement("MaxDisplacement", Range( 0 , 0.5)) = 0.1367662
		_MinDisplacement("MinDisplacement", Range( 0 , 0.5)) = 0
		_Tessellation("Tessellation", Range( 0 , 25)) = 25
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend One Zero , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_DummyTex;
		};

		struct appdata
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 texcoord2 : TEXCOORD2;
			float4 texcoord3 : TEXCOORD3;
			fixed4 color : COLOR;
			UNITY_VERTEX_INPUT_INSTANCE_ID
		};

		uniform sampler2D _Normal;
		uniform float _MinTilling;
		uniform float _MaxTilling;
		uniform float _Speed;
		uniform float _Force;
		uniform sampler2D _DummyTex;
		uniform sampler2D _Albedo;
		uniform float4 _Color;
		uniform float _Alpha;
		uniform sampler2D _Noise;
		uniform float _MinDisplacement;
		uniform float _MaxDisplacement;
		uniform float _Tessellation;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			float4 temp_cast_5 = (_Tessellation).xxxx;
			return temp_cast_5;
		}

		void vertexDataFunc( inout appdata v )
		{
			float mulTime2 = _Time.y * _Speed;
			float temp_output_8_0 = ( cos( mulTime2 ) * _Force );
			float2 temp_cast_0 = (( _MinTilling + ( ( _MaxTilling - _MinTilling ) * temp_output_8_0 ) )).xx;
			float2 temp_cast_1 = (temp_output_8_0).xx;
			v.texcoord.xy = v.texcoord.xy * temp_cast_0 + temp_cast_1;
			float4 tex2DNode16 = tex2Dlod( _Albedo, float4( v.texcoord.xy, 0.0 , 0.0 ) );
			v.vertex.xyz += ( tex2DNode16.b * tex2Dlod( _Noise, float4( v.texcoord.xy, 0.0 , 0.0 ) ) * ( _MinDisplacement + ( ( _MaxDisplacement - _MinDisplacement ) * temp_output_8_0 ) ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime2 = _Time.y * _Speed;
			float temp_output_8_0 = ( cos( mulTime2 ) * _Force );
			float2 temp_cast_0 = (( _MinTilling + ( ( _MaxTilling - _MinTilling ) * temp_output_8_0 ) )).xx;
			float2 temp_cast_1 = (temp_output_8_0).xx;
			float2 texCoordDummy14 = i.uv_DummyTex*temp_cast_0 + temp_cast_1;
			o.Normal = tex2D( _Normal, texCoordDummy14 ).rgb;
			float4 tex2DNode16 = tex2D( _Albedo, texCoordDummy14 );
			float4 blendOpSrc25 = _LightColor0;
			float4 blendOpDest25 = ( tex2DNode16 * _Color );
			o.Albedo = ( saturate( ( blendOpDest25 > 0.5 ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest25 - 0.5 ) ) * ( 1.0 - blendOpSrc25 ) ) : ( 2.0 * blendOpDest25 * blendOpSrc25 ) ) )).xyz;
			o.Alpha = _Alpha;
		}

		ENDCG
		CGPROGRAM
		#pragma only_renderers d3d9 d3d11 glcore gles gles3 d3d11_9x 
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
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			# include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD6;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				fixed3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				fixed3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			fixed4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
Version=13101
7;29;1352;692;3100.128;1175.686;3.522379;True;True
Node;AmplifyShaderEditor.RangedFloatNode;1;-2481.065,-189.6364;Float;False;Property;_Speed;Speed;6;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;2;-2145.065,-184.6364;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;6;-2095.482,-33.2643;Float;False;Property;_Force;Force;5;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;3;-2335.878,-413.7167;Float;False;Property;_MaxTilling;MaxTilling;7;0;0;0;20;0;1;FLOAT
Node;AmplifyShaderEditor.CosOpNode;5;-1944.755,-184.1559;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;4;-2262.755,-624.1558;Float;False;Property;_MinTilling;MinTilling;8;0;0;0;20;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1979.124,-407.5528;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1772.482,-184.2643;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1783.124,-354.5528;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;11;-1328.786,859.682;Float;False;Property;_MaxDisplacement;MaxDisplacement;9;0;0.1367662;0;0.5;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;12;-1282.146,728.3766;Float;False;Property;_MinDisplacement;MinDisplacement;10;0;0;0;0.5;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1639.124,-403.5528;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1564.935,-233.8393;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-972.0316,865.8459;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.WireNode;15;-1633.4,851.9393;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;16;-1183.228,-258.8161;Float;True;Property;_Albedo;Albedo;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;17;-814.7553,-185.0456;Float;False;Property;_Color;Color;1;0;0.5294118,0.4941176,0.8392157,1;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-776.0314,918.8459;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;22;-1151.129,421.0175;Float;True;Property;_Noise;Noise;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LightColorNode;20;-524.4541,-371.2888;Float;False;0;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-527.2096,-249.2804;Float;False;2;2;0;FLOAT4;0.0;False;1;COLOR;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-632.0311,869.8459;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-582.9539,233.7585;Float;False;3;3;0;FLOAT;0.0,0,0,0;False;1;FLOAT4;0.0;False;2;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SamplerNode;27;-1183.177,11.1768;Float;True;Property;_Normal;Normal;2;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;23;-437.7145,177.7133;Float;False;Property;_Alpha;Alpha;4;0;0.3402344;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.BlendOpsNode;25;-317.1643,-245.9163;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;26;-448.3403,348.1312;Float;False;Property;_Tessellation;Tessellation;11;0;25;0;25;0;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1,0;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Created/Water/Water OptimaseT;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Back;0;0;False;0;0;Transparent;0.5;True;True;0;False;Transparent;Transparent;All;True;True;True;True;True;False;True;False;False;False;False;False;False;True;True;True;True;False;0;255;255;0;0;0;0;True;0;4;10;25;False;0.5;True;0;Zero;Zero;2;SrcAlpha;OneMinusSrcAlpha;Add;Add;1;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;5;0;2;0
WireConnection;7;0;3;0
WireConnection;7;1;4;0
WireConnection;8;0;5;0
WireConnection;8;1;6;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;10;0;4;0
WireConnection;10;1;9;0
WireConnection;14;0;10;0
WireConnection;14;1;8;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;15;0;8;0
WireConnection;16;1;14;0
WireConnection;18;0;13;0
WireConnection;18;1;15;0
WireConnection;22;1;14;0
WireConnection;19;0;16;0
WireConnection;19;1;17;0
WireConnection;21;0;12;0
WireConnection;21;1;18;0
WireConnection;24;0;16;3
WireConnection;24;1;22;0
WireConnection;24;2;21;0
WireConnection;27;1;14;0
WireConnection;25;0;20;0
WireConnection;25;1;19;0
WireConnection;0;0;25;0
WireConnection;0;1;27;0
WireConnection;0;9;23;0
WireConnection;0;11;24;0
WireConnection;0;14;26;0
ASEEND*/
//CHKSM=53EA90C29EBD379C72709338C4879BFB075027CB