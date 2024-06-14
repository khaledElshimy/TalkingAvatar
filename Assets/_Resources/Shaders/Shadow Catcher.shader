// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Shadow Catcher"
{
	Properties
	{
		[HideInInspector]_Maskclip("Maskclip", Range( 0 , 1)) = 0.5
		_ShadowOpacity("Shadow Opacity", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend DstColor Zero , DstColor Zero
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting keepalpha exclude_path:deferred noforwardadd 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _Maskclip;
		uniform float _ShadowOpacity;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float temp_output_108_0 = (1.0 + (_ShadowOpacity - 0.0) * (0.0 - 1.0) / (1.0 - 0.0));
			float ifLocalVar101 = 0;
			if( 0.0 == ase_lightColor.a )
				ifLocalVar101 = 0.0;
			else if( 0.0 < ase_lightColor.a )
				ifLocalVar101 = saturate( ( 1.0 - ( temp_output_108_0 + ase_lightAtten ) ) );
			float3 temp_cast_0 = (1.0).xxx;
			float3 temp_cast_1 = (1.0).xxx;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			UnityGI gi74 = gi;
			float3 diffNorm74 = ase_worldNormal;
			gi74 = UnityGI_Base( data, 1, diffNorm74 );
			float3 indirectDiffuse74 = gi74.indirect.diffuse + diffNorm74 * 0.0001;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult71 = dot( ase_worldNormal , ase_worldlightDir );
			float3 lerpResult64 = lerp( saturate( ( temp_output_108_0 + ( indirectDiffuse74 * max( dotResult71 , 0.0 ) ) ) ) , float3( 1,1,1 ) , ase_lightAtten);
			float3 ifLocalVar92 = 0;
			if( 0.0 >= ase_lightColor.a )
				ifLocalVar92 = temp_cast_0;
			else
				ifLocalVar92 = lerpResult64;
			c.rgb = ifLocalVar92;
			c.a = ifLocalVar101;
			clip( ifLocalVar101 - _Maskclip );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.SaturateNode;98;175.0465,-71.52537;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;96;208.1461,201.9103;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;99;290.0471,489.3744;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;205.554,335.9913;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;809.8775,-52.39107;Inherit;False;Property;_Maskclip;Maskclip;0;1;[HideInInspector];Create;True;0;0;0;True;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;970.5893,5.960964;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Shadow Catcher;False;False;False;False;False;False;False;False;False;False;False;True;False;False;True;False;False;False;False;False;True;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;6;2;False;;0;False;;6;2;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;True;_Maskclip;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ConditionalIfNode;92;545.4939,368.934;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;69;-753.2055,115.8372;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;71;-497.1056,59.93721;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;70;-723.3056,-28.4632;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;83;-349.5869,50.7507;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;74;-492.3568,-39.7075;Inherit;False;World;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-228.5567,-2.007507;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;15.92615,-44.86304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;64;207.0828,43.76811;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,1,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ConditionalIfNode;101;555.4266,160.2171;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;100;215.2467,397.2747;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;106;93.68445,393.0853;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;34;-241.8218,157.8821;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;107;351.6844,395.0853;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;108;-193.7228,-180.2829;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-491.8572,-204.615;Inherit;False;Property;_ShadowOpacity;Shadow Opacity;1;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
WireConnection;98;0;104;0
WireConnection;0;9;101;0
WireConnection;0;10;101;0
WireConnection;0;13;92;0
WireConnection;92;1;96;2
WireConnection;92;2;99;0
WireConnection;92;3;99;0
WireConnection;92;4;64;0
WireConnection;71;0;70;0
WireConnection;71;1;69;0
WireConnection;83;0;71;0
WireConnection;74;0;70;0
WireConnection;72;0;74;0
WireConnection;72;1;83;0
WireConnection;104;0;108;0
WireConnection;104;1;72;0
WireConnection;64;0;98;0
WireConnection;64;2;34;0
WireConnection;101;1;96;2
WireConnection;101;3;102;0
WireConnection;101;4;107;0
WireConnection;100;0;106;0
WireConnection;106;0;108;0
WireConnection;106;1;34;0
WireConnection;107;0;100;0
WireConnection;108;0;105;0
ASEEND*/
//CHKSM=819074A7EE09E97CEE5B9BEF2635EE4F02AA1A98