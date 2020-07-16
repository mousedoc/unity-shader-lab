using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialFloatVariator : MonoBehaviour
{
    [SerializeField]
    private string propertyName = null;

    [SerializeField]
    private float minimum = -1f;
    [SerializeField]
    private float maximum = 1f;
    [SerializeField]
    private float speed = 1f;

    private Material material;

    private void Awake()
    {
        material = GetComponent<Material>();
    }

    private void Update()
    {
        if (material == null || string.IsNullOrEmpty(propertyName))
            return;

        var time = Time.time;
        var value = Mathf.Lerp(minimum, maximum, Mathf.Sin(time * speed));
        material.SetFloat(propertyName, value);
    }
}
