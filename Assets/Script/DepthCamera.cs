using UnityEngine;

[ExecuteInEditMode]
public class DepthCamera : MonoBehaviour
{
    private void OnEnable()
    {
        var cam = GetComponent<Camera>();
        if (cam != null)
            cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.Depth;
    }
}