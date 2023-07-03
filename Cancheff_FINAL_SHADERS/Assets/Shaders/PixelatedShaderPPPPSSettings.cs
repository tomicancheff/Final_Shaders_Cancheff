// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PixelatedShaderPPPPSRenderer ), PostProcessEvent.AfterStack, "PixelatedShaderPP", true )]
public sealed class PixelatedShaderPPPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Pixel X" )]
	public FloatParameter _PixelX = new FloatParameter { value = 0f };
	[Tooltip( "Pixel Y" )]
	public FloatParameter _PixelY = new FloatParameter { value = 0f };
}

public sealed class PixelatedShaderPPPPSRenderer : PostProcessEffectRenderer<PixelatedShaderPPPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PixelatedShaderPP" ) );
		sheet.properties.SetFloat( "_PixelX", settings._PixelX );
		sheet.properties.SetFloat( "_PixelY", settings._PixelY );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
