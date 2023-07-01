using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class PostProcessScript : MonoBehaviour
{
    [SerializeField] private Shader shader;
    private Material mat;
    public float intensity;
    // Start is called before the first frame update
    void Start()
    {
        mat = new Material(shader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        mat.SetFloat("_Intensity", intensity);
        Graphics.Blit(source, destination, mat);
    }
}
