package ugr.npi

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.provider.Settings
import android.util.Log
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.MotionEvent
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.*
import com.google.android.material.bottomappbar.BottomAppBar
import com.google.android.material.floatingactionbutton.FloatingActionButton
import kotlinx.android.synthetic.main.activity_alhambra_map.*
import java.lang.Exception

class AlhambraMap : AppCompatActivity(), OnMapReadyCallback, GoogleMap.OnMarkerClickListener {

    private var locationMarker: Circle? = null
    private lateinit var mMap: GoogleMap
    private var modeRequested: String = "none"
    private var mapLoaded = false

    // ---------------------------------------------------------------------------------------------
    // Location related attributes

    private lateinit var mFusedLocationProviderClient: FusedLocationProviderClient
    private var mLastKnownLocation: Location? = null

    // A default location (Alhambra) and default zoom to use when location permission is not granted.
    private val mDefaultLocation = LatLng(37.176400, -3.589595)
    private val mDefaultZoom = 17f

    // Keys for storing activity state.
    companion object {
        const val KEY_CAMERA_POSITION: String = "camera_position"
        const val KEY_LOCATION: String = "location"
        const val PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION = 1
    }

    // To check if permissions are granted
    private var mLocationPermissionGranted: Boolean = false

    // For the simulation
    private var userLocations = arrayListOf<Location>()
    private var nextLocation = 0

    // ---------------------------------------------------------------------------------------------
    // Map style

    private lateinit var sensorLight: Sensor
    private lateinit var sensorManager: SensorManager
    private var lightEventListener: SensorEventListener? = null

    private var isDayTime = true
    private val context: Context = this

    // ---------------------------------------------------------------------------------------------
    // Markers

    // Should be in a unique structure
    private var markersGame = arrayListOf<Marker>()
    private var locationsGame = arrayListOf<Pair<LatLng, String>>()
    private var markersInformation = arrayListOf<Marker>()
    private var locationsInformation = arrayListOf<LatLng>()
    private var markersBathroom = arrayListOf<Marker>()
    private var locationsBathroom = arrayListOf<LatLng>()
    private var markersExit = arrayListOf<Marker>()
    private var locationsExit = arrayListOf<LatLng>()

    // To swipe
    private var downFinger1 = 0.0f
    private var downFinger2 = 0.0f
    private var downFinger3 = 0.0f
    private var upFinger1 = 0.0f
    private var upFinger2 = 0.0f
    private var upFinger3 = 0.0f

    private var showInformation = false
    private var showGames = false

    private lateinit var vibrator: Vibrator

    // ---------------------------------------------------------------------------------------------
    // Routes, regions and user

    private lateinit var user: User
    private var regions = arrayListOf<Region>()
    private var routes = arrayListOf<Route>()
    private lateinit var selectedRoute: String

