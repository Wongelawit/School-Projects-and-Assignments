package ca.ubc.cs.cpsc210.mindthegap.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

/**
 * Represents an arrivals board for a particular station, on a particular line,
 * for trains traveling in a particular direction (as indicated by platform prefix).
 *
 * Invariant: iterator provides arrivals in order of time to station
 * (first train to arrive will be listed first).
 */
public class ArrivalBoard implements Iterable<Arrival> {
    private List<Arrival> arrivals;
    private Line line;
    private String travelDirn;

    /**
     * Constructs an arrival board for the given line with an empty list of arrivals
     * and given travel direction.
     *
     * @param line        line on which arrivals listed on this board operate (cannot be null)
     * @param travelDirn  the direction of travel
     */
    public ArrivalBoard(Line line, String travelDirn) {
        this.line = line;
        this.travelDirn = travelDirn;
        arrivals = new ArrayList<Arrival>();
    }

    public Line getLine() {
        return line;   // stub
    }

    public String getTravelDirn() {
        return travelDirn;   // stub
    }


    /**
     * Get total number of arrivals posted on this arrival board
     *
     * @return  total number of arrivals
     */
    public int getNumArrivals() {
        return arrivals.size();   // stub
    }

    /**
     * Add a train arrival to this arrivals board.
     *
     * @param arrival  the arrival to add to this arrivals board
     */
    public void addArrival(Arrival arrival) {
        arrivals.add(arrival);
    }

    /**
     * Clear all arrivals from this arrival board
     */
    public void clearArrivals() {
        arrivals.clear();
    }

    /**
     * Two ArrivalBoards are equal if their lines are equal and travel directions are equal
     */
    @Override
    public boolean equals(Object o) {
        if(o == null){
            return false;
        }
        if(getClass() != o.getClass()){
            return false;
        }

        ArrivalBoard arrivalBoard = (ArrivalBoard) o;
        if(line.equals((arrivalBoard.getLine())) && travelDirn.equals(arrivalBoard.getTravelDirn())){
            return true;
        }
        return false;   // stub
    }

    /**
     * Two ArrivalBoards are equal if their lines are equal and travel directions are equal
     */
    @Override
    public int hashCode() {
        int result =11;
        result = 37*result + line.hashCode();
        result = 37*result + travelDirn.hashCode();
        return result;   // stub
    }

    /**
     * Produces an iterator over the arrivals on this arrival board
     * ordered by time to arrival (first train to arrive is produced
     * first).
     */
    @Override
    public Iterator<Arrival> iterator() {
        return arrivals.iterator();
    }
}
