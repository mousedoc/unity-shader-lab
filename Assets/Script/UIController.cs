using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIController : MonoBehaviour
{
    #region Mesh

    public void ChangeToSphere() => ChangeMesh(PrimitiveType.Sphere);
    public void ChangeToCube() => ChangeMesh(PrimitiveType.Cube);
    public void ChangeToCylinder() => ChangeMesh(PrimitiveType.Cylinder);
    public void ChangeToCapsule() => ChangeMesh(PrimitiveType.Capsule);
    public void ChangeToQuad() => ChangeMesh(PrimitiveType.Quad);

    private void ChangeMesh(PrimitiveType type)
    {
        foreach(var example in ExampleCache.Examples)
        {
            var variator = example.GetComponent<MeshVariator>();
            if (variator != null)
                variator.Change(type);
        }
    }

    #endregion
}
