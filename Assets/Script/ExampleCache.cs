using System.Collections.Generic;
using UnityEngine;

public class ExampleCache : MonoBehaviour
{
    public static List<GameObject> Examples { get; private set; } = new List<GameObject>();

    public const string ExampleTag = "ShaderExample";

    private void Awake()
    {
        var meshChilds = GetComponentsInChildren<MeshFilter>();

        foreach (var meshChild in meshChilds)
        {
            if (meshChild == null)
                continue;

            if (meshChild.CompareTag(ExampleTag) == false)
                continue;

            Examples.Add(meshChild.gameObject);
        }
    }
}