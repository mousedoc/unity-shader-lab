using System.Collections.Generic;
using UnityEngine;

public class MeshVariator : MonoBehaviour
{
    private static Dictionary<PrimitiveType, Mesh> meshMap = new Dictionary<PrimitiveType, Mesh>();

    private static Mesh GetMesh(PrimitiveType type)
    {
        if (meshMap.ContainsKey(type))
            return meshMap[type];

        string name = $"{type}.fbx";
        return meshMap[type] = Resources.GetBuiltinResource<Mesh>(name);
    }

    private MeshFilter meshFilter;

    private void Awake()
    {
        meshFilter = GetComponent<MeshFilter>();
    }

    public void Change(PrimitiveType type)
    {
        meshFilter.mesh = GetMesh(type);

        float scale = 0.5f;
        switch (type)
        {
            case PrimitiveType.Cube:
                scale = 0.9f;
                break;
            case PrimitiveType.Capsule:
                scale = 0.3f;
                break;
            default:
                scale = 0.5f;
                break;
        }

        transform.localScale = Vector3.one * scale;
    }
}