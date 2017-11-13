package ca.ubc.cs.cpsc210.mindthegap.model;

/**
 * Represents an estimated arrival with time to arrival in seconds,
 * name of destination and platform at which train arrives.  Platform
 * data is generally assumed to be of the form:
 *    "Travel Direction - Platform Name"
 * with an arbitrary number of spaces either side of "-" and at the
 * start and end of the string.  In some cases, the "-" could
 * be missing.
 */
public class Arrival implements Comparable<Arrival> {
    private int timeToStation;
    private String destination;
    private String platform;


    /**
     * Constructs a new arrival with the given time to station (in seconds),
     * destination and platform.
     *
     * @param timeToStation  time until train arrives at station (in seconds)
     * @param destination    name of destination station
     * @param platform       platform at which train will arrive
     */
    public Arrival(int timeToStation, String destination, String platform) {
        this.timeToStation = timeToStation;
        this.destination = destination;
        this.platform = platform;

    }

    /**
     * Get direction of travel as indicated by platform prefix (part of platform prior to "-" with
     * leading and trailing whitespace trimmed).  If platform does not contain "-", returns
     * "Unknown direction".
     *
     * @return direction of travel
     */
    public String getTravelDirn() {
        if (!platform.contains("-")){
            return "Unknown direction";
        }
        else{
            String[] mystr = platform.split("-",2);
            String directionRaw = mystr[0];
            System.out.println(directionRaw);
            //remove white space from directionRaw
            String directionParsed = directionRaw.replaceAll("\\s+","");
            System.out.println(directionParsed);
            return directionParsed;
        }

  // stub
    }

    /**
     * Get platform name as indicated by platform suffix (part of platform after "-" with leading
     * and trailing whitespace trimmed). If platform does not contain "-", returns platform
     * (with leading and trailing whitespace trimmed).
     *
     * @return  platform name
     */
    public String getPlatformName() {


            String[] mystr = platform.split("Platfor",2);

            String pNameRaw = mystr[1];
            System.out.println(pNameRaw);
            String pNameRaw1 = "Platfor" + pNameRaw;

            String pNameParsed = pNameRaw1.trim();

            //remove white space from directionRaw
            //String pNameParsed = pNameRaw.replaceAll("\\s+Platform","Platform");
            //String pNameParsed1 = pNameParsed.replaceAll("d+","Platform");
            System.out.println(pNameParsed);
            return pNameParsed;


       // return null;  // stubreturn null;  // stub
    }

    /**
     * Get time until train arrives at station rounded up to nearest minute.
     *
     * @return  time until train arrives at station in minutes
     */
    public int getTimeToStationInMins() {

        int timeToStationMin;
       // System.out.print("timeToStation: " + timeToStation);
        if((timeToStation%60)==0 ){

            //System.out.println("should print 2:" + timeToStation/60);
            return timeToStation/60;
        }
        else{
            timeToStationMin = ((int)(timeToStation/60)) +1;
            //System.out.println("should print 3:" + timeToStationMin);
            return timeToStationMin;
        }

          // stub
    }

    public String getDestination() {
        return destination;  // stub
    }

    public String getPlatform() {
        return platform;  // stub
    }

    /**
     * Order train arrivals by time until train arrives at station
     * (shorter times ordered before longer times)
     */
    @Override
    public int compareTo(Arrival arrival) {
        return this.timeToStation - arrival.timeToStation;  // stub
    }
}
