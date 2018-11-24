// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/Triplanar"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_RightTexture("Right Texture", 2D) = "white" {}
		_RightForce("RightForce", Range( -1 , 0)) = -1
		_ColorRight("ColorRight", Color) = (1,0,0,0)
		_TopTexture("Top Texture", 2D) = "white" {}
		_TopForce("TopForce", Range( -1 , 0)) = -1
		_ColorTop("ColorTop", Color) = (0.2413793,1,0,0)
		_FrontTexture("Front Texture", 2D) = "white" {}
		_FrontForce("FrontForce", Range( -1 , 0)) = -1
		_ColorFront("ColorFront", Color) = (0,0.04827571,1,0)
		_Tiling("Tiling", Float) = 1
		_FallOff("FallOff", Float) = 0
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
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
		};

		uniform sampler2D _RightTexture;
		uniform float _Tiling;
		uniform float _FallOff;
		uniform float _RightForce;
		uniform float4 _ColorRight;
		uniform sampler2D _TopTexture;
		uniform float _TopForce;
		uniform float4 _ColorTop;
		uniform sampler2D _FrontTexture;
		uniform float _FrontForce;
		uniform float4 _ColorFront;


		inline float4 TriplanarSampling( sampler2D topTexMap, sampler2D midTexMap, sampler2D botTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float vertex )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			if(vertex == 1){
			xNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.zy * float2( nsign.x, 1.0 )).xy,0,0) ) );
			yNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.zx).xy,0,0) ) );
			zNorm = ( tex2Dlod( topTexMap, float4((tilling * worldPos.xy * float2( -nsign.z, 1.0 )).xy,0,0) ) );
			} else {
			xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( topTexMap, tilling * worldPos.zx ) );
			zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			}
			return xNorm* projNormal.x + yNorm* projNormal.y + zNorm* projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar41 = TriplanarSampling( _RightTexture, _RightTexture, _RightTexture, ase_worldPos, ase_worldNormal, _FallOff, _Tiling, 0 );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 temp_cast_0 = (( ase_vertexNormal.x * _RightForce )).xxxx;
			float4 triplanar45 = TriplanarSampling( _TopTexture, _TopTexture, _TopTexture, ase_worldPos, ase_worldNormal, _FallOff, _Tiling, 0 );
			float4 temp_cast_2 = (( ase_vertexNormal.y * _TopForce )).xxxx;
			float4 triplanar40 = TriplanarSampling( _FrontTexture, _FrontTexture, _FrontTexture, ase_worldPos, ase_worldNormal, _FallOff, _Tiling, 0 );
			float4 temp_cast_4 = (( ase_vertexNormal.z * _FrontForce )).xxxx;
			o.Albedo = ( ( ( triplanar41 - temp_cast_0 ) * _ColorRight ) + ( ( triplanar45 - temp_cast_2 ) * _ColorTop ) + ( ( triplanar40 - temp_cast_4 ) * _ColorFront ) ).xyz;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
7;54;1352;653;705.8831;307.8673;1;True;True
Node;AmplifyShaderEditor.NormalVertexDataNode;11;-1362.856,-325.816;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;5;-2038.29,-104.8834;Float;False;Property;_Tiling;Tiling;9;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;6;-2037.29,-11.38347;Float;False;Property;_FallOff;FallOff;10;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;53;-1387.293,-193.295;Float;False;Property;_RightForce;RightForce;1;0;-1;-1;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;51;-1436.331,656.1921;Float;False;Property;_FrontForce;FrontForce;7;0;-1;-1;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;56;-1439.85,223.7612;Float;False;Property;_TopForce;TopForce;4;0;-1;-1;0;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;10;-1368.436,85.7834;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;9;-1404.489,510.1837;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-1112.523,584.3616;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;40;-1339.209,329.8291;Float;True;Spherical;World;False;Front Texture;_FrontTexture;white;6;None;Mid Texture 3;_MidTexture3;white;8;None;Bot Texture 3;_BotTexture3;white;9;None;FRONT;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1105.691,134.5876;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;41;-1326.639,-516.5302;Float;True;Spherical;World;False;Right Texture;_RightTexture;white;0;None;Mid Texture 0;_MidTexture0;white;7;None;Bot Texture 0;_BotTexture0;white;8;None;RIGHT;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-1068.485,-299.1255;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;45;-1328.201,-97.79123;Float;True;Spherical;World;False;Top Texture;_TopTexture;white;3;None;Mid Texture 0;_MidTexture0;white;8;None;Bot Texture 0;_BotTexture0;white;9;None;TOP;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;17;-982.4885,693.7335;Float;False;Property;_ColorFront;ColorFront;8;0;0,0.04827571,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;15;-957.1691,255.9831;Float;False;Property;_ColorTop;ColorTop;5;0;0.2413793,1,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-921.5355,110.3835;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;14;-917.8561,-380.316;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-922.689,560.6837;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ColorNode;18;-937.2894,-211.7161;Float;False;Property;_ColorRight;ColorRight;2;0;1,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-705.3693,178.7831;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-723.0889,614.4337;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-714.7891,-318.4161;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-323.7891,25.98361;Float;True;3;3;0;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;17,25;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Created/Triplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;9;3
WireConnection;52;1;51;0
WireConnection;40;3;5;0
WireConnection;40;4;6;0
WireConnection;49;0;10;2
WireConnection;49;1;56;0
WireConnection;41;3;5;0
WireConnection;41;4;6;0
WireConnection;54;0;11;1
WireConnection;54;1;53;0
WireConnection;45;3;5;0
WireConnection;45;4;6;0
WireConnection;13;0;45;0
WireConnection;13;1;49;0
WireConnection;14;0;41;0
WireConnection;14;1;54;0
WireConnection;16;0;40;0
WireConnection;16;1;52;0
WireConnection;21;0;13;0
WireConnection;21;1;15;0
WireConnection;19;0;16;0
WireConnection;19;1;17;0
WireConnection;20;0;14;0
WireConnection;20;1;18;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;22;2;19;0
WireConnection;0;0;22;0
ASEEND*/
//CHKSM=CC2727F2E88488393D38E1A243B0D3F3619EABB1