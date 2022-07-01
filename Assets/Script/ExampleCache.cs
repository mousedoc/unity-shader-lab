using System.Collections.Generic;
using UnityEngine;

public class ExampleCache : MonoBehaviour
{
    public static List<GameObject> Examples { get; private set; } = new List<GameObject>();

    private readonly string exampleTag = "ShaderExample";

    private void Awake()
    {
        var meshChilds = GetComponentsInChildren<MeshFilter>();

        foreach (var meshChild in meshChilds)
        {
            if (meshChild == null)
                continue;

            if (meshChild.CompareTag(exampleTag) == false)
                continue;

            Examples.Add(meshChild.gameObject);
        }
    }
}