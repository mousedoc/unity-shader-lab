using UnityEngine;

public class RotationVariator : MonoBehaviour
{
    [SerializeField]
    private bool byLocal = true;

    [SerializeField]
    private float speed = 2f;

    [SerializeField]
    private float range = 0.5f;

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
        var time = Time.time;
        var offset = new Vector3();

        if (x)
            offset.x = Mathf.Sin(time * speed) * range;
        if (y)
            offset.y = Mathf.Cos(time * speed) * range;
        if (z)
            offset.z = Mathf.Cos(time * speed) * range;

        transform.localRotation = Quaternion.Euler(originRotation + offset);
    }
}