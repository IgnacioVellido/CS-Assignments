using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MenuActivation : MonoBehaviour
{
    float targetTime;
    public float initialTime = 3.0f;
    bool startTimer;
    public Material new_background;
    public Slider timeSlider;
    public GameObject frame;
    public GameObject sliderText;

    // Start is called before the first frame update
    void Start()
    {
        Debug.Log("Hello from Start", this.gameObject);

        targetTime = initialTime;
        timeSlider.value = targetTime;
        startTimer = false;
        
    }

    // Update is called once per frame
    void Update()
    {
        if (startTimer == true)
        {
            targetTime = targetTime - Time.deltaTime;
            timeSlider.value = targetTime;

            if (targetTime <= 0.0f)
            {
                timerEnded();
            }
        }
        
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Cursor")
        {
            startTimer = true;
            frame.SetActive(true);
            timeSlider.gameObject.SetActive(true);
            sliderText.gameObject.SetActive(true);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.tag == "Cursor")
        {
            startTimer = false;
            targetTime = initialTime;
            timeSlider.value = initialTime;
            frame.SetActive(false);
            timeSlider.gameObject.SetActive(false);
            sliderText.gameObject.SetActive(false);
        }
    }

    public static GameObject FindChild(GameObject parent, string name)
    {
        Transform[] trs = parent.GetComponentsInChildren<Transform>(true);
        foreach (Transform t in trs)
        {
            if (t.name == name)
            {
                return t.gameObject;
            }
        }
        return null;
    }

    // we set the mesh render to false

    void timerEnded()
    {
        //Debug.Log("this object has disappeared", this.gameObject);

        MeshRenderer m = this.gameObject.GetComponent<MeshRenderer>();
        m.enabled = false;
        frame.SetActive(false);
        sliderText.SetActive(false);
        timeSlider.gameObject.SetActive(false);

        // Check menu name and change accordingly
        switch (this.gameObject.name)
        {
            case "Menu-Capture":    
                // Change background material
                GameObject background = GameObject.Find("Plane-Background");  
                background.GetComponent<Renderer>().material = new_background;

                // Show information
                GameObject menu = GameObject.Find("Information");
                GameObject monumentInformation1 = FindChild(menu, "Information-Text1");
                monumentInformation1.SetActive(true);
                GameObject monumentInformation2 = FindChild(menu, "Information-Background");
                monumentInformation2.SetActive(true);
                GameObject instructions = FindChild(menu, "Instructions");
                instructions.SetActive(true);
                GameObject.Find("Menu-Capture").SetActive(false);
                break;
            case "Menu-Maze":       // Launch game scene
                SceneManager.LoadScene("Maze", LoadSceneMode.Single);
                break;
            case "Menu-Route":      // Launch arrow scene
                SceneManager.LoadScene("Arrow", LoadSceneMode.Single);
                break;
            case "Menu-Back":      // Launch menu scene
                SceneManager.LoadScene("Menu", LoadSceneMode.Single);
                break;
            case "Menu-Puzzle": // Launch Puzzle scene
                SceneManager.LoadScene("Puzzle", LoadSceneMode.Single);
                break;
            case "Menu-Questions": // Launch Questions scene
                SceneManager.LoadScene("Questions", LoadSceneMode.Single);
                break;
            case "Menu-Chest": // Launch Chest scene
                SceneManager.LoadScene("Chest", LoadSceneMode.Single);
                break;
        }
    }
}
