package ca.ubc.cs.cpsc210.mindthegap.model;

import java.util.*;

/**
 * Represents a line on the underground with a name, id, list of stations and list of branches.
 *
 * Invariants:
 * - no duplicates in list of stations
 * - stations must be maintained in the order in which they were added to the line
 */
public class Line implements Iterable<Station> {
    private List<Station> stations;
    private Set<Branch> branches;
    private String id;
    private String name;
    private LineResourceData lmd;

    /**
     * Constructs a line with given resource data, id and name.
     * List of stations and list of branches are empty.
     *
     * @param lmd     the line meta-data
     * @param id      the line id
     * @param name    the name of the line
     */
    public Line(LineResourceData lmd, String id, String name) {
        // stub
        this.lmd = lmd;
        this.id = id;
        this.name = name;
        stations = new ArrayList<Station>();
        branches = new HashSet<Branch>();
    }

    public String getName() {
        return this.name;   // stub
    }

    public String getId() {
        return this.id;  // stub
    }

    /**
     * Get colour specified by line resource data
     *
     * @return  colour in which to plot this line
     */
    public int getColour() {
        return this.lmd.getColour();  // stub
    }

    /**
     * Add station to line, if it's not already there.
     *
     * @param stn  the station to add to this line
     */
    public void addStation(Station stn) {
        //stub
        if(!stations.contains(stn)){
            stations.add(stn);
        }
    }

    /**
     * Remove station from line
     *
     * @param stn  the station to remove from this line
     */
    public void removeStation(Station stn) {
        // stub
        stations.remove(stn);
    }

    /**
     * Remove all stations from this line
     */
    public void clearStations() {
        // stub
        stations.clear();
    }

    /**
     *
     * @return unmodifiable view of list of stations on this line
     */
    public List<Station> getStations() {
        List<Station> unmodifiable = Collections.unmodifiableList(stations);
        return  unmodifiable;  // stub
    }

    /**
     * Determines if this line has a given station
     *
     * @param stn  the station
     * @return  true if line has the given station
     */
    public boolean hasStation(Station stn) {
        return stations.contains(stn);  // stub
    }

    /**
     * Add a branch to this line
     *
     * @param b  the branch to add to line
     */
    public void addBranch(Branch b) {
        // stub
        branches.add(b);    //How can I change the branch to station??
    }

    /**
     *
     * @return unmodifiable view of set of all branches in this line
     */
    public Set<Branch> getBranches() {
        Set unmodifiable = Collections.unmodifiableSet(branches);
        return branches;   // stub
    }

    /**
     * Two lines are equal if their ids are equal
     */
    @Override
    public boolean equals(Object o) {
        if(o == null){
            return false;
        }
        if(getClass() != o.getClass()){
            return false;
        }

        Line line= (Line) o;
        if(this.getId().equals(line.getId())){
            return true;
        }
        return false;   // stub

    }

    /**
     * Two lines are equal if their ids are equal
     */
    @Override
    public int hashCode() {
        int result =11;
        result = 37*result + this.id.hashCode();

        return result;   // stub
    }

    @Override
    public Iterator<Station> iterator() {
        return stations.iterator();
    }
}
