using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetMover : MonoBehaviour
{
    [Header("Customizable Options")]
    public float horizontalSpeed = 1f;
    public float movementLength = 2f;
    private Vector3 _initialPosition;
    private void Start()
    {
        // Guardar la posición inicial del target
        _initialPosition = transform.position;
    }
    private void Update()
    {
        // Calcular la posición horizontal actual del target
        float newPositionX = Mathf.PingPong(Time.time * horizontalSpeed, movementLength);
        
        // Calcular la nueva posición completa del target (incluyendo la posición inicial en Y y Z)
        Vector3 newPosition = new Vector3(newPositionX, _initialPosition.y, _initialPosition.z);

        // Asignar la nueva posición al target
        transform.position = newPosition;
    }
}