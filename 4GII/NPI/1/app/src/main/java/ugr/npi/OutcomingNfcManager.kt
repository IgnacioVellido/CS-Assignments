package ugr.npi

import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.nfc.NfcEvent

// https://expertise.jetruby.com/a-complete-guide-to-implementing-nfc-in-a-kotlin-application-5a94c5baf4dd

class OutcomingNfcManager(
    private val nfcActivity: NfcActivity
) :
    NfcAdapter.CreateNdefMessageCallback,
    NfcAdapter.OnNdefPushCompleteCallback {

    override fun createNdefMessage(event: NfcEvent): NdefMessage {
        // creating outcoming NFC message with a helper method
        // you could as well create it manually and will surely need, if Android version is too low
        val outString = nfcActivity.getOutcomingMessage()

        with(outString) {
            val outBytes = this.toByteArray()
            val outRecord = NdefRecord.createMime("text/plain", outBytes) //changed from the original, I think is not working
            return NdefMessage(outRecord)
        }
    }

    override fun onNdefPushComplete(event: NfcEvent) {
        // onNdefPushComplete() is called on the Binder thread, so remember to explicitly notify
        // your view on the UI thread
        nfcActivity.signalResult()
    }


    /*
    * Callback to be implemented by a Sender activity
    * */
    interface NfcActivity {
        fun getOutcomingMessage(): String

        fun signalResult()
    }
}