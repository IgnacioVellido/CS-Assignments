package ugr.npi

import android.content.Intent
import android.graphics.Color
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.view.MotionEvent
import android.view.MotionEvent.actionToString
import androidx.core.view.MotionEventCompat
import kotlinx.android.synthetic.main.activity_true_false.*

class TrueFalse : AppCompatActivity() {

    private var x1_finger1: Float = 0.toFloat()
    private var x1_finger2: Float = 0.toFloat()
    private var x2_finger1: Float = 0.toFloat()
    private var x2_finger2: Float = 0.toFloat()

    private var multitouch2: Boolean = false
    private var handler_incoming: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_true_false)
    }

    override fun onTouchEvent(touchevent: MotionEvent): Boolean {

        //for debugging the current action
        val (xPos: Int, yPos: Int) = MotionEventCompat.getActionMasked(touchevent).let { action ->
            Log.d("MotionEventCompat", "The action is ${actionToString(action)}")
            // Get the index of the pointer associated with the action.
            MotionEventCompat.getActionIndex(touchevent).let { index ->
                // The coordinates of the current screen contact, relative to
                // the responding View or Activity.
                MotionEventCompat.getX(touchevent, index).toInt() to MotionEventCompat.getY(touchevent, index).toInt()
            }
        }

        if(touchevent.pointerCount == 2) {
            Log.d("", "multitouch event with two fingers")
            Log.d("", touchevent.pointerCount.toString())
            multitouch2 = true
        }
        else {
            // Single touch event
            Log.d("", "Single/3+ finger event")
            multitouch2 = false
        }

        if (multitouch2) {
            when (touchevent.actionMasked) {
                MotionEvent.ACTION_POINTER_DOWN -> {
                    //we get the coordinates of the down movement
                    x1_finger1 = touchevent.getX(0)
                    x1_finger2 = touchevent.getX(1)
                }
                MotionEvent.ACTION_POINTER_UP -> {
                    //we get the coordinates of the up movement
                    x2_finger1 = touchevent.getX(0)
                    x2_finger2 = touchevent.getX(1)

                    //swipe right with both fingers
                    if (x1_finger1 > x2_finger1 && x1_finger2 > x2_finger2 && !handler_incoming) {
                        this.tv_true_false.text = "TRUE \nYou unlocked a key!"
                        this.tv_true_false.setTextColor(resources.getColor(R.color.colorTrue))
                        this.handler_incoming = true

                        Handler().postDelayed({
                            //After 3 seconds, the key will be unlocked and the user will be ready to send the nfc message with his device
                            val mainIntent = Intent(this, SenderActivity::class.java)
                            startActivity(mainIntent)
                            finish()
                        }, 3000)
                    }

                    else if (x1_finger1 < x2_finger1 && x1_finger2 < x2_finger2 && !handler_incoming){
                        this.tv_true_false.text = "FALSE \n Incorrect answer, you got a 30 seconds penalty \n Try again!"
                        this.tv_true_false.setTextColor(resources.getColor(R.color.colorFalse))

                        this.handler_incoming = true

                        Handler().postDelayed({
                            //After 3 seconds, the key will be unlocked and the user will be ready to send the nfc message with his device
                            val mainIntent = Intent(this, TrueFalse::class.java)
                            startActivity(mainIntent)
                            finish()
                        }, 3000)
                    }
                }
            }
        }

        return true
    }

    // Given an action int, returns a string description
    fun actionToString(action: Int): String {
        return when (action) {
            MotionEvent.ACTION_DOWN -> "Down"
            MotionEvent.ACTION_MOVE -> "Move"
            MotionEvent.ACTION_POINTER_DOWN -> "Pointer Down"
            MotionEvent.ACTION_UP -> "Up"
            MotionEvent.ACTION_POINTER_UP -> "Pointer Up"
            MotionEvent.ACTION_OUTSIDE -> "Outside"
            MotionEvent.ACTION_CANCEL -> "Cancel"
            else -> ""
        }
    }
}
