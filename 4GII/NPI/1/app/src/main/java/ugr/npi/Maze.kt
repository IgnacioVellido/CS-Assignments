package ugr.npi

import android.content.Context
import android.content.Intent
import android.graphics.*
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.view.View
import android.widget.Toast


class Maze : AppCompatActivity() {

    private lateinit var sensorGravity: Sensor
    private lateinit var sensorManager: SensorManager
    private var gravityEventListener: SensorEventListener? = null

    private lateinit var mazeView: MazeView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val context = this

        // Using gravity sensor (mix of accelerometer and gyroscope) -------------------------------
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensorGravity = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY)

        gravityEventListener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                // Inverting x value, y value goes as normal
                val win = mazeView.updateBall(-event!!.values[0], event.values[1])

                // Sending the user to get the key
                if (win) {
                    Toast.makeText(applicationContext, "You win!!", Toast.LENGTH_LONG).show()

                    // Stopping the listener
                    sensorManager.unregisterListener(gravityEventListener)

                    Handler().postDelayed({
                        //After 3 seconds, the key will be unlocked and the user will be ready to
                        // send the nfc message with his device
                        val mainIntent = Intent(context, SenderActivity::class.java)
                        startActivity(mainIntent)
                        finish()
                    }, 3000)
                }
            }

            // Don't needed, we will only change mode when the sensor reports a new value
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) { }
        }

        // Setting the view
        mazeView = MazeView(this)
        setContentView(mazeView)
    }

    // ---------------------------------------------------------------------------------------------

    override fun onResume() {
        super.onResume()

        // Resuming sensors
        sensorManager.registerListener(
            gravityEventListener,
            sensorGravity,
            SensorManager.SENSOR_DELAY_FASTEST
        )
    }

    // ---------------------------------------------------------------------------------------------

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(gravityEventListener)
    }
}

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

class MazeView(context: Context) : View(context) {
    // Ball coordinates, velocity, style
    private var initialCx: Float
    private var initialCy: Float
    private var cx = 0f
    private var cy = 0f

    private var vx = 0.0f
    private var vy = 0.0f

    private val ballRadius = 30f
    private var ballPaint: Paint = Paint()

    // Goal
    private var gx = 0.0f
    private var gy = 0.0f

    private val goalRadius = 90f
    private var goalPaint: Paint = Paint()

    // Path
    private var path = arrayListOf<RectF>()
    private var pathPaint: Paint = Paint()

    // Screen size
    private var windowWidth = 0
    private var windowHeight = 0


    init {
        setBackgroundResource(R.drawable.maze_background)

        // Getting window size (they are not the real pixels, affected by device bar)
        // Upper-left corner si (0,0)
        windowWidth = resources.displayMetrics.widthPixels
        windowHeight = resources.displayMetrics.heightPixels

        // Initial position of the ball
        initialCx = (1 * (windowWidth / 4)).toFloat()
        initialCy = (1 * (windowHeight / 4)).toFloat()
        cx = initialCx
        cy = initialCy

        // Position of the goal
        gx = (3 * (windowWidth / 4)).toFloat()
        gy = (3 * (windowHeight / 4)).toFloat()

        // Setting the drawing style for the ball
        ballPaint.color = Color.GREEN
        ballPaint.style = Paint.Style.FILL
        ballPaint.isAntiAlias = true

        // Setting the drawing style for the goal
        goalPaint.color = Color.YELLOW
        goalPaint.style = Paint.Style.FILL
        goalPaint.isAntiAlias = true

        // Path
        createPath()
        pathPaint.color = Color.LTGRAY
        pathPaint.style = Paint.Style.FILL
        pathPaint.isAntiAlias = true
    }

    // ---------------------------------------------------------------------------------------------

    override fun onDraw(canvas: Canvas?) {
        super.onDraw(canvas)

        // Drawing the path
        for (rect in path)
            canvas?.drawRect(rect, pathPaint)

        canvas?.drawCircle(gx,gy, goalRadius, goalPaint)
        canvas?.drawCircle(cx,cy, ballRadius, ballPaint)
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * Creating the path to follow
     */
    private fun createPath() {
        var left  = (1*(windowWidth / 6)).toFloat()
        var right = (3*(windowWidth / 6)).toFloat()
        var up   = (1*(windowHeight / 6)).toFloat()
        var down = (3*(windowHeight / 6)).toFloat()

        var rect = RectF(left, up, right, down)
        path.add(rect)

        left  = (3*(windowWidth / 6)).toFloat()
        right = (5*(windowWidth / 6)).toFloat()
        up   = (3*(windowHeight / 6)).toFloat()
        down = (5*(windowHeight / 6)).toFloat()

        rect = RectF(left, up, right, down)
        path.add(rect)

        left  = (1*(windowWidth / 6)).toFloat()
        right = (5*(windowWidth / 6)).toFloat()
        up   = (2.5*(windowHeight / 6)).toFloat()
        down = (3.5*(windowHeight / 6)).toFloat()

        rect = RectF(left, up, right, down)
        path.add(rect)
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * To check if ball if out of boundaries
     */
    private fun inPath(): Boolean {
        var inside = false

        for (rect in path) {
            if (rect.contains(cx, cy))
                inside = true
        }

        return inside
    }

    /**
     * To check if ball reached the goal
     */
    private fun inGoal(): Boolean {
        return cx > (gx - goalRadius) && cx < (gx + goalRadius)
                && cy > (gy - goalRadius) && cy < (gy + goalRadius)
    }

    //----------------------------------------------------------------------------------------------

    /**
     * Updates ball coordinates considering the velocity and the new value received from sensor
     */
    fun updateBall(sensorx: Float, sensory: Float): Boolean {
        // Reducing the velocity of the move
        vx += sensorx / 100
        vy += sensory / 100

        // Updating the coordinates
        cx += vx
        cy += vy

        // Checking if objective is completed or out of borders
        if (inGoal()) {
            return true
        }

        if (!inPath()) {
            cx = initialCx
            cy = initialCy
            vx = 0f
            vy = 0f
        }

        // Comparing with screen boundaries
        if (cx > (windowWidth - ballRadius)) {
            cx = windowWidth - ballRadius
            vx = 0f
        }
        else if (cx < ballRadius) {
            cx = ballRadius
            vx = 0f
        }

        if (cy > (windowHeight - ballRadius)) {
            cy = windowHeight - ballRadius
            vy = 0f
        }
        else if(cy < ballRadius) {
            cy = ballRadius
            vy = 0f
        }

        // Redraw canvas
        invalidate()

        // Not winning yet
        return false
    }
}
