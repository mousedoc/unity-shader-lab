using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public float lookSpeed = 5f;
    public float lookDistance = 5f;
    public float moveLerpSpeed = 3f;
    public float rotateSlerpSpeed = 3f;

    private Camera targetCamera;
    private GameObject targetObj;
    private Vector3 lastMousePos = Vector3.zero;
    private Vector3 mouseDelta = Vector3.zero;
    public Vector3 orbit = Vector3.one;

    private void Awake()
    {
        targetCamera = GetComponent<Camera>();
    }

    private void Start()
    {
        if(targetObj == null && ExampleCache.Examples.Count > 0)
            targetObj = ExampleCache.Examples[0];
    }

    public void Update()
    {
        CalculateMouseDelta();

        if (targetObj == null)
            return;

        if (Input.GetMouseButtonDown(0))
            ChangeTargetObject();
        //else if(Input.GetMouseButton(1))
            Rotate();

        ProcessTransform();
    }

    private void CalculateMouseDelta()
    {
        var currentMousePos = Input.mousePosition;

        if (lastMousePos != Vector3.zero)
            mouseDelta = currentMousePos - lastMousePos;

        lastMousePos = currentMousePos;
    }

    private void ChangeTargetObject()
    {
        var ray = targetCamera.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit))
        {
            var go = hit.transform.gameObject;
            if (go.CompareTag(ExampleCache.ExampleTag) == false)
                return;

            targetObj = go;
        }
    }

    private void Rotate()
    {
        var offset = new Vector3(mouseDelta.y, mouseDelta.x, 0);
        orbit += offset;

        var rot = Quaternion.Euler(orbit);

        orbit = rot.eulerAngles;
    }

    private void ProcessTransform()
    {
        var tr = transform;
        var center = targetObj.transform.parent.position;
        var direction = Quaternion.Euler(orbit);

        var curPos = tr.position;
        var destPos = center + orbit * lookDistance;

        UpdatePosition(destPos);

        var rot = Quaternion.LookRotation(Vector3.Normalize(center - curPos));
        UpdateRotation(rot);
    }

    private void UpdatePosition(Vector3 pos)
    {
        transform.position = Vector3.Lerp(transform.position, pos, moveLerpSpeed * Time.deltaTime);
    }

    private void UpdateRotation(Quaternion rot)
    {
        transform.rotation = Quaternion.Slerp(transform.rotation, rot, rotateSlerpSpeed * Time.deltaTime);
    }
}
