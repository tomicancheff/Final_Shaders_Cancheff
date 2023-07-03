using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemPickUp : MonoBehaviour
{
    private bool _isCollected = false;

    void OnTriggerEnter(Collider other)
    {
        if (!_isCollected && other.gameObject.CompareTag("Player"))
        {
            _isCollected = true;

            AudioManager.instance.PickUpSound();
            gameObject.SetActive(false);
        }
    }
}