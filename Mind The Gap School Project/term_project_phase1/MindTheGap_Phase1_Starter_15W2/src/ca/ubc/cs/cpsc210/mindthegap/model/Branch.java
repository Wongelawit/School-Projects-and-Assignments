package ca.ubc.cs.cpsc210.mindthegap.model;

import ca.ubc.cs.cpsc210.mindthegap.parsers.BranchStringParser;
import ca.ubc.cs.cpsc210.mindthegap.util.LatLon;

import java.util.Iterator;
import java.util.List;

/**
 * A branch of a line consisting of a path of lat/lon points.
 * These points are used to draw the branch on a map.  Note that the points used to
 * represent the branch are not necessarily co-located with stations.
 */
public class Branch implements Iterable<LatLon> {
    private List<LatLon> points;

    /**
     * Constructs a Branch by parsing (using BranchStringParser) the points
     * that define the branch from the given string.
     *
     * @param lineString  string of coordinates representing points on branch
     */
    public Branch(String lineString) {
        points = BranchStringParser.parseBranch(lineString);
        //this.lineString = lineString;
    }

    /**
     * Get list of all points on this branch
     *
     * @return  unmodifiable view of list of all points on this branch
     */
    public List<LatLon> getPoints() {
        return points;   // stub
    }

    /**
     * Two branches are equal if their lists of points are equal
     */
    @Override
    public boolean equals(Object o) {
        if(o == null){
            return false;
        }
        if(getClass() != o.getClass()){
            return false;
        }

        Branch branch = (Branch) o;

        if(branch.getPoints().size() != this.getPoints().size()){
            return false;
        }

        Iterator<LatLon> itrLatLon = this.iterator();
        Iterator<LatLon> itrLatLon1 = branch.iterator();

        while(itrLatLon.hasNext() && itrLatLon1.hasNext()){
            if(!itrLatLon.next().equals(itrLatLon1.next())){
                return false;
            }

        }
        return true;   // stub
    }

    /**
     * Two branches are equal if their lists of points are equal
     */
    @Override
    public int hashCode() {
        int result = 11;
        for (LatLon pt : points) {
            result = 37 * result + pt.hashCode();
            return result;   // stub
        }
        return result;
    }
    @Override
    public Iterator<LatLon> iterator() {
        return points.iterator();
    }
}
