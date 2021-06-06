package ugr.npi

import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Bundle
import android.provider.Settings
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_sender.*

// https://expertise.jetruby.com/a-complete-guide-to-implementing-nfc-in-a-kotlin-application-5a94c5baf4dd

class SenderActivity : AppCompatActivity(), OutcomingNfcManager.NfcActivity {

    private var outcomingNfcCallback: OutcomingNfcManager? = null //needed
    private var nfcAdapter: NfcAdapter? = null

    private lateinit var editableText : EditText
    private lateinit var message : TextView


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sender)

        editableText = this.et_message
        message=this.tv_out_message

        // set the button for sending messages
        var buttonSetMessage = findViewById<Button>(R.id.btn_set_out_message)
        buttonSetMessage .setOnClickListener {
            message.text = editableText.text
        }

        // Check if NFC Adapter is supported
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        if (nfcAdapter == null) {
            Toast.makeText(this, "NFC not Supported", Toast.LENGTH_LONG).show()
            finish()
        }

        // Check if NFC Adapter is supported
        val ncfAdptLocal = nfcAdapter

        if (ncfAdptLocal != null && !ncfAdptLocal.isEnabled) {
            Toast.makeText(this, "Enable NFC before using the app", Toast.LENGTH_LONG).show();
            val intent = Intent(Settings.ACTION_WIRELESS_SETTINGS)
            startActivity(intent)
        }

        // encapsulate sending logic in a separate class
        this.outcomingNfcCallback = OutcomingNfcManager(this)
        this.nfcAdapter?.setOnNdefPushCompleteCallback(outcomingNfcCallback, this)
        this.nfcAdapter?.setNdefPushMessageCallback(outcomingNfcCallback, this)

    }

    override fun signalResult() {
        // this will be triggered when NFC message is sent to a device.
        // should be triggered on UI thread. We specify it explicitly
        // cause onNdefPushComplete is called from the Binder thread
        runOnUiThread {
            Toast.makeText(this, R.string.message_beaming_complete, Toast.LENGTH_SHORT).show()
        }
    }

    override fun getOutcomingMessage(): String {
        return this.tv_out_message.text.toString()
    }

}



