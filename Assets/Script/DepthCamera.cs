using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthCamera : MonoBehaviour
{
    public Camera targetCamera;
    public RenderTexture renderTexture;

    void Start()
    {
        //renderTexture = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.Depth);
        renderTexture.width = Screen.width;
        renderTexture.height = Screen.height;
        renderTexture.depth = 24;
        renderTexture.format = RenderTextureFormat.Depth;


        targetCamera.depthTextureMode = DepthTextureMode.Depth;
        targetCamera.targetTexture = renderTexture;
    }
}
