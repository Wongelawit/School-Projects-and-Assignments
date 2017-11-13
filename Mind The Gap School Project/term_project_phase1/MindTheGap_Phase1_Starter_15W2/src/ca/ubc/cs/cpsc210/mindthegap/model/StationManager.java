package ca.ubc.cs.cpsc210.mindthegap.model;

import ca.ubc.cs.cpsc210.mindthegap.model.exception.StationException;
import ca.ubc.cs.cpsc210.mindthegap.util.LatLon;
import ca.ubc.cs.cpsc210.mindthegap.util.SphericalGeometry;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

/**
 * Manages all tube stations on network.
 *
 * Singleton pattern applied to ensure only a single instance of this class
 * is globally accessible throughout application.
 */
public class StationManager implements Iterable<Station> {
    public static final int RADIUS = 10000;
    private static StationManager instance;
    private Set<Station> stations;
    private Station selectedStation;

    /**
     * Constructs station manager with empty set of stations and null as the selected station
     */
    private StationManager() {
      //stub
        this.selectedStation = null;
        this.stations = new HashSet<Station>();
    }

    /**
     * Gets one and only instance of this class
     *
     * @return  instance of class
     */
    public static StationManager getInstance() {
        if(instance == null) {
            instance = new StationManager();
        }

        return instance;
    }

    public Station getSelected() {
        return selectedStation;   // stub
    }

    /**
     * Get station with given id or null if no such station is found in this manager
     *
     * @param id  the id of this station
     *
     * @return  station with given id or null if no such station is found
     */
    public Station getStationWithId(String id) {
        for(Station station: stations){
            if(station.getID().equals(id)){
                return station;
            }
        }
        return null;   // stub
    }

    /**
     * Set the station selected by user
     *
     * @param selected   station selected by user
     * @throws StationException when station manager doesn't contain selected station
     */
    public void setSelected(Station selected) throws StationException {
        // stub
        if(!stations.contains(selected)){
            throw new StationException();
        }
        this.selectedStation = selected;
    }

    /**
     * Clear selected station (selected station is null)
     */
    public void clearSelectedStation() {
        this.selectedStation = null;
        // stub
    }

    /**
     * Add all stations on given line. Station added only if it is not already in the collection.
     *
     * @param line  the line from which stations are to be added
     */
    public void addStationsOnLine(Line line) {
        // stub
        for(Station station: line.getStations()){
            if(!stations.contains(station)){
                stations.add(station);
            }
        }
    }

    /**
     * Get number of stations managed
     *
     * @return  number of stations added to manager
     */
    public int getNumStations() {
        return stations.size();  // stub
    }

    /**
     * Remove all stations from station manager and
     * clear selected station.
     */
    public void clearStations() {
        // stub
        stations.clear();
        selectedStation = null;
    }


    /**
     * Find nearest station to given point.  Returns null if no station is closer than RADIUS metres. If
     * two or more stations are at an equal distance from the given point, any one of those stations is
     * returned.
     *
     * @param pt  point to which nearest station is sought
     * @return    station closest to pt but less than 10,000m away; null if no station is within RADIUS metres of pt
     */
    public Station findNearestTo(LatLon pt) {
        Station nearestStation = null;
        double smallestDistance;

        Iterator<Station> stationIterator = stations.iterator();
        if(stationIterator.hasNext()){
            //set the first station in the list to nearest station at first.
            nearestStation = stationIterator.next();
            smallestDistance = SphericalGeometry.distanceBetween(nearestStation.getLocn(), pt);

            //check if another station from the list is closer than the current nearest station
            while(stationIterator.hasNext()){
                Station nextStation = stationIterator.next();
                double distance = SphericalGeometry.distanceBetween(nextStation.getLocn(), pt);
                if(distance<smallestDistance){
                    nearestStation = nextStation;
                    smallestDistance = distance;
                }
            }
            //if no station is found within RADIUS distance, return null
            if(smallestDistance>RADIUS){
                return null;
            }
            else return nearestStation;
        }

        return null;   // stub
    }

    @Override
    public Iterator<Station> iterator() {
        return stations.iterator();
    }
}
