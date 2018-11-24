// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/Toon/CelShadingProTriplanar"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,1)
		_ASEOutlineWidth( "Outline Width", Float ) = 0.01
		_RightTexture("Right Texture", 2D) = "white" {}
		_RightForce("RightForce", Range( -1 , 0)) = -0.4234252
		_ColorRight("ColorRight", Color) = (1,0,0,0)
		_FrontTexture("Front Texture", 2D) = "white" {}
		_TopForce("TopForce", Range( -1 , 0)) = -1
		_ColorTop("ColorTop", Color) = (0.2413793,1,0,0)
		_FrontForce("FrontForce", Range( -1 , 0)) = -1
		_ColorFront("ColorFront", Color) = (0,0.04827571,1,0)
		_Tilling("Tilling", Float) = 1
		_FallOff("Fall Off", Float) = 0
		_TopTexture("Top Texture", 2D) = "white" {}
		[Header(SoftToon)]
		_Cutofblend("Cut of blend", Range( 0.01 , 3)) = 0.01
		_Cutoffangle("Cut off angle", Range( -1 , 1)) = -0.2537299
		_ShadowTexture("ShadowTexture", 2D) = "white" {}
		_TillingShadow("TillingShadow", Float) = 120
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:outlineVertexDataFunc
		uniform fixed4 _ASEOutlineColor;
		uniform fixed _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline fixed4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return fixed4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o ) { o.Emission = _ASEOutlineColor.rgb; o.Alpha = 1; }
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
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
			float2 texcoord_0;
		};

		uniform sampler2D _RightTexture;
		uniform float _Tilling;
		uniform float _FallOff;
		uniform float _RightForce;
		uniform float4 _ColorRight;
		uniform sampler2D _TopTexture;
		uniform float _TopForce;
		uniform float4 _ColorTop;
		uniform sampler2D _FrontTexture;
		uniform float _FrontForce;
		uniform float4 _ColorFront;
		uniform float _Cutoffangle;
		uniform fixed _Cutofblend;
		uniform sampler2D _ShadowTexture;
		uniform float _TillingShadow;


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (_TillingShadow).xx;
			o.texcoord_0.xy = v.texcoord.xy * temp_cast_0 + float2( 0,0 );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar334 = TriplanarSampling( _RightTexture, _RightTexture, _RightTexture, ase_worldPos, ase_worldNormal, _FallOff, _Tilling, 0 );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 temp_cast_0 = (( ase_vertexNormal.x * _RightForce )).xxxx;
			float4 triplanar348 = TriplanarSampling( _TopTexture, _TopTexture, _TopTexture, ase_worldPos, ase_worldNormal, _FallOff, _Tilling, 0 );
			float4 temp_cast_2 = (( ase_vertexNormal.y * _TopForce )).xxxx;
			float4 triplanar336 = TriplanarSampling( _FrontTexture, _FrontTexture, _FrontTexture, ase_worldPos, ase_worldNormal, _FallOff, _Tilling, 0 );
			float4 temp_cast_4 = (( ase_vertexNormal.z * _FrontForce )).xxxx;
			float4 temp_cast_6 = (1.0).xxxx;
			float3 linearToGamma305 = LinearToGammaSpace( min( ( ( ( triplanar334 - temp_cast_0 ) * _ColorRight ) + ( ( triplanar348 - temp_cast_2 ) * _ColorTop ) + ( ( triplanar336 - temp_cast_4 ) * _ColorFront ) ) , temp_cast_6 ).xyz );
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_objectlightDir = normalize( ObjSpaceLightDir( ase_vertex4Pos ) );
			float dotResult12_g2 = dot( -ase_objectlightDir , ase_vertexNormal );
			float temp_output_14_0_g2 = smoothstep( ( _Cutoffangle + _Cutofblend ) , ( _Cutoffangle - _Cutofblend ) , dotResult12_g2 );
			float3 blendOpSrc114 = linearToGamma305;
			float4 blendOpDest114 = ( ( _LightColor0 * temp_output_14_0_g2 ) + ( ( _LightColor0 * tex2D( _ShadowTexture, i.texcoord_0 ) ) * ( 1.0 - temp_output_14_0_g2 ) * _LightColor0 * 0.2337242 ) );
			o.Emission = ( ( blendOpSrc114 * blendOpDest114 ) / 1.0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
7;54;1352;653;1757.614;340.1656;1;True;True
Node;AmplifyShaderEditor.NormalVertexDataNode;329;-2628.207,-540.3943;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;324;-2705.201,9.18273;Float;False;Property;_TopForce;TopForce;4;0;-1;-1;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;331;-3302.641,-225.962;Float;False;Property;_FallOff;Fall Off;9;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;328;-3303.641,-319.4619;Float;False;Property;_Tilling;Tilling;8;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;325;-2633.787,-128.7951;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;327;-2701.682,441.6135;Float;False;Property;_FrontForce;FrontForce;6;0;-1;-1;0;0;1;FLOAT
Node;AmplifyShaderEditor.NormalVertexDataNode;326;-2669.84,295.6052;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;330;-2652.644,-407.8735;Float;False;Property;_RightForce;RightForce;1;0;-0.4234252;-1;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;-2371.042,-79.99091;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;348;-2722.936,-327.2456;Float;True;Spherical;World;False;Top Texture;_TopTexture;white;10;None;Mid Texture 0;_MidTexture0;white;11;None;Bot Texture 0;_BotTexture0;white;12;None;TOP;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;334;-2590.69,-731.1086;Float;True;Spherical;World;False;Right Texture;_RightTexture;white;0;None;Mid Texture 1;_MidTexture1;white;7;None;Bot Texture 1;_BotTexture1;white;8;None;RIGHT;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-2333.836,-513.7039;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-2377.874,369.783;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.TriplanarNode;336;-2604.56,115.2506;Float;True;Spherical;World;False;Front Texture;_FrontTexture;white;3;None;Mid Texture 3;_MidTexture3;white;8;None;Bot Texture 3;_BotTexture3;white;9;None;FRONT;5;0;SAMPLER2D;;False;1;SAMPLER2D;;False;2;SAMPLER2D;;False;3;FLOAT;1.0;False;4;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;343;-2186.887,-104.195;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;338;-2188.04,346.1052;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.ColorNode;339;-2202.641,-426.2946;Float;False;Property;_ColorRight;ColorRight;2;0;1,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;342;-2222.52,41.40461;Float;False;Property;_ColorTop;ColorTop;5;0;0.2413793,1,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.ColorNode;341;-2247.84,479.155;Float;False;Property;_ColorFront;ColorFront;7;0;0,0.04827571,1,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleSubtractOpNode;340;-2183.208,-594.8943;Float;False;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;344;-1980.141,-532.9944;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-1970.721,-35.79538;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;346;-1988.441,399.8552;Float;False;2;2;0;FLOAT4;0.0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.SimpleAddOpNode;347;-1589.141,-188.5949;Float;True;3;3;0;FLOAT4;0.0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.RangedFloatNode;317;-1281.852,-31.66311;Float;False;Constant;_Saturation;Saturation;6;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMinNode;316;-965.8523,-187.6631;Float;True;2;0;FLOAT4;0.0;False;1;FLOAT;0,0,0,0;False;1;FLOAT4
Node;AmplifyShaderEditor.LinearToGammaNode;305;-690.5583,-186.8389;Float;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.FunctionNode;350;-511.675,104.9164;Float;False;SoftToon;11;;2;0;1;COLOR
Node;AmplifyShaderEditor.CommentaryNode;119;-67.79566,-239.2972;Float;False;445.5153;236.875;ASE dobles all your emission color automatically;2;120;121;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;114;-337.1093,-190.586;Float;False;Multiply;False;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;120;-36.6089,-103.0316;Float;False;Constant;_EmissionDivider;EmissionDivider;3;0;1;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;121;231.638,-181.9316;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;488.8998,-232.2999;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Created/Toon/CelShadingProTriplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;True;0.01;0,0,0,1;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;118;-369.5091,-230.7858;Float;False;246.2002;151.3;Screen;0;;1,1,1,1;0;0
WireConnection;337;0;325;2
WireConnection;337;1;324;0
WireConnection;348;3;328;0
WireConnection;348;4;331;0
WireConnection;334;3;328;0
WireConnection;334;4;331;0
WireConnection;332;0;329;1
WireConnection;332;1;330;0
WireConnection;335;0;326;3
WireConnection;335;1;327;0
WireConnection;336;3;328;0
WireConnection;336;4;331;0
WireConnection;343;0;348;0
WireConnection;343;1;337;0
WireConnection;338;0;336;0
WireConnection;338;1;335;0
WireConnection;340;0;334;0
WireConnection;340;1;332;0
WireConnection;344;0;340;0
WireConnection;344;1;339;0
WireConnection;345;0;343;0
WireConnection;345;1;342;0
WireConnection;346;0;338;0
WireConnection;346;1;341;0
WireConnection;347;0;344;0
WireConnection;347;1;345;0
WireConnection;347;2;346;0
WireConnection;316;0;347;0
WireConnection;316;1;317;0
WireConnection;305;0;316;0
WireConnection;114;0;305;0
WireConnection;114;1;350;0
WireConnection;121;0;114;0
WireConnection;121;1;120;0
WireConnection;0;2;121;0
ASEEND*/
//CHKSM=EB5AA99093C18547CA85FA26C1417107AAB868A3