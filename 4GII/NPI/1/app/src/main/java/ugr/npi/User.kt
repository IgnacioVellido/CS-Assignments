package ugr.npi

import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.Polygon
import com.google.maps.android.PolyUtil
import kotlin.math.pow
import kotlin.math.sqrt

class User(id: Int) {

    val id: Int = id

    // Why LatLng and not Location ?
    // Because we don't need additional information like altitude, we only want the coordinates
    lateinit var lastLocation: LatLng
    var region = "DEFAULT_REGION"

    /**
     *  Update lastLocation and check for new region
     *  @return True if User enters in a new region
     */
    fun updateLocation(loc: LatLng, regions: List<Region>): Boolean {
        lastLocation = loc
        return updateRegion(regions)
    }

    /**
     *  Check every region to evaluate if the user is inside
     *  @return True if User enters in a new region
     */
    private fun updateRegion(regions: List<Region>): Boolean {
        var regionChanged = false

        for (reg in regions) {
            if (reg.id != region &&
                    PolyUtil.containsLocation(lastLocation, reg.polygon!!.points, true)) {
                region = reg.id
                regionChanged = true
            }
        }

        return regionChanged
    }

    /**
     * Search for the nearest region with no GPS, considering the user entered in it
     * For this, calculates the distance to the entrance of each region, keeping the shortest
     */
    fun getNearestNonGPSRegion(regions: List<Region>) {
        var coord: LatLng
        var distance: Double
        var minDistance = Double.POSITIVE_INFINITY

        for (reg in regions) {
            if (!reg.trackGPS) {
                for (exit in reg.exits) {
                    coord = exit.first

                    // Calculating distance between the exit and the actual location
                    distance = sqrt(
                        (coord.longitude - lastLocation.longitude).pow(2) +
                                (coord.latitude - lastLocation.latitude).pow(2)
                    )

                    if (distance < minDistance) {
                        minDistance = distance

                        if (region != reg.id) {
                            region = reg.id
                        }
                    }
                }
            }
        }
    }
}

class Region(id: String, coord: List<LatLng>, ex: List<Pair<LatLng, String> >, track: Boolean = true) {
    val id: String = id

    // Boundaries of the region
    // Must be in order to form a drawable figure
    // Last coordinate will be connected with the first one
    val coordinates: List<LatLng> = coord

    // Possible exits and the adjacent regions
    val exits: List<Pair<LatLng, String> > = ex

    // If GPS usually works in this region
    val trackGPS: Boolean = track

    // Number of people inside - This value should be received from a server
    var usersInside: Int = 0

    // Associated polygon and circles
    var polygon: Polygon? = null
}

class Route(i: String, n: String, reg: List<String>, desc: String) {
    // Because a room can belong to various regions (for example, the entrance), we only keep the ids
    val id: String = i
    val name: String = n
    val regions: List<String> = reg
    var usersInside: Int = 0    // This value should be received from a server
    val description: String = desc
}