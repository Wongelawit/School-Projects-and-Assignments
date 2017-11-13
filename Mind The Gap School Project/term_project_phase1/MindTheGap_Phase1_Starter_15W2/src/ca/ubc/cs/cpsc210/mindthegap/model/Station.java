package ca.ubc.cs.cpsc210.mindthegap.model;

import ca.ubc.cs.cpsc210.mindthegap.model.exception.ArrivalException;
import ca.ubc.cs.cpsc210.mindthegap.util.LatLon;

import java.util.*;

/**
 * Represents a station on the underground with an id, name, location (lat/lon)
 * set of lines that stop at this station and a list of arrival boards.
 */
public class Station implements Iterable<ArrivalBoard> {
    private List<ArrivalBoard> arrivalBoards;
    private Set<Line> lines;
    private LatLon location;
    private String name;
    private String id;

    /**
     * Constructs a station with given id, name and location.
     * Set of lines and list of arrival boards are empty.
     *
     * @param id    the id of this station (cannot by null)
     * @param name  name of this station
     * @param locn  location of this station
     */
    public Station(String id, String name, LatLon locn) {
        this.id = id;
        this.name = name;
        this.location = locn;
        arrivalBoards = new ArrayList<ArrivalBoard>();
        lines = new HashSet<Line>();

    }

    public String getName() {
        return this.name;   // stub
    }

    public LatLon getLocn() {
        return this.location;   // stub
    }

    public String getID() {
        return this.id;   // stub
    }

    /**
     *
     * @return  returns an unmodifiable view of the set of lines through this station
     */
    public Set<Line> getLines() {
        Set<Line> unmodifiable = Collections.unmodifiableSet(this.lines);
        return unmodifiable;  // stub
    }

    public int getNumArrivalBoards() {
        return arrivalBoards.size();  // stub
    }

    /**
     * Add line to set of lines with stops at this station.
     *
     * @param line  the line to add
     */
    public void addLine(Line line) {
        // stub
        lines.add(line);
    }

    /**
     * Remove line from set of lines with stops at this station
     *
     * @param line the line to remove
     */
    public void removeLine(Line line) {
        // stub
        lines.remove(line);
    }

    /**
     * Determine if this station is on a given line
     * @param line  the line
     * @return  true if this station is on given line
     */
    public boolean hasLine(Line line) {
        return lines.contains(line);  // stub
    }

    /**
     * Add train arrival travelling on a particular line in a particular direction to this station.
     * Throws ArrivalException if line does not run through this station.  Otherwise,
     * arrival is added to corresponding arrival board based on the line on which it is
     * operating and the direction of travel (as indicated by platform prefix).  If the arrival
     * board for given line and travel direction does not exist, it is created and added to
     * arrival boards for this station.
     *
     * @param line    line on which train is travelling
     * @param arrival the train arrival to add to station
     * @throws ArrivalException when given line does not run through this station
     */
    public void addArrival(Line line, Arrival arrival) throws ArrivalException {
        // stub
        if(!hasLine(line)){
            throw new ArrivalException();
        }
        boolean foundAB=false;
        for(ArrivalBoard ab: arrivalBoards){
            //if ArrivalBoard with the corresponding line and travel direction is found, add arrival to that arrival board
            if(ab.getLine().equals(line) && ab.getTravelDirn().equals(arrival.getTravelDirn())){
                foundAB= true;
                ab.addArrival(arrival);
            }
        }
        //create arrival board if one does not already exit for the given line and travel direction
        if(!foundAB){
            ArrivalBoard newAB = new ArrivalBoard(line, arrival.getTravelDirn());
            newAB.addArrival(arrival);
        }

    }

    /**
     * Remove all arrival boards from this station
     */
    public void clearArrivalBoards() {
        // stub
        arrivalBoards.clear();
    }

    /**
     * Two stations are equal if their ids are equal
     */
    @Override
    public boolean equals(Object o) {
        if(o == null){
            return false;
        }
        if(getClass() != o.getClass()){
            return false;
        }

        Station station = (Station) o;
        if(this.getID().equals(station.getID())){
            return true;
        }
        return false;   // stub // stub
    }

    /**
     * Two stations are equal if their ids are equal
     */
    @Override
    public int hashCode() {
        int result =11;
        result = 37*result + this.id.hashCode();

        return result;   // stub
    }

    @Override
    public Iterator<ArrivalBoard> iterator() {
        return arrivalBoards.iterator();
    }
}
