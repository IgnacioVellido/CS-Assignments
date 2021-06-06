package ugr.npi

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class GamesTest : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_games_test)

        var buttonBlow= findViewById<Button>(R.id.buttonBlow)
        buttonBlow.setOnClickListener {
            val intent = Intent(this, Blow::class.java)
            startActivity(intent)
        }

        var buttonShake= findViewById<Button>(R.id.buttonShake)
        buttonShake.setOnClickListener {
            val intent = Intent(this, Shake::class.java)
            startActivity(intent)
        }

        var buttonMaze= findViewById<Button>(R.id.buttonMaze)
        buttonMaze.setOnClickListener {
            val intent = Intent(this, Maze::class.java)
            startActivity(intent)
        }

        var buttonTrueFalse= findViewById<Button>(R.id.buttonTrueFalse)
        buttonTrueFalse.setOnClickListener {
            val intent = Intent(this, TrueFalse::class.java)
            startActivity(intent)
        }

        var buttonSender= findViewById<Button>(R.id.buttonSender)
        buttonSender.setOnClickListener {
            val intent = Intent(this, SenderActivity::class.java)
            startActivity(intent)
        }

        var buttonReceiver= findViewById<Button>(R.id.buttonReceiver)
        buttonReceiver.setOnClickListener {
            val intent = Intent(this, ReceiverActivity::class.java)
            startActivity(intent)
        }

        var buttonMainAct= findViewById<Button>(R.id.buttonMainAct)
        buttonMainAct.setOnClickListener {
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
        }
    }
}
