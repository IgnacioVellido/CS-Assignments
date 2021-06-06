package ugr.npi

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.media.MediaRecorder
import android.nfc.NfcAdapter
import android.os.Bundle
import android.os.Handler
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.app.ActivityCompat
import kotlinx.android.synthetic.main.activity_blow.*
import kotlinx.android.synthetic.main.activity_blow.view.*
import java.io.IOException
import androidx.annotation.NonNull
import androidx.core.app.ComponentActivity
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.R.attr.name
import android.util.Log
import androidx.fragment.app.FragmentActivity


class Blow : AppCompatActivity() {

    private var mediaRecorder: MediaRecorder? = null
    private var handler = Handler()
    private var phase = 0
    private lateinit var layout: ConstraintLayout
    private lateinit var context: Context
    private var changedPhaseAt = 0.toLong()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this,
                                        arrayOf("Manifest.permission.RECORD_AUDIO"), 0)
        }

        setContentView(R.layout.activity_blow)

        // To modify the displayed text
        layout = this.layout_blow
        context = this
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            if (requestCode == 0) {
                mediaRecorder = MediaRecorder()
                mediaRecorder!!.setAudioSource(MediaRecorder.AudioSource.MIC)
                mediaRecorder!!.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP)
                mediaRecorder!!.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)
                mediaRecorder!!.setOutputFile("/dev/null")

                try {
                    mediaRecorder!!.prepare()
                } catch (e: IllegalStateException) {
                    e.printStackTrace()
                } catch (e: IOException) {
                    e.printStackTrace()
                }

                mediaRecorder!!.start()

                handler.postDelayed(mPollTask, 300)
            }
        } else {
            Toast.makeText(this, "Please turn on microphone permissions", Toast.LENGTH_LONG).show()
            finish()
        }
    }

    /**
     * Background service to check received value
     * Depending of the phase (it changes based on the game), shows a text/background to the user.
     * When all phases are completed, launches NFC
     */
    private var mPollTask = object : Runnable {
        override fun run() {
            val amplitude = mediaRecorder!!.maxAmplitude / 2700.0 // Getting the amount of noise detected
            var noiseThreshold: Int  // Threshold to know if is blowing

            val currTime = System.currentTimeMillis()

            if ((currTime - changedPhaseAt) > 5000) {
                when (phase) {
                    0 -> {
                        noiseThreshold = 8

                        if (amplitude > noiseThreshold) {
                            Toast.makeText(applicationContext, "Good lungs out there boy!", Toast.LENGTH_LONG).show()
                            layout.setBackgroundResource(R.drawable.dust_page)
                            phase = 1
                            layout.blow_text.text = "Oh, the book it's still dusty inside, be careful now"

                            // Wait a second to continue
                            changedPhaseAt = currTime
                        }
                        else if (amplitude > 2){
                            Toast.makeText(applicationContext, "Is this all you got?", Toast.LENGTH_LONG).show()
                        }
                    }
                    1 -> {
                        noiseThreshold = 3

                        if (amplitude > noiseThreshold && amplitude < 5) {
                            Toast.makeText(applicationContext, "Nice job :D", Toast.LENGTH_LONG).show()
                            phase = 2
                        }
                        else if (amplitude > 8) {
                            Toast.makeText(applicationContext, "Woah, you are gonna break it!!", Toast.LENGTH_LONG).show()
                        }
                        else if (amplitude > 1){
                            Toast.makeText(applicationContext, "Not enough! Try again", Toast.LENGTH_LONG).show()
                        }
                    }
                    2 -> {
                        Handler().postDelayed({
                            //After 3 seconds, the key will be unlocked and the user will be ready to send the nfc message with his device
                            val mainIntent = Intent(context, SenderActivity::class.java)
                            startActivity(mainIntent)
                            finish()
                        }, 3000)

                        // Stopping the handler
                        handler.removeCallbacks(this)
                        return
                    }
                }
            }

            // Calling this service again in 1 second
            handler.postDelayed(this, 500)
        }
    }

    override fun onStop() {
        super.onStop()

        handler.removeCallbacks(mPollTask)
        if (mediaRecorder != null)
            mediaRecorder!!.stop()
    }

    override fun onResume() {
        super.onResume()

        handler.postDelayed(mPollTask, 300)
    }
}
