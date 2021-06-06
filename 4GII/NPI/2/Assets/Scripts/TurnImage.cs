using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TurnImage : MonoBehaviour
{
    public GameObject image;
    int rotationAngle;
    float targetTime;
    public float initialTime = 1.0f;

    // Start is called before the first frame update
    void Start()
    {
        targetTime = initialTime;
        rotationAngle = 0;
    }

    // Update is called once per frame
    void Update()
    {
            targetTime -= Time.deltaTime;

            if (targetTime <= 0.0f)
            {
                //Debug.Log("the value of rotation angle is: " + rotationAngle + "\n");
                rotationAngle = (rotationAngle + 90) % 360;
                image.transform.eulerAngles = new Vector3(0,0,rotationAngle);
                targetTime = initialTime;
            }
    }
}
