using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProcessingController : MonoBehaviour
{
    public PostProcessVolume postProcessVolume1;
    public PostProcessVolume postProcessVolume2;

    private void Start()
    {
        // Desactivar el postprocesamiento al inicio
        DeactivatePostProcessing1();
        DeactivatePostProcessing2();
    }

    public void ActivatePostProcessing1()
    {
        postProcessVolume1.enabled = true;
    }

    public void DeactivatePostProcessing1()
    {
        postProcessVolume1.enabled = false;
    }

    public void ActivatePostProcessing2()
    {
        postProcessVolume2.enabled = true;
        AudioManager.instance.PlaySound(AudioManager.instance.nightVisionOnSound);
    }

    public void DeactivatePostProcessing2()
    {
        postProcessVolume2.enabled = false;
    }
}