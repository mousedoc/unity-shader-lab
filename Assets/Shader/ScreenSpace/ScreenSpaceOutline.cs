using UnityEngine;
using System.Collections;
 
public class ScreenSpaceOutline : MonoBehaviour
{
    public Shader OutlineShader;
    public Shader WhiteShader;

    private Camera mainCamera;
    private Camera screenSpaceOutlineCamera;
    private Material outlineMaterial;

    private RenderTexture renderTexture;

    private void Start()
    {
        mainCamera = GetComponent<Camera>();
        if (mainCamera == null)
        {
            enabled = false;
            return;
        }

        outlineMaterial = new Material(OutlineShader);

        screenSpaceOutlineCamera = new GameObject().AddComponent<Camera>();
        screenSpaceOutlineCamera.enabled = false;

        //set up a temporary camera
        var layerName = "ScreenSpaceOutline";
        screenSpaceOutlineCamera.name = layerName + " Camera";
        screenSpaceOutlineCamera.CopyFrom(mainCamera);
        screenSpaceOutlineCamera.transform.SetParent(mainCamera.transform);
        screenSpaceOutlineCamera.clearFlags = CameraClearFlags.Depth;
        screenSpaceOutlineCamera.backgroundColor = Color.black;

        //cull any layer that isn't the outline
        screenSpaceOutlineCamera.cullingMask = 1 << LayerMask.NameToLayer(layerName);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // Make the temporary rendertexture
        if(renderTexture == null)
            renderTexture = new RenderTexture(source.width, source.height, 0, RenderTextureFormat.R8);

        // Put it to video memory
        renderTexture.Create();

        // Set the camera's target texture when rendering
        screenSpaceOutlineCamera.targetTexture = renderTexture;

        // Render all objects this camera can render, but with our custom shader.
        screenSpaceOutlineCamera.RenderWithShader(WhiteShader, "");

        // Copy source to destination (original render image)
        Graphics.Blit(source, destination);

        // Copy outline texture to destination
        Graphics.Blit(renderTexture, destination, outlineMaterial);

        // Release the temporary RT
        renderTexture.Release();
    }

}