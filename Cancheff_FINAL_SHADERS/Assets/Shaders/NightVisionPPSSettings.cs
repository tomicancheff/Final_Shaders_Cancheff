// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( NightVisionPPSRenderer ), PostProcessEvent.AfterStack, "NightVision", true )]
public sealed class NightVisionPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Intensity" )]
	public FloatParameter _Intensity1 = new FloatParameter { value = 1f };
}

public sealed class NightVisionPPSRenderer : PostProcessEffectRenderer<NightVisionPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "NightVision" ) );
		sheet.properties.SetFloat( "_Intensity1", settings._Intensity1 );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
