package ugr.npi

import android.content.Context
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import android.os.Handler
import android.util.Log
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import kotlinx.android.synthetic.main.activity_shake.*
import kotlin.math.abs


class Shake : AppCompatActivity() {

    private lateinit var sensorShake: Sensor
    private lateinit var sensorManager: SensorManager
    private var shakeEventListener: SensorEventListener? = null
    private var timeThreshold: Long = 100
    private var shakeThreshold: Float = 500.0f
    private var lastUpdate: Long = System.currentTimeMillis()

    private var phase = 0
    private var changedPhaseAt = 0.toLong()
    private lateinit var layout: ConstraintLayout
    private lateinit var context: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_shake)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensorShake = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY)

        layout = this.layout_shake
        context = this

        shakeEventListener = object : SensorEventListener {
            var last_x = 0.0f
            var last_y = 0.0f
            var last_z = 0.0f

            override fun onSensorChanged(sensorEvent: SensorEvent) {
                val currTime = System.currentTimeMillis()
                val diffTime = currTime - lastUpdate

                // If one second passed after changing phase, and the threshold before last measure
                if ((currTime - changedPhaseAt) > 1000 && diffTime > timeThreshold) {
                    lastUpdate = currTime

                    val x = sensorEvent.values[0]
                    val y = sensorEvent.values[1]
                    val z = sensorEvent.values[2]

                    // Only measured speed in movement on way down
                    val speed = (abs(x) - abs(last_x)) / diffTime * 10000

                    // Check speed when phone is half-way down
                    if (x > 8.5 && speed > shakeThreshold) {
                        when (phase) {
                            0 -> {
                                layout.setBackgroundResource(R.drawable.wall_damaged)
                                Toast.makeText(applicationContext, "Almost there!", Toast.LENGTH_SHORT).show()
                                phase = 1

                                // Wait a second to continue
                                changedPhaseAt = currTime
                            }
                            1 -> {
                                layout.setBackgroundResource(R.drawable.wall_broken)
                                Toast.makeText(applicationContext, "Done :D", Toast.LENGTH_SHORT).show()

                                Handler().postDelayed({
                                    val mainIntent = Intent(context, SenderActivity::class.java)
                                    startActivity(mainIntent)
                                    finish()
                                }, 3000)

                                // Stopping the listener
                                sensorManager.unregisterListener(shakeEventListener)
                            }
                        }
                    }

                    // Start tracking when phone is up
                    if (y > 8.5) {
                        last_x = x
                        last_y = y
                        last_z = z
                    }
                }
            }

            // Don't needed, we will only change mode when the sensor reports a new value
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }
    }

    // ---------------------------------------------------------------------------------------------

    override fun onResume() {
        super.onResume()

        // Resuming sensors
        sensorManager.registerListener(
            shakeEventListener,
            sensorShake,
            SensorManager.SENSOR_DELAY_FASTEST
        )
    }

    // ---------------------------------------------------------------------------------------------

    override fun onPause() {
        super.onPause()

        // (Mostly?) All sensors should be paused when app pass to background
        sensorManager.unregisterListener(shakeEventListener)
    }
}
