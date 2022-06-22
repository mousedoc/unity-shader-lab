using UnityEngine;

public class PositionVariator : MonoBehaviour
{
    [SerializeField]
    private float speed = 3f;

    [SerializeField]
    private float range = 0.5f;

    [SerializeField]
    private bool x = true;

    [SerializeField]
    private bool y = true;

    [SerializeField]
    private bool z = true;

    private Transform tr;
    private Vector3 originPosition;

    private void Awake()
    {
        tr = transform;
        originPosition = tr.localPosition;
    }

    private void Update()
    {
        var time = Time.time;
        var offset = new Vector3();

        if (x)
            offset.x = Mathf.Sin(time * speed) * range;
        if (y)
            offset.y = Mathf.Cos(time * speed) * range;
        if (z)
            offset.z = Mathf.Cos(time * speed) * range;

        transform.localPosition = originPosition + offset;
    }
}