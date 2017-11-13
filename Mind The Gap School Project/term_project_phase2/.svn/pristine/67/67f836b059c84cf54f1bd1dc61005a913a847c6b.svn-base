package ca.ubc.cs.cpsc210.mindthegap.TfL;

/*
 * Copyright 2015-2016 Department of Computer Science UBC
 */

import ca.ubc.cs.cpsc210.mindthegap.model.Line;
import ca.ubc.cs.cpsc210.mindthegap.model.Station;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

/**
 * Wrapper for TfL Arrival Data Provider
 */
public class TfLHttpArrivalDataProvider extends AbstractHttpDataProvider {
    //private static final String ARRIVALS_API_BASE = "https://api.tfl.gov.uk";              // for TfL data
    private static final String ARRIVALS_API_BASE = "http://kunghit.ugrad.cs.ubc.ca:6060";   // for simulated data (3pm to midnight)
    private Station stn;

    public TfLHttpArrivalDataProvider(Station stn) {
        super();
        this.stn = stn;
    }

    @Override
    protected URL getURL() throws MalformedURLException {
        String url = "";
        String stnID= stn.getID();
        ArrayList<String> listOfLine= new ArrayList<String>();
        for(Line line: stn.getLines()){
            String lineID= line.getId();
            listOfLine.add(lineID);
        }

        url = url.concat(ARRIVALS_API_BASE);
        url = url.concat("/Line/");
        for(int i = 0; i<listOfLine.size(); i++){
            if(i==listOfLine.size()-1){
                url = url.concat(listOfLine.get(i) + "/");
            }else {
                url = url.concat(listOfLine.get(i) + ",");
            }
        }
        url =  url.concat("Arrivals?stopPointId=" + stnID + "&app_id=&app_key=");



        // TODO: Phase Two Task 7
        return new URL(url);   // stub
    }


}
