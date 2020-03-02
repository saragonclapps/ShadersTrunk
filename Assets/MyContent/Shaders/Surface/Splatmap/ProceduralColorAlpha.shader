// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Created/Splatmap/ProceduralColorAlpha"
{
	Properties
	{
		[HideInInspector] __dirty( "", Int ) = 1
		_MaskClipValue( "Mask Clip Value", Float ) = 0.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Color1("Color 1", Color) = (0,1,0.006896496,0)
		_Color0("Color 0", Color) = (1,0,0,0)
		_GreenForce("GreenForce", Range( 0 , 1)) = 1
		_RedForce("RedForce", Range( 0 , 1)) = 1
		_BlueForce("BlueForce", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _RedForce;
		uniform float _GreenForce;
		uniform float _BlueForce;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _MaskClipValue = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode1 = tex2D( _TextureSample0, uv_TextureSample0 );
			float4 lerpResult22 = lerp( _Color0 , _Color1 , ( ( tex2DNode1.r / _RedForce ) + ( tex2DNode1.g / _GreenForce ) + ( tex2DNode1.b / _BlueForce ) ));
			o.Albedo = lerpResult22.rgb;
			o.Alpha = 1;
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			clip( tex2D( _TextureSample1, uv_TextureSample1 ).r - _MaskClipValue );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=13101
-1434;-101;1352;653;1926.16;408.9933;1.3;True;True
Node;AmplifyShaderEditor.SamplerNode;1;-1669.501,-97.19987;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Assets/Shaders/Textures/AlbedoLeaf.jpg;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;46;-1265.799,-74.20093;Float;False;Property;_GreenForce;GreenForce;5;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;45;-1262.799,-189.2009;Float;False;Property;_RedForce;RedForce;6;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.RangedFloatNode;47;-1267.799,39.79907;Float;False;Property;_BlueForce;BlueForce;7;0;1;0;1;0;1;FLOAT
Node;AmplifyShaderEditor.WireNode;51;-1316.799,-84.20093;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.WireNode;49;-1331.799,-188.2009;Float;False;1;0;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;52;-938.7993,-24.20093;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;48;-937.7993,-248.2009;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.SimpleDivideOpNode;50;-937.7993,-126.2009;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;17;-697.0988,-237.9;Float;False;Property;_Color1;Color 1;3;0;0,1,0.006896496,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-694.6019,-66.99932;Float;True;3;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT
Node;AmplifyShaderEditor.ColorNode;5;-697.8998,-404.2997;Float;False;Property;_Color0;Color 0;4;0;1,0,0,0;0;5;COLOR;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.LerpOp;22;-348.6011,-190.8987;Float;True;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR
Node;AmplifyShaderEditor.SamplerNode;2;-358.4,254.3;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT4;FLOAT;FLOAT;FLOAT;FLOAT
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-0.5,-189.5;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Created/Splatmap/ProceduralColorAlpha;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;Off;0;0;False;0;0;Custom;0.5;True;True;0;True;Transparent;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;False;0;4;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;Add;Add;0;False;0;0,0,0,0;VertexOffset;False;Spherical;False;Relative;0;;0;-1;-1;-1;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;OBJECT;0.0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;51;0;1;2
WireConnection;49;0;1;1
WireConnection;52;0;1;3
WireConnection;52;1;47;0
WireConnection;48;0;49;0
WireConnection;48;1;45;0
WireConnection;50;0;51;0
WireConnection;50;1;46;0
WireConnection;32;0;48;0
WireConnection;32;1;50;0
WireConnection;32;2;52;0
WireConnection;22;0;5;0
WireConnection;22;1;17;0
WireConnection;22;2;32;0
WireConnection;0;0;22;0
WireConnection;0;10;2;1
ASEEND*/
//CHKSM=F7E0DA18CB346E9916886F4AE65FD47CFDC8BBFE