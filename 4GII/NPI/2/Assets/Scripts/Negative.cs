using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RSUnityToolkit;

public class Negative : VirtualWorldBoxAction
{
    #region Public Fields

    /// <summary>
    /// The smoothing factor.
    /// </summary>
    public float SmoothingFactor = 0;

    public SmoothingUtility.SmoothingTypes SmoothingType = SmoothingUtility.SmoothingTypes.Weighted;

    /// <summary>
    /// Position / Rotation constraints
    /// </summary>
    public Transformation3D Constraints;

    /// <summary>
    /// Invert Positions / Rotations
    /// </summary>
    public Transformation3D InvertTransform;

    /// <summary>
    /// Effect Physics will use Unityâ€™s MoveRotation and MovePosition to move the object.
    /// </summary>
    public bool EffectPhysics = false;

    /// <summary>
    /// SetDefaultsTo lets you switch in one click between 3 different tracking modes â€“ hands, face and object tracking
    /// </summary>
    [BaseAction.ShowAtFirst]
    public Defaults SetDefaultsTo = Defaults.FaceTracking;

    // thresholds 
    public float upthreshold = 2.0f;
    public float leftthreshold = 3.0f;
    public float righthreshold = 3.0f;
    public float downthreshold = 2.0f;

    #endregion

    #region Private Fields

    [SerializeField]
    [HideInInspector]
    private Defaults _lastDefaults = Defaults.FaceTracking;

    private bool _actionTriggered = false;

    private SmoothingUtility _translationSmoothingUtility = new SmoothingUtility();
    private SmoothingUtility _rotationSmoothingUtility = new SmoothingUtility();
    private bool gestureStarted = false;
    private bool gestureStarted2 = false;
    private bool gesture1Completed = false;
    private bool resetNeeded = false;
    private bool gesture1_left = false;
    private bool gesture1_right = false;
    private Vector3 old_face_vec;
    private Vector3 old_face_vec2;

    #endregion

    #region Ctor

    /// <summary>
    /// Constructor
    /// </summary>
    public Negative() : base()
    {
        Constraints = new Transformation3D();
        InvertTransform = new Transformation3D();
    }

    #endregion

    #region Public methods

    /// <summary>
    /// Determines whether this instance is support custom triggers.
    /// </summary>		
    public override bool IsSupportCustomTriggers()
    {
        return false;
    }

    /// <summary>
    /// Returns the actions's description for GUI purposes.
    /// </summary>
    /// <returns>
    /// The action description.
    /// </returns>
    public override string GetActionDescription()
    {
        return "This Action links the transformation of the associated Game Object to the real world tracked source";
    }

