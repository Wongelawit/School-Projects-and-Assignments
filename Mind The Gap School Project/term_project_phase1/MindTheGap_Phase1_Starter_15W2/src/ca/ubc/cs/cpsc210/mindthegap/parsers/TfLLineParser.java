package ca.ubc.cs.cpsc210.mindthegap.parsers;

import ca.ubc.cs.cpsc210.mindthegap.model.*;
import ca.ubc.cs.cpsc210.mindthegap.parsers.exception.TfLArrivalsDataMissingException;
import ca.ubc.cs.cpsc210.mindthegap.parsers.exception.TfLLineDataMissingException;
import ca.ubc.cs.cpsc210.mindthegap.tests.parsers.AbstractTfLArrivalsParserTest;
import ca.ubc.cs.cpsc210.mindthegap.util.LatLon;

import javax.json.*;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;

/**
 * A parser for the data returned by TFL line route query
 */
public class TfLLineParser extends TfLAbstractParser {

    /**
     * Parse line from JSON response produced by TfL.
     *
     * @param lmd              line meta-data
     * @return                 line parsed from TfL data
     * @throws JsonException   when JSON data does not have expected format
     * @throws TfLLineDataMissingException when
     * <ul>
     *  <li> JSON data is missing lineName, lineId or stopPointSequences elements </li>
     *  <li> or, for a given sequence: </li>
     *    <ul>
     *      <li> the stopPoint array is missing, or </li>
     *      <li> all station elements are missing one of name, lat, lon or stationId elements </li>
     *    </ul>
     * </ul>
     */
    public static Line parseLine(LineResourceData lmd, String jsonResponse)
            throws JsonException, TfLLineDataMissingException {

        JsonReader reader = Json.createReader(new StringReader(jsonResponse));

        JsonObject rootJSON = reader.readObject();

        //parse line name and lineId
        try {
            String lineName = rootJSON.getString("lineName");
            String lineId = rootJSON.getString("lineId");


            System.out.println(lineName);
            System.out.println(lineId);
            //create the line with lmd,lineId,lineName
            Line line = new Line(lmd, lineId, lineName);

            //parse branch strings aka linestrings
            JsonArray branchStrings =rootJSON.getJsonArray("lineStrings");
            //parse branch string
            for(int i = 0; i<branchStrings.size(); i++) {
                String branchString = branchStrings.getString(i);

                System.out.println(branchString);
                //add branch to the line
                line.addBranch(new Branch(branchString));
            }

            JsonArray stopPointSequencesArray = rootJSON.getJsonArray("stopPointSequences");

            List<Station> allStations = new ArrayList<Station>();

            for(int i = 0; i<stopPointSequencesArray.size(); i++) {
                JsonObject stopPointSequenceObject = stopPointSequencesArray.getJsonObject(i);
                int branchId  = stopPointSequenceObject.getInt("branchId");
                System.out.println("\n\nbranchid: " + branchId);
                List<Station> stations = parseStationsOnABranch(stopPointSequenceObject);

                for(Station st: stations){
                    System.out.println(st.getName());
                    System.out.println(st.getID());
                    System.out.println(st.getLocn().getLatitude());
                    System.out.println(st.getLocn().getLongitude());
                }
                //add this branch's stations to the list of all stations
                allStations.addAll(stations);
            }

            //add all stations to the line
            for(Station station: allStations){
                line.addStation(station);
            }
            //add stations on this line to the stationManager so we can check if a station already exists
            StationManager stnManager = StationManager.getInstance();
            stnManager.addStationsOnLine(line);
            return line;
        }
        catch(TfLLineDataMissingException e){
            throw new TfLLineDataMissingException(e.getMessage());
        }
        catch (NullPointerException e){
            throw new TfLLineDataMissingException("missing some line data");
        }
        catch(Exception e){
            throw new JsonException(e.getMessage());
        }


/*
        for(Branch branch: line.getBranches()) {
            System.out.println(branch.getPoints().get(2).getLatitude());
            System.out.println(branch.getPoints().get(2).getLongitude());
        }
*/
        // NOTE: you must complete the rest of the implementation of this method

    }

    private static List<Station> parseStationsOnABranch(JsonObject stopPointSequenceObject) throws TfLLineDataMissingException{
        List<Station> stations = new ArrayList<Station>();
        try {
            JsonArray stopPointArray = stopPointSequenceObject.getJsonArray("stopPoint");

            for (int i = 0; i < stopPointArray.size(); i++) {
                JsonObject stopPointObject = stopPointArray.getJsonObject(i);
               try {
                   Station st = parseOneStation(stopPointObject);
                   stations.add(st);
               }
               catch(TfLLineDataMissingException e){
                   System.out.println(e.getMessage());
               }
                /*
            System.out.println(st.getLocn().getLatitude());
            System.out.println(st.getLocn().getLongitude());
            System.out.println(st.getID());
            System.out.println(st.getName());
*/
            }
            //if stations list is empty meaning all of the stations in this branch were missing some field, then throw exception
            if(stations.size()==0){
                throw new TfLLineDataMissingException("all stations in this branch(aka stopPoint) are missing at least one field");
            }
        }
        catch(NullPointerException e){
            throw new TfLLineDataMissingException();
        }
        catch(Exception e){
            throw new JsonException(e.getMessage());
        }
        return stations;
    }

    private static Station parseOneStation(JsonObject stopPointObject) throws TfLLineDataMissingException{
        Station station = null;
        LatLon location = null;
        double lat;
        double lon;
        StationManager stationManager = StationManager.getInstance();

        try {
            String stationId = stopPointObject.getString("stationId");
            Station exists = stationManager.getStationWithId(stationId);
            //if staiton doesn't already exist then create one
            if (exists == null) {
                String stationName = stopPointObject.getString("name");
                String abbreviatedStationName = TfLAbstractParser.parseName(stationName);
                JsonNumber latitude = stopPointObject.getJsonNumber("lat");
                JsonNumber longitude = stopPointObject.getJsonNumber("lon");
                lat = latitude.doubleValue();
                lon = longitude.doubleValue();
                location = new LatLon(lat, lon);
                station = new Station(stationId, abbreviatedStationName, location);
/*
            System.out.println(lat);
            System.out.println(lon);
            System.out.println(stationId);
            System.out.println(stationName);
            */
                return station;
            }
            return exists;
        }
        catch(NullPointerException e){
            throw new TfLLineDataMissingException("missing some station data");
        }
        catch(Exception e){
            throw new JsonException(e.getMessage());
        }

    }
}
