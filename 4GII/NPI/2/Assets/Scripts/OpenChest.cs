using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using RSUnityToolkit;

/// <summary>
/// Activate action: links the transformation of the associated Game Object to the real world tracked source
/// </summary>
public class OpenChest : VirtualWorldBoxAction
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
    public Defaults SetDefaultsTo = Defaults.HandTracking;

    public float upthreshold = 15.0f;
    public float leftthreshold = 2.0f;
    public float rightthreshold = 2.0f;

    #endregion

    #region Private Fields

    [SerializeField]
    [HideInInspector]
    private Defaults _lastDefaults = Defaults.HandTracking;

    private bool _actionTriggered = false;

    private SmoothingUtility _translationSmoothingUtility = new SmoothingUtility();
    private SmoothingUtility _rotationSmoothingUtility = new SmoothingUtility();
    private bool gestureStarted = false;
    private Vector3 old_right_vec;
    private Vector3 old_left_vec;

    #endregion

    #region Ctor

    /// <summary>
    /// Constructor
    /// </summary>
    public OpenChest() : base()
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
                ((EventTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<TwoHandsDetectedRule>() };
                break;
            case 1:
                ((TrackTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<HandTrackingRule>() };
                break;
            case 2:
                ((TrackTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<HandTrackingRule>() };
                break;
            case 3:
                trigger.FriendlyName = "Stop Event";
                ((EventTrigger)trigger).Rules = new BaseRule[1] { AddHiddenComponent<TwoHandsLostRule>() };
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
        SupportedTriggers = new Trigger[4]{
            AddHiddenComponent<EventTrigger>(),
            AddHiddenComponent<TrackTrigger>(),
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
        if (_actionTriggered && SupportedTriggers[3].Success)
        {
            _actionTriggered = false;
            gestureStarted = false;
        }

        if (!_actionTriggered)
        {
            return;
        }

        TrackTrigger right_trgr = (TrackTrigger)SupportedTriggers[1];
        TrackTrigger left_trgr = (TrackTrigger)SupportedTriggers[2];

        if (right_trgr.Success)
        {
            // Get hands positions
            Vector3 right_vec = right_trgr.Position;
            Vector3 left_vec = left_trgr.Position;

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

            right_vec.x = (right_vec.x * VirtualWorldBoxDimensions.x);
            right_vec.y = (right_vec.y * VirtualWorldBoxDimensions.y);
            right_vec.z = (right_vec.z * VirtualWorldBoxDimensions.z);

            left_vec.x = (left_vec.x * VirtualWorldBoxDimensions.x);
            left_vec.y = (left_vec.y * VirtualWorldBoxDimensions.y);
            left_vec.z = (left_vec.z * VirtualWorldBoxDimensions.z);


            // Check gesture
            if (!gestureStarted)
            {
                gestureStarted = true;
                old_right_vec = right_vec;
                old_left_vec = left_vec;
            }
            else
            {
                // Corroborating the move is up and not to far to one side
                bool correct_move_up = (right_vec.y > (old_right_vec.y + upthreshold) && left_vec.y > (old_left_vec.y + upthreshold));
                bool correct_move_left = !(right_vec.x < (old_right_vec.x - leftthreshold) && left_vec.x < (old_left_vec.x - leftthreshold));
                bool correct_move_right = !(right_vec.x > (old_right_vec.x + rightthreshold) && left_vec.x > (old_left_vec.x + rightthreshold));

                if (correct_move_up && correct_move_right && correct_move_left)
                {
                    Debug.Log("Chest opened");
                    gestureStarted = false;

                    // Opening the chest in the game
                    GameObject chest_open = GameObject.Find("chest_open");
                    chest_open.GetComponent<MeshRenderer>().enabled = true;

                    GameObject chest_close = GameObject.Find("chest_close");
                    chest_close.GetComponent<MeshRenderer>().enabled = false;
                }
                else if (correct_move_up)
                {
                    // Forcing to restart the movement
                    gestureStarted = false;
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
