package ca.ubc.cs.cpsc210.mindthegap.parsers;

import ca.ubc.cs.cpsc210.mindthegap.model.Arrival;
import ca.ubc.cs.cpsc210.mindthegap.model.Line;
import ca.ubc.cs.cpsc210.mindthegap.model.Station;
import ca.ubc.cs.cpsc210.mindthegap.model.exception.ArrivalException;
import ca.ubc.cs.cpsc210.mindthegap.parsers.exception.TfLArrivalsDataMissingException;
import ca.ubc.cs.cpsc210.mindthegap.parsers.exception.TfLLineDataMissingException;

import javax.json.*;
import java.io.StringReader;
import java.util.Set;

/**
 * A parser for the data returned by the TfL station arrivals query
 */
public class TfLArrivalsParser extends TfLAbstractParser {

    /**
     * Parse arrivals from JSON response produced by TfL query.  Parsed arrivals are
     * added to given station assuming that arrival is on a line that passes
     * through the station and that corresponding JSON object has all of:
     * timeToStation, platformName, lineID and one of destinationName or towards.  If
     * any of the aforementioned elements is missing, or if arrival is on a line
     * that does not pass through the station, the arrival is not added to the station.
     *
     * @param stn             station to which parsed arrivals are to be added
     * @param jsonResponse    the JSON response produced by TfL
     * @throws JsonException  when JSON response does not have expected format
     * @throws TfLArrivalsDataMissingException  when all arrivals are missing at least one of the following:
     *      <ul>
     *          <li>timeToStation</li>
     *          <li>platformName</li>
     *          <li>lineId</li>
     *          <li>destinationName and towards</li>
     *      </ul>
     *  or if all arrivals are on a line that does not run through given station.
     */
    public static void parseArrivals(Station stn, String jsonResponse)
            throws JsonException, TfLArrivalsDataMissingException {
        try {
            JsonReader reader = Json.createReader(new StringReader(jsonResponse));
            JsonArray arrivals = reader.readArray();


            JsonObject arrival;
            String lineId;
            String platformName;
            int timeToStation;
            String destinationName=null;
            String towards=null;
            Arrival ar = null;
            boolean arrivalRunsThroughLine = false;

            for (int i = 0; i < arrivals.size(); i++) {
                try {
                    arrival = arrivals.getJsonObject(i);
                    lineId = arrival.getString("lineId");
                    platformName = arrival.getString("platformName");
                    timeToStation = arrival.getInt("timeToStation");

                    boolean destinationFound = false;
                    boolean towardsFound = false;
                    try {
                        destinationName = arrival.getString("destinationName");
                        destinationFound = true;

                    }
                    catch(NullPointerException e)
                    {
                    }
                    try {
                        towards = arrival.getString("towards");
                        towardsFound =true;
                    }
                    catch(NullPointerException e)
                    {
                    }
                    if(!(destinationFound||towardsFound)){
                        throw new NullPointerException();

                    }

                    System.out.println(lineId);
                    System.out.println("platformName: " + platformName);
                    System.out.println("timetoStation: " + timeToStation);
                    System.out.println("destinationName: " + destinationName);
                    System.out.println("towards:" + towards + "\n\n");

                    //if destination found, use abbreviated destinationName else use towards field for the destination
                    if(destinationFound) {
                        ar = new Arrival(timeToStation, TfLAbstractParser.parseName(destinationName), platformName);
                    }
                    else {
                        if(towardsFound){
                            ar = new Arrival(timeToStation, towards, platformName);
                        }
                    }

                } catch (NullPointerException e) {
                    e.printStackTrace();
                    continue;
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new JsonException(e.getMessage());
                }
                try {
                    Set<Line> stnLines = stn.getLines();
                    if (stnLines == null) {
                        System.out.println("no lines found in this stn");
                    } else {
                        //if station contains the line with lineID found above, then add the arrival to this staion
                        for (Line line : stnLines) {
                            if (line.getId().equals(lineId)) {
                                stn.addArrival(line, ar);
                                //found an arrival running through a line in this station
                                arrivalRunsThroughLine = true;
                            }
                        }
                    }

                } catch (ArrivalException e) {
                    e.printStackTrace();
                } catch (NullPointerException e) {
                    e.printStackTrace();
                    throw new TfLArrivalsDataMissingException("missing some arrivals data");
                } catch (Exception e) {
                    e.printStackTrace();
                    throw new JsonException(e.getMessage());
                }


            }
            if (!arrivalRunsThroughLine) {
                throw new TfLArrivalsDataMissingException("didn't find any arrival running through the lines in this station");
            }
            //no arrival object was created because  all arrivals were missing at least important field
            if (ar == null) {
                throw new TfLArrivalsDataMissingException("all arrivals missing some important field");

            }
            // NOTE: you must complete the rest of the implementation of this method
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new JsonException(e.getMessage());
        }
    }
}
