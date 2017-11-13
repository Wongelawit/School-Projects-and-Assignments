package ca.ubc.cs.cpsc210.mindthegap.tests.model;

import ca.ubc.cs.cpsc210.mindthegap.model.Arrival;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

/**
 * Created by wongel on 2016-03-12.
 */
public class ArrivalTest {
    private Arrival estArrival;

    @Before
    public void setUp() {
        //estArrival= new Arrival(0,"asdfasdfa","  EastBound    Platform 1   ");

       // stnManager.clearSelectedStation();
        //stnManager.clearStations();
    }

    @Test
    public void testGetTravelDirn() {
        Arrival estArrival1= new Arrival(0,"asdfasdfa","  EastBound   -     Platform 1        ");
        String platformName1 =  estArrival1.getTravelDirn();
        assertEquals("EastBound",platformName1);

        Arrival estArrival2= new Arrival(0,"asdfasdfa","  EastBound    Platform 1   ");
        String platformName2 = estArrival2.getTravelDirn();
        assertEquals("Unknown direction",platformName2);

    }

    @Test
    public void testGetPlatformName() {
        Arrival estArrival1= new Arrival(0,"asdfasdfa","  EastBound   -     Platform 1        ");
        String platformName1 =  estArrival1.getPlatformName();
        assertEquals("Platform 1",platformName1);

        Arrival estArrival2= new Arrival(0,"asdfasdfa","  EastBound    Platform 1   ");
        String platformName2 = estArrival2.getPlatformName();
        assertEquals("Platform 1",platformName2);
    }

    @Test
    public void testGetTimeToStationInMins() {
        Arrival estArrival1= new Arrival(120,"asdfasdfa","  EastBound   -     Platform 1        ");
        int arrivalTimeMin =  estArrival1.getTimeToStationInMins();
        assertEquals(2, arrivalTimeMin);

        Arrival estArrival2= new Arrival(130,"asdfasdfa","  EastBound    Platform 1   ");
        int arrivalTimeMin1 =  estArrival2.getTimeToStationInMins();
        assertEquals(3, arrivalTimeMin1);

    }

}
