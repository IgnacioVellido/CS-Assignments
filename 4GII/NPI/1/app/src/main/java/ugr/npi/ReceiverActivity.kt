package ugr.npi

import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import kotlinx.android.synthetic.main.activity_receiver.*
import kotlinx.android.synthetic.main.activity_sender.*
import java.util.*

// https://expertise.jetruby.com/a-complete-guide-to-implementing-nfc-in-a-kotlin-application-5a94c5baf4dd

class ReceiverActivity : AppCompatActivity() {

    private var nfcAdapter: NfcAdapter? = null
    private lateinit var receiver : TextView
    private lateinit var op_chest : ImageView
    private lateinit var cl_chest : ImageView
    private var startTime : Long = 0
    private var endTime : Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_receiver)

        // Check if NFC Adapter is supported
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        if (nfcAdapter == null) {
            Toast.makeText(this, "NFC not Supported", Toast.LENGTH_LONG).show()
            finish()
        }

        // Check if NFC Adapter is enabled
        val ncfAdptLocal = nfcAdapter

        if (ncfAdptLocal != null && !ncfAdptLocal.isEnabled()) {
            Toast.makeText(this, "Enable NFC before using the app", Toast.LENGTH_LONG).show();
            val intent = Intent(Settings.ACTION_WIRELESS_SETTINGS)
            startActivity(intent)
        }

        receiver = this.tv_receiver
        op_chest = this.open_chest
        cl_chest = this.closed_chest
        startTime = System.currentTimeMillis()
    }

    override fun onNewIntent(intent: Intent) {
        // also reading NFC message from here in case this activity is already started in order
        // not to start another instance of this activity
        receiveMessageFromDevice(intent)
    }

    private fun receiveMessageFromDevice(intent: Intent) {
        val action = intent.action
        if (NfcAdapter.ACTION_NDEF_DISCOVERED == action) {
            val parcelables = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)
            with(parcelables) {
                val inNdefMessage = this[0] as NdefMessage
                val inNdefRecords = inNdefMessage.records
                val ndefRecord_0 = inNdefRecords[0]

                val inMessage = String(ndefRecord_0.payload)

                endTime = System.currentTimeMillis()

                val time_minutes = (endTime - startTime)/60000
                val time_seconds =((((endTime - startTime)/60000f) - time_minutes)*60f).toInt()

                cl_chest.visibility = View.INVISIBLE
                op_chest.visibility = View.VISIBLE

                receiver.text = "Congratulations team " + inMessage + "!! Go northeast to Generalife Garden. You will find the next hint next " +
                        "to the biggest tree somewhere in the courtyard\n\nYour current time is: " + time_minutes.toString() + " minutes and " +
                        time_seconds.toString() + " seconds"
            }
        }
    }

    // From here and on is not so important, just extra checking and onResume/Pause methods to enable/disable the nfc connection

    private fun enableForegroundDispatch(activity: AppCompatActivity, adapter: NfcAdapter?) {

        // here we are setting up receiving activity for a foreground dispatch
        // thus if activity is already started it will take precedence over any other activity or app
        // with the same intent filters

        // I think this is for checking if the type, etc of the nfc intent is the one that we set in the Manifest

        val intent = Intent(activity.applicationContext, activity.javaClass)
        intent.flags = Intent.FLAG_ACTIVITY_SINGLE_TOP

        val pendingIntent = PendingIntent.getActivity(activity.applicationContext, 0, intent, 0)

        val filters = arrayOfNulls<IntentFilter>(1)
        val techList = arrayOf<Array<String>>()

        filters[0] = IntentFilter()
        with(filters[0]) {
            this?.addAction(NfcAdapter.ACTION_NDEF_DISCOVERED)
            this?.addCategory(Intent.CATEGORY_DEFAULT)
            try {
                //this?.addDataType(NdefRecord.TNF_MIME_MEDIA.toString()) //invent
                this?.addDataType("text/plain") //invent
            } catch (ex: IntentFilter.MalformedMimeTypeException) {
                throw RuntimeException("Check your MIME type")
            }
        }

        adapter?.enableForegroundDispatch(activity, pendingIntent, filters, techList)
    }

    override fun onResume() {
        super.onResume()

        // foreground dispatch should be enabled here, as onResume is the guaranteed place where app
        // is in the foreground
        enableForegroundDispatch(this, NfcAdapter.getDefaultAdapter(this)) //invent
        receiveMessageFromDevice(intent)
    }

    private fun disableForegroundDispatch(activity: AppCompatActivity, adapter: NfcAdapter?) {
        adapter?.disableForegroundDispatch(activity)
    }


    override fun onPause() {
        super.onPause()
        disableForegroundDispatch(this, NfcAdapter.getDefaultAdapter(this)) //invent
    }
}
