using System.Collections.Generic;
using UnityEngine;

public class MeshVariator : MonoBehaviour
{
    private static Dictionary<PrimitiveType, Mesh> meshMap = new Dictionary<PrimitiveType, Mesh>();
    private static Vector3 newLocalScale = new Vector3(0.5f, 0.5f, 0.5f);

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
        transform.localScale = newLocalScale;
    }
}