// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( UnderWaterPPSRenderer ), PostProcessEvent.AfterStack, "UnderWater", true )]
public sealed class UnderWaterPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Color 0" )]
	public ColorParameter _Color0 = new ColorParameter { value = new Color(0f,0.6713879f,1f,0f) };
	[Tooltip( "NoiseScale" )]
	public FloatParameter _NoiseScale = new FloatParameter { value = 3.09f };
	[Tooltip( "ColorIntensity" )]
	public FloatParameter _ColorIntensity = new FloatParameter { value = 0f };
	[Tooltip( "NoiseSpeed" )]
	public FloatParameter _NoiseSpeed = new FloatParameter { value = 0.5f };
	[Tooltip( "DistortionIntensity" )]
	public FloatParameter _DistortionIntensity = new FloatParameter { value = 0.15f };
	[Tooltip( "Radius" )]
	public FloatParameter _Radius = new FloatParameter { value = 0f };
	[Tooltip( "Gradient" )]
	public FloatParameter _Gradient = new FloatParameter { value = 1f };
}

public sealed class UnderWaterPPSRenderer : PostProcessEffectRenderer<UnderWaterPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "UnderWater" ) );
		sheet.properties.SetColor( "_Color0", settings._Color0 );
		sheet.properties.SetFloat( "_NoiseScale", settings._NoiseScale );
		sheet.properties.SetFloat( "_ColorIntensity", settings._ColorIntensity );
		sheet.properties.SetFloat( "_NoiseSpeed", settings._NoiseSpeed );
		sheet.properties.SetFloat( "_DistortionIntensity", settings._DistortionIntensity );
		sheet.properties.SetFloat( "_Radius", settings._Radius );
		sheet.properties.SetFloat( "_Gradient", settings._Gradient );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
