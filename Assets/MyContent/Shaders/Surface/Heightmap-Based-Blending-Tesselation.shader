// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/Heightmap-Based-Blending-Tesselation"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_TextureAAlbedo("Texture A Albedo", 2D) = "white" {}
		_TextureBAlbedo("Texture B Albedo", 2D) = "white" {}
		_TextureANormal("Texture A Normal", 2D) = "white" {}
		_TextureBNormal("Texture B Normal", 2D) = "white" {}
		_TextureAOcclusion("Texture A Occlusion", 2D) = "white" {}
		_TextureBOcclusion("Texture B Occlusion", 2D) = "white" {}
		_BlendHeightmap("Blend Heightmap", 2D) = "white" {}
		_Tessellation("Tessellation", Range( 0.001 , 32)) = 0
		_Displacement("Displacement", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
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

		uniform sampler2D _TextureANormal;
		uniform float4 _TextureANormal_ST;
		uniform sampler2D _TextureBNormal;
		uniform float4 _TextureBNormal_ST;
		uniform sampler2D _BlendHeightmap;
		uniform float4 _BlendHeightmap_ST;
		uniform sampler2D _TextureAAlbedo;
		uniform float4 _TextureAAlbedo_ST;
		uniform sampler2D _TextureBAlbedo;
		uniform float4 _TextureBAlbedo_ST;
		uniform sampler2D _TextureAOcclusion;
		uniform float4 _TextureAOcclusion_ST;
		uniform sampler2D _TextureBOcclusion;
		uniform float4 _TextureBOcclusion_ST;
		uniform float _Displacement;
		uniform float _Tessellation;

		float4 tessFunction( appdata v0, appdata v1, appdata v2 )
		{
			float4 temp_cast_3 = (_Tessellation).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata v )
		{
			float3 ase_vertexNormal = v.normal.xyz;
			float4 uv_TextureAOcclusion = float4(v.texcoord * _TextureAOcclusion_ST.xy + _TextureAOcclusion_ST.zw, 0 ,0);
			float4 uv_TextureBOcclusion = float4(v.texcoord * _TextureBOcclusion_ST.xy + _TextureBOcclusion_ST.zw, 0 ,0);
			float4 uv_BlendHeightmap = float4(v.texcoord * _BlendHeightmap_ST.xy + _BlendHeightmap_ST.zw, 0 ,0);
			float4 tex2DNode7 = tex2Dlod( _BlendHeightmap, uv_BlendHeightmap );
			float4 lerpResult9 = lerp( tex2Dlod( _TextureAOcclusion, uv_TextureAOcclusion ) , tex2Dlod( _TextureBOcclusion, uv_TextureBOcclusion ) , tex2DNode7.r);
			v.vertex.xyz += ( ( float4( ase_vertexNormal , 0.0 ) * lerpResult9 ) * _Displacement ).rgb;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureANormal = i.uv_texcoord * _TextureANormal_ST.xy + _TextureANormal_ST.zw;
			float2 uv_TextureBNormal = i.uv_texcoord * _TextureBNormal_ST.xy + _TextureBNormal_ST.zw;
			float2 uv_BlendHeightmap = i.uv_texcoord * _BlendHeightmap_ST.xy + _BlendHeightmap_ST.zw;
			float4 tex2DNode7 = tex2D( _BlendHeightmap, uv_BlendHeightmap );
			float4 lerpResult8 = lerp( tex2D( _TextureANormal, uv_TextureANormal ) , tex2D( _TextureBNormal, uv_TextureBNormal ) , tex2DNode7.r);
			o.Normal = lerpResult8.rgb;
			float2 uv_TextureAAlbedo = i.uv_texcoord * _TextureAAlbedo_ST.xy + _TextureAAlbedo_ST.zw;
			float2 uv_TextureBAlbedo = i.uv_texcoord * _TextureBAlbedo_ST.xy + _TextureBAlbedo_ST.zw;
			float4 lerpResult10 = lerp( tex2D( _TextureAAlbedo, uv_TextureAAlbedo ) , tex2D( _TextureBAlbedo, uv_TextureBAlbedo ) , tex2DNode7.r);
			o.Albedo = lerpResult10.rgb;
			float2 uv_TextureAOcclusion = i.uv_texcoord * _TextureAOcclusion_ST.xy + _TextureAOcclusion_ST.zw;
			float2 uv_TextureBOcclusion = i.uv_texcoord * _TextureBOcclusion_ST.xy + _TextureBOcclusion_ST.zw;
			float4 lerpResult9 = lerp( tex2D( _TextureAOcclusion, uv_TextureAOcclusion ) , tex2D( _TextureBOcclusion, uv_TextureBOcclusion ) , tex2DNode7.r);
			o.Occlusion = lerpResult9.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13101
-1604;-91;1196;582;1915.698;-142.729;1.973787;True;True
Node;AmplifyShaderEditor.SamplerNode;5;-1256.704,662.8946;Float;True;Property;_TextureAOcclusion;Texture A Occlusion;4;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;6;-1251.217,859.8961;Float;True;Property;_TextureBOcclusion;Texture B Occlusion;5;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;7;-1396.861,264.9027;Float;True;Property;_BlendHeightmap;Blend Heightmap;6;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;9;-818.3152,842.386;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.NormalVertexDataNode;12;-872.0349,610.1021;Float;False;0;5;FLOAT3;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;2;-982.7128,-332.2696;Float;True;Property;_TextureBAlbedo;Texture B Albedo;1;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;1;-981.4901,-530.8676;Float;True;Property;_TextureAAlbedo;Texture A Albedo;0;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;15;-836.8278,954.425;Float;False;Property;_Displacement;Displacement;8;0;0;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.SamplerNode;3;-980.954,49.52466;Float;True;Property;_TextureANormal;Texture A Normal;2;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SamplerNode;4;-978.581,245.0436;Float;True;Property;_TextureBNormal;Texture B Normal;3;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-605.4025,686.8763;Float;False;2;2;0;FLOAT3;0.0;False;1;COLOR;0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-440.8506,686.987;Float;False;2;2;0;COLOR;0.0;False;1;FLOAT;0,0,0,0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;10;-516.6624,-351.657;Float;False;3;0;COLOR;0.0,0,0,0;False;1;COLOR;0.0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.LerpOp;8;-511.2041,227.3734;Float;False;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.RangedFloatNode;11;-637.499,497.532;Float;False;Property;_Tessellation;Tessellation;8;0;0;0.001;32;0;1;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-232.1497,202.8987;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Created/Heightmap-Based-Blending-Tesselation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;True;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;9;2;7;0
WireConnection;13;0;12;0
WireConnection;13;1;9;0
WireConnection;16;0;13;0
WireConnection;16;1;15;0
WireConnection;10;0;1;0
WireConnection;10;1;2;0
WireConnection;10;2;7;0
WireConnection;8;0;3;0
WireConnection;8;1;4;0
WireConnection;8;2;7;0
WireConnection;0;0;10;0
WireConnection;0;1;8;0
WireConnection;0;5;9;0
WireConnection;0;11;16;0
WireConnection;0;14;11;0
ASEEND*/
//CHKSM=099D4BA64F5267791BABA7E7F6CFB5001A71B01A