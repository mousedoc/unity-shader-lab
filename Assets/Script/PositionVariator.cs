using UnityEngine;

public class PositionVariator : MonoBehaviour
{
    [SerializeField]
    private float speed = 3f;

    [SerializeField]
    private float range = 0.5f;

    [SerializeField]
    private float timeOffset = 0f;

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
        var value = Time.time * speed + timeOffset;
        var offset = new Vector3();

        if (x)
            offset.x = Mathf.Sin(value) * range;
        if (y)
            offset.y = Mathf.Cos(value) * range;
        if (z)
            offset.z = Mathf.Cos(value) * range;

        transform.localPosition = originPosition + offset;
    }
}