    // ---------------------------------------------------------------------------------------------
    // on... functions
    // ---------------------------------------------------------------------------------------------

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_alhambra_map)
        setSupportActionBar(bottom_app_bar)

        // To get last location later on
        mFusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this)

        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)

        // Light sensor ----------------------------------------------------------------------------
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        sensorLight = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT)

        lightEventListener = object : SensorEventListener {
            override fun onSensorChanged(sensorEvent: SensorEvent) {
                changeMapStyle(sensorEvent.values[0])
            }

            // Don't needed, we will only change mode when the sensor reports a new value
            override fun onAccuracyChanged(sensor: Sensor, i: Int) {}
        }
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * Saves the state of the map when the activity is paused.
     */
    override fun onSaveInstanceState(outState: Bundle) {
        outState.putParcelable(KEY_CAMERA_POSITION, mMap.cameraPosition)
        outState.putParcelable(KEY_LOCATION, mLastKnownLocation)
        super.onSaveInstanceState(outState)
    }

    // ---------------------------------------------------------------------------------------------

    override fun onMapReady(googleMap: GoogleMap) {
        mMap = googleMap
        mapLoaded = true

        // -----------------------------------------------------------------------------------------
        // Setting night mode by default
        val style = MapStyleOptions.loadRawResourceStyle(context, R.raw.map_night_mode)
        mMap.setMapStyle(style)

        // -----------------------------------------------------------------------------------------
        // Defining a region with Alhambra coordinates
        val alhambraBounds = LatLngBounds(
            // Southwest corner - Northeast corner
            LatLng(37.173602, -3.593538), LatLng(37.179521, -3.584102)
        )

        // Constrain the camera target to the Alhambra bounds.
        mMap.setLatLngBoundsForCameraTarget(alhambraBounds)

        // Defining max and minimum zoom
        mMap.setMinZoomPreference(16f)
        mMap.setMaxZoomPreference(22f)

        // -----------------------------------------------------------------------------------------
        // Prompt the user for permission.
        getLocationPermission()

        // Turn on the My Location layer and the related control on the map.
        updateLocationUI()

        // Get the current location of the device and set the position of the map.
        getDeviceLocation()

        // -----------------------------------------------------------------------------------------
        // Creating the map objects
        createRegions()
        createRoutes()

        createGamePoints()
        createBathroomPoints()
        createExitPoints()
        createInformationPoints()

        drawAllMarkers()
        mMap.setOnMarkerClickListener(this)

        // Hiding all non requested markers
        hideAllMarkers()

        // Creating the vibrator for game notifications
        vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

        // Creating the polygons of the regions
        for (reg in regions)
            drawRegion(reg)

        // Setting a testing user
        user = User(1)
        if (user.updateLocation(LatLng(37.176912, -3.590014), regions)) {
            // Removing old regions
            clearRegions()

            for (reg in regions)
                drawRegion(reg)

            if (modeRequested == "routes")
                drawRoute()

            // Drawing the new region
            val reg = findRegionById(user.region)
            if (reg != null)
                drawRegion(reg, fill = true)
            else
                Log.i("", "User located in non-existence region")
        }

        // -----------------------------------------------------------------------------------------
        // Simulation button
        createUserLocations()

        val button: FloatingActionButton = findViewById(R.id.fab)
        button.setOnClickListener{
            changeCoordinates()
        }
    }

    // ---------------------------------------------------------------------------------------------

    override fun onResume() {
        super.onResume()

        // Resuming sensors
        sensorManager.registerListener(
            lightEventListener,
            sensorLight,
            SensorManager.SENSOR_DELAY_FASTEST
        )
    }

    // ---------------------------------------------------------------------------------------------

    override fun onPause() {
        super.onPause()

        // (Mostly?) All sensors should be paused when app pass to background
        sensorManager.unregisterListener(lightEventListener)
    }


    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.map_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle item selection
        return when (item.itemId) {
            R.id.menuAlcazaba -> {
                selectedRoute = "A2"
                modeRequested = "routes"

                clearRegions()
                for (reg in regions)
                    drawRegion(reg)

                drawRoute()
                true
            }
            R.id.menuJardines -> {
                selectedRoute = "A1"
                modeRequested = "routes"

                clearRegions()
                for (reg in regions)
                    drawRegion(reg)

                drawRoute()
                true
            }
            R.id.menuGames -> {
                modeRequested = "games"

                showGames = !showGames
                if (showGames) {
                    Toast.makeText(applicationContext, "Game mode activated", Toast.LENGTH_LONG).show()
                }
                else {
                    Toast.makeText(applicationContext, "Game mode deactivated", Toast.LENGTH_LONG).show()
                    hideMarkersOfType("game")
                }
                true
            }
            R.id.menuInformation -> {
                modeRequested = "information"

                showInformation = !showInformation
                if (showInformation) {
                    hideMarkersOfType("exit")
                    hideMarkersOfType("bathroom")
                    hideMarkersOfType("information")
                }
                else {
                    showMarkersOfType("exit")
                    showMarkersOfType("bathroom")
                    showMarkersOfType("information")
                }

                true
            }
            R.id.gametest -> {
                val intent = Intent(this, GamesTest::class.java)
                startActivity(intent)

                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }


    // -----------------------------------------------------------------------------------------
    // Markers
    // -----------------------------------------------------------------------------------------

    /**
     * Draw a marker on the specified location
     */
    private fun drawMarker(loc: LatLng, type: String, gameType: String = "") {
        val height = 100
        val width = 100
        var title = ""
        var mipmap = 0

        when (type) {
            "game" -> {
                title = "What could it be?"
                mipmap = R.mipmap.marker_game
            }
            "information" -> {
                title = "Point of information"
                mipmap = R.mipmap.marker_information
            }
            "exit" -> {
                title = "Emergency exit"
                mipmap = R.mipmap.marker_exit
            }
            "bathroom" -> {
                title = "Bathroom"
                mipmap = R.mipmap.marker_bathroom
            }
            else -> {
                Log.e("Point type", "Point type not recognised")
            }
        }

        val bitmap = BitmapFactory.decodeResource(resources, mipmap)
        val smallMarker = Bitmap.createScaledBitmap(bitmap, width, height, false)

        val marker = mMap.addMarker(MarkerOptions()
            .position(loc)
            .title(title)
            .icon(BitmapDescriptorFactory.fromBitmap(smallMarker))
        )

        // To keep track of them
        when (type) {
            "game" -> {
                marker.tag = Pair(0, gameType)
                markersGame.add(marker)
            }
            "information" -> {
                marker.tag = Pair(1, "information")
                markersInformation.add(marker)
            }
            "exit" -> {
                marker.tag = Pair(2, "exit")
                markersExit.add(marker)
            }
            "bathroom" -> {
                marker.tag = Pair(3, "bathroom")
                markersBathroom.add(marker)
            }
            else -> {
                Log.e("Point type", "Point type not recognised")
            }
        }
    }

    /**
     * Hides all markers of a given type
     */
    private fun hideMarkersOfType(type: String) {
        when (type) {
            "game" -> {
                for (marker in markersGame)
                    marker.isVisible = false
            }
            "information" -> {
                for (marker in markersInformation)
                    marker.isVisible = false
            }
            "exit" -> {
                for (marker in markersExit)
                    marker.isVisible = false
            }
            "bathroom" -> {
                for (marker in markersBathroom)
                    marker.isVisible = false
            }
            else -> {
                Log.e("Point type", "Point type not recognised")
            }
        }
    }

    /**
     * Show all markers of a given type
     */
    private fun showMarkersOfType(type: String) {
        when (type) {
            "game" -> {
                for (marker in markersGame)
                    marker.isVisible = true
            }
            "information" -> {
                for (marker in markersInformation)
                    marker.isVisible = true
            }
            "exit" -> {
                for (marker in markersExit)
                    marker.isVisible = true
            }
            "bathroom" -> {
                for (marker in markersBathroom)
                    marker.isVisible = true
            }
            else -> {
                Log.e("Point type", "Point type not recognised")
            }
        }
    }

    /**
     * When clicking in a game marker, something happens
     */
    override fun onMarkerClick(marker: Marker): Boolean {
        val type = marker.tag as Pair<*, *>

        // If it is a game marker
        if (type.first == 0) {
            // Activate the specific game
            when (type.second) {
                "blow" -> {
                    val intent = Intent(this, Blow::class.java)
                    startActivity(intent)
                }
                "maze" -> {
                    val intent = Intent(this, Maze::class.java)
                    startActivity(intent)
                }
                "shake" -> {
                    val intent = Intent(this, Shake::class.java)
                    startActivity(intent)
                }
                "truefalse" -> {
                    val intent = Intent(this, TrueFalse::class.java)
                    startActivity(intent)
                }
                else -> {
                    Log.e("Game tag", "Unrecognised game tag")
                }
            }
        }

        // Because we still want the camera to center on the marker
        return false
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * Hide all possible markers
     */
    private fun hideAllMarkers() {
        hideMarkersOfType("game")
        hideMarkersOfType("information")
        hideMarkersOfType("exit")
        hideMarkersOfType("bathroom")
    }

    /**
     * Fully show all possible markers
     */
    private fun drawAllMarkers() {
        for (loc in locationsGame)
            drawMarker(loc.first, "game", loc.second)

        for (loc in locationsExit)
            drawMarker(loc, "exit")

        for (loc in locationsInformation)
            drawMarker(loc, "information")

        for (loc in locationsBathroom)
            drawMarker(loc, "bathroom")
    }

    // ---------------------------------------------------------------------------------------------

    /** The following points should be received from a file **/

    private fun createInformationPoints() {
        var coord = LatLng(37.17747461810394,-3.5906432210191053)
        locationsInformation.add(coord)
        coord = LatLng(37.177013849972994,-3.5894279830833042)
        locationsInformation.add(coord)
    }


    private fun createBathroomPoints() {
        var coord = LatLng(37.17660573462942,-3.5897694091899512)
        locationsBathroom.add(coord)
        coord = LatLng(37.1771246953933,-3.591049664234429)
        locationsBathroom.add(coord)
    }

    private fun createExitPoints() {
        var coord = LatLng(37.17655444369159,-3.58998532701565)
        locationsExit.add(coord)
        coord = LatLng(37.177071625720046,-3.5890398483379005)
        locationsExit.add(coord)
    }

    private fun createGamePoints() {
        var coord = LatLng(37.17693198552592,-3.590047848409552)
        locationsGame.add(Pair(coord, "blow"))
        coord = LatLng(37.1772418661964,-3.591060382312674)
        locationsGame.add(Pair(coord, "shake"))
        coord = LatLng(37.17715210638004,-3.591554243472721)
        locationsGame.add(Pair(coord, "maze"))
        coord = LatLng(37.17718691654971,-3.5897764544239275)
        locationsGame.add(Pair(coord, "truefalse"))
    }

    // ---------------------------------------------------------------------------------------------
    // Swipe between modes
    // ---------------------------------------------------------------------------------------------

    override fun dispatchTouchEvent(touchevent: MotionEvent): Boolean {
        var multitouchReceived = false

        if (touchevent.pointerCount >= 3) {
            when (touchevent.actionMasked) {
                MotionEvent.ACTION_POINTER_DOWN -> {
                    //we get the coordinates of the down movement
                    downFinger1 = touchevent.getX(0)
                    downFinger2 = touchevent.getX(1)
                    downFinger3 = touchevent.getX(2)
                }
                MotionEvent.ACTION_POINTER_UP -> {
                    //we get the coordinates of the up movement
                    upFinger1 = touchevent.getX(0)
                    upFinger2 = touchevent.getX(1)
                    upFinger3 = touchevent.getX(2)

                    //swipe left with both fingers
                    if (downFinger1 > upFinger1 && downFinger2 > upFinger2 && downFinger3 > upFinger3) {
                        showInformation = !showInformation
                        if (showInformation) {
                            hideMarkersOfType("exit")
                            hideMarkersOfType("bathroom")
                            hideMarkersOfType("information")
                        }
                        else {
                            showMarkersOfType("exit")
                            showMarkersOfType("bathroom")
                            showMarkersOfType("information")
                        }
                    }
                    // swipe right
                    else if (downFinger1 < upFinger1 && downFinger2 < upFinger2 && downFinger3 < upFinger3) {
                        showGames = !showGames
                        if (showGames) {
                            Toast.makeText(applicationContext, "Game mode activated", Toast.LENGTH_LONG).show()
                        }
                        else {
                            Toast.makeText(applicationContext, "Game mode deactivated", Toast.LENGTH_LONG).show()
                            hideMarkersOfType("game")
                        }
                    }
                }
            }

            multitouchReceived = true
        }

        // To don't move the map when doing multitouch
        return if (multitouchReceived)
            true
        else
            super.dispatchTouchEvent(touchevent)
    }

    // ---------------------------------------------------------------------------------------------
    // MapStyle
    // ---------------------------------------------------------------------------------------------

    /**
     * Change map style between day and night mode
     */
    private fun changeMapStyle(lux: Float) {
        if (mapLoaded) {
            val mode: Int

            if (lux < 40) {
                isDayTime = false

                mode = if (lux < 15) {
                            R.raw.map_full_dark_mode
                        } else {
                            R.raw.map_night_mode
                        }

                val style = MapStyleOptions.loadRawResourceStyle(context, mode)
                mMap.setMapStyle(style)
            }
            else if (!isDayTime && (lux >= 50)) {
                isDayTime = true
                mode = R.raw.map_day_mode

                val style = MapStyleOptions.loadRawResourceStyle(context, mode)
                mMap.setMapStyle(style)
            }
        }
    }

    // ---------------------------------------------------------------------------------------------
    // Routes
    // ---------------------------------------------------------------------------------------------

    /**
     * Creates some routes to test, actual routes should check regions and be defined from a file
     */
    private fun createRoutes() {
        var ids = arrayListOf<String>()
        ids.add("R1")
        ids.add("R2")
        ids.add("R3")
        ids.add("R4")
        ids.add("R8")
        var route = Route("A1", "Jardines", ids, "Jardines")
        routes.add(route)

        ids = arrayListOf()
        ids.add("R1")
        ids.add("R2")
        ids.add("R5")
        ids.add("R6")
        ids.add("R7")
        route = Route("A2", "Alcabaza", ids, "Alcazaba")
        routes.add(route)
    }

    /**
     * Having the route selected, emphasize it
     */
    private fun drawRoute() {
        val route = findRouteById(selectedRoute)

        for (regId in route!!.regions) {
            val reg = findRegionById(regId)
            drawRegion(reg!!, true)
        }
    }

    private fun findRouteById(id: String): Route? {
        for (route in routes)
            if (route.id == id)
                return route

        return null
    }

    // ---------------------------------------------------------------------------------------------
    // Regions
    // ---------------------------------------------------------------------------------------------

    /**
     * Draw the boundaries of the region as specified
     */
    private fun drawRegion(region: Region, mark: Boolean = false, fill: Boolean = false) {
        val strokeColor =   if (mark) {
                                Color.argb(255, 255, 10, 0)
                            }
                            else {
                                if (isDayTime)
                                    Color.argb(255, 0, 0, 0)
                                else {
                                    Color.argb(255, 255, 255, 255)
                                }
                            }

        val fillColor = Color.argb(if (fill) 155 else 10, 95, 170, 255)


        // Drawing with polygon
        if (region.polygon != null)
            region.polygon!!.remove()

        region.polygon = mMap.addPolygon(
                                            PolygonOptions()
                                                .addAll(region.coordinates)
                                                .strokeWidth(4.5f)
                                                .strokeColor(strokeColor)
                                                .fillColor(fillColor)
                                        )


        for (exit in region.exits) {
            mMap.addCircle(
                CircleOptions()
                    .center(exit.first)
                    .radius(1.0)
                    .strokeColor(Color.BLACK)
                    .fillColor(Color.YELLOW)
            )
        }
    }

    private fun clearRegions() {
        for (reg in regions)
            reg.polygon!!.isVisible = false
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * THIS FUNCTION SHOULD READ A FILE AND CREATE THE REGIONS FROM IT
     * https://www.gps-coordinates.net/
     */
    private fun createRegions() {
        var coordinates = arrayListOf<LatLng>()
        var coord = LatLng(37.176400, -3.589595)
        coordinates.add(coord)
        coord = LatLng(37.176535, -3.590337)
        coordinates.add(coord)
        coord = LatLng(37.177091, -3.590144)
        coordinates.add(coord)
        coord = LatLng(37.176981, -3.589491)
        coordinates.add(coord)

        var exits = arrayListOf<Pair<LatLng, String> >()
        var ex = Pair(LatLng(37.177056, -3.589785),"E1")
        exits.add(ex)

        var reg = Region("R1", coordinates, exits)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.177080048544404,-3.5898592971325005)
        coordinates.add(coord)
        coord = LatLng(37.17703730636698,-3.589557548618325)
        coordinates.add(coord)
        coord = LatLng(37.17740061410428,-3.5895320676326836)
        coordinates.add(coord)
        coord = LatLng(37.17742412219181,-3.589831133937844)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.177056, -3.589785),"E1")
        exits.add(ex)
        ex = Pair(LatLng(37.17728948486423,-3.589550843095788),"E2")
        exits.add(ex)
        ex = Pair(LatLng(37.17727248903406,-3.589852157042961),"E3")
        exits.add(ex)

        reg = Region("R2", coordinates, exits)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.17721468624523,-3.5895468197822655)
        coordinates.add(coord)
        coord = LatLng(37.1773386382021,-3.589548160886773)
        coordinates.add(coord)
        coord = LatLng(37.17733650110113,-3.5893724761962975)
        coordinates.add(coord)
        coord = LatLng(37.17719331519763,-3.5893845461368645)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.17728948486423,-3.589550843095788),"E1")
        exits.add(ex)
        ex = Pair(LatLng(37.17718690388217,-3.589455624675759),"E2")
        exits.add(ex)

        // No GPS
        reg = Region("R3", coordinates, exits, track = false)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.17717835546071,-3.5895199976921166)
        coordinates.add(coord)
        coord = LatLng(37.17698815283305,-3.589550843095788)
        coordinates.add(coord)
        coord = LatLng(37.17698387861119,-3.5891015730857934)
        coordinates.add(coord)
        coord = LatLng(37.17715057308428,-3.589097549772271)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.17718690388217,-3.589455624675759),"E1")
        exits.add(ex)
        ex = Pair(LatLng(37.17697746727796,-3.5892705522537316),"E2")
        exits.add(ex)

        reg = Region("R4", coordinates, exits)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.177189898505716,-3.5898739794973245)
        coordinates.add(coord)
        coord = LatLng(37.17746592439161,-3.5898480653325904)
        coordinates.add(coord)
        coord = LatLng(37.17748113838756,-3.5910851257230147)
        coordinates.add(coord)
        coord = LatLng(37.17684432136869,-3.5912556136488316)
        coordinates.add(coord)
        coord = LatLng(37.17662914989985,-3.5909105460868274)
        coordinates.add(coord)
        coord = LatLng(37.176427018567836,-3.590914637797058)
        coordinates.add(coord)
        coord = LatLng(37.176283570197654,-3.590449546735235)
        coordinates.add(coord)
        coord = LatLng(37.17712686883134,-3.5902245026731094)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.17727248903406,-3.589852157042961),"E1")
        exits.add(ex)
        ex = Pair(LatLng(37.177170337577934,-3.5912119687398847),"E2")
        exits.add(ex)

        reg = Region("R5", coordinates, exits)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.1774245409976,-3.5911523402207024)
        coordinates.add(coord)
        coord = LatLng(37.17683211584509,-3.591245281762605)
        coordinates.add(coord)
        coord = LatLng(37.17693175130931,-3.591953327327404)
        coordinates.add(coord)
        coord = LatLng(37.17708793636722,-3.5920023328676898)
        coordinates.add(coord)
        coord = LatLng(37.17723334975157,-3.5916491550084317)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.17702061526117,-3.591998953175284),"E1")
        exits.add(ex)
        ex = Pair(LatLng(37.177170337577934,-3.5912119687398847),"E2")
        exits.add(ex)

        reg = Region("R6", coordinates, exits)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.177096014895916,-3.592025990714771)
        coordinates.add(coord)
        coord = LatLng(37.17691559421594,-3.5920141617912704)
        coordinates.add(coord)
        coord = LatLng(37.17689135856939,-3.5922118737986164)
        coordinates.add(coord)
        coord = LatLng(37.17678633734449,-3.5922710184162)
        coordinates.add(coord)
        coord = LatLng(37.1769748368748,-3.592384238112718)
        coordinates.add(coord)
        coord = LatLng(37.17711755763488,-3.592379168574069)
        coordinates.add(coord)
        coord = LatLng(37.17712294331867,-3.59222539256836)
        coordinates.add(coord)
        coord = LatLng(37.17707447215083,-3.592230462107009)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.17702061526117,-3.591998953175284),"E1")
        exits.add(ex)

        reg = Region("R7", coordinates, exits)
        regions.add(reg)

        //------------------------------------------------

        coordinates = arrayListOf()
        coord = LatLng(37.17688866571949,-3.589460804158102)
        coordinates.add(coord)
        coord = LatLng(37.17638779393231,-3.5895605050849366)
        coordinates.add(coord)
        coord = LatLng(37.1757361170662,-3.587919664408825)
        coordinates.add(coord)
        coord = LatLng(37.177397612682796,-3.586261925270524)
        coordinates.add(coord)
        coord = LatLng(37.17806004645145,-3.5850334070710743)
        coordinates.add(coord)
        coord = LatLng(37.17845858104215,-3.5853848950841294)
        coordinates.add(coord)
        coord = LatLng(37.1770529294002,-3.5876577382454666)
        coordinates.add(coord)
        coord = LatLng(37.17692367276372,-3.5890045456800834)
        coordinates.add(coord)

        exits = arrayListOf()
        ex = Pair(LatLng(37.17697746727796,-3.5892705522537316),"E1")
        exits.add(ex)

        reg = Region("R8", coordinates, exits)
        regions.add(reg)
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * To don't keep an entire Region as a attribute of User, we only keep the ID
     */
    private fun findRegionById(id: String): Region? {
        for (reg in regions)
            if (reg.id == id)
                return reg

        return null
    }

    // ---------------------------------------------------------------------------------------------
    // Location
    // ---------------------------------------------------------------------------------------------

    /**
     * For the simulation
     */
    private fun createUserLocations() {
        var loc = Location("target")
        loc.latitude = 37.17660272115626
        loc.longitude = -3.5899914156428725
        userLocations.add(loc)  // Entrance
        loc = Location("target")
        loc.latitude = 37.17700678442484
        loc.longitude = -3.590029072946448
        userLocations.add(loc)  // First room, near game
        loc = Location("target")
        loc.latitude = 37.17718691644971
        loc.longitude = -3.5897764544238275
        userLocations.add(loc)  // Second room
        loc = Location("target")
        loc.latitude = 37.17731703205905
        loc.longitude = -3.5902280396205444
        userLocations.add(loc)  // Left route, entrance
        loc = Location("target")
        loc.latitude = 37.17721408384334
        loc.longitude = -3.590946388429541
        userLocations.add(loc)
        loc = Location("target")
        loc.latitude = 37.17694694531165
        loc.longitude = -3.590912860816855
        userLocations.add(loc) // Left route, near game
        loc = Location("target")
        loc.latitude = 37.177113436546726
        loc.longitude = -3.591526243564449
        userLocations.add(loc)  // In the maze
        loc = Location("target")
        loc.latitude = 37.177258612833626
        loc.longitude = -3.5895731577670986
        userLocations.add(loc)
        loc = Location("target")
        loc.latitude = 0.0
        loc.longitude = 0.0
        userLocations.add(loc) // Right route
    }

    /**
     * To simulate walking
     */
    private fun getNextLocation(): Location? {
        val loc = userLocations[nextLocation.rem(userLocations.size)]
        nextLocation += 1

        return  if (loc.latitude == 0.0)
                    null
                else
                    loc
    }

    /**
     * Update map based on new coordinates
     */
    private fun changeCoordinates() {
        val nextLoc = getNextLocation()

        if (nextLoc != null) {
            mLastKnownLocation = nextLoc
            mMap.moveCamera(
                CameraUpdateFactory.newLatLngZoom(
                    LatLng(
                        mLastKnownLocation!!.latitude,
                        mLastKnownLocation!!.longitude
                    ), mMap.cameraPosition.zoom
                )
            )

            // Update user location
            val regionChanged = user.updateLocation(
                LatLng(mLastKnownLocation!!.latitude, mLastKnownLocation!!.longitude),
                regions
            )

            // Draw new region
            if (regionChanged) {
                // Removing old regions
                clearRegions()

                for (reg in regions)
                    drawRegion(reg)

                if (modeRequested == "routes")
                    drawRoute()

                // Drawing the new region
                val reg = findRegionById(user.region)
                if (reg != null)
                    drawRegion(reg, fill = true)
                else
                    Log.i("", "User located in non-existence region")
            }

            // Check game-points nearby
            if (modeRequested == "games" || showGames) {
                for (i in 0 until locationsGame.size) {
                    val game = locationsGame[i].first
                    val loc = Location("target")
                    loc.latitude = game.latitude
                    loc.longitude = game.longitude

                    // If game point in less of a 10m radius
                    if (mLastKnownLocation!!.distanceTo(loc) < 20) {
                        markersGame[i].isVisible = true

                        // Vibrate
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            vibrator.vibrate(VibrationEffect.createOneShot(300, VibrationEffect.DEFAULT_AMPLITUDE))
                        }
                    }
                    else {
                        markersGame[i].isVisible = false
                    }
                }
            }

            // Drawing current location
            if (locationMarker != null)
                locationMarker!!.remove()

            locationMarker = mMap.addCircle(
                CircleOptions()
                    .fillColor(Color.RED)
                    .strokeColor(Color.BLACK)
                    .strokeWidth(1f)
                    .radius(3.0)
                    .center(LatLng(mLastKnownLocation!!.latitude,
                        mLastKnownLocation!!.longitude)

                    )
            )

        } else {    // When user enters in a room with no GPS
            Log.d("", "Current location is null")
            mMap.moveCamera(
                CameraUpdateFactory
                    .newLatLngZoom(
                        LatLng(mLastKnownLocation!!.latitude,
                            mLastKnownLocation!!.longitude),
                        mMap.cameraPosition.zoom)
            )

            // Removing current location
            if (locationMarker != null)
                locationMarker!!.remove()

            // Finding the new region without GPS
            user.getNearestNonGPSRegion(regions)

            // Removing old regions
            clearRegions()

            for (reg in regions)
                drawRegion(reg)

            if (modeRequested == "routes")
                drawRoute()

            // Drawing the new region
            val reg = findRegionById(user.region)
            if (reg != null)
                drawRegion(reg, fill = true)
            else
                Log.i("", "User located in non-existence region")
        }
    }

    /**
     * Get the best and most recent location of the device, which may be null in rare
     * cases when a location is not available.
     */
    private fun getDeviceLocation() {
        try {
            if (mLocationPermissionGranted) {
                val locationResult = mFusedLocationProviderClient.lastLocation
                locationResult.addOnCompleteListener { task ->
                    if (task.isSuccessful && task.result != null) {
                        // Set the map's camera position to the current location of the device.
                        mLastKnownLocation = task.result
                        mMap.moveCamera(
                            CameraUpdateFactory.newLatLngZoom(
                                LatLng(
                                    mLastKnownLocation!!.latitude,
                                    mLastKnownLocation!!.longitude
                                ), mDefaultZoom
                            )
                        )

                        // Update user location
                        val regionChanged = user.updateLocation(
                            LatLng(mLastKnownLocation!!.latitude, mLastKnownLocation!!.longitude),
                            regions
                        )

                        // Draw new region
                        if (regionChanged) {
                            val reg = findRegionById(user.region)
                            if (reg != null)
                                drawRegion(reg, fill = true)
                            else
                                Log.i("", "User located in non-existence region")
                        }

                        // Check game-points nearby
                        if (modeRequested == "games") {
                            for (i in 0 .. locationsGame.size) {
                                val game = locationsGame[i].first
                                val loc = Location("target")
                                loc.latitude = game.latitude
                                loc.longitude = game.longitude

                                // If game point in less of a 10m radius
                                if (mLastKnownLocation!!.distanceTo(loc) < 10) {
                                    markersGame[i].isVisible = true
                                }
                            }
                        }
                    } else {
                        Log.d("", "Current location is null. Using defaults.")
                        Log.e("", "Exception: %s", task.exception)
                        mMap.moveCamera(
                            CameraUpdateFactory
                                .newLatLngZoom(mDefaultLocation, mDefaultZoom)
                        )
                        mMap.uiSettings.isMyLocationButtonEnabled = false
                    }
                }
            }
        } catch (e: Exception) {
            val message: String  = e.message!!
            Log.e("Exception: %s", message)
        }

    }

    // ---------------------------------------------------------------------------------------------
    // Location permissions related methods
    // ---------------------------------------------------------------------------------------------

    /**
     * Prompts the user for permission to use the device location.
     */
    private fun getLocationPermission() {
        if (ContextCompat.checkSelfPermission(
                this.applicationContext,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) == PackageManager.PERMISSION_GRANTED
        ) {
            mLocationPermissionGranted = true
        } else {
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION
            )
        }
    }

    // ---------------------------------------------------------------------------------------------

    /**
     * Handles the result of the request for location permissions.
     */
    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<String>,
        grantResults: IntArray
    ) {
        mLocationPermissionGranted = false
        when (requestCode) {
            PERMISSIONS_REQUEST_ACCESS_FINE_LOCATION -> {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    mLocationPermissionGranted = true
                }
            }
        }
        updateLocationUI()
    }


    // ---------------------------------------------------------------------------------------------

    /**
     * Updates the map's UI settings based on whether the user has granted location permission.
     */
    private fun updateLocationUI() {
        try {
            if (mLocationPermissionGranted) {
                mMap.isMyLocationEnabled = true
                mMap.uiSettings.isMyLocationButtonEnabled = true
            } else {
                mMap.isMyLocationEnabled = false
                mMap.uiSettings.isMyLocationButtonEnabled = false
                mLastKnownLocation = null
                getLocationPermission()
            }
        } catch (e: SecurityException) {
            val message: String  = e.message!!
            Log.e("Exception: %s", message)
        }
    }
}