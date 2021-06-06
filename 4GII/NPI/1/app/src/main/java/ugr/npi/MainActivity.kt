package ugr.npi

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity


class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Creating the view
        setContentView(R.layout.activity_main)

        // Routes button
        val buttonRoutes = findViewById<Button>(R.id.routes)
        buttonRoutes.setOnClickListener {
            val intent = Intent(this, AlhambraMap::class.java).apply {
                putExtra("mode_requested", "routes")
                putExtra("route_selected", "A1")
            }
            startActivity(intent)
        }

        // Games button
        val buttonGames = findViewById<Button>(R.id.games)
        buttonGames.setOnClickListener {
            val intent = Intent(this, GamesTest::class.java)
            startActivity(intent)
        }
    }
}