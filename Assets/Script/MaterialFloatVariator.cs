using UnityEngine;

public class MaterialFloatVariator : MonoBehaviour
{
    [SerializeField]
    private Material targetMaterial = null;

    [SerializeField]
    private string propertyName = null;

    [SerializeField]
    private float minimum = -1f;

    [SerializeField]
    private float maximum = 1f;

    [SerializeField]
    private float speed = 1f;

    private void Awake()
    {
        if (targetMaterial == null)
            targetMaterial = GetComponent<Material>();
    }

    private void Update()
    {
        if (targetMaterial == null || string.IsNullOrEmpty(propertyName))
            return;

        var time = Time.time;
        var offset = (Mathf.Sin(time * speed) + 1) / 2f;
        var value = Mathf.Lerp(minimum, maximum, offset);
        targetMaterial.SetFloat(propertyName, value);
    }
}