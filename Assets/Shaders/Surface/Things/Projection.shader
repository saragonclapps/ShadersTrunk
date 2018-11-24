// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/Things/Projection"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		[HideInInspector] _DummyTex( "", 2D ) = "white" {}
		_TextureColor("TextureColor", 2D) = "white" {}
		_Transition("Transition", 2D) = "white" {}
		_SpeedAnimation("Speed Animation", Range( 0.1 , 20)) = 0
		_SpeedTexture("Speed Texture", Range( 0 , 20)) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 1
		_ScaleNoise("ScaleNoise", Range( 0 , 10)) = 1
		_Tilling("Tilling", Float) = 1
		_Tesselation("Tesselation", Range( 0.1 , 32)) = 0
		_TextureNoise("Texture Noise", 2D) = "white" {}
		_RimForce("RimForce", Range( 0 , 1)) = 0
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
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform sampler2D _TextureColor;
		uniform float _SpeedTexture;
		uniform float _RimForce;
		uniform sampler2D _Transition;
		uniform float _Tilling;
		uniform float _SpeedAnimation;
		uniform sampler2D _DummyTex;
		uniform float _Alpha;
		uniform sampler2D _TextureNoise;
		uniform float _ScaleNoise;
		uniform float _Tesselation;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			float4 temp_cast_4 = (_Tesselation).xxxx;
			return temp_cast_4;
		}

		void vertexDataFunc( inout appdata v )
		{
			float2 temp_cast_0 = (_Time.y).xx;
			v.texcoord.xy = v.texcoord.xy * float2( 1,1 ) + temp_cast_0;
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( tex2Dlod( _TextureNoise, float4( v.texcoord.xy, 0.0 , 0.0 ) ) * float4( ( ase_vertexNormal * _ScaleNoise ) , 0.0 ) ).xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float mulTime46 = _Time.y * _SpeedTexture;
			o.Emission = tex2D( _TextureColor, (abs( float2( 0,0 )+mulTime46 * float2(1,1 ))) ).xyz;
			float3 worldViewDir = normalize( UnityWorldSpaceViewDir( i.worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelFinalVal67 = (0.0 + 1.0*pow( 1.0 - dot( ase_worldNormal, worldViewDir ) , 5.0));
			float2 temp_cast_1 = (_Tilling).xx;
			float mulTime1 = _Time.y * _SpeedAnimation;
			float2 temp_cast_2 = (mulTime1).xx;
			float2 texCoordDummy8 = i.uv_DummyTex*temp_cast_1 + temp_cast_2;
			float2 temp_cast_3 = (texCoordDummy8.y).xx;
			o.Alpha = ( ( ( ( _RimForce * 1.0 ) * fresnelFinalVal67 ) + tex2D( _Transition, temp_cast_3 ) ) * _Alpha ).x;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				fixed3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
7;29;1352;692;1711.055;605.447;2.436989;True;True
Node;AmplifyShaderEditor.RangedFloatNode;2;-1533.865,252.3055;Float;False;Property;_SpeedAnimation;Speed Animation;2;0;0;0.1;20;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;34;-1158.972,350.0003;Float;False;Property;_Tilling;Tilling;6;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1186.864,257.3055;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;72;-581.463,-322.7765;Float;True;Constant;_Float0;Float 0;11;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;71;-578.3025,-417.6683;Float;False;Property;_RimForce;RimForce;9;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-951.5649,211.6757;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;63;-730.5366,715.1525;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;47;-1475.36,46.70706;Float;False;Property;_SpeedTexture;Speed Texture;3;0;0;0;20;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-257.3025,-358.6683;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.FresnelNode;67;-307.955,-236.0514;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;5.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;6;-592.2631,228.7764;Float;True;Property;_Transition;Transition;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;50;-266.5852,811.637;Float;False;Property;_ScaleNoise;ScaleNoise;5;0;1;0;10;0;1;FLOAT
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-419.0156,547.9363;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;49;-200.1874,655.9779;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-70.30249,-305.6683;Float;True;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;46;-1199.36,52.70706;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;53;53.31629,530.3712;Float;True;Property;_TextureNoise;Texture Noise;8;0;Assets/Shaders/Textures/Noise.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;43;-603.824,449.2477;Float;False;Property;_Alpha;Alpha;4;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.PannerNode;37;-875.5681,33.18829;Float;False;1;1;2;0;FLOAT2;0,0;False;1;FLOAT;0.0;False;1;FLOAT2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;81.11534,742.1371;Float;True;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-210.7105,147.164;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;FLOAT4;0.0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;424.8155,653.1675;Float;True;2;2;0;FLOAT4;0.0;False;1;FLOAT3;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;52;18.5116,391.5117;Float;False;Property;_Tesselation;Tesselation;7;0;0;0.1;32;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;35;-590.5681,6.188293;Float;True;Property;_TextureColor;TextureColor;0;0;Assets/Shaders/Textures/Gradient.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-181.5804,251.7662;Float;True;2;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;493.0311,-11.28984;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Created/Things/Projection;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;0;False;0;0;Transparent;0.5;True;True;0;False;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;True;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;2;0
WireConnection;8;0;34;0
WireConnection;8;1;1;0
WireConnection;70;0;71;0
WireConnection;70;1;72;0
WireConnection;6;1;8;2
WireConnection;60;1;63;0
WireConnection;69;0;70;0
WireConnection;69;1;67;0
WireConnection;46;0;47;0
WireConnection;53;1;60;0
WireConnection;37;1;46;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;73;0;69;0
WireConnection;73;1;6;0
WireConnection;54;0;53;0
WireConnection;54;1;51;0
WireConnection;35;1;37;0
WireConnection;42;0;73;0
WireConnection;42;1;43;0
WireConnection;0;2;35;0
WireConnection;0;9;42;0
WireConnection;0;11;54;0
WireConnection;0;14;52;0
ASEEND*/
//CHKSM=75F357F8FF85F8D4AAD4F18469C09720AF2FD551