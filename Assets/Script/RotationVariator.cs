using UnityEngine;

public class RotationVariator : MonoBehaviour
{
    [SerializeField]
    private float speed = 2f;

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
    private Vector3 originRotation;

    private void Awake()
    {
        tr = transform;
        originRotation = tr.localRotation.eulerAngles;
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

        transform.localRotation = Quaternion.Euler(originRotation + offset);
    }
}