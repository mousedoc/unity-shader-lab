using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PositionVariator : MonoBehaviour
{
    [SerializeField]
    private bool byLocal = true;
    [SerializeField]
    private float speed = 3f;
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
        var position = byLocal ? transform.localPosition : transform.position;

        if(x)
            position.x = Mathf.Sin(time * speed) * offset;
        if(y)
            position.y = Mathf.Cos(time * speed) * offset;
        if(z)
            position.z = Mathf.Cos(time * speed) * offset;

        if(byLocal)
            transform.localPosition = position;
        else
            transform.position = position;
    }
}
