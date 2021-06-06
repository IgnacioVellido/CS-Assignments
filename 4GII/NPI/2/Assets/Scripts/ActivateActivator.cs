using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateActivator : MonoBehaviour
{
    public GameObject Activator;
    public GameObject TurnImage;
    public GameObject Frame;
    public GameObject Frame2;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Cursor")
        {
            Activator.SetActive(true);
            Frame.SetActive(true);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Cursor")
        {
            Activator.SetActive(false);
            TurnImage.SetActive(false);
            Frame.SetActive(false);
            Frame2.SetActive(false);
        }
    }
}
