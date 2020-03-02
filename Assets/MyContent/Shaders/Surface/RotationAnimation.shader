// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/RotationAnimation"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_TextureAlbedo("Texture Albedo", 2D) = "white" {}
		_ValueAnim("ValueAnim", Range( 0 , 1)) = 1
		_Tesselation("Tesselation", Range( 0 , 32)) = 1
		_Displacement("Displacement", Range( -5 , 5)) = 0
		_Radius("Radius", Range( 0 , 5)) = 1.608516
		_Speed("Speed", Range( 0 , 5)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
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

		uniform sampler2D _TextureAlbedo;
		uniform float4 _TextureAlbedo_ST;
		uniform float _Displacement;
		uniform float _Speed;
		uniform float _Radius;
		uniform float _ValueAnim;
		uniform float _Tesselation;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			float4 temp_cast_0 = (_Tesselation).xxxx;
			return temp_cast_0;
		}

		void vertexDataFunc( inout appdata v )
		{
			float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex);
			float3 appendResult125 = (float3(( ase_worldPos.x * 0.0 ) , ( ase_worldPos.y * _Displacement ) , ( ase_worldPos.z * 0.0 )));
			float mulTime99 = _Time.y * _Speed;
			float3 appendResult57 = (float3(( sin( mulTime99 ) * _Radius ) , 0.0 , ( cos( mulTime99 ) * _Radius )));
			v.vertex.xyz += ( ( appendResult125 + appendResult57 ) * _ValueAnim );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureAlbedo = i.uv_texcoord * _TextureAlbedo_ST.xy + _TextureAlbedo_ST.zw;
			o.Albedo = tex2D( _TextureAlbedo, uv_TextureAlbedo ).xyz;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13101
7;33;1352;653;3236.661;856.3073;3.553906;True;True
Node;AmplifyShaderEditor.CommentaryNode;156;-2209.356,39.85578;Float;False;1231.784;429.8876;Rotation;9;100;99;103;96;97;102;101;109;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-2159.356,252.4274;Float;False;Property;_Speed;Speed;5;0;1;0;5;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleTimeNode;99;-1860.356,258.4274;Float;False;1;0;FLOAT;1.0;False;1;FLOAT
Node;AmplifyShaderEditor.CommentaryNode;155;-1935.821,-359.5314;Float;False;957.005;373.2436;Displacement;6;136;125;127;126;113;135;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosOpNode;97;-1569.407,337.4505;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SinOpNode;96;-1572.407,218.4504;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;103;-1718.699,129.9158;Float;False;Property;_Radius;Radius;4;0;1.608516;0;5;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;135;-1885.821,-185.7256;Float;False;Property;_Displacement;Displacement;3;0;0;-5;5;0;1;FLOAT
Node;AmplifyShaderEditor.WorldPosInputsNode;113;-1623.088,-309.5314;Float;False;0;4;FLOAT3;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1368.847,221.8221;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;-1368.352,336.7435;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1366.545,-287.7787;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1368.748,-119.2878;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-1367.821,-203.7256;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;109;-1367.84,89.85578;Float;False;Constant;_Y;Y;5;0;0;0;0;0;1;FLOAT
Node;AmplifyShaderEditor.DynamicAppendNode;125;-1145.816,-199.8509;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.DynamicAppendNode;57;-1144.572,263.5533;Float;False;FLOAT3;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT3
Node;AmplifyShaderEditor.SimpleAddOpNode;114;-853.3326,114.2622;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.RangedFloatNode;72;-1227.541,514.8063;Float;False;Property;_ValueAnim;ValueAnim;1;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-628.3426,243.7574;Float;False;2;2;0;FLOAT3;0.0;False;1;FLOAT;0.0,0,0;False;1;FLOAT3
Node;AmplifyShaderEditor.SamplerNode;1;-409,-30;Float;True;Property;_TextureAlbedo;Texture Albedo;0;0;Assets/Shaders/Textures/TexLava.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;2;-372.6841,415.8529;Float;False;Property;_Tesselation;Tesselation;2;0;1;0;32;0;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Created/RotationAnimation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;True;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;99;0;100;0
WireConnection;97;0;99;0
WireConnection;96;0;99;0
WireConnection;101;0;96;0
WireConnection;101;1;103;0
WireConnection;102;0;97;0
WireConnection;102;1;103;0
WireConnection;126;0;113;1
WireConnection;127;0;113;3
WireConnection;136;0;113;2
WireConnection;136;1;135;0
WireConnection;125;0;126;0
WireConnection;125;1;136;0
WireConnection;125;2;127;0
WireConnection;57;0;101;0
WireConnection;57;1;109;0
WireConnection;57;2;102;0
WireConnection;114;0;125;0
WireConnection;114;1;57;0
WireConnection;106;0;114;0
WireConnection;106;1;72;0
WireConnection;0;0;1;0
WireConnection;0;11;106;0
WireConnection;0;14;2;0
ASEEND*/
//CHKSM=9D91793B993713C19696A20C9062E80987F39DC6