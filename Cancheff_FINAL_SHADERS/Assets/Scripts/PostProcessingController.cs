using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProcessingController : MonoBehaviour
{
    public PostProcessVolume postProcessVolume;

    private void Start()
    {
        // Desactivar el postprocesamiento al inicio
        DeactivatePostProcessing();
    }

    public void ActivatePostProcessing()
    {
        postProcessVolume.enabled = true;
    }

    public void DeactivatePostProcessing()
    {
        postProcessVolume.enabled = false;
    }
}