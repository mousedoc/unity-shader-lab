using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotationVariator : MonoBehaviour
{
    [SerializeField]
    private bool byLocal = true;
    [SerializeField]
    private float speed = 2f;
    [SerializeField]
    private float offset = 0.5f;

    [SerializeField]
    private bool x = true;
    [SerializeField]
    private bool y = true;
    [SerializeField]
    private bool z = true;

    private void Update()
    {
        var time = Time.time;
        var rotation = byLocal ? transform.localRotation : transform.rotation;

        if(x)
            rotation.x = Mathf.Sin(time * speed) * offset;
        if(y)
            rotation.y = Mathf.Cos(time * speed) * offset;
        if(z)
            rotation.z = Mathf.Cos(time * speed) * offset;

        if(byLocal)
            transform.localRotation = rotation;
        else
            transform.rotation = rotation;
    }
}
