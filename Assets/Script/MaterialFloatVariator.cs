using UnityEngine;

public class MaterialFloatVariator : MonoBehaviour
{
    [SerializeField]
    private Renderer targetRenderer = null;

    [SerializeField]
    private string propertyName = null;

    [SerializeField]
    private float timeOffset = 0f;

    [SerializeField]
    private float minimum = -1f;

    [SerializeField]
    private float maximum = 1f;

    [SerializeField]
    private float speed = 1f;

    private void Awake()
    {
        if (targetRenderer == null)
            targetRenderer = GetComponent<Renderer>();
    }

    private void Update()
    {
        if (targetRenderer == null || string.IsNullOrEmpty(propertyName))
            return;

        var time = Time.time * speed + timeOffset;
        var offset = (Mathf.Sin(time) + 1) / 2f;
        var value = Mathf.Lerp(minimum, maximum, offset);
        targetRenderer.material.SetFloat(propertyName, value);
    }
}