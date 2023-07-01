using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetMover : MonoBehaviour
{
    [Header("Customizable Options")]
    //Horizontal movement speed
    public float horizontalSpeed = 1f;
    //Length of horizontal movement
    public float movementLength = 2f;

    private void Update()
    {
        //Move the target horizontally
        transform.position = new Vector3(Mathf.PingPong(Time.time * horizontalSpeed, movementLength), transform.position.y, transform.position.z);
    }
    
}