    /// <summary>
    /// Sets the default trigger values (for the triggers set in SetDefaultTriggers() )
    /// </summary>
    /// <param name='index'>
    /// Index of the trigger.
    /// </param>
    /// <param name='trigger'>
    /// A pointer to the trigger for which you can set the default rules.
    /// </param>
    public override void SetDefaultTriggerValues(int index, Trigger trigger)
    {
        switch (index)
        {
            case 0:
                trigger.FriendlyName = "Start Event";
                ((EventTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<FaceDetectedRule>() };
                break;
            case 1:
                ((TrackTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<FaceTrackingRule>() };
                break;
            case 2:
                trigger.FriendlyName = "Stop Event";
                ((EventTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<FaceLostRule>() };
                break;
        }
    }

    /// <summary>
    /// Updates the inspector.
    /// </summary>
    public override void UpdateInspector()
    {
        if (_lastDefaults != SetDefaultsTo)
        {
            CleanSupportedTriggers();
            SupportedTriggers = null;
            InitializeSupportedTriggers();
            _lastDefaults = SetDefaultsTo;
        }
    }

    #endregion

    #region Protected methods

    /// <summary>
    /// Sets the default triggers for that action.
    /// </summary>
    override protected void SetDefaultTriggers()
    {
        SupportedTriggers = new Trigger[3]{
            AddHiddenComponent<EventTrigger>(),
            AddHiddenComponent<TrackTrigger>(),
            AddHiddenComponent<EventTrigger>()};
    }

    #endregion

    #region Private Methods

    /// <summary>
    /// Update is called once per frame.
    /// </summary>
    void Update()
    {
        updateVirtualWorldBoxCenter();

        ProcessAllTriggers();

        //Start Event
        if (!_actionTriggered && SupportedTriggers[0].Success)
        {
            _actionTriggered = true;
        }

        //Stop Event
        if (_actionTriggered && SupportedTriggers[2].Success)
        {
            _actionTriggered = false;
            gestureStarted = false;
        }

        if (!_actionTriggered)
        {
            return;
        }

        TrackTrigger face_trgr = (TrackTrigger)SupportedTriggers[1];

        if (face_trgr.Success)
        {
            // Get hands positions
            Vector3 face_vec = face_trgr.Position;

            // Be sure we have valid values:
            if (VirtualWorldBoxDimensions.x <= 0)
            {
                VirtualWorldBoxDimensions.x = 1;
            }

            if (VirtualWorldBoxDimensions.y <= 0)
            {
                VirtualWorldBoxDimensions.y = 1;
            }

            if (VirtualWorldBoxDimensions.z <= 0)
            {
                VirtualWorldBoxDimensions.z = 1;
            }

            face_vec.x = (face_vec.x * VirtualWorldBoxDimensions.x);
            face_vec.y = (face_vec.y * VirtualWorldBoxDimensions.y);
            face_vec.z = (face_vec.z * VirtualWorldBoxDimensions.z);

            // Check gesture
            if (!gestureStarted)
            {
                Debug.Log("WE START THE CHEKING OF THE FIRST GESTURE");
                gestureStarted = true;
                old_face_vec = face_vec;
            }
            else if (gestureStarted && !gesture1Completed)
            {
                // Corroborating if we look to one of the sides correctly
                bool correct_move_up = (face_vec.y < (old_face_vec.y + upthreshold));
                bool correct_move_left = (face_vec.x < (old_face_vec.x - leftthreshold));
                bool correct_move_right = (face_vec.x > (old_face_vec.x + righthreshold));
                bool correct_move_down = (face_vec.y > (old_face_vec.y - downthreshold));

                if ((correct_move_left || correct_move_right) && correct_move_up && correct_move_down)
                {
                    gesture1Completed = true;

                    if (correct_move_left)
                    {
                        gesture1_left = true;
                        Debug.Log("We looked to the left");
                    }
                    else
                    {
                        gesture1_right = true;
                        Debug.Log("We looked to the right");
                    }
                    
                }
            }

            // Now we check that the movement is looking down

            if (!gestureStarted2 && gesture1Completed)
            {
                gestureStarted2 = true;
                old_face_vec2 = face_vec;
            }
            else if (gesture1Completed && gesture1_left)
            {
                Debug.Log("Look to the right to complete the gesture");

                // Corroborating the move is looking to the right
                bool correct_move_down2 = (face_vec.y > (old_face_vec2.y - downthreshold));
                bool correct_move_up2 = (face_vec.y < (old_face_vec2.y + upthreshold));
                bool correct_move_right2 = (face_vec.x > (old_face_vec2.x + righthreshold*2.0f)); // may be times 2


                if (!correct_move_down2 || !correct_move_up2)
                {
                    resetNeeded = true;
                }

                if (correct_move_right2 && !resetNeeded)
                {
                    Debug.Log("Chest opened");

                    gestureStarted = false;
                    gestureStarted2 = false;
                    gesture1Completed = false;
                    gesture1_left = false;
                    gesture1_right = false;

                    // Opening the chest in the game
                    GameObject chest_open = GameObject.Find("chest_open");
                    chest_open.GetComponent<MeshRenderer>().enabled = true;

                    GameObject chest_close = GameObject.Find("chest_close");
                    chest_close.GetComponent<MeshRenderer>().enabled = false;
                }
                else if (correct_move_right2 && resetNeeded)
                {
                    Debug.Log("We looked up or down in the second gesture");

                    gestureStarted = false;
                    gestureStarted2 = false;
                    gesture1Completed = false;
                    gesture1_left = false;
                    gesture1_right = false;
                    resetNeeded = false;
                }
            }
            else if (gesture1Completed && gesture1_right)
            {
                Debug.Log("Look to the left to complete the gesture");

                // Corroborating the move is looking to the right
                bool correct_move_down2 = (face_vec.y > (old_face_vec2.y - downthreshold));
                bool correct_move_up2 = (face_vec.y < (old_face_vec2.y + upthreshold));
                bool correct_move_left2 = (face_vec.x < (old_face_vec2.x - leftthreshold*2.0f)); // may be times 2


                if (!correct_move_down2 || !correct_move_up2)
                {
                    resetNeeded = true;
                }

                if (correct_move_left2 && !resetNeeded)
                {
                    Debug.Log("Chest opened");

                    gestureStarted = false;
                    gestureStarted2 = false;
                    gesture1Completed = false;
                    gesture1_left = false;
                    gesture1_right = false;

                    // Opening the chest in the game
                    GameObject chest_open = GameObject.Find("chest_open");
                    chest_open.GetComponent<MeshRenderer>().enabled = true;

                    GameObject chest_close = GameObject.Find("chest_close");
                    chest_close.GetComponent<MeshRenderer>().enabled = false;
                }
                else if (correct_move_left2 && resetNeeded)
                {
                    Debug.Log("We looked up or down in the second gesture");

                    gestureStarted = false;
                    gestureStarted2 = false;
                    gesture1Completed = false;
                    gesture1_left = false;
                    gesture1_right = false;
                    resetNeeded = false;
                }
            }
        }
    }

    /// <summary>
	/// Gets the average of the given list and add new number to the list
	/// </summary>
	/// <returns>
	/// The average and add new number.
	/// </returns>
	/// <param name='list'>
	/// List.
	/// </param>
	/// <param name='number'>
	/// Number.
	/// </param>
	private float GetAverageAndAddNewNumber(List<float> list, float number)
    {
        int size = list.Count;
        if (size < 2)
        {
            return number;
        }

        float sum = 0;

        for (int i = 0; i < size - 1; i++)
        {
            sum += list[i];
            list[i] = (float)list[i + 1];
        }
        sum += list[size - 1];
        list[size - 1] = number;

        return (sum / size);
    }


    #endregion

    #region Nested Types

    /// <summary>
    /// Default trackig modes that can be selected by SetDefaultsTo
    /// </summary>
    public enum Defaults
    {
        FaceTracking,
        HandTracking,
        ObjectTracking
    }


    #endregion

    #region Menu
#if UNITY_EDITOR

    /// <summary>
    /// Adds the action to the Toolkit menu.
    /// </summary>
    //[UnityEditor.MenuItem("Toolkit/Add Action/Tracking")]
    //static void AddThisAction()
    //{
    //    AddAction<OpenChest>();
    //}

#endif
    #endregion

